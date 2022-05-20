Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40C77E
	for <patches@lists.linux.dev>; Fri, 20 May 2022 16:09:19 +0000 (UTC)
Received: by mail-ej1-f51.google.com with SMTP id f9so16568845ejc.0
        for <patches@lists.linux.dev>; Fri, 20 May 2022 09:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7Cg6LCQfLn0WTSvtR466h1aEa2Iwynbdw1Q3+GdOyGc=;
        b=hn11T95mrho5yuqp2gZrUIBSVxzM8d397y/SgcNfkDuej6NZ35p5WaBiVTBr8Yb5cZ
         K1PNeYeoieYOWYuVZFtUrL8DbE5xa9toqzYOreQmJtRYPEGWsyK+G10RvApdBy6/NDIu
         x/uCmwil0wE5EiKN9EtoAXuBnu1fTGoFjy38Z5wnywInwR37UWmCwY65QL7Gc8mzukq7
         veK2NgpNRPZIkFx4jxfTEPJnLTnTpl6Vx0MSIEmnbjrDA10gCEnYhsJI2fxxLVSEabRo
         7cwoG9ogF+y2uxT6BgNSVbAXRI9DlzoBE9z28XDsRZdFrxlAeG3orgSbeuSth3iYQG9I
         nqqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7Cg6LCQfLn0WTSvtR466h1aEa2Iwynbdw1Q3+GdOyGc=;
        b=pNZ3LkDtf1sU5R12yIR9S0ruQEvs3jlN52OaHPnPaemuviD0Wy3ow70Hv7itW7E0eh
         BQgsQP9i89UTN5dd/O+lKDSH8GeheJ/dDHv8jtT61YEImRqLi4QvwNVu+LCM2Tio3+60
         Ne6c0qetdB+YbhJu2jidrd/QGtfso130+hsGIhf5WVqlYXTrO1z/kYS3zvtd7wtFZptK
         su99nuXOqkSdnPFL1DJIyzaQdlNS41LqPnPxZDvnA7k2o2x9BUCqnW8PWRWVA03tOPuF
         X772TWdmOIDv6pkQPS+s5+SG8KMmEqJ1BSY3ZhxIRRZczw5NISr7nPZMZguvedO3n0HX
         KcpA==
X-Gm-Message-State: AOAM531tACeB6zuoCo1HNSnYwUgDJdH6/Fx3wT87wL8XM+xH9eHa+XLo
	ykVW4EKz2yh5khxm5UmRuiM=
X-Google-Smtp-Source: ABdhPJwVSQh87j/fQYXfttzAvS9rCL+sj10jEGCuy9Reln3FFPjoBUuGc+RJz4+CjUCYy2GNYnxjZg==
X-Received: by 2002:a17:907:971b:b0:6f4:3b8c:ae04 with SMTP id jg27-20020a170907971b00b006f43b8cae04mr9685554ejc.548.1653062957920;
        Fri, 20 May 2022 09:09:17 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id s27-20020a170906221b00b006f3ef214e73sm3264386ejs.217.2022.05.20.09.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 09:09:17 -0700 (PDT)
Date: Fri, 20 May 2022 19:09:16 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: netdev@vger.kernel.org, patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Vivien Didelot <vivien.didelot@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Juergen Borleis <jbe@pengutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Mans Rullgard <mans@mansr.com>
Subject: Re: [PATCH v2] net: dsa: restrict SMSC_LAN9303_I2C kconfig
Message-ID: <20220520160916.jwpbi6y2uyqlbrwz@skbuf>
References: <20220520051523.10281-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520051523.10281-1-rdunlap@infradead.org>

On Thu, May 19, 2022 at 10:15:23PM -0700, Randy Dunlap wrote:
> Since kconfig 'select' does not follow dependency chains, if symbol KSA
> selects KSB, then KSA should also depend on the same symbols that KSB
> depends on, in order to prevent Kconfig warnings and possible build
> errors.
> 
> Change NET_DSA_SMSC_LAN9303_I2C and NET_DSA_SMSC_LAN9303_MDIO so that
> they are limited to VLAN_8021Q if the latter is enabled. This prevents
> the Kconfig warning:
> 
> WARNING: unmet direct dependencies detected for NET_DSA_SMSC_LAN9303
>   Depends on [m]: NETDEVICES [=y] && NET_DSA [=y] && (VLAN_8021Q [=m] || VLAN_8021Q [=m]=n)
>   Selected by [y]:
>   - NET_DSA_SMSC_LAN9303_I2C [=y] && NETDEVICES [=y] && NET_DSA [=y] && I2C [=y]
> 
> Fixes: 430065e26719 ("net: dsa: lan9303: add VLAN IDs to master device")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Vivien Didelot <vivien.didelot@gmail.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Juergen Borleis <jbe@pengutronix.de>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Mans Rullgard <mans@mansr.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
