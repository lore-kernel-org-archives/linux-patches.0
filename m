Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C792F43
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 21:31:26 +0000 (UTC)
Received: by mail-ot1-f53.google.com with SMTP id r2-20020a9d7cc2000000b006718a7f7fbaso10523064otn.2
        for <patches@lists.linux.dev>; Wed, 28 Dec 2022 13:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g55xSgNfuPxooo0uABGdBIlskF3WWC3oxJT4+davjnw=;
        b=YIQtzmZiZrRrzBNTu1RxdZ+Vf8ouChz3e5d32r4foWNA5CUR0dd3zxVDL0yQPaHhaw
         /cQ95eJp+hZSV5fwY5lxP+CEP7pKstaHhpxvQw+KKGXkb3YhAbbeNFffZlThe61W6k/l
         Tqd4IEdelOixOLnZCCd/xsuxoph7HvrflwMwaPynp+3/jvi/fUrQRacCKWo+KUbKo2vE
         nfZlSPLGsmT3bxgR/GCl1gNgcE7IBZtyzm7oqVZc+OCU8fZ/N0sU0PoIVbGYuVXUSU0j
         1b4vIfsM6DNBtMM8UxCKMCUsZgVwJsUwcIk4NW3ES83XpxToVgCLaKk3Ur82ugNk7+DF
         Po5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g55xSgNfuPxooo0uABGdBIlskF3WWC3oxJT4+davjnw=;
        b=Pp1r4vRiMddvk+cXbKpSvNt4F9pNoCrnT/hwRE9VlbZDXJes2wEDno5CN7NZHmB/Qf
         jTtsvY/T5lPILMYr2VubBm5EhaxY59lqkCRNLDWK458mk/mivLo8u3dHHKccuaN4/bST
         MTff6VQXwswam8rY1nfWfsJOugRsryFn1HwAd33Mhq8PwU3LKEeZo72CSziQZOWwjUHq
         rm6LnohLw4zXkIVSq7NEM7JpX4PrnaTHROu5IMJp95JsjEJwvXoe/TsNqaHhGS9d3+/d
         rS6qpVf2Lu078UpCU9hqlX5VEfiO71V0c5UeFZ9snn+W/c/4o0k20MSDkKetNHtgyEWa
         l17g==
X-Gm-Message-State: AFqh2krEmqFqHb7xr82HL4zByfoGHtBCVKd+NLHZASCuPkNswoI7q6bn
	cEVj7FLwxnNZJaX5kViCWGs=
X-Google-Smtp-Source: AMrXdXtArnjAShWd3z6jxGQbNFDe7/wWUdnQMKeSas/MRzfuO/ZFoy01XuecrrZnXZPthPb1haDWtA==
X-Received: by 2002:a05:6830:43:b0:670:99fe:2dcc with SMTP id d3-20020a056830004300b0067099fe2dccmr12703052otp.18.1672263085580;
        Wed, 28 Dec 2022 13:31:25 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h12-20020a9d600c000000b0066e93d2b858sm8230656otj.55.2022.12.28.13.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 13:31:24 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 28 Dec 2022 13:31:23 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
Message-ID: <20221228213123.GA2229529@roeck-us.net>
References: <20221228144330.180012208@linuxfoundation.org>
 <9560136e-d6e9-995a-141a-61dd05a62b8a@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9560136e-d6e9-995a-141a-61dd05a62b8a@linaro.org>

On Wed, Dec 28, 2022 at 03:15:01PM -0600, Daniel Díaz wrote:
> Hello!
> 
> 
> On 28/12/22 08:25, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.2 release.
> > There are 1146 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 30 Dec 2022 14:41:29 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.2-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> We're seeing the already reported problem with the unused variable 'rpm', but also seeing this on Arm, i386, MIPS, PA-RISC:
> 
I see this as well if I try to build with gcc 9.4, but not with gcc 11.3.
Interesting.

Anyway, the problem is fixed upstream with commit dd1f1da4ada5
("pwm: tegra: Fix 32 bit build").

Guenter

> | /builds/linux/drivers/pwm/pwm-tegra.c: In function 'tegra_pwm_config':
> | /builds/linux/drivers/pwm/pwm-tegra.c:148:53: error: result of '1000000000 << 8' requires 39 bits to represent, but 'long int' only has 32 bits [-Werror=shift-overflow=]
> |    required_clk_rate = DIV_ROUND_UP_ULL(NSEC_PER_SEC << PWM_DUTY_WIDTH,
> |                                                      ^~
> | /builds/linux/include/linux/math.h:40:32: note: in definition of macro 'DIV_ROUND_DOWN_ULL'
> |   ({ unsigned long long _tmp = (ll); do_div(_tmp, d); _tmp; })
> |                                 ^~
> | /builds/linux/drivers/pwm/pwm-tegra.c:148:23: note: in expansion of macro 'DIV_ROUND_UP_ULL'
> |    required_clk_rate = DIV_ROUND_UP_ULL(NSEC_PER_SEC << PWM_DUTY_WIDTH,
> |                        ^~~~~~~~~~~~~~~~
> | cc1: all warnings being treated as errors
> 
> Those are with GCC-8 and allmodconfig.
> 
> Greetings!
> 
> Daniel Díaz
> daniel.diaz@linaro.org
> 
