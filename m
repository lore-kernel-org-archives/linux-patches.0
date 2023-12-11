Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B991554FB4
	for <patches@lists.linux.dev>; Mon, 11 Dec 2023 22:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VsV3Yahx"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7b435966249so227615239f.0
        for <patches@lists.linux.dev>; Mon, 11 Dec 2023 14:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702332333; x=1702937133; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W/LcolI4QDLbemi3xTm4WKcBHmFiHa6SFKMr14wpRXg=;
        b=VsV3YahxtQXIuqN0cyCsBPM/OWByotfNOYFA8i36KoUJXTriFYC1ETGktD+PNCaebL
         kiuANue8WVlsMcnbcE260se4P9Q7BdgwVNX7toSnCfvKWzSaVpzIBJDLj5mUwmevJ6aV
         vZ4jKrzk2e1Vi3eDk/8RtHQUepsh0Pk0WSk7pLYtXOflPtAB9+9siqkWxmdaAW5M30Fs
         PjyBXq+SLlgRpIQ9IrO5joLsvQ8cX2RlxEFq9YJS+Cu6vItWa9Z90GIUHxs/HuNCEAQ5
         O4HgeAhMPWqne2ZCXP1cy9stbr+euam9UuVbr8BS68MRrgJznboIBBYoj0TN3unQVQQR
         jdUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702332333; x=1702937133;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W/LcolI4QDLbemi3xTm4WKcBHmFiHa6SFKMr14wpRXg=;
        b=joNbrLXQ2+hdY3RnFime/7TQVzblEQrGC348K2eh5a881Ehx14PUls0415wWhSU+SU
         Gqokf0cswuTszHOvEK5XamsSW+bQ8rA/uYdJ5rLAXP4icbvQ2UfW+XecJc+8AW0q/Zif
         OCRupRaOQn/g1Bg/HZhqZ9+KmsIBsNCSpG97uVzDXrvDjQOXix+Hn90lQWTSdekiyFsK
         GHltRaTEj8l6QBl7xtij3cWMMLdhVTB1f/rBZRmIFPhOGiEEdn3bRPVYeuLd0p5Gy6cP
         IK9qn7L89mwhSwvLjD+Mi9K0CA1Ul1Iv8ViQDCWNuPfltC3AvkpMckB5H/yNo5nd2NYl
         14vg==
X-Gm-Message-State: AOJu0YzEUDZ8hTJyBvcZyKsJDkSFX7bvjWVRsDPajRljZtQ5WNmSf7Ig
	W6LuFn1bvYET1jRIharvhCY=
X-Google-Smtp-Source: AGHT+IEaZrGcp13LZjtYhiN03xowZAr5RYhQnOMf0ZnqwL5tJXpWfpsJAFRKmY2MSp8bI4daSmqLpg==
X-Received: by 2002:a05:6602:39a:b0:7b4:28f8:2bf4 with SMTP id f26-20020a056602039a00b007b428f82bf4mr5354668iov.29.1702332332713;
        Mon, 11 Dec 2023 14:05:32 -0800 (PST)
Received: from ?IPV6:2001:470:42c4:101:ddc1:e1ea:7b3c:3877? ([2001:470:42c4:101:ddc1:e1ea:7b3c:3877])
        by smtp.gmail.com with ESMTPSA id e21-20020a02a515000000b004300eca209csm2009160jam.112.2023.12.11.14.05.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Dec 2023 14:05:32 -0800 (PST)
Message-ID: <0584789e-2337-2d94-608c-81c09ca0d6d9@gmail.com>
Date: Mon, 11 Dec 2023 15:05:31 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 6.6 126/244] arm64: dts: rockchip: Fix eMMC Data Strobe PD
 on rk3588
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Heiko Stuebner <heiko@sntech.de>,
 Sasha Levin <sashal@kernel.org>
References: <20231211182045.784881756@linuxfoundation.org>
 <20231211182051.468710881@linuxfoundation.org>
From: Sam Edwards <cfsworks@gmail.com>
In-Reply-To: <20231211182051.468710881@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/11/23 11:20, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.

Hi Greg,

This is my first stable review and I don't know the policy on what we do 
with "won't hurt, might help, not strictly needed" cases (which I 
believe this one is). I'll instead list the reasons for/against it (to 
give some background) and will let you/others make the call.

Reasons FOR including this patch in 6.6-stable:
- It is the correct (i.e. standards-compliant) thing to do.
- Because of that, I'd be very surprised if it caused a regression.
- It would be helpful to people who are backporting support for the
   affected board(s) onto 6.6 while they wait for 6.7. (I am one.)

Reasons AGAINST including this patch in 6.6-stable:
- The bug it fixes is a solid, reliable crash on boot, which happens
   virtually 100% of the time on affected boards. If it affected any of
   the boards supported by 6.6, we'd probably have heard of it by now.
- 6.6 isn't LTS, so it isn't likely to be targeted with backported
   support for affected board(s) from 6.7 once 6.7 releases. That is,
   my last point in favor only applies in the short term.

Ultimately, either including it or not will have my full support.

Hope this helps!

Happy Monday,
Sam

> 
> ------------------
> 
> From: Sam Edwards <cfsworks@gmail.com>
> 
> [ Upstream commit 37f3d6108730713c411827ab4af764909f4dfc78 ]
> 
> JEDEC standard JESD84-B51 defines the eMMC Data Strobe line, which is
> currently used only in HS400 mode, as a device->host clock signal that
> "is used only in read operation. The Data Strobe is always High-Z (not
> driven by the device and pulled down by RDS) or Driven Low in write
> operation, except during CRC status response." RDS is a pull-down
> resistor specified in the 10K-100K ohm range. Thus per the standard, the
> Data Strobe is always pulled to ground (by the eMMC and/or RDS) during
> write operations.
> 
> Evidently, the eMMC host controller in the RK3588 considers an active
> voltage on the eMMC-DS line during a write to be an error.
> 
> The default (i.e. hardware reset, and Rockchip BSP) behavior for the
> RK3588 is to activate the eMMC-DS pin's builtin pull-down. As a result,
> many RK3588 board designers do not bother adding a dedicated RDS
> resistor, instead relying on the RK3588's internal bias. The current
> devicetree, however, disables this bias (`pcfg_pull_none`), breaking
> HS400-mode writes for boards without a dedicated RDS, but with an eMMC
> chip that chooses to High-Z (instead of drive-low) the eMMC-DS line.
> (The Turing RK1 is one such board.)
> 
> Fix this by changing the bias in the (common) emmc_data_strobe case to
> reflect the expected hardware/BSP behavior. This is unlikely to cause
> regressions elsewhere: the pull-down is only relevant for High-Z eMMCs,
> and if this is redundant with a (dedicated) RDS resistor, the effective
> result is only a lower resistance to ground -- where the range of
> tolerance is quite high. If it does, it's better fixed in the specific
> devicetrees.
> 
> Fixes: d85f8a5c798d5 ("arm64: dts: rockchip: Add rk3588 pinctrl data")
> Signed-off-by: Sam Edwards <CFSworks@gmail.com>
> Link: https://lore.kernel.org/r/20231205202900.4617-2-CFSworks@gmail.com
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/arm64/boot/dts/rockchip/rk3588s-pinctrl.dtsi | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/rockchip/rk3588s-pinctrl.dtsi b/arch/arm64/boot/dts/rockchip/rk3588s-pinctrl.dtsi
> index 48181671eacb0..0933652bafc30 100644
> --- a/arch/arm64/boot/dts/rockchip/rk3588s-pinctrl.dtsi
> +++ b/arch/arm64/boot/dts/rockchip/rk3588s-pinctrl.dtsi
> @@ -369,7 +369,7 @@
>   		emmc_data_strobe: emmc-data-strobe {
>   			rockchip,pins =
>   				/* emmc_data_strobe */
> -				<2 RK_PA2 1 &pcfg_pull_none>;
> +				<2 RK_PA2 1 &pcfg_pull_down>;
>   		};
>   	};
>   
