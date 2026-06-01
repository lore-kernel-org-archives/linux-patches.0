Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF383AC0C6;
	Mon,  1 Jun 2026 13:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780321633; cv=none; b=othP8ZrmmBnh7ThOPxC2kY5X3d0YpiKjVcsxSeBjvo20d3hsj6A0WuALRSoZbzohXMJ4xkGsWWWV+JhbU1D3D/ftWjd/47MSH0Yzh5Go+z/YnHyWlL0kgo2xKLCsukaQ3aUQIIfrFdOgB66IjAxlpp/jnfIIpRR8cjInYfgwWWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780321633; c=relaxed/simple;
	bh=ivlCxRGNF386tPnWGgTKC/CptXjnGcRIfgnH6QoM0Qo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nupdSxFsf2gHdYkdU7bJ/H0l2DZBigLLWMHriqu0d2fCQfCti0gY0y//9LjzTLzJVZR+xZrqCmZeJujw4aJTvcLQxyhAUWmmS5awhlV6U2t61mc4DkRVdi9Em9AU+mV3JVH5Zt8YYh0RRkcxhzqvwwtxs0skuIHitpvf115JNf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d0LzBg/2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d0LzBg/2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27AD1F00893;
	Mon,  1 Jun 2026 13:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780321632;
	bh=Y2GwDticJOYvIEvRsKmZv4Q0rmxiNh+m4wf3y2Pi0+I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=d0LzBg/2CcTTXR4+l/9upmvZ41AZlNzgAKKC9xzBTv6zwIgqp8Sz5cAxW1wxt8kup
	 OR08IMwAemJnUFfq1YsW+Yq1kmgS1NAoVePWPHyLZSYbYjYBWQhYjO4Uj12a1+7YgP
	 BgTgq20QvSFdmW5lcrvBsexKNl3NwajfoI7du+wuZEBRpcGWAFwAJiKdIJlWuVnhVX
	 aymtaNahYiOmu65Slzqpi5rnPrD0cfRJx942sKJ+3w7IxeMgTun9n24mvHbQCcHltV
	 wWx11iLkT24S0xS3JBiRDIrCglB5gcu/Y/cFAPUxlz9JBe7FbsulpvZzRAbB2IQqgC
	 +yHRCb0cEAUlw==
Message-ID: <4858069b-ee61-4469-960e-3c56c2ccc4fc@kernel.org>
Date: Mon, 1 Jun 2026 16:47:05 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/589] 5.10.258-rc1 review
To: Pavel Machek <pavel@nabladev.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Chris.Paterson2@renesas.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260530160224.570625122@linuxfoundation.org>
 <ah1HCk9vuUMCzAvU@duo.ucw.cz>
Content-Language: en-US
From: Claudiu Beznea <claudiu.beznea@kernel.org>
In-Reply-To: <ah1HCk9vuUMCzAvU@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi, all,

On 6/1/26 11:47, Pavel Machek wrote:
> Hi!
> 
>> This is the start of the stable review cycle for the 5.10.258 release.
>> There are 589 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
> 
> We see boot failures on 5.10-cip:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2564188475
> https://lava.ciplatform.org/scheduler/job/1451830

This should be related to the patch:

commit 0f86a559900f
Author: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Date:   Tue Apr 7 14:37:41 2026 +0300

     phy: renesas: rcar-gen3-usb2: Lock around hardware registers and driver data

     commit 55a387ebb9219cbe4edfa8ba9996ccb0e7ad4932 upstream.

     The phy-rcar-gen3-usb2 driver exposes four individual PHYs that are
     requested and configured by PHY users. The struct phy_ops APIs access the
     same set of registers to configure all PHYs. Additionally, PHY settings can
     be modified through sysfs or an IRQ handler. While some struct phy_ops APIs
     are protected by a driver-wide mutex, others rely on individual
     PHY-specific mutexes.

     This approach can lead to various issues, including:
     1/ the IRQ handler may interrupt PHY settings in progress, racing with
        hardware configuration protected by a mutex lock
     2/ due to msleep(20) in rcar_gen3_init_otg(), while a configuration thread
        suspends to wait for the delay, another thread may try to configure
        another PHY (with phy_init() + phy_power_on()); re-running the
        phy_init() goes to the exact same configuration code, re-running the
        same hardware configuration on the same set of registers (and bits)
        which might impact the result of the msleep for the 1st configuring
        thread
     3/ sysfs can configure the hardware (though role_store()) and it can
        still race with the phy_init()/phy_power_on() APIs calling into the
        drivers struct phy_ops

     To address these issues, add a spinlock to protect hardware register access
     and driver private data structures (e.g., calls to
     rcar_gen3_is_any_rphy_initialized()). Checking driver-specific data remains
     necessary as all PHY instances share common settings. With this change,
     the existing mutex protection is removed and the cleanup.h helpers are
     used.

     While at it, to keep the code simpler, do not skip
     regulator_enable()/regulator_disable() APIs in
     rcar_gen3_phy_usb2_power_on()/rcar_gen3_phy_usb2_power_off() as the
     regulators enable/disable operations are reference counted anyway.

     [claudiu.beznea:
      - in rcar_gen3_init_otg(): fixed conflict by droppping ch->soc_no_adp_ctrl 
check
      - in rcar_gen3_phy_usb2_irq() use spin_lock()/spin_unlock() as scoped_guard()
        is not avaialable in v5.10
      - in probe(): replace mutex_init() with spin_lock_init()
      - rcar_gen3_phy_usb2_power_off() replaced scoped_guard() as it is not
        available in v5.10
      - in rcar_gen3_phy_usb2_power_on() droppped guard to avoid compilation
        warning "ISO C90 forbids mixed declarations and code"]

     Fixes: f3b5a8d9b50d ("phy: rcar-gen3-usb2: Add R-Car Gen3 USB2 PHY driver")
     Cc: stable@vger.kernel.org
     Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
     Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
     Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
     Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
     Link: 
https://lore.kernel.org/r/20250507125032.565017-4-claudiu.beznea.uj@bp.renesas.com
     Signed-off-by: Vinod Koul <vkoul@kernel.org>
     Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
     Signed-off-by: Sasha Levin <sashal@kernel.org>

In this backported version I failed to replaced the msleep() with mdelay() as it 
was in the original patch.

The following patch should fix this problem and align the v5.10 backport support 
with the currently upstream one: 
https://lore.kernel.org/all/20260501225859.504868-1-nobuhiro.iwamatsu.x90@mail.toshiba

Greg, since this fix ^ aligns v5.10 stable with the current upstream support, 
would there be a way to integrated it in v5.10 stable as well?

I am currently working to remove this long sleep in atomic context from upstream:
https://lore.kernel.org/all/20260528070826.478813-1-claudiu.beznea@kernel.org

> 
> This may be related to
> 
> [PATCH v3] phy: renesas: rcar-gen3-usb2: Avoid long delay in atomic context

This is not yet integrated in upstream.

Thank you,
Claudiu

> 
> but I don't see related patches in the shortlog below. I put Renesas
> people in the cc list, they should know more.
> 
> Best regards,
> 									Pavel
