Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C382F39A7
	for <patches@lists.linux.dev>; Thu, 19 Feb 2026 10:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771497019; cv=pass; b=EvOWp0VuyZbnKrThU4EW7CvBcHLQ4v+boSm4s4XKaVwbNuxSp15ogCBxN91fuUaREssJNvJlGRouhuHgoxXLqjjI+n9uErWyXFjX296WPDeUUFVF0V6Ckokrq+p5J/Bj00G3cmCpCIqvzxi9WF+scgw6e0EdOV46GKwPR5gg1go=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771497019; c=relaxed/simple;
	bh=eWjMi9oPdjlnFDLhC1g6CgpEWpUV5f5UQwqPs/wjrlM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cTfvbfbj2SouBpfEYhy7IUfIU3+g+CFs3YQ7gd5doBj916QINhI9BZna94CUeoyC5rlz061MUhFvkAPeCaaXL1E2JjPBkrmQOieaAqYfoHo3zg+7DFhempFhhQnf6NWxHb+wga2El6gGqs5I4nhsxpHR15ke5kg0yrnSd+uCZbU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RhZwN9K5; arc=pass smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RhZwN9K5"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-59e62a3ee29so852160e87.3
        for <patches@lists.linux.dev>; Thu, 19 Feb 2026 02:30:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771497016; cv=none;
        d=google.com; s=arc-20240605;
        b=T6oc9mgjQRUJqsLLXAoR+KCPIBFhN86Oo3oZMZyQBGMIr6k0Y7q28Mg2vNpYY6g7rH
         IJitLt91GKdoWWSv0yvKoKNtEEgDDaPZZ3HygZKRhF8nz5jdXoVge2QDLEm39Ve4qCq/
         X0beiLdVVNJIqVvpSrmw3KESR0USkNHlfSkRxgSGz7HiSnRbpFsDEPMSXrvtxJvNDzbH
         4o4waK0xfqMOlBoPhZrLNceRvU16Nr/ciiEG1DzER5V/oNl1YiPmf2SorHgiwwqcjwkF
         U2AzwLBQLGu2lqOyIQ7otiOH+KMM+3V+HDGNpO5nyvx9E4WvWHXDl/TqUJKn4TPm2LPT
         ufgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=X4t0aQn668iou6qj2IRqi89HzqoDCvFcIKaw6c4juHE=;
        fh=QKQTDQdx+97yDnUuUfkpRBMmJEdAH664JiJjmrExalo=;
        b=knYKPcBbMKR2HXLFOozGWDyLI0UlyKhddrRxxPo35WjbgHCaGRtbJbrN1ywDBDN+lF
         gOvDc2GCfgmIuET3NGCAH3QgXYIbBOYM/nZD9EIFIP4E5ggSWjg7+2hlHsho8ddwvSu5
         gB303/3qfULXwHPibBks9go0AsyfcZhw/lG/cFxEH3Hm05gOZyb9CZvJHu/bxl7bOPvw
         dvqLIGawBZthFM29uganhK55cgQ3td6K8p5Jy+QFLfFt5f9U/sV+fqAWm9vaoAinKlDm
         zzICxd0sloBrZPe3OLWEDHUdaYXNhSzqTTP8DoXX10BjoRLcugR6D0laDRlgB7zEEu6X
         gYIA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771497016; x=1772101816; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X4t0aQn668iou6qj2IRqi89HzqoDCvFcIKaw6c4juHE=;
        b=RhZwN9K5zr7BfHeI6/c++7zAd15NxdyGq+fDUV0YhMpmaIHGqrGfJw6VwTap8fsDLg
         TMIsw+hhq0faUarU6/w9oPM7KZe3Atf+aVOkMrM2CfNI55gJWT7FYvUcb+9jk+9W/V6l
         xjUfgeVPyavsTgLA7rd7sZGwZQGGN9bTLbzKT7LTpDIiWGjR7JiK6vOGADv9Ge68FIbg
         MBiY/ajyxWbbKr8LOGoqhF2Zh8LM+++gPz/X/dfC3flmWzFv0nos7C1xWoBYgCuTb7e8
         XBkFyL65VMUP5Sl0p6lMbCgAtKX+4SqeR7+3XCnXwAHwF5a+Jqn3m4HZx/oo/p7F84C/
         IEAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771497016; x=1772101816;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X4t0aQn668iou6qj2IRqi89HzqoDCvFcIKaw6c4juHE=;
        b=YfpOrG/0t9VN3/ncV8TNxRz+dB/SaEJF++4uFDqLLS4dChYgAaotnbdsrkqW6C9VN+
         3zsAomf0Vl1LcbNG0aw1dgB5Ck29feajMM7ZtEV/BbRGegqx2lvzbhf1APgNx750Zwjz
         hrFCXN1NZfwAUlAVpRC5vA6zEnYiDD/I8fkDwuOgRKkYMSXSLe5ndjABpd+Knd4PslXn
         +JWRdNwuqhp0mmb5ll4j+K/ZTjZgHJmx++/iHx4+w9puii44JqIPNvfD/AjpsgV3/oYD
         N4gEyeokYhwjiWSeYHfNPRHnHDMokr7aouQbAgXDddVgjacfuwOq5mxoyYg3veeUBAIh
         8Y9Q==
X-Gm-Message-State: AOJu0Yy9R4tS0xHD5cVzgCdHeT3zMxWnS3XZGaUHvwV7w2W558DDtTwn
	NxVxIckIEtwJeIbg4xiiAHNa+PXSuI9DTq6mkZYmEMdFOzMuLl6C3r6uANYeFl7CjGWFVOQt7Hb
	9mZFGXCKXLV7hUqxkvDN2dCVAvTn+slR/oEGtu0KKSg==
X-Gm-Gg: AZuq6aJWxPe8qC+miDryXxoPSt8SzQHkyNsVSdnpd/jD5I+mTBqSfRe8SvKNfi2aeKB
	ztgVvT8fU7mXEm0b/g8ZzkW0nHnAWuO8yrLhl0dmnESYon5V6ULlxloiFG8rEwZfQ5QpEC5FBSF
	b+GU09HDdYcFNziyQoGE/Fc0mdvszhNMPOsrRfkDi5E+pOYudPIL+yrSkZTgKu6tiQ3faFMelT8
	1De5MAxoCtgf39OfM20GpqVMiCdURlpLk+LboHQL2xUFL1WXxFnzl6yPdlnVQPPDwAHL7blLz5W
	zVKoGx7z
X-Received: by 2002:a05:6512:3b8e:b0:59e:5a13:f66f with SMTP id
 2adb3069b0e04-59ef97f1918mr6303112e87.15.1771497015566; Thu, 19 Feb 2026
 02:30:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260219020422.1539798-1-sashal@kernel.org> <20260219020422.1539798-7-sashal@kernel.org>
In-Reply-To: <20260219020422.1539798-7-sashal@kernel.org>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Thu, 19 Feb 2026 11:29:38 +0100
X-Gm-Features: AaiRm52jeG2Yu2stc47ELqgLlKg0TMPFDoFFFEOyy4G5WPX8KGX8zE9V0OcybSA
Message-ID: <CAPDyKFpnyh0csWRZN5yNZ7+941bGRXF4=yONbQygdDEF3URE6A@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.19-5.15] mmc: rtsx_pci: add quirk to disable
 MMC_CAP_AGGRESSIVE_PM for RTS525A
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, 
	Matthew Schwartz <matthew.schwartz@linux.dev>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, 
	linux-mmc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 19 Feb 2026 at 03:04, Sasha Levin <sashal@kernel.org> wrote:
>
> From: Matthew Schwartz <matthew.schwartz@linux.dev>
>
> [ Upstream commit 5f0bf80cc5e04d31eeb201683e0b477c24bd18e7 ]
>
> Using MMC_CAP_AGGRESSIVE_PM on RTS525A card readers causes game
> performance issues when the card reader comes back from idle into active
> use. This can be observed in Hades II when loading new sections of the
> game or menu after the card reader puts itself into idle, and presents
> as a 1-2 second hang.
>
> Add EXTRA_CAPS_NO_AGGRESSIVE_PM quirk to allow cardreader drivers to
> opt-out of aggressive PM, and set it for RTS525A.
>
> Closes: https://lore.kernel.org/linux-mmc/ff9a7c20-f465-4afa-bf29-708d4a52974a@linux.dev/
> Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
> Link: https://patch.msgid.link/20260103204226.71752-1-matthew.schwartz@linux.dev
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

NAK.

This patch is reverted in mainline, as it's not the proper fix.

See commit eb89b17f283b233ba721fce358fa0d15223ae69d

Kind regards
Uffe




> ---
>
> LLM Generated explanations, may be completely bogus:
>
> ### Summary Analysis
>
> **What the commit does:**
> This commit adds a device-specific quirk for the Realtek RTS525A card
> reader to disable `MMC_CAP_AGGRESSIVE_PM`. When aggressive PM is enabled
> on this device, it powers down the card reader after 10 seconds of idle,
> and re-tuning when waking up causes 1-2 second hangs that are user-
> visible and impact performance.
>
> **Does it fix a real bug?**
> Yes. The aggressive PM behavior on RTS525A causes real, user-observable
> 1-2 second hangs during normal use. This was reported by a real user
> with concrete reproduction steps (playing a game that loads data from a
> micro SD card). The "Closes:" tag links to a real mailing list report.
>
> **Stable kernel criteria assessment:**
>
> 1. **Obviously correct and tested**: The change follows an existing
>    pattern (`EXTRA_CAPS_NO_MMC` is the exact same kind of quirk flag).
>    The author tested it on affected hardware.
>
> 2. **Fixes a real bug**: Yes - user-visible performance degradation (1-2
>    second hangs) on specific hardware.
>
> 3. **Important issue**: It's a usability issue rather than a
>    crash/security issue. However, hardware quirks for broken behavior
>    are explicitly allowed in stable.
>
> 4. **Small and contained**: The change is minimal - 3 new lines of code
>    plus a new flag definition. It only affects RTS525A devices and
>    doesn't change behavior for any other hardware.
>
> 5. **No new features**: This is a hardware quirk/workaround, which is an
>    explicitly allowed exception to the "no new features" rule.
>
> 6. **Clean application**: The change builds on existing infrastructure
>    (`extra_caps` flags) that exists in all stable trees since v5.11.
>
> **Risk assessment:**
> - **Very low risk**: The quirk only affects RTS525A devices
>   (`PID_525A`). All other devices are completely unaffected.
> - The code pattern is identical to existing quirks
>   (`EXTRA_CAPS_NO_MMC`).
> - The worst case if the quirk is wrong is slightly higher power
>   consumption on RTS525A (no aggressive PM = card reader stays powered).
>
> **Dependencies:**
> None. The change uses existing infrastructure (`extra_caps`,
> `CHK_PCI_PID`, `PID_525A`) that has been present since before v5.11.
>
> ### Verification
>
> - **git log** showed `rtd3_en` / `MMC_CAP_AGGRESSIVE_PM` was introduced
>   in commit `5b4258f6721f4` (v5.11), confirming all current stable trees
>   have the affected code.
> - **git tag --contains** confirmed the runtime PM commit is in stable
>   trees (p-5.15, p-6.1, p-6.12).
> - **Grep for EXTRA_CAPS_** confirmed the existing quirk flag pattern
>   (NO_MMC at bit 7, SD_EXPRESS at bit 8, new flag at bit 9 - clean
>   progression).
> - **lore.kernel.org fetch** confirmed the bug report describes real
>   user-reported 1-2 second hangs on RTS525A with concrete reproduction
>   steps.
> - **Code review** verified the change only adds a condition check and
>   flag - no behavioral change for non-RTS525A devices.
> - The commit was signed off by Greg Kroah-Hartman, the stable tree
>   maintainer, indicating it went through proper review.
> - Could NOT verify whether any stable tree has already picked this up
>   (unverified, but not relevant to the YES/NO decision).
>
> ### Conclusion
>
> This is a textbook hardware quirk for a specific device with a real,
> user-reported issue. It follows existing patterns in the codebase, is
> minimal in scope, and has zero risk to other devices. Hardware quirks
> are explicitly listed as appropriate for stable backporting. The
> affected code exists in all current stable trees (5.15+).
>
> **YES**
>
>  drivers/misc/cardreader/rts5249.c | 3 +++
>  drivers/mmc/host/rtsx_pci_sdmmc.c | 4 ++--
>  include/linux/rtsx_pci.h          | 1 +
>  3 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/misc/cardreader/rts5249.c b/drivers/misc/cardreader/rts5249.c
> index 38aefd8db452a..87d576a03e68e 100644
> --- a/drivers/misc/cardreader/rts5249.c
> +++ b/drivers/misc/cardreader/rts5249.c
> @@ -78,6 +78,9 @@ static void rtsx_base_fetch_vendor_settings(struct rtsx_pcr *pcr)
>         if (CHK_PCI_PID(pcr, PID_524A) || CHK_PCI_PID(pcr, PID_525A))
>                 pcr->rtd3_en = rtsx_reg_to_rtd3_uhsii(reg);
>
> +       if (CHK_PCI_PID(pcr, PID_525A))
> +               pcr->extra_caps |= EXTRA_CAPS_NO_AGGRESSIVE_PM;
> +
>         if (rtsx_check_mmc_support(reg))
>                 pcr->extra_caps |= EXTRA_CAPS_NO_MMC;
>         pcr->sd30_drive_sel_3v3 = rtsx_reg_to_sd30_drive_sel_3v3(reg);
> diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
> index 4db3328f46dfb..8df60000b5b41 100644
> --- a/drivers/mmc/host/rtsx_pci_sdmmc.c
> +++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
> @@ -1497,8 +1497,8 @@ static void realtek_init_host(struct realtek_pci_sdmmc *host)
>         mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SD_HIGHSPEED |
>                 MMC_CAP_MMC_HIGHSPEED | MMC_CAP_BUS_WIDTH_TEST |
>                 MMC_CAP_UHS_SDR12 | MMC_CAP_UHS_SDR25;
> -       if (pcr->rtd3_en)
> -               mmc->caps = mmc->caps | MMC_CAP_AGGRESSIVE_PM;
> +       if (pcr->rtd3_en && !(pcr->extra_caps & EXTRA_CAPS_NO_AGGRESSIVE_PM))
> +               mmc->caps |= MMC_CAP_AGGRESSIVE_PM;
>         mmc->caps2 = MMC_CAP2_NO_PRESCAN_POWERUP | MMC_CAP2_FULL_PWR_CYCLE |
>                 MMC_CAP2_NO_SDIO;
>         mmc->max_current_330 = 400;
> diff --git a/include/linux/rtsx_pci.h b/include/linux/rtsx_pci.h
> index 3c5689356004e..f6122349c00ec 100644
> --- a/include/linux/rtsx_pci.h
> +++ b/include/linux/rtsx_pci.h
> @@ -1230,6 +1230,7 @@ struct rtsx_pcr {
>  #define EXTRA_CAPS_MMC_8BIT            (1 << 5)
>  #define EXTRA_CAPS_NO_MMC              (1 << 7)
>  #define EXTRA_CAPS_SD_EXPRESS          (1 << 8)
> +#define EXTRA_CAPS_NO_AGGRESSIVE_PM    (1 << 9)
>         u32                             extra_caps;
>
>  #define IC_VER_A                       0
> --
> 2.51.0
>
