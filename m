Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4183546E4
	for <patches@lists.linux.dev>; Wed, 10 Jun 2026 17:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781114342; cv=none; b=NWxPlPji31AATIxDkHja/P3SbwAsl5dxSuhoid4aQSv+VvZESNp3kqpzHrpsalgusjYatmMz/efP2s3zT+zJhLOGwKaoRlqFHXAt1UpkTHl0P3yX7u4yJ16DO/vDS1iwC/D4lLQASVx9TQbVYhqpQzsbQH0klJBdvfeu9Web0S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781114342; c=relaxed/simple;
	bh=rjDwk63GlpD6IcSyJ6iGWBTG0j4qGvoDZhdWCYjXdCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MuOqQcaqK8HjcWpT6A+SyDGzt1A83IBWlRiVTcONAYgd+U4PqTfC8uljuIz5L5EJW/vwx57FdX2VBvi37ExTcKGHrFgFQ7ra7zyC9l24Z8NtKM897ZJm9eFwP5Bvx1B3CT0DCXaRVdY7PBbnf9p9JVsjtRorB6mntRjME/pWfVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YVdOjj89; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YVdOjj89"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2bf2911f93cso9425ad.1
        for <patches@lists.linux.dev>; Wed, 10 Jun 2026 10:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781114340; x=1781719140; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aDcoxqooq3aEAqC8ohG0LuHtDb4TZolRXl4+Rn70IsU=;
        b=YVdOjj896M3FsFHd06BEgf39PH5V7/63xhGtmXYkpSmbewE9ah5opNtWbA99lwT0w/
         MzV1M09vlcAE4vT7sc1hoH8R0C5uFzJ0TDSO0GZF+jtb9FeId07hMUdKFvNu/gO2zCIa
         ZQCiZw6N3oPhFZtI302Neh+CBNFICCMTIL8Skqi92x+kv2ElMCNcnrQwHvd6TwI3fSIm
         s6g7kyB+ou+wj19N6YX96pLS3dKv0/gK3u9+nEn4u3xUbO4Ig9zzz8ZpaXPIP+JuCA0A
         xb+vhBR6DG2rZzhbLv3Iak5cW0w1Npsa+vnaeKaWIu6Xuxh8OQ46DiY/wabpyEWNMnVH
         e8+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781114340; x=1781719140;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aDcoxqooq3aEAqC8ohG0LuHtDb4TZolRXl4+Rn70IsU=;
        b=BDuGPPDZdCrh2f66mFi4yPdXQmtPhbg8PecKxyseyesMMm23kLH0Jbd/f6L/OKan7d
         sYDfgbjY+aq9ckKQNTotuS9qmaH5REsQsu2GieXzBIw8jaFHvbgqeW/WLHT1VuIs3xc7
         OhImvYfQd14B+cyAlCef2rryf8Ec8ICO8wGOHHItaMabxqHnSAg2+F4GHn6Vr3HeFC74
         bq/Yr0XlbOQoHTEdM490F2YUqR1vxKnq3bIiST5Cod3ks7hIZbaVrea90iX24Zk0ZzuJ
         OishDItdAzkdjUUVLpBT5VWd3N+9OkBI4RDdMRekZZcyS4lJwkuaBi4Q58lzvxc7UTqO
         3VJQ==
X-Forwarded-Encrypted: i=1; AFNElJ8DNIkRzvFIuO++KTvpXpbOgBinWk3Od1fqcMgY9iUH5eWH0+/7dVLE6ewOFDOPs6IvODlNHK7b@lists.linux.dev
X-Gm-Message-State: AOJu0Yzv5IY82hyppKA5QHUft4MM0xJfp1nZY2k+g/ABpx/BsmiXDA/y
	a9jGpXuWfSot7p/fudwDEy85WDSK8ELogFIXFKaY78A786VBC0HQaKhL/oAMjsN/iQ==
X-Gm-Gg: Acq92OGA1XVIpxPo8wFGaD1SOS+uuhME/6fmvNYlr1BdHG8U2yxJMM9Hkpplc3JkxNd
	uxmYPRgjNHT76aiksLXx1gE3oDlyB02IymyrTj0VWmo/PFIaU9gtxZlfwi6dzJ0qBR9Ny53RZMK
	GaiYeZOCuzXACcqE6jLFt5M74Dw1hVAxKhfsy3jvZt2KN44oAGBKAl8UHH5Xw1doPVwhqFwNmN+
	jRYCasHWtNxqHX+MZ4iqnf3IRAbmqG7JBZ/QcBPQ+PbfO0dc1S4xv6E3o2aFk85iROxlJroTosD
	qt6KhUMuk3Ob79G9jUKWXtW4C96syQZPXh6zYTc2mLrEo2c0ugWl5M0XMiq2wg0gZJOtFenc+Z6
	wx8YVipJB4tvuNqkXqnGVcv5FTdKZBCAw540WagNDuYbT3kQ8qXVtGOcwgxGRw56WKoLk5Zszzw
	iH5fmsfmZwe2XlotMc2EKVOHH/wFhdG099b5JU+yKFKx2A3QcAVcw0KXdbiQFlPpqgXou2h9fLv
	lIsU4nCV+dTwvQKlCSNG9dYxuzaO/EuVZL4QDV0cvTD8yhsCXl6o7Rq
X-Received: by 2002:a17:902:e84e:b0:2bf:749:551 with SMTP id d9443c01a7336-2c2d93c9b9cmr564445ad.22.1781114339342;
        Wed, 10 Jun 2026 10:58:59 -0700 (PDT)
Received: from google.com (112.174.16.34.bc.googleusercontent.com. [34.16.174.112])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8428221a7e9sm33046676b3a.11.2026.06.10.10.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 10:58:58 -0700 (PDT)
Date: Wed, 10 Jun 2026 17:58:54 +0000
From: Carlos Llamas <cmllamas@google.com>
To: Sasha Levin <sashal@kernel.org>
Cc: gregkh@linuxfoundation.org, stable@vger.kernel.org, khtsai@google.com,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	raubcameo@gmail.com, andrzej.p@samsung.com, balbi@ti.com,
	kyungmin.park@samsung.com, linux-usb@vger.kernel.org,
	Jianqiang kang <jianqkang@sina.cn>
Subject: Re: [PATCH 6.6.y] usb: gadget: f_ncm: Fix net_device lifecycle with
 device_move
Message-ID: <aiml3pDOjudjX71j@google.com>
References: <20260608053636.2797024-1-jianqkang@sina.cn>
 <20260608-stable-reply-0013@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608-stable-reply-0013@kernel.org>

On Mon, Jun 08, 2026 at 08:51:59PM -0400, Sasha Levin wrote:
> > [PATCH 6.6.y] usb: gadget: f_ncm: Fix net_device lifecycle with device_move
> 
> I can't take this one (6.6 or 6.1) on its own. ec35c1969650 alone opens a
> userspace-reachable NULL deref in eth_get_drvinfo() that is later closed
> upstream by e002e92e88e1 ("usb: gadget: u_ether: Fix NULL pointer deref in
> eth_get_drvinfo"), so applying this commit by itself trades a UAF for a DoS.
> 
> Please send a complete backport that also includes e002e92e88e124 (as the
> follow-up patch in the same series) for both 6.6.y and 6.1.y, and I'll queue
> them together.

I just ran this patch plus a cherry-pick of e002e92e88e1 that you
mentioned through Android's CI with no issues. Same goes with 6.1.y, so
I can send Jianqiang's backports with the fix added to them.

Cheers,
--
Carlos Llamas
