Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CC72102
	for <patches@lists.linux.dev>; Wed,  7 Dec 2022 14:26:18 +0000 (UTC)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-142b72a728fso21446883fac.9
        for <patches@lists.linux.dev>; Wed, 07 Dec 2022 06:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ovp7RN5SJxtC9JYyhzfJ5fXBmFrl0V1pv9Cshdr2tKo=;
        b=X1hMrMShFbyKPASWyO2nsxVvM/4/yGxaobGzSRQzeijHIzLzaMcBPewA8jyEKrnbHX
         yRefLWVmModh8H10gfRhygNwI1/Te/91zVm+uZJGbLTtBN3aFBfVTgw3Inm+gAiMvUjA
         jquqyc9GzythWR0QpJwcnNhE86IU3ghX6nVYz5IXueF7Sq+EusnbRlckGqIi5oUv1V6V
         /tA39D6Yl9bRbTBFdc/fRKL3gG5kY024oVhFUKf6ldl+c3J9yA8k/JF7i1zPQ6nE0u0n
         QXoBMikiNqKZmPSL9eYkPQVGp37MgA8pIVWdLVE4H97+ZZ4rzVvRDKInZHxl4yckAqtM
         0wLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ovp7RN5SJxtC9JYyhzfJ5fXBmFrl0V1pv9Cshdr2tKo=;
        b=obW6ARJJAAB2qHl60XpEOxkInG5uPrFYU/D6z1aVJPJuwZNcM5g4nseWXsk2j+CSVw
         SFzdOOToS+K0yV8uzpfCiD2xhaDC89F+36UH23iLR2LVTYvP6msXhSTJJ4f4cvEE4Mvq
         sOOHbcOHbQhuHCV4CWu9IIxMAFH46iUhcnaUEbIBXpHP/vv6QFhoIH27G7UVqT1N/XKp
         Sk+NoU8PfnfTaivGGVnhgo8so6dafbqd/em3h/K6tcKPYhxZtp53lmz0U70z7ybti+pi
         KKEWJm8FnZf7c87LWU/IT5A/lCx3p9jFSKRaHFPS3RmljvuWT91OYvEVr4mfl/j+6RK4
         y6rQ==
X-Gm-Message-State: ANoB5plzqjOL7l8Si/Z9DYHFQCLV06PTSP76+QJshgZge9mUb2BVy+Rs
	Iq07JgiJALhKP5KWfdA5w/8=
X-Google-Smtp-Source: AA0mqf5MfrSnhU8Me+2xR0btOmSBuCr+p7EbXonY79Kaqx6iEurxY/odxuSdvQvLUWloBhr5eJVwuA==
X-Received: by 2002:a05:6870:d985:b0:13b:6d76:8bcb with SMTP id gn5-20020a056870d98500b0013b6d768bcbmr43910294oab.281.1670423177845;
        Wed, 07 Dec 2022 06:26:17 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q5-20020acac005000000b00339befdfad0sm9463395oif.50.2022.12.07.06.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 06:26:17 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 7 Dec 2022 06:26:16 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/157] 5.4.226-rc2 review
Message-ID: <20221207142616.GD319836@roeck-us.net>
References: <20221206124054.310184563@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206124054.310184563@linuxfoundation.org>

On Tue, Dec 06, 2022 at 01:42:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.226 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 447 pass: 447 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
