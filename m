Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDDE7A
	for <patches@lists.linux.dev>; Thu, 17 Mar 2022 07:32:38 +0000 (UTC)
Received: by mail-wr1-f54.google.com with SMTP id p9so6039286wra.12
        for <patches@lists.linux.dev>; Thu, 17 Mar 2022 00:32:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:content-language:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=14b+YRMPF+XicziyqyS1A1J9PGyx9cOE69X038CMxDg=;
        b=KgFSOvsYYd63GR8dEv2MhCU74UGHcl8AECGDi/N0mhGMu6U0pl6lxa1/pBqFLcM43Q
         uPBfYF9QRKFg6ukKSbe8NT0iAImGpKyPhXkfwc/Ev4UXAXRpTUVaBvfkfxh2ihbPHN7F
         gFLg1hNQfLpNTbwUxcRsWYsftJ1+70zYqVwl976hRqHhABanMQh04SnwlHw0nRjbbfnO
         aJb/7VilHKcaHYeGvOIpHobaO4o1dr/1vHSpR4mvR9i1eODmzdTpAshAo3/PH5zob9LA
         KLvZt/ccerCFBkFTgfUEbT/1ISpaBtlPQdVUdQSFXVD/2puepmkwS0i0akuwI8rgCIAx
         XUPA==
X-Gm-Message-State: AOAM5313zZ5fW5iM/kAlDhfm/04f0SM8VI1FrDy/GGjJAsrebrkBfwEF
	kyi3Wfrj2NCda7o8QhBMEvI=
X-Google-Smtp-Source: ABdhPJwozSkjDXV+DHyksKvHyKhiL5fDQ63iPacCt1TMgZ6CfrYaft+8e49jYXsMOYkMY2oilEVhmA==
X-Received: by 2002:a5d:498b:0:b0:203:e5d5:622c with SMTP id r11-20020a5d498b000000b00203e5d5622cmr2724473wrq.153.1647502356995;
        Thu, 17 Mar 2022 00:32:36 -0700 (PDT)
Received: from [192.168.0.17] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.googlemail.com with ESMTPSA id k17-20020a05600c1c9100b00386bb6e9c50sm10984171wms.45.2022.03.17.00.32.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 00:32:36 -0700 (PDT)
Message-ID: <cdba580f-097e-da4d-bfb4-63a7cb64ec95@kernel.org>
Date: Thu, 17 Mar 2022 08:32:34 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH] ARM: JIVE: fix return value of __setup handler
Content-Language: en-US
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: patches@lists.linux.dev, Ben Dooks <ben-linux@fluff.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Russell King <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
 patches@armlinux.org.uk
References: <20220312063609.19362-1-rdunlap@infradead.org>
In-Reply-To: <20220312063609.19362-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/03/2022 07:36, Randy Dunlap wrote:
> __setup() handlers should return 1 to obsolete_checksetup() in
> init/main.c to indicate that the boot option has been handled.
> A return of 0 causes the boot option/value to be listed as an Unknown
> kernel parameter and added to init's (limited) argument or environment
> strings. Also, error return codes don't mean anything to
> obsolete_checksetup() -- only non-zero (usually 1) or zero.
> So return 1 from jive_mtdset().
> 
> Fixes: 9db829f485c5 ("[ARM] JIVE: Initial machine support for Logitech Jive")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: patches@armlinux.org.uk
> ---
> KernelVersion: v5.17-rc7
> 
>  arch/arm/mach-s3c/mach-jive.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 

It's too late for upcoming cycle, so I will pick it up after merge window.


Best regards,
Krzysztof
