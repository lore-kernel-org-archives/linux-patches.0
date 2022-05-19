Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811CB33C3
	for <patches@lists.linux.dev>; Thu, 19 May 2022 23:09:09 +0000 (UTC)
Received: by mail-ed1-f51.google.com with SMTP id en5so8765254edb.1
        for <patches@lists.linux.dev>; Thu, 19 May 2022 16:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9CWDSURQk/3htkD4j+cM1CkjRNsaAvbsFTzIT2f2lb0=;
        b=RAc5sGkL5HuqaIGTgSm16Fb01mjDi1MQEgWef+w4QOdWr6N1r/IDA2I3EYivJYx6Rh
         96uB8h2yei4fRJGI1MGiv1waNzwGjqBjZ3pdbbu+FW4FW6h8KZ+4wRr8XiwJTJ6YW9/n
         r/ZR1dTroWRb5/4EvzJSElOvC+x9dIqrhdNFsJ/OP+OleVmuqPR1Q6WeOMg/9nAQ00FP
         JgBtQwB/ngcvsVCtE0FpAq5WN7WWbv5vDtNS84gqpfE6Dx44osHwNybMHkFmxqjwp0dm
         lGL0yf37sBeCWX2xewZvE5CsJ25h0ZvW3PbyGecCyBAXNTX4iNGpbGTNwYef4FseLAgL
         EOGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9CWDSURQk/3htkD4j+cM1CkjRNsaAvbsFTzIT2f2lb0=;
        b=a2cOAPUETXM52sbedIiI0dPJezVBFzPkylywDqNdkSiZOq6oRTrToTGJR26GrZHfwB
         X/DTRZgq+KWk8p2gSw7nJaX/rSblwXoaKYP23KV8HBp1gHmkO38YFkkfLhcCsQq95Qpw
         DLKF6WJJGARW6SGLiahx8raSVYoYmFP6QZhIZX/Z32VlTf3SuXu2X74hpMOXtDfGUrk1
         nER8cNWtD8FPDbHafOrULKJTK3RsASffpNBYbBIU8nd1cHTtWI+SPIbSv49IGBcMkmni
         mmfZboAEs3Orv41ygCZ7vHltmcjnIrFSZaQJdR0pJpnXAREeejGlMzlJZsuuVXb6b33Q
         5pcg==
X-Gm-Message-State: AOAM530baPUAbtbZUN7iwJRFGPTTgnwEJtT9NPMUKfw1usdp8aT1u0na
	R19RQ4cO6OuIVvCj0ETPjazaUQdo7mY=
X-Google-Smtp-Source: ABdhPJxyot9iRBoP6LKx0451QYxc1SBc4bgJYCP7NDqTs5B94M7uT1oxPm4J4jcldSZCSWZJ3ksffA==
X-Received: by 2002:a05:6402:94a:b0:42a:be9f:6698 with SMTP id h10-20020a056402094a00b0042abe9f6698mr7842739edz.393.1653001747702;
        Thu, 19 May 2022 16:09:07 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id ec9-20020a0564020d4900b0042acd20d46csm3378831edb.92.2022.05.19.16.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 16:09:07 -0700 (PDT)
Date: Fri, 20 May 2022 02:09:05 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: netdev@vger.kernel.org, patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Vivien Didelot <vivien.didelot@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Juergen Borleis <jbe@pengutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] net: dsa: restrict SMSC_LAN9303_I2C kconfig
Message-ID: <20220519230905.mkuwi3ytguxrwbpl@skbuf>
References: <20220519213351.9020-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519213351.9020-1-rdunlap@infradead.org>

Hi Randy,

On Thu, May 19, 2022 at 02:33:51PM -0700, Randy Dunlap wrote:
> Since kconfig 'select' does not follow dependency chains, if symbol KSA
> selects KSB, then KSA should also depend on the same symbols that KSB
> depends on, in order to prevent Kconfig warnings and possible build
> errors.
> 
> Change NET_DSA_SMSC_LAN9303_I2C so that it is limited to VLAN_8021Q if
> the latter is enabled and results in changing NET_DSA_SMSC_LAN9303_I2C
> from =y to =m and eliminating the kconfig warning.
> 
> WARNING: unmet direct dependencies detected for NET_DSA_SMSC_LAN9303
>   Depends on [m]: NETDEVICES [=y] && NET_DSA [=y] && (VLAN_8021Q [=m] || VLAN_8021Q [=m]=n)
>   Selected by [y]:
>   - NET_DSA_SMSC_LAN9303_I2C [=y] && NETDEVICES [=y] && NET_DSA [=y] && I2C [=y]
> 
> Fixes: be4e119f9914 ("net: dsa: LAN9303: add I2C managed mode support")

The Fixes: tag is incorrect. It should be:

Fixes: 430065e26719 ("net: dsa: lan9303: add VLAN IDs to master device")

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
> ---
>  drivers/net/dsa/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/drivers/net/dsa/Kconfig
> +++ b/drivers/net/dsa/Kconfig
> @@ -82,6 +82,7 @@ config NET_DSA_SMSC_LAN9303
>  config NET_DSA_SMSC_LAN9303_I2C
>  	tristate "SMSC/Microchip LAN9303 3-ports 10/100 ethernet switch in I2C managed mode"
>  	depends on I2C
> +	depends on VLAN_8021Q || VLAN_8021Q=n

I'm pretty sure that NET_DSA_SMSC_LAN9303_MDIO needs the same treatment
as NET_DSA_SMSC_LAN9303_I2C. And the "depends" line can now be removed
from NET_DSA_SMSC_LAN9303, it serves no purpose.

>  	select NET_DSA_SMSC_LAN9303
>  	select REGMAP_I2C
>  	help
