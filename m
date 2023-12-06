Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898211A704;
	Wed,  6 Dec 2023 09:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="EoFWHUqK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1701854813; x=1733390813;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XHy/s7usIh2uxCmLk5HoCb1I1blqNWn/YNuTf1NuEXs=;
  b=EoFWHUqKUYatpFZmjz7IxgDLiYgDvtcEcscmdzApMxh1bd958Y7L+Ruk
   KOswZ8jdZzf4K5Ac/O9WDPGujaobk49YOW9Kroh6k0hiMWlQr80haEFSh
   9iUug4iGbv44Siaj9eqkiBfC316VCsQbDEsKOhplFH1ENFa06A+cUriBr
   vVKmHbgv4NtHX84jlmKTkgtsW3IsF5n8+PZKZSfk553Ewknldmm76FB6S
   ghXR6UlI8Yx0ihEI8e6Sqn67QEkQ6WODyGqeseGQTXPSdxmtG9fXNx3YJ
   9674W/RhidEN9BmpSKSF0PUAdLcb2aQqa1GYeFdx+APna89NeVzvTMK+C
   g==;
X-CSE-ConnectionGUID: O1O4e9wQSgiVhtaltz5BaA==
X-CSE-MsgGUID: 2MFCeDcoTHqb0Vo2lm1HFg==
X-ThreatScanner-Verdict: Negative
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="13697268"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Dec 2023 02:25:44 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Dec 2023 02:25:33 -0700
Received: from [10.171.248.78] (10.10.85.11) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Wed, 6 Dec 2023 02:25:31 -0700
Message-ID: <62b3cd0f-e71c-4d53-be87-388809b42dcc@microchip.com>
Date: Wed, 6 Dec 2023 10:24:51 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] power: reset: at91: Drop '__init' from
 at91_wakeup_status()
To: Nathan Chancellor <nathan@kernel.org>, <sre@kernel.org>
CC: <alexandre.belloni@bootlin.com>, <claudiu.beznea@tuxon.dev>,
	<u.kleine-koenig@pengutronix.de>, <linux-pm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <llvm@lists.linux.dev>,
	<patches@lists.linux.dev>
References: <20231120-fix-at91-modpost-warnings-v1-1-813671933863@kernel.org>
Content-Language: en-US, fr-FR
From: Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
In-Reply-To: <20231120-fix-at91-modpost-warnings-v1-1-813671933863@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit

On 20/11/2023 at 23:35, Nathan Chancellor wrote:
> When building with clang, there are two section mismatch warnings:
> 
>    WARNING: modpost: vmlinux: section mismatch in reference: at91_poweroff_probe+0x7c (section: .text) -> at91_wakeup_status (section: .init.text)
>    WARNING: modpost: vmlinux: section mismatch in reference: at91_shdwc_probe+0xcc (section: .text) -> at91_wakeup_status (section: .init.text)
> 
> Drop '__init' from at91_wakeup_status() to clear up the mismatch.
> 
> Fixes: dde74a5de817 ("power: reset: at91-sama5d2_shdwc: Stop using module_platform_driver_probe()")
> Fixes: 099806de68b7 ("power: reset: at91-poweroff: Stop using module_platform_driver_probe()")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Thanks, best regards,
   Nicolas

> ---
> I suspect this is not visible for GCC due to inlining
> at91_wakeup_status() but I did not actually check.
> ---
>   drivers/power/reset/at91-poweroff.c      | 2 +-
>   drivers/power/reset/at91-sama5d2_shdwc.c | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/reset/at91-poweroff.c b/drivers/power/reset/at91-poweroff.c
> index 126e774e210c..93eece027865 100644
> --- a/drivers/power/reset/at91-poweroff.c
> +++ b/drivers/power/reset/at91-poweroff.c
> @@ -57,7 +57,7 @@ static struct shdwc {
>          void __iomem *mpddrc_base;
>   } at91_shdwc;
> 
> -static void __init at91_wakeup_status(struct platform_device *pdev)
> +static void at91_wakeup_status(struct platform_device *pdev)
>   {
>          const char *reason;
>          u32 reg = readl(at91_shdwc.shdwc_base + AT91_SHDW_SR);
> diff --git a/drivers/power/reset/at91-sama5d2_shdwc.c b/drivers/power/reset/at91-sama5d2_shdwc.c
> index af95c7b39cb3..959ce0dbe91d 100644
> --- a/drivers/power/reset/at91-sama5d2_shdwc.c
> +++ b/drivers/power/reset/at91-sama5d2_shdwc.c
> @@ -107,7 +107,7 @@ static const unsigned long long sdwc_dbc_period[] = {
>          0, 3, 32, 512, 4096, 32768,
>   };
> 
> -static void __init at91_wakeup_status(struct platform_device *pdev)
> +static void at91_wakeup_status(struct platform_device *pdev)
>   {
>          struct shdwc *shdw = platform_get_drvdata(pdev);
>          const struct reg_config *rcfg = shdw->rcfg;
> 
> ---
> base-commit: b55d073e6501dc6077edaa945a6dad8ac5c8bbab
> change-id: 20231120-fix-at91-modpost-warnings-beabd2bac722
> 
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
> 

