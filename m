Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594637E
	for <patches@lists.linux.dev>; Fri, 20 May 2022 16:23:00 +0000 (UTC)
Received: by mail-pg1-f178.google.com with SMTP id 31so8135355pgp.8
        for <patches@lists.linux.dev>; Fri, 20 May 2022 09:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BzTIjLFgI/4DNCbVKVgCgTv6ggS62nm8SPfLBkmMwB0=;
        b=VP6mijatCvPTB1Xt3JKsa+gtl0XpsYkaNnT46EUNRH033Vis/7AuwDtdei0srXow3C
         uuaMu2ekoCmJSaj+q25/u4kojvJxMTvXlnzG3CYUkHkCZswgAbEi+VG5IDGFP2kyVKxw
         pyVbvEe+Y3zEX7KQm4RG6ptvuMyJy53wDnOjAStUqdr4TsYz45OkvqGvaiRCRv/bk+lg
         mjT3L0uVxHzPtvtglrb0fMQx25RHpD1mRWcAI8DJQtHmlKiTsOlcEOKdSPTDlQ25b8Jh
         0dDK08qVYOdfMH41MKjLaPL80ctl45OdtoNaQy3tehya+C1sK6veXs6S05R4aqzXJVHU
         zctQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BzTIjLFgI/4DNCbVKVgCgTv6ggS62nm8SPfLBkmMwB0=;
        b=hRSn2FnbmKnAWdxzXxIF9S2V01Phz5/Fm06s3nMwEZWv+lkgrLOmxyzCWilcxqvxKv
         +GDkj11DeG/wHrfxczIlVsVbH+Clq6HNn++nxNXIft1modzd0zFOh35UkOLvQsMzzFjP
         qoqd3ivo3asw3KyOECaX9FSq39lwNK4jIvmvLzZY1NpG2cCIp9nsX0JUdJX4fGg5Mtkh
         kU/ddh4pba1l8iv6I64UJtygPliNN26SfDfKucg4EXV8G+sZAM51D8gzuLFdgvOvti9Q
         Mu13RRts9VyHMT/7n+hOPNGDygBpGwC/Kj4R6e8Om1z6Q315wpDqKr8B6xMom2iV6KQu
         CHYA==
X-Gm-Message-State: AOAM5311q70pUWbLD2iKfO+veK9s3JxxEF2CmH12cfppGIObQRKZ2B9a
	ZCpZ18QMq4X5U1+yo1vFqj8=
X-Google-Smtp-Source: ABdhPJxFu8Ij8zVoRuTXWQW9GGooIxP6QrfsLuNSpQZOdnUL9WT2VqkbkJ/skYFoaQXchVeZcP0p0w==
X-Received: by 2002:a05:6a00:198f:b0:50e:7e6:6d5c with SMTP id d15-20020a056a00198f00b0050e07e66d5cmr10606108pfl.20.1653063779722;
        Fri, 20 May 2022 09:22:59 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id e21-20020a170902d39500b0015f4b7a012bsm5901125pld.251.2022.05.20.09.22.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 09:22:59 -0700 (PDT)
Message-ID: <437b7685-5990-bab5-d321-3246a03f41ac@gmail.com>
Date: Fri, 20 May 2022 09:22:57 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2] net: dsa: restrict SMSC_LAN9303_I2C kconfig
Content-Language: en-US
To: Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org
Cc: patches@lists.linux.dev, Andrew Lunn <andrew@lunn.ch>,
 Vivien Didelot <vivien.didelot@gmail.com>,
 Vladimir Oltean <olteanv@gmail.com>, Juergen Borleis <jbe@pengutronix.de>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Mans Rullgard <mans@mansr.com>
References: <20220520051523.10281-1-rdunlap@infradead.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220520051523.10281-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/19/2022 10:15 PM, Randy Dunlap wrote:
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
>    Depends on [m]: NETDEVICES [=y] && NET_DSA [=y] && (VLAN_8021Q [=m] || VLAN_8021Q [=m]=n)
>    Selected by [y]:
>    - NET_DSA_SMSC_LAN9303_I2C [=y] && NETDEVICES [=y] && NET_DSA [=y] && I2C [=y]
> 
> Fixes: 430065e26719 ("net: dsa: lan9303: add VLAN IDs to master device")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
