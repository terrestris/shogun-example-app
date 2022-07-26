// TODO: Adjust to your project
package de.terrestris.shogunexample.config;

import de.terrestris.shogun.boot.config.ApplicationConfig;
import de.terrestris.shogun.lib.envers.ShogunEnversRevisionRepositoryFactoryBean;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@ComponentScan(basePackages = "de.terrestris.shogunexample")
@EnableJpaRepositories(
    basePackages = "de.terrestris.shogunexample",
    repositoryFactoryBeanClass = ShogunEnversRevisionRepositoryFactoryBean.class
)
@EntityScan(basePackages = "de.terrestris.shogunexample")
public class ShogunExampleAppConfig extends ApplicationConfig {
    public static void main(String[] args) {
        SpringApplication.run(de.terrestris.shogunexample.config.ShogunExampleAppConfig.class, args);
    }
}
