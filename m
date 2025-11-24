Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53CCDDC5
	for <patches@lists.linux.dev>; Mon, 24 Nov 2025 10:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763980252; cv=none; b=Od6q31YYneHZYWZelBEiA1VbZPFmZ8YjWpCfq8VGJJBqzKZawSZnf3u8/Tv1Gc9WnU12HK4LH8pkBBXqFtPM9oYK6MPmih1JVW5pGGKpchEyRdJOo7w5CKkP6MjECggKysVvS2Q/z2SF9vp4Aq7xXdybodqceewV0UMxBwv442U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763980252; c=relaxed/simple;
	bh=h+6tU4BC4F1P+zHlJEhy4xvq/Rtffs5b/r87AmI+WpA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ElC5nNoFx1ngIHfCiuLSrty3Yn2Rb/Q/lqc4c2UF9QaZaNqzEuyvbfvmHfDoMP8SVvNna4X92puIxaQfLZhpfxMXWjwmqdbRnl6ypF3IUX+ueroW/JhqMvbi62mHHc9O2+hhqI2U+ar8mwiQmaY9RRO3VNRRYVu5QYwcV+O1Zqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riscstar.com; spf=pass smtp.mailfrom=riscstar.com; dkim=pass (2048-bit key) header.d=riscstar-com.20230601.gappssmtp.com header.i=@riscstar-com.20230601.gappssmtp.com header.b=Kk7FbYba; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riscstar.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=riscstar.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=riscstar-com.20230601.gappssmtp.com header.i=@riscstar-com.20230601.gappssmtp.com header.b="Kk7FbYba"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4775895d69cso16798755e9.0
        for <patches@lists.linux.dev>; Mon, 24 Nov 2025 02:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=riscstar-com.20230601.gappssmtp.com; s=20230601; t=1763980249; x=1764585049; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4c093UhJVULliuhoXS0buCOSXcGwmlWet+kmHrIixLs=;
        b=Kk7FbYbagefhGBThiIQLPa0EZw647tavmwKrB9QGhgGkAOzlR9NbSMTkBSh99LoPWr
         APYTnRyRS8nf00lgcnNQsM9EAZU4b7PHh/FCyN11susTdHR/duLgjSlSvIZ2rk3TtgKx
         /G9mwXQ9S/IJ6ivnL/SmlviEVvJ2IT6a3O2txkLHo3l0LHdjpApqycm+2Mj5i/gyO4tj
         dRvpd+PZ/ZNaRzdNhFZ02wvXWACH6rzrR42Qfk2aAqxDOtY+cJ6BzOujWkP93wSHVd/c
         RMkfeny8NQBqHXjYlJvnZuEJ8aXmkNu4OvMQUm4zJ0/VXDzUATstS7zy45cKAlNyN8SD
         UVxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763980249; x=1764585049;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4c093UhJVULliuhoXS0buCOSXcGwmlWet+kmHrIixLs=;
        b=NqLeClcdxJcaSG1S7D6Ua4cqNmqam0Y6Ams1ybQuwBmbxxLtqZqyM0dtvERiPuEm2r
         cpliUS40sspVycSPUeF860Zqgzw/FWeJpX8w9JLl6QrMn2yThGFbiCvptX0m0ZrZJYI1
         BZ7jeXH5zoki3Bb9ecaGmb1j6vaRiNnFHVxtk0ws/BrKxjwNhBAm4xTMDC8Ej9zKR8q7
         1rj+VrM5cZmvPX/DppSIjh6GSu9imo54l6FPP6RxGSiqIQqOWC1Wt5k11SJi44dCg7a6
         wglaeKXi9fTLQR4Pp11ZYG2hJ7QRqOI1CIhPg18IrPOR9zVpPLcLLxvzQrnOxxdnQuLk
         ZuSw==
X-Forwarded-Encrypted: i=1; AJvYcCU7GDGWUSEmmuWuLdzrmRKQkoKNYKxwwkGx2s43IpuKFSREOe/itbC/IJEBPFmrFF/uXxRd2mjt@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+2W7F0vPk5j8s0Py6tmo3HFiJMEJIfXesLQZdzfungtUlCu9c
	rdA31K6svAfrTlIPJSAJa9tllluO+W+4O1h7BWztXa3GSXuiPHF371iUzHVTP0c4Wdc=
X-Gm-Gg: ASbGncvSnFbAJmt7nwDAg/6PjajezHrAExlEKsuc+5sUMS4nwTOASZT3shRMMAifmZA
	0LbyOzNH1nFK391++Are7ilHTx+CMk407PJK400mXUmLTAAstnF8eZY0k/gyvzv+sHweBn6Zwiu
	gmUzpDS44KI/7K7NoipXk5lRiam1uFnBve48zyq2MrII46OJHnMpgDTOuaIesWMq3CKR0U9s0P/
	8+KNYYWM0Y0AV8o2p7p9MCwkKCIexpMkNwNck+99glaaA98pXB/ALyg+CzcWQVl6gV+41ePZ7e5
	/dTNTfiI3MDLn/6DW/F38cErK29hZ826cRhX10Bcgu64A6WzOSV/bRD7K1KtKBmfr4cryHXijHU
	Cc8o/10moK8OcxW1rIsYlBSJ/qFqGFs3YpAK7vORgl5d4XePBF0qBeva+Th/+Xz4wcD2bT0WkCB
	H3qSjxjbY7yi8lteFHuQe2UpTXABLItk/iCW1c9mLm80CVWq0GZ2TFn5e7qTfbsyKEpm7H+A==
X-Google-Smtp-Source: AGHT+IHPvlWQDf6K1Dga8MvZAdfzerPWHGBEBq8a4QKy7lgUieNkzL+6lwU5ijEhA9SrymIWtcSJSQ==
X-Received: by 2002:a05:600c:35cf:b0:477:9a28:b0a4 with SMTP id 5b1f17b1804b1-477c00ee003mr144798845e9.0.1763980248870;
        Mon, 24 Nov 2025 02:30:48 -0800 (PST)
Received: from aspen.lan (aztw-34-b2-v4wan-166919-cust780.vm26.cable.virginm.net. [82.37.195.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf227ae2sm188134925e9.9.2025.11.24.02.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 02:30:48 -0800 (PST)
Date: Mon, 24 Nov 2025 10:34:32 +0000
From: Daniel Thompson <daniel@riscstar.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Lee Jones <lee@kernel.org>, Daniel Thompson <danielt@kernel.org>,
	Jingoo Han <jingoohan1@gmail.com>, Helge Deller <deller@gmx.de>,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Junjie Cao <caojunjie650@gmail.com>,
	dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] backlight: aw99706: Fix unused function warnings from
 suspend/resume ops
Message-ID: <aSQ0uLLsvnWy_yvj@aspen.lan>
References: <20251120-backlight-aw99706-fix-unused-pm-functions-v1-1-8b9c17c4e783@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120-backlight-aw99706-fix-unused-pm-functions-v1-1-8b9c17c4e783@kernel.org>

On Thu, Nov 20, 2025 at 01:22:46PM -0700, Nathan Chancellor wrote:
> When building for a platform without CONFIG_PM_SLEEP, such as s390,
> there are two unused function warnings:
>
>   drivers/video/backlight/aw99706.c:436:12: error: 'aw99706_resume' defined but not used [-Werror=unused-function]
>     436 | static int aw99706_resume(struct device *dev)
>         |            ^~~~~~~~~~~~~~
>   drivers/video/backlight/aw99706.c:429:12: error: 'aw99706_suspend' defined but not used [-Werror=unused-function]
>     429 | static int aw99706_suspend(struct device *dev)
>         |            ^~~~~~~~~~~~~~~
>
> SET_SYSTEM_SLEEP_PM_OPS, used within SIMPLE_DEV_PM_OPS, expands to
> nothing when CONFIG_PM_SLEEP is not set, so these functions are
> completely unused in this configuration.
>
> SIMPLE_DEV_PM_OPS is deprecated in favor of DEFINE_SIMPLE_DEV_PM_OPS,
> which avoids this issue by using pm_sleep_ptr to make these callbacks
> NULL when CONFIG_PM_SLEEP is unset while making the callback functions
> always appear used to the compiler regardless of configuration. Switch
> to DEFINE_SIMPLE_DEV_PM_OPS for aw99706_pm_ops to clear up the warning.
>
> Additionally, wrap the pointer to aw99706_pm_ops in pm_ptr() in
> aw99706_i2c_driver to ensure that the structure is completely eliminated
> in configurations without CONFIG_PM.
>
> Fixes: 88a8e9b49ee8 ("backlight: aw99706: Add support for Awinic AW99706 backlight")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>


Daniel.
