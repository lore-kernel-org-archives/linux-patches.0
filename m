Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE49AD49
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 12:22:06 +0000 (UTC)
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-578aca5a6bbso565201a12.1
        for <patches@lists.linux.dev>; Thu, 21 Sep 2023 05:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695298926; x=1695903726; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=6ycq4RYW26n13+qG8PeK+HELns5NdBnVW6wjHVW/9Zg=;
        b=jm5a82kpR4lu86oH9iVhWWtcJW5I1qyvvn+BKCzNtethzNGt+LIAfCnRhhPYAt0Rd1
         WwBI4RJng4CAmY14kuTvRcTOPQwvN1uUd9rNNy3XFnNvpJ6212FqiSdGNFNo+Pe0U0Lj
         HJOPAyFBEzXCLu7dOqFfoI11N8p/f6nm75HFFcK9enEgUGTE17xpelCie9xuyr8IA/EN
         BX2JINcUo0VHfqC0xojHu1F+H3TijkGVz9hj4kchx9dkaYDW+Ybmbapo9t9F6nQYoSuU
         xqNENBZx1tisCEDbZkGeFem2h0tAp7Q7q8pkE+bmkC2uHygSuFOMqX8yTpSg67vnxqFZ
         UR5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695298926; x=1695903726;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6ycq4RYW26n13+qG8PeK+HELns5NdBnVW6wjHVW/9Zg=;
        b=ZMysuyx6sUo3E38dmWPSEHpDlTaN92ev//ZaIHqSaw1R7bEGDGHEeqP8IYOf1FOnha
         XKFs3EtvHVwCD6HdvvvkKQLybRDp62CINj8qzY2NabVvwhRBrNTq1meLQWDb1ObjIx6O
         TDu77ZwjEZ233n2DeVj6xoyD5jPqqjMv1+XmAYWU2ohKZ5hTBq4wd01ioUG+1tGRgz6x
         4Wqmlo4XnGNSbxlGSWmHYYFf8zZJo/TqvYftRhxx+QLLZkITmKQ0HsSY50G5+g83GWD2
         7OxFEYjGNDUh+uuEXhC4Odl+1U/bN3Swrh8okm1It5IDp295rWPVJYnwUMRsSJu591fM
         JJ8A==
X-Gm-Message-State: AOJu0YwaBAz9SmvQZEvcJPIOJIDh18NAdMEOQcdQLAoxrkSqwyPloXlG
	lI8iPNy1MMM5vjQq99jvcIY=
X-Google-Smtp-Source: AGHT+IEN+KM57bCdf4eKScy5SarZ26h+zSVsgMksHHBbzP/crbWScGaklsxqFqMvuGvsI/qe78DgaA==
X-Received: by 2002:a05:6a21:3394:b0:13c:988c:e885 with SMTP id yy20-20020a056a21339400b0013c988ce885mr5624763pzb.56.1695298926170;
        Thu, 21 Sep 2023 05:22:06 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v13-20020a63b64d000000b0057783b0f102sm1069390pgt.40.2023.09.21.05.22.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Sep 2023 05:22:05 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <f0e0f90f-d24a-6d71-b3eb-3e15e834f7b2@roeck-us.net>
Date: Thu, 21 Sep 2023 05:22:04 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 4.19 000/273] 4.19.295-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
References: <20230920112846.440597133@linuxfoundation.org>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/23 04:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.295 release.
> There are 273 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
> 

Building arm:allmodconfig ... failed
Building arm:imx_v6_v7_defconfig ... failed

drivers/pci/controller/dwc/pci-imx6.c:645:10: error: 'const struct dw_pcie_host_ops' has no member named 'host_deinit'; did you mean 'host_init'?
   645 |         .host_deinit = imx6_pcie_host_exit,
       |          ^~~~~~~~~~~
       |          host_init
drivers/pci/controller/dwc/pci-imx6.c:645:24: error: 'imx6_pcie_host_exit' undeclared here (not in a function); did you mean 'imx6_pcie_host_init'?
   645 |         .host_deinit = imx6_pcie_host_exit,
       |                        ^~~~~~~~~~~~~~~~~~~
       |                        imx6_pcie_host_init

Guenter

