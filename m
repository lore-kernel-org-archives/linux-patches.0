Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436EB258CED;
	Sun, 26 Oct 2025 20:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761510023; cv=none; b=sinT5Y5G8AvAxxbfZkPqFOhYbirGbANu43kXpz0/4rzs9T4kJRLya8MqwxpTpUDLKWBp2t/mNI4t4ZCwZFH4qjTlI6vXahELCTTIluKamk2AGM5/SBtn8ZkG+LL3pYuwPulwyzb1sfEWbh7wE77y5PzhbIHMSS5kf8NmbOrrrR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761510023; c=relaxed/simple;
	bh=sRswTRQ8BhFz1jE9+FF7nCc4VY4RBuM0yj9/aPl83vQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gpGqW214WTapdEd3mY4dPnhsGPOuPAaprZXDWYaQ+WIFbpoNhio+4CAfEVrVzZSMuCJyh9otAjXC+sXLPiZj0azwtGvQNzysz9WZ11ZGweejkTIRlHz5nK+MfqyL5Nt5oZKojoonIcQPhyIa/sW9FXcaX9gUqMS4skXNBg3cSFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=qjsl7Esq; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="qjsl7Esq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qaep31UbZlY0IUQFvcmK+EkI0Uq2zB6hu6wgp5CoWPI=; b=qjsl7Esqr7PGH43u2oAWsrrLNz
	a8GK4EPBpKrqOzt2LLz4pZOC5G7FVYyhp0e9STfmgET/ZpDjHaWIkH3SgkRqmO3/m+okzG8aH7sTQ
	kqo//E6J4rvCWF+l3wseQKmMam2N0PjuOQZwo2nszaBHcFjLZCfkEhNUHL903mGl76XVpYBVjjIRJ
	4jnr9sZtFkD/ysnlh5qb2kcgH6c7/Lie2prZcZIsc4EKRenvh1oXYYNdh2GDBwnLo1el10sNG2zO9
	VNYFRtUAmhBCPY6CePHGrK/P2GAPIi1dOMerumXCSEkWaaFpuyYzs+ZKMxfaCEh/5ZptBI/zjYDot
	tvHLtxLw==;
Received: from 179-125-70-177-dinamico.pombonet.net.br ([179.125.70.177] helo=quatroqueijos.cascardo.eti.br)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1vD7Dl-00FVHb-Hx; Sun, 26 Oct 2025 21:20:10 +0100
Date: Sun, 26 Oct 2025 17:20:03 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH AUTOSEL 6.17-6.6] char: misc: Make misc_register()
 reentry for miscdevice who wants dynamic minor
Message-ID: <aP6Cc9G8Il3W1LGb@quatroqueijos.cascardo.eti.br>
References: <20251025160905.3857885-1-sashal@kernel.org>
 <20251025160905.3857885-64-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251025160905.3857885-64-sashal@kernel.org>

On Sat, Oct 25, 2025 at 11:54:55AM -0400, Sasha Levin wrote:
> From: Zijun Hu <zijun.hu@oss.qualcomm.com>
> 
> [ Upstream commit 52e2bb5ff089d65e2c7d982fe2826dc88e473d50 ]
> 
> For miscdevice who wants dynamic minor, it may fail to be registered again
> without reinitialization after being de-registered, which is illustrated
> by kunit test case miscdev_test_dynamic_reentry() newly added.
> 
> There is a real case found by cascardo when a part of minor range were
> contained by range [0, 255):
> 
> 1) wmi/dell-smbios registered minor 122, and acpi_thermal_rel registered
>    minor 123
> 2) unbind "int3400 thermal" driver from its device, this will de-register
>    acpi_thermal_rel
> 3) rmmod then insmod dell_smbios again, now wmi/dell-smbios is using minor
>    123
> 4) bind the device to "int3400 thermal" driver again, acpi_thermal_rel
>    fails to register.
> 
> Some drivers may reuse the miscdevice structure after they are deregistered
> If the intention is to allocate a dynamic minor, if the minor number is not
> reset to MISC_DYNAMIC_MINOR before calling misc_register(), it will try to
> register a previously dynamically allocated minor number, which may have
> been registered by a different driver.
> 
> One such case is the acpi_thermal_rel misc device, registered by the
> int3400 thermal driver. If the device is unbound from the driver and later
> bound, if there was another dynamic misc device registered in between, it
> would fail to register the acpi_thermal_rel misc device. Other drivers
> behave similarly.
> 
> Actually, this kind of issue is prone to happen if APIs
> misc_register()/misc_deregister() are invoked by driver's
> probe()/remove() separately.
> 
> Instead of fixing all the drivers, just reset the minor member to
> MISC_DYNAMIC_MINOR in misc_deregister() in case it was a dynamically
> allocated minor number, as error handling of misc_register() does.
> 
> Cc: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
> Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
> Link: https://lore.kernel.org/r/20250714-rfc_miscdev-v6-5-2ed949665bde@oss.qualcomm.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> 
> LLM Generated explanations, may be completely bogus:
> 
> YES
> 
> - What it fixes
>   - Dynamic-minor misc devices that reuse their `struct miscdevice`
>     across probe/remove or unbind/rebind can fail to re-register if
>     another device grabs the old dynamically allocated minor in the
>     interim. On re-register, the stale `misc->minor` value is treated as
>     a static request, returning -EBUSY instead of allocating a fresh
>     dynamic minor. This is exactly the failure described for
>     `acpi_thermal_rel` when raced with `dell_smbios`.
>   - In this tree, `misc_register()` decides dynamic vs. static solely by
>     checking `misc->minor == MISC_DYNAMIC_MINOR`
>     (drivers/char/misc.c:177). If a previously dynamic device calls
>     `misc_register()` with a leftover non-255 minor, it is treated as
>     static, and the duplicate check can fail if the number is taken.
> 
> - Why the change is correct and minimal
>   - The patch resets `misc->minor` back to `MISC_DYNAMIC_MINOR` during
>     deregistration, but only if the device had a dynamically allocated
>     minor. In the posted diff this appears as:
>     - After freeing the minor: `misc_minor_free(misc->minor);`
>     - Then reset: `if (misc->minor > MISC_DYNAMIC_MINOR) misc->minor =
>       MISC_DYNAMIC_MINOR;`
>   - This mirrors existing error handling already present in
>     `misc_register()` that restores `misc->minor = MISC_DYNAMIC_MINOR`
>     on registration failure (drivers/char/misc.c:214). Making
>     deregistration symmetrical is consistent and expected.
>   - The change is tiny (two lines), touches only `drivers/char/misc.c`,
>     and does not alter any API or architecture.
> 
> - Evidence the bug exists here
>   - Deregistration frees the dynamic minor bit but does not reset
>     `misc->minor` (drivers/char/misc.c:241–251). Thus, the stale minor
>     persists across lifecycles.
>   - There are in-tree users that reuse a static `struct miscdevice` with
>     `.minor = MISC_DYNAMIC_MINOR` across add/remove. Example:
>     `acpi_thermal_rel` registers/deregisters a static miscdevice
>     (drivers/thermal/intel/int340x_thermal/acpi_thermal_rel.c:359, 369,
>     373–375). Unbind/rebind without module unload leaves the static
>     object in memory with the old minor value, triggering the re-
>     register failure described in the commit message.
> 
> - Backport notes
>   - Older trees (like this one) use a 64-bit dynamic minor bitmap with
>     indices mapped via `i = DYNAMIC_MINORS - misc->minor - 1` and
>     `clear_bit(i, misc_minors)` (drivers/char/misc.c:241–250), not
>     `misc_minor_free()`. The equivalent backport should reset
>     `misc->minor = MISC_DYNAMIC_MINOR` only if the minor was dynamically
>     allocated, which can be inferred by the same range check already
>     used before clearing the bit:
>     - If `i < DYNAMIC_MINORS && i >= 0` then it was a dynamic minor;
>       after `clear_bit(i, misc_minors);` set `misc->minor =
>       MISC_DYNAMIC_MINOR;`.
>   - Newer trees using `misc_minor_free()` may use a different condition
>     (as in the diff). Adjust the condition to the tree’s semantics; the
>     intent is “if this was a dynamically allocated minor, reset it.”
> 

The LLM got it right here. This won't work for 6.6.y and 6.12.y. The check
for dynamically allocated minors is different on those versions.

> - Risk assessment
>   - Very low risk:
>     - Static-minor devices are unaffected.
>     - Dynamic-minor devices now always behave as “dynamic” on re-
>       register, which is the intended contract.
>     - Change is localized, under the same mutex as the rest of the
>       deregistration path.
>   - Positive impact:
>     - Fixes real user-visible failures on unbind/rebind or probe/remove
>       cycles.
>     - Consistent with `misc_register()` error path behavior
>       (drivers/char/misc.c:214).
> 
> - Stable criteria
>   - Fixes a real bug that affects users (unbind/rebind failures).
>   - Small, contained change in a well-scoped subsystem.
>   - No new features or architectural changes.
>   - Signed-off-by by Greg Kroah-Hartman, matching subsystem ownership.
> 
> Given the above, this is a strong candidate for stable backport.
> 
>  drivers/char/misc.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/char/misc.c b/drivers/char/misc.c
> index 558302a64dd90..255a164eec86d 100644
> --- a/drivers/char/misc.c
> +++ b/drivers/char/misc.c
> @@ -282,6 +282,8 @@ void misc_deregister(struct miscdevice *misc)
>  	list_del(&misc->list);
>  	device_destroy(&misc_class, MKDEV(MISC_MAJOR, misc->minor));
>  	misc_minor_free(misc->minor);
> +	if (misc->minor > MISC_DYNAMIC_MINOR)
> +		misc->minor = MISC_DYNAMIC_MINOR;

For 6.12 and 6.6, this should be:

	if (misc->minor > MISC_DYNAMIC_MINOR ||
	    (misc->minor < DYNAMIC_MINORS && misc->minor >= 15))
		misc->minor = MISC_DYNAMIC_MINOR;

Or pick 31b636d2c416 ("char: misc: restrict the dynamic range to exclude
reserved minors"), or just drop this from 6.6 and 6.12.

Cascardo.

>  	mutex_unlock(&misc_mtx);
>  }
>  EXPORT_SYMBOL(misc_deregister);
> -- 
> 2.51.0
> 
