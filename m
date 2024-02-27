Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC9D14D425
	for <patches@lists.linux.dev>; Tue, 27 Feb 2024 20:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709066348; cv=none; b=bM5vuQYxZ9JwI4oxw5mFUvwRbiOPVSXBJVtumFugvPjczGrTPzLdGJABgItmBNIvawDt4/nSd+fFCQUJR6hdggTGxRhXHMV4KgsdcLrJNA/Oj/Q2X2azVObA5k5PuYbKf8MIBUtRoroKeLmO7+PnfCDsuEfzUEMqF3vpznueGu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709066348; c=relaxed/simple;
	bh=xdH9wQvuibGdS3521b3Yl5pFCguEtjPF9Q1VnrR7fFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sv2Lq95nfOGIMns5ls0s1hZ+kwaUa7ZuVFKTANwCBtS2gVze0muBvudSRPiBVVTxVP1Ztuc4g9jZ/Y+3NCgC3XP4u/ZjaRUxDIAI84pNqSCnLNW/RA0yFB39APww+Koj5K6hqlq9Xl/R/aJauYce/FodzcH1zvOsHXdw5+DSY/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=marliere.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=marliere.net header.i=@marliere.net header.b=bLRbZEz6; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=marliere.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marliere.net header.i=@marliere.net header.b="bLRbZEz6"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6e544f927d4so159294b3a.0
        for <patches@lists.linux.dev>; Tue, 27 Feb 2024 12:39:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709066345; x=1709671145;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from
         :dkim-signature:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X59fJ/J27eMKvNmrbhkx6PxMNMDqien6ZCKa8BPpIww=;
        b=v2ecGexu0q4F8YjDtx2Fms0Qw7SiygBNSudm9cbu/4KM3oWyjU/LzboGb6Zsu97Yvv
         aTP3iLmOoDXyOVBONRkO+zRx71r4cHbrPMBBJDTy6xKECUZ73B50e9Awlf3k+sZORw84
         DQu/hfDpxY+otgaWmzbsA5jUO26aAeGNu7p3oZtb83rzqiPxVfTUiW8ewSUiG2vIuAu2
         i+nJQJonO4+oe1CMFXTYQ27suy1Uis5hi8jrwmCpimCUYs+owYUI+5Meb8CpnCHgorJy
         DgAlg+9R/B034IlUWTK+4D1UOxy6I4iM3LTJy3VeYEUanoVDC05R3/Yq9/L88tzc74q2
         pS0A==
X-Forwarded-Encrypted: i=1; AJvYcCXwzFa1LS+6I9firzvz8xh+L9macIXjtIeuc5DVUSoaCP52lP+z/Bi7MISbLHbDYqMb6NbDF7EGoy7nltfkoBPPbIofh4cvMA==
X-Gm-Message-State: AOJu0YwdaDuJxw9OWqZZoCe2K+QGGrP+6oCPadmXVY1g3jVRKEbofppi
	i2A5AxWyA/SWvRYonzKHpjn/46MxdbC8Bcd/QhjtMGXwk7tCLJaE
X-Google-Smtp-Source: AGHT+IFb6JG7YBhYPZqeAm8ix8wFHy6yu6Mt/bkWiC5vchN3UVxztPKRng0x+W4ZGdC2kfbQIvZmmA==
X-Received: by 2002:a05:6a20:2d11:b0:1a0:f7d0:e680 with SMTP id g17-20020a056a202d1100b001a0f7d0e680mr625884pzl.5.1709066345278;
        Tue, 27 Feb 2024 12:39:05 -0800 (PST)
Received: from mail.marliere.net ([24.199.118.162])
        by smtp.gmail.com with ESMTPSA id r6-20020a655086000000b005dab535fac2sm5280361pgp.90.2024.02.27.12.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 12:39:04 -0800 (PST)
Date: Tue, 27 Feb 2024 17:39:55 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=2024; t=1709066343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X59fJ/J27eMKvNmrbhkx6PxMNMDqien6ZCKa8BPpIww=;
	b=bLRbZEz6uGE7FJfH+n71Urgd0JxhXeNRZSQruhon2LuAPDpvUb1H9jN1mIeywNQmnUN5qp
	FZEvCOzcDK9q90gVkgil4kBb180OIuiiTD/at90R6TBJFhizjGiY7uryfrWwvztJxtcvv2
	w4JZxnXb/JNA9XQ4lULlhdq9P1Wks0VXDorjZIF5+AmuaPUJHIIMIx0nUwzoZesnuakKtG
	qkE2yP4WnL49GnLNRhjhkD+iJ2sEqUbFUHOtQOJWUuF6mBsjYO6C3rcOlBZoDe4gkenAkC
	mvXMjgWyK0rgF8DudDLbJzRXOOAjyx5gU81e5baZOy2W+AGtBhT7S/OHl6wrnw==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=ricardo@marliere.net smtp.mailfrom=ricardo@marliere.net
From: "Ricardo B. Marliere" <ricardo@marliere.net>
To: Nathan Chancellor <nathan@kernel.org>
Cc: sre@kernel.org, linux-pm@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] power: supply: core: Fix power_supply_init_attrs() stub
Message-ID: <mlfrfarnnv3i4xwgqd3pavpwxjktkqf2afidoc4ogdq3634jah@kposnyo6725z>
References: <20240227-fix-power_supply_init_attrs-stub-v1-1-43365e68d4b3@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240227-fix-power_supply_init_attrs-stub-v1-1-43365e68d4b3@kernel.org>

Hi Nathan,

On 27 Feb 13:34, Nathan Chancellor wrote:
> When building without CONFIG_SYSFS, there is an error because of a
> recent refactoring that failed to update the stub of
> power_supply_init_attrs():
> 
>   drivers/power/supply/power_supply_core.c: In function 'power_supply_class_init':
>   drivers/power/supply/power_supply_core.c:1630:9: error: too few arguments to function 'power_supply_init_attrs'
>    1630 |         power_supply_init_attrs();
>         |         ^~~~~~~~~~~~~~~~~~~~~~~
>   In file included from drivers/power/supply/power_supply_core.c:25:
>   drivers/power/supply/power_supply.h:25:20: note: declared here
>      25 | static inline void power_supply_init_attrs(struct device_type *dev_type) {}
>         |                    ^~~~~~~~~~~~~~~~~~~~~~~
> 
> Update the stub function to take no parameters like the rest of the
> refactoring, which resolves the build error.
> 
> Fixes: 7b46b60944d7 ("power: supply: core: constify the struct device_type usage")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/power/supply/power_supply.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> ────────────────────────────────────────────────────────────────────────────────
> modified: drivers/power/supply/power_supply.h
> ────────────────────────────────────────────────────────────────────────────────
> @ drivers/power/supply/power_supply.h:25 @ extern int power_supply_uevent(const struct device *dev, struct kobj_uevent_env
> 
> #else
> 
> static inline void power_supply_init_attrs(struct device_type *dev_type) {}
> static inline void power_supply_init_attrs(void) {}

I've missed that #else in my building test. Thanks for catching it.

Reviewed-by: Ricardo B. Marliere <ricardo@marliere.net>

> #define power_supply_uevent NULL
> 
> #endif /* CONFIG_SYSFS */
> 
> --
> base-commit: 3da8d71754d3c1aa0b72d74c8a324a4bc7fab473
> change-id: 20240227-fix-power_supply_init_attrs-stub-7be5328b4e72
> 
> Best regards,
> - 
> Nathan Chancellor <nathan@kernel.org>
> 
