Received: from smtp-8fa8.mail.infomaniak.ch (smtp-8fa8.mail.infomaniak.ch [83.166.143.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EF2443AB1
	for <patches@lists.linux.dev>; Tue, 21 Jul 2026 21:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.166.143.168
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668069; cv=none; b=NJbZ4SrwF+89af2LO6Vy1687F0sWc//OH6ShUNtQoHZtpIHq6+Mw0kf4ZQo3qtqtRnUx+DgY3Rq2LdCb3P8Cjf5wAVFyqnIZfugYRmrqTqsHpXSy+Jj+fMTeoib5NqVOWM8YAY1T40MhIV0tLvQdoQ3M68nDqoWzWh4v5GWODhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668069; c=relaxed/simple;
	bh=zVYPAilCCRw/za7nmQnWZOMVwd6uMi9yNkQXhAPGU9I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IBxMaCX7K8rN/MnrN+3T9z3ZDbW0FkiKRGEU6zxgoogBr71m3En4Ayoc+QEh0Xbp0GS3D+cfb31JvLZzzOm04Xrs6MyFl/XR1s//b5J/M0ikTCrH42Ou92l+rzsl8/hGX5Qca43rQQflmkpi2ZrhhcOe9kNtRnkIfxFgp2H+ros=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gibson.sh; spf=pass smtp.mailfrom=gibson.sh; dkim=pass (2048-bit key) header.d=gibson.sh header.i=@gibson.sh header.b=TAwnH7tr; arc=none smtp.client-ip=83.166.143.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gibson.sh
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gibson.sh
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gibson.sh header.i=@gibson.sh header.b="TAwnH7tr"
Received: from smtp-4-0001.mail.infomaniak.ch (smtp-4-0001.mail.infomaniak.ch [10.7.10.108])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4h4VMX4fM4zqkp;
	Tue, 21 Jul 2026 23:07:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gibson.sh;
	s=20260228; t=1784668056;
	bh=AXEX8vHC7fnEL9xRdTYPsZPV7T5jLpStPXIPhPSPlvo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TAwnH7trgkDBkzX/Jjp2nrgNI+VzNmhjo7S1/43dNzX4zCUhX8lB9AIfMPPqurhl4
	 f92CIg91ByEvzjRU5rZD/6Dc4nyfL3Bpoj50L6zIur6Y1q5P/usBZG1ArZEtJOC/A7
	 HHSjrfn/KW0vjpL4fkzNXqtE9LJM3HvpQeCPXug79KLNdKVkcoHFodJ8FbpN13ssvc
	 BCuzqTTF8b5ko/7eVoJAN2urfxskeR/eeaISDPyyH02ugX8U+LrtQZJnEukCemeHPf
	 oRNWBURuRQ4NHT9X0+o1CyNGIz9rGPnPOtrJUSjJw4DzDTBv+aUfwN2HsSp18pZkik
	 nwQY2g+t6QP1Q==
Received: from unknown by smtp-4-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4h4VMW4yZHz7Ly;
	Tue, 21 Jul 2026 23:07:35 +0200 (CEST)
Message-ID: <980c483b-d3ed-41be-94e0-9b28fc42b482@gibson.sh>
Date: Tue, 21 Jul 2026 23:07:35 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 1020/1266] platform/x86/amd/pmc: Add delay_suspend
 module parameter
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Hans de Goede <johannes.goede@oss.qualcomm.com>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
References: <20260721152441.786066624@linuxfoundation.org>
 <20260721152504.653512550@linuxfoundation.org>
Content-Language: de-DE, en-GB
From: Daniel Gibson <daniel@gibson.sh>
In-Reply-To: <20260721152504.653512550@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

Hi,

On 21.07.26 17:24, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.
> 

No objections, I just wonder why the commits
037f0b03c663a2 "platform/x86/amd/pmc: Dont log during intermediate wakeups"
and
a0738abd042f74 "platform/x86/amd/pmc: Avoid logging "(null)" for DMI values"

are not added for 6.6 as well (they're added for 6.12, 6.18 and 7.1).

Unfortunately intermediate wakeups happen a lot when charging while in
s2idle, so in that case dmesg gets spammed with log messages,
unless prevented by the "Dont log during intermediate wakeups" commit.

The other commit is more cosmetic, but might still make sense to add it
as well so the log messages are consistent between kernel versions.

Cheers,
Daniel

> ------------------
> 
> From: Daniel Gibson <daniel@gibson.sh>
> 
> commit 428b9fd2dce50b4dc5cd9ade10b92efcf57ce7aa upstream.
> 
> Enabling the new delay_suspend module parameter delays suspend for
> 2.5 seconds which is known to help for some AMD-based Lenovo Laptops
> that otherwise failed to send/receive events for key presses or the
> lid switch after s2idle. Apparently the EC needs to do some things
> in the background before suspend or it gets into a bad state.
> 
> There are many reports of AMD-based laptops (mostly but not exclusively
> IdeaPads) about similar issues on the web; this parameter gives
> affected users an easy way to try out if their issues have the same
> root cause and to work around them until their specific device is added
> to the quirks list.
> 
> The parameter description has a note encouraging users to report
> their device so it can be added to the quirks list, inspired by a
> similar request in parameter descriptions of the ideapad-laptop module.
> 
> The module parameter can be set to "1" to explicitly enable it,
> "0" to disable it even on devices that are assumed to be affected,
> or -1 (the default) to enable it if the device is assumed to be affected
> (according to fwbug_list[])
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=221383
> Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
> Signed-off-by: Daniel Gibson <daniel@gibson.sh>
> Cc: stable@vger.kernel.org
> Link: https://patch.msgid.link/20260611150426.3683372-4-daniel@gibson.sh
> Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/platform/x86/amd/pmc/pmc.c |   25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
> 
> --- a/drivers/platform/x86/amd/pmc/pmc.c
> +++ b/drivers/platform/x86/amd/pmc/pmc.c
> @@ -16,6 +16,7 @@
>  #include <linux/bits.h>
>  #include <linux/debugfs.h>
>  #include <linux/delay.h>
> +#include <linux/dmi.h>
>  #include <linux/io.h>
>  #include <linux/iopoll.h>
>  #include <linux/limits.h>
> @@ -147,6 +148,11 @@ static bool disable_workarounds;
>  module_param(disable_workarounds, bool, 0644);
>  MODULE_PARM_DESC(disable_workarounds, "Disable workarounds for platform bugs");
>  
> +static int delay_suspend = -1;
> +module_param(delay_suspend, int, 0644);
> +MODULE_PARM_DESC(delay_suspend,
> +		 "Delays s2idle by 2.5 seconds to work around buggy ECs, often causing keyboard issues after suspend. 0: don't delay, 1: do delay, -1 (default): let amd_pmc decide. If you need this please report this to: platform-driver-x86@vger.kernel.org");
> +
>  static struct amd_pmc_dev pmc;
>  static int amd_pmc_send_cmd(struct amd_pmc_dev *dev, u32 arg, u32 *data, u8 msg, bool ret);
>  static int amd_pmc_read_stb(struct amd_pmc_dev *dev, u32 *buf);
> @@ -817,8 +823,23 @@ static bool amd_pmc_want_suspend_delay(s
>  	 *
>  	 * See https://bugzilla.kernel.org/show_bug.cgi?id=221383
>  	 */
> -	if (!disable_workarounds && amd_pmc_quirk_need_suspend_delay(pdev)) {
> -		dev_info(pdev->dev, "Delaying suspend by 2.5s to avoid platform bug\n");
> +	if (amd_pmc_quirk_need_suspend_delay(pdev)) {
> +		/*
> +		 * delay_suspend=1 force-enables this, otherwise it can be
> +		 * disabled with disable_workarounds or delay_suspend=0
> +		 */
> +		if (delay_suspend == 1 || (delay_suspend == -1 && !disable_workarounds)) {
> +			dev_info(pdev->dev, "Delaying suspend by 2.5s to avoid platform bug\n");
> +			return true;
> +		}
> +		dev_info(pdev->dev, "Not delaying suspend because of module parameter, even though your device is assumed to need it!\n");
> +	} else if (delay_suspend == 1) {
> +		dev_info(pdev->dev, "Delaying suspend by 2.5s because delay_suspend=1. If this solves problems on your machine, please report this whole line to: platform-driver-x86@vger.kernel.org so it can be automatically detected as affected in the future. System Vendor: \"%s\" Product Name: \"%s\" Product Family: \"%s\" Board Vendor: \"%s\" Board Name: \"%s\"\n",
> +			 dmi_get_system_info(DMI_SYS_VENDOR),
> +			 dmi_get_system_info(DMI_PRODUCT_NAME),
> +			 dmi_get_system_info(DMI_PRODUCT_FAMILY),
> +			 dmi_get_system_info(DMI_BOARD_VENDOR),
> +			 dmi_get_system_info(DMI_BOARD_NAME));
>  		return true;
>  	}
>  	return false;
> 
> 

