Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B465225D7
	for <patches@lists.linux.dev>; Wed,  8 Jan 2025 03:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736308661; cv=none; b=cRyKrsaYcp5AnJv3J4Kr2SJo1iqRHW0xULQZV6AMUQimxIMzSN9DKYcvMaXDiO0lMBJENplFIU+gjsqERu07AJoaBiKNtLtF6ijn3EQZ+t1KmkRl2G7oyqkrqYPYS2mT54mroCYLoTr56jrnBTjn7NXcBLId4IUrK3eoFk/QCUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736308661; c=relaxed/simple;
	bh=HFAP6Z27ggflbOwbqei/tPnM7E/jc5voO6Q/60x7cCQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AbGMc2tm0Lz/tNmD8vLOmjO7EX51fR4F5A88Xs/twSMyUBCuXiRPThOiE/Z466U/NUDLyuRKX1FLY2uOyr4N/73HBNLizE9m3AeBdfOltpFTF7WXJWlF+utS9QUYOOTq5CGeC+HtlRIHTIMxoSumudz0Y+ULqMIB5hx6q72JB3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=kswwTUx7; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="kswwTUx7"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2f441791e40so19385791a91.3
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 19:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1736308660; x=1736913460; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IponVW/M+FnCmeuwMnKczDOxfpK2ZzCUGsvfkspw3lo=;
        b=kswwTUx7mxrOVtJmgQsBXX9DgwpNFKnp6mR2mjxs8ohKClutMlKdmzTGASsQaYFyrq
         YJ3/D+eLv73ZYswwnrt56r2WnuhECYPV8UOIeNDnxLXF/A0wozKDhwWEagpfCqCsGKAh
         o1YomeMVpeoV+TZ0C0Dx82aZC7YGXG8YSErJo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736308660; x=1736913460;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IponVW/M+FnCmeuwMnKczDOxfpK2ZzCUGsvfkspw3lo=;
        b=g8dpL37niOuBwGQKLO97Ls7omzyRP2nJTnsBSiYvjQXTYjGE2+GN1dwou9spQ6ZZ4b
         9FegMs43b/PJ4l8SDYX5zwq6S12PUyOq7E3FkVPyGIWX6v/imzm+/e9mCPTzBqF2PWy3
         XuAQ2W8pM0B503cIep1DvYFx0yAZpou4JllfEnWIIzQzso35B6WM8471KgPs6PRma7zX
         GJxMa3fhY+AXx6EfYd83sm88bpaH1nMq8NQQP259dPyAY0sFxB/ZzFkIXfNiqFzb8Rxh
         1TCapjtn/9jZXh+qmrUH58sOvtUj2BN4i7fGzDUq9NUKp4sBj8/dNyfZ9Gb6i/lU7jtk
         VKtw==
X-Forwarded-Encrypted: i=1; AJvYcCX0l6yCshuQEuW39Zdm9r2HGkl4CHV5DF5/gdBhrBfKua1nmNT1pd+MJDdX1G5SezlhKXwx2KIs@lists.linux.dev
X-Gm-Message-State: AOJu0YxuI4JzaHbDyvaQTUfDovbUwazutFijNj/GvdH4rWc7c93SymCW
	2hPQH3K0H6lnkXKt3dBgL26odmlP+viWUCOzU5JYkCratYZIRb6nZEcw+KfN+g==
X-Gm-Gg: ASbGncsS8L1vYhZ1r31h/Bf+3MuOO7tMMk9lJRPSgTsU0eR8jlenqpXeNxRiesSUSo3
	xVRm57UcbiyQownuhFnY52VZboR5P4NHZv/UM4npCS0mXXHtwsuBy5VSIu+5WKaWYG1YcXnd7q9
	p48QURLXoFUvrY7hqPZ+FBASNHsOwGsv3vcOtoqxhnCgjRpQN8sI87b2sUoevScj35ayvFQMRJ2
	XJJOduR/Ze8IgZ4QUoAMg+AvK8KeNefX4puCbL+U8Go/lhR8EDoUrmizGdq
X-Google-Smtp-Source: AGHT+IF1jV4TMg8uxC/I2vIoxriNkws4tuVNpHjLTgWdv9bAUYjLRlHBJroU8Xxrj96i568sNEJiSA==
X-Received: by 2002:a17:90b:56cb:b0:2ee:c04a:4281 with SMTP id 98e67ed59e1d1-2f548f102demr1967055a91.6.1736308659843;
        Tue, 07 Jan 2025 19:57:39 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:57ef:1197:3074:36c2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f54a265fffsm402107a91.2.2025.01.07.19.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 19:57:39 -0800 (PST)
Date: Wed, 8 Jan 2025 12:57:34 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Kairui Song <kasong@tencent.com>, Desheng Wu <deshengwu@tencent.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.1 58/83] zram: fix uninitialized ZRAM not releasing
 backing device
Message-ID: <fg53jy5btcr7cgfltwknct766wdurl34nkblh3wylhiawz2vje@zh6p4yc4wdjt>
References: <20241223155353.641267612@linuxfoundation.org>
 <20241223155355.874444273@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241223155355.874444273@linuxfoundation.org>

On (24/12/23 16:59), Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Kairui Song <kasong@tencent.com>
> 
> commit 74363ec674cb172d8856de25776c8f3103f05e2f upstream.
> 
> Setting backing device is done before ZRAM initialization.  If we set the
> backing device, then remove the ZRAM module without initializing the
> device, the backing device reference will be leaked and the device will be
> hold forever.
> 
> Fix this by always reset the ZRAM fully on rmmod or reset store.
> 
> Link: https://lkml.kernel.org/r/20241209165717.94215-3-ryncsn@gmail.com
> Fixes: 013bf95a83ec ("zram: add interface to specif backing device")
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Reported-by: Desheng Wu <deshengwu@tencent.com>
> Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Can we please drop this patch?
