## Explication

### Terraform
Terraform provisionne l'infrastructure à partir du code défini dans le dossier `terraform/`.
Il crée un conteneur Docker (`projet-ops-server`) basé sur l'image `php:8.2-apache`, 
connecté à un réseau Docker isolé (`projet-ops-network`).
Le state de l'infrastructure est stocké à distance sur **Terraform Cloud**, 
ce qui permet de suivre l'état réel de l'infra et d'éviter les conflits si plusieurs 
personnes travaillent sur le projet.

### Ansible
Une fois le conteneur créé, Ansible s'y connecte via le **plugin de connexion Docker** 
(sans SSH) et exécute le playbook `site.yml` qui applique le rôle `apache`.
Ce rôle se charge de déployer la page d'accueil `index.html` et la page applicative 
`app.php` directement dans le répertoire servi par Apache (`/var/www/html`).

### Pourquoi la page n'est pas accessible via une URL publique
Le conteneur est créé sur le **runner GitHub Actions**, une machine virtuelle temporaire 
qui est détruite automatiquement à la fin du pipeline. Elle ne possède pas d'IP publique 
et n'est donc pas accessible depuis un navigateur.

Pour prouver que le déploiement fonctionne, le pipeline exécute des `curl` en fin de job 
qui affichent le **contenu HTML complet** des pages directement dans les logs GitHub Actions, 
confirmant qu'Apache tourne et que PHP est bien interprété.

Pour tester localement avec une vraie URL (`http://localhost:8080`), 
il suffit d'avoir Docker et Terraform installés sur sa machine et de lancer :
```bash
terraform apply -var-file="variables.tfvars" -auto-approve
ansible-playbook -i inventory.yml playbooks/site.yml
```