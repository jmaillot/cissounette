<?php
/**
 * Fonctions du thème enfant Cissounette.
 * Chargement du CSS parent (Astra) + personalisations légères.
 */
add_action( 'wp_enqueue_scripts', function () {
    wp_enqueue_style(
        'astra-parent',
        get_template_directory_uri() . '/style.css'
    );
    wp_enqueue_style(
        'cissounette',
        get_stylesheet_uri(),
        array( 'astra-parent' ),
        wp_get_theme()->get( 'Version' )
    );
}, 20 );

/* Support des logos personnalisés (Apparence > Personnaliser) */
add_theme_support( 'custom-logo', array(
    'height'      => 160,
    'width'       => 400,
    'flex-height' => true,
    'flex-width'  => true,
) );
