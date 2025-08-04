Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1AF417BA9
	for <patches@lists.linux.dev>; Mon,  4 Aug 2025 18:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754330860; cv=pass; b=BP3bC8ZHC5CLS0iLVEQTKQ8jRCRvmb2EyLBaWtimYXzFbIfKF5iHAWBA7CrZhpv6NKHeW11v4Qn7lUN1OfrHHVu9UPeWVCTHI9kRh7KAu43fmKy9540Vaew1P+X+du5cO/jtjVkcnKYsEYqUpyQiuVcp+fqHpa3shVvA+2flaPo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754330860; c=relaxed/simple;
	bh=9/EJtyi2MJ4uix1b9BuM6nox6vXfr/9YpAKEQyCzFC8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rl3+kCv/0vKiHs+0Sc9QqvxgcfnCKgRp2c0dCWC9s1U/sElM8yow3F2W8Mo0q8iydELAGjEIrxi7i1SExmhTFS7bSQ/W1q5lcFypJx56+98bEG5d6wSs1apIncte/Ko+OojrpNr/+pMS95/GuOVBBhSlz11BXucC6NGYhmWbeVs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=sebastian.reichel@collabora.com header.b=GHCXDWlq; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=sebastian.reichel@collabora.com header.b="GHCXDWlq"
ARC-Seal: i=1; a=rsa-sha256; t=1754330854; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=PCn+MzV8KEN1dDOO0oXOJhxrLAodzY+YnHlA5oRDJzIN8tfthFcf6l0oNWL8RpevSC25zGt0dCFuCW0Od9rS6NtdhSXuxuxvlsFV1vS8atk+pSnQ9PecOJZKivIvqhHDvdWeqp22esmS/yQQSEqMqrTIrPQoh8g/9Zx+93wKczo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1754330854; h=Content-Type:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=0p9zPy5jCnAuCNh1cEZc3mWRWv1QVhhioFIGXyoHewU=; 
	b=OqIAIcktrahq8KAQgijRa+AvVqAJ35P/kRbf5XeAH5ie5ni+cjJobUEqNlpMxAnyrTcTMInXmH479oi1Dre+6c7TDt+clZ8kb3df0pPPLYT+53q4KtyjqmkS32rqx31j3CGNIFwVuZnd8vN7Vo/EFCsaOMwlbeZZx48kp46gJ+M=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=sebastian.reichel@collabora.com;
	dmarc=pass header.from=<sebastian.reichel@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1754330854;
	s=zohomail; d=collabora.com; i=sebastian.reichel@collabora.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Subject:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To:Message-Id:Reply-To;
	bh=0p9zPy5jCnAuCNh1cEZc3mWRWv1QVhhioFIGXyoHewU=;
	b=GHCXDWlqt76/8JCnHZmXTSJ3fmhUsIZpa007c5E69Jgoir0uH4TITezXhdmOji1G
	sFedqjM8oxkVio0HBKz3QIwtFC81tq/aosfxON9/eCgJDnRWeW/I7l9yMB0jj9PLyTt
	1xyZALPnVTeK3R+Q5KyMVuFkvnZ8ii/GhH5tBAw8=
Received: by mx.zohomail.com with SMTPS id 1754330850944626.5522935698707;
	Mon, 4 Aug 2025 11:07:30 -0700 (PDT)
Received: by venus (Postfix, from userid 1000)
	id D3C1A180645; Mon, 04 Aug 2025 20:07:27 +0200 (CEST)
Date: Mon, 4 Aug 2025 20:07:27 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.com>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, 
	Yongbo Zhang <giraffesnn123@gmail.com>, Heikki Krogerus <heikki.krogerus@linux.intel.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, krzysztof.kozlowski@linaro.org, Hans de Goede <hansg@kernel.org>
Subject: Re: [PATCH AUTOSEL 6.16 73/85] usb: typec: fusb302: fix scheduling
 while atomic when using virtio-gpio
Message-ID: <3m7xyylzbchxe6jtblcat6gq4nqam5ifq65wzrq3kknz6yqyfe@atyst565drka>
References: <20250804002335.3613254-1-sashal@kernel.org>
 <20250804002335.3613254-73-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6fkhnoik22uhyibs"
Content-Disposition: inline
In-Reply-To: <20250804002335.3613254-73-sashal@kernel.org>
X-Zoho-Virus-Status: 1
X-Zoho-Virus-Status: 1
X-Zoho-AV-Stamp: zmail-av-1.4.3/254.317.26
X-ZohoMailClient: External


--6fkhnoik22uhyibs
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH AUTOSEL 6.16 73/85] usb: typec: fusb302: fix scheduling
 while atomic when using virtio-gpio
MIME-Version: 1.0

Hello Sasha,

On Sun, Aug 03, 2025 at 08:23:22PM -0400, Sasha Levin wrote:
> From: Yongbo Zhang <giraffesnn123@gmail.com>
>=20
> [ Upstream commit 1c2d81bded1993bb2c7125a911db63612cdc8d40 ]
>=20
> When the gpio irqchip connected to a slow bus(e.g., i2c bus or virtio
> bus), calling disable_irq_nosync() in top-half ISR handler will trigger
> the following kernel BUG:
>=20
> BUG: scheduling while atomic: RenderEngine/253/0x00010002
> ...
> Call trace:
>  dump_backtrace+0x0/0x1c8
>  show_stack+0x1c/0x2c
>  dump_stack_lvl+0xdc/0x12c
>  dump_stack+0x1c/0x64
>  __schedule_bug+0x64/0x80
>  schedule_debug+0x98/0x118
>  __schedule+0x68/0x704
>  schedule+0xa0/0xe8
>  schedule_timeout+0x38/0x124
>  wait_for_common+0xa4/0x134
>  wait_for_completion+0x1c/0x2c
>  _virtio_gpio_req+0xf8/0x198
>  virtio_gpio_irq_bus_sync_unlock+0x94/0xf0
>  __irq_put_desc_unlock+0x50/0x54
>  disable_irq_nosync+0x64/0x94
>  fusb302_irq_intn+0x24/0x84
>  __handle_irq_event_percpu+0x84/0x278
>  handle_irq_event+0x64/0x14c
>  handle_level_irq+0x134/0x1d4
>  generic_handle_domain_irq+0x40/0x68
>  virtio_gpio_event_vq+0xb0/0x130
>  vring_interrupt+0x7c/0x90
>  vm_interrupt+0x88/0xd8
>  __handle_irq_event_percpu+0x84/0x278
>  handle_irq_event+0x64/0x14c
>  handle_fasteoi_irq+0x110/0x210
>  __handle_domain_irq+0x80/0xd0
>  gic_handle_irq+0x78/0x154
>  el0_irq_naked+0x60/0x6c
>=20
> This patch replaces request_irq() with devm_request_threaded_irq() to
> avoid the use of disable_irq_nosync().
>=20
> Signed-off-by: Yongbo Zhang <giraffesnn123@gmail.com>
> Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Link: https://lore.kernel.org/r/20250526043433.673097-1-giraffesnn123@gma=
il.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

I suggest to wait wait a bit with backporting this commit until the
discussion I just started has been resolved (also applies to all the
other stable kernel releases you included this patch for):

https://lore.kernel.org/linux-usb/m7n22g5fsfvpjz4s5d6zfcfddrzrj3ixgaqehrjkg=
7mcbufvjc@s4omshvxtkaf/

Greetings,

-- Sebastian

>=20
> LLM Generated explanations, may be completely bogus:
>=20
> **Backport Status: YES**
>=20
> This commit should be backported to stable kernel trees. Here's my
> extensive analysis:
>=20
> ## Bug Analysis
>=20
> The commit fixes a critical "scheduling while atomic" bug that occurs
> when the fusb302 USB Type-C controller uses GPIO interrupts connected
> through slow buses (like I2C or virtio). The bug manifests as a kernel
> BUG with the following call trace showing `__schedule_bug` being
> triggered from within an atomic context.
>=20
> ## Technical Details of the Bug
>=20
> 1. **Root Cause**: The fusb302 driver's interrupt handler
>    (`fusb302_irq_intn`) calls `disable_irq_nosync()` from the top-half
>    ISR context (lines 1480-1481 in the original code). When the GPIO
>    controller is connected via a slow bus like virtio-gpio, the
>    `disable_irq_nosync()` operation requires bus transactions that can
>    sleep, which is forbidden in atomic/interrupt context.
>=20
> 2. **The Problem Flow**:
>    - Hardware interrupt occurs =E2=86=92 `fusb302_irq_intn` ISR runs in a=
tomic
>      context
>    - ISR calls `disable_irq_nosync(chip->gpio_int_n_irq)`
>    - virtio-gpio's `virtio_gpio_irq_bus_sync_unlock()` needs to
>      communicate over virtio bus
>    - This requires `wait_for_completion()` which can sleep
>    - Sleeping in atomic context triggers the kernel BUG
>=20
> ## The Fix
>=20
> The fix replaces `request_irq()` with `devm_request_threaded_irq()` and
> removes the problematic `disable_irq_nosync()`/`enable_irq()` pattern:
>=20
> 1. **Before**: Used regular IRQ handler that disabled the interrupt in
>    top-half, scheduled work, then re-enabled in bottom-half
> 2. **After**: Uses threaded IRQ handler which naturally handles the
>    interrupt masking/unmasking without explicit calls
>=20
> Key changes:
> - Line 1751-1754: Changed from `request_irq()` to
>   `devm_request_threaded_irq()` with NULL top-half handler
> - Line 1481: Removed `disable_irq_nosync()` call from ISR
> - Line 1625: Removed corresponding `enable_irq()` call from work
>   function
> - Line 1750: Removed `free_irq()` call (handled by devm_*)
>=20
> ## Stable Backport Criteria Evaluation
>=20
> 1. **Fixes a bug affecting users**: YES - This fixes a kernel BUG that
>    causes system instability
> 2. **Relatively small and contained**: YES - Only 7 lines changed,
>    confined to one driver file
> 3. **Clear side effects**: NO - The fix is straightforward with no
>    architectural changes
> 4. **Major architectural changes**: NO - Simply changes IRQ registration
>    method
> 5. **Critical kernel subsystems**: NO - Limited to USB Type-C controller
>    driver
> 6. **Stable tree mention**: NO - But follows stable tree rules perfectly
> 7. **Follows stable rules**: YES - Important bugfix with minimal risk
>=20
> ## Additional Considerations
>=20
> - The bug only manifests with specific hardware configurations (virtio-
>   gpio or slow I2C GPIO expanders)
> - The fix is a standard pattern used throughout the kernel for similar
>   issues
> - Using `devm_request_threaded_irq()` is actually cleaner and provides
>   automatic cleanup
> - No functional changes to the driver's behavior, only fixes the atomic
>   scheduling violation
> - Similar fixes have been applied to other drivers facing the same issue
>   pattern
>=20
> This is an ideal stable backport candidate: it fixes a real bug that
> causes kernel panics, the fix is minimal and well-understood, and
> there's virtually no risk of regression.
>=20
>  drivers/usb/typec/tcpm/fusb302.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/usb/typec/tcpm/fusb302.c b/drivers/usb/typec/tcpm/fu=
sb302.c
> index f15c63d3a8f4..f2801279c4b5 100644
> --- a/drivers/usb/typec/tcpm/fusb302.c
> +++ b/drivers/usb/typec/tcpm/fusb302.c
> @@ -1477,9 +1477,6 @@ static irqreturn_t fusb302_irq_intn(int irq, void *=
dev_id)
>  	struct fusb302_chip *chip =3D dev_id;
>  	unsigned long flags;
> =20
> -	/* Disable our level triggered IRQ until our irq_work has cleared it */
> -	disable_irq_nosync(chip->gpio_int_n_irq);
> -
>  	spin_lock_irqsave(&chip->irq_lock, flags);
>  	if (chip->irq_suspended)
>  		chip->irq_while_suspended =3D true;
> @@ -1622,7 +1619,6 @@ static void fusb302_irq_work(struct work_struct *wo=
rk)
>  	}
>  done:
>  	mutex_unlock(&chip->lock);
> -	enable_irq(chip->gpio_int_n_irq);
>  }
> =20
>  static int init_gpio(struct fusb302_chip *chip)
> @@ -1747,9 +1743,10 @@ static int fusb302_probe(struct i2c_client *client)
>  		goto destroy_workqueue;
>  	}
> =20
> -	ret =3D request_irq(chip->gpio_int_n_irq, fusb302_irq_intn,
> -			  IRQF_ONESHOT | IRQF_TRIGGER_LOW,
> -			  "fsc_interrupt_int_n", chip);
> +	ret =3D devm_request_threaded_irq(dev, chip->gpio_int_n_irq,
> +					NULL, fusb302_irq_intn,
> +					IRQF_ONESHOT | IRQF_TRIGGER_LOW,
> +					"fsc_interrupt_int_n", chip);
>  	if (ret < 0) {
>  		dev_err(dev, "cannot request IRQ for GPIO Int_N, ret=3D%d", ret);
>  		goto tcpm_unregister_port;
> @@ -1774,7 +1771,6 @@ static void fusb302_remove(struct i2c_client *clien=
t)
>  	struct fusb302_chip *chip =3D i2c_get_clientdata(client);
> =20
>  	disable_irq_wake(chip->gpio_int_n_irq);
> -	free_irq(chip->gpio_int_n_irq, chip);
>  	cancel_work_sync(&chip->irq_work);
>  	cancel_delayed_work_sync(&chip->bc_lvl_handler);
>  	tcpm_unregister_port(chip->tcpm_port);
> --=20
> 2.39.5
>=20

--6fkhnoik22uhyibs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmiQ9t8ACgkQ2O7X88g7
+prUhRAAi4r19w+eSan+XF6XTFjI7XP8D1vb7ie6jaDmPVd2GGzCIDMC+KAeXbPM
/bhv1bOgi8LpNuYpTym1ifuSy3sjU1U2TF1t85lQTYcNGAaTvAQOGhgLRNYa2MWH
DeEP6pl8g9H9wSVbZixqwCMcVxVKe24sWe9sHHqZk2/qcyiD2WdbRZYfaoOhYxAX
HN3nlI4GE3O2vua16Xzfb71DKIyGoZaiZMn/xBpKQLWm9y93ijhckM2AGjE0h6YU
2W3abV878lLyXutc54pnIrk2Ib3MYzDOuIU2isKOmWKej5rk4RGU4/i+2iTZOhHX
LIjz9UNEMcOPAzl3K46mWBRaqVW9fFWCaLh3m7SuMdl4lMDpHi70gt1EawpuZl1z
WJXzSidgyZVNwGnhMHYqRGYjAAB2ZhMMoTDeqV7gHQ/ciX0KPREFUPy5kLpKnFaG
WqG+J1Dn/ATXHUA0NpMm8wbub71cNdVeUqdnZw0IWG0cYVROD0S8834Pdq6bbSla
K+mYmz976dJBKMpmcOCmhxBj2JjgEAyEaIVNRujW7bbiT24j3l0MNWlKGbYKxpe7
rcYIbkjkxsD4rrUZM9VRhz6lOzQB18eiiqktGV2jHpusC97umMk23wqbdboDlgjY
RADYodWrjCBUxoXARByK5JXotRuwfJZh4W3Rk2MdGUvlI4sxyKk=
=3Smq
-----END PGP SIGNATURE-----

--6fkhnoik22uhyibs--
