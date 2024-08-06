Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4D8F4FA
	for <patches@lists.linux.dev>; Tue,  6 Aug 2024 07:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722929799; cv=none; b=BODzA5eTIGSgbUbCNPwtXyQQjMDGvmU1sjEtLIucfxGNsWj9qaWwTOXjlEuEm/wNXEAQUeODXU95dlFfhViDTcMKU2TEvOZIUgWEnSGzhVqVVJM/dRvSWxLj128588Htkz9DQrc89dSgX8+rZQ64WlllHi47VSvfnHHON07UlJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722929799; c=relaxed/simple;
	bh=I6C7BvaUdAdLwrh0Gvt52aGRJGIfDLorbag6PNqslJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ph4CSRWzRMVQOa4O7g2bfBItcEk8mUUaRO6Myj0AwQcAp2q9e8lxRLpKu11VFvvBqJQvkfWJPnAPA/VfLyatN6adwbyBZxuO0c48cQxEdjlxHn2AOjurLZHdKFuSPfksJYahaFNNposIukf8a4CY7WfLT5jd26QbdMIPVE21UsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch; spf=none smtp.mailfrom=ffwll.ch; dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b=JwPBxtXc; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ffwll.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="JwPBxtXc"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5a5809a3bb9so84735a12.3
        for <patches@lists.linux.dev>; Tue, 06 Aug 2024 00:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1722929796; x=1723534596; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6mk2bppyKJsnVJWowW5xQtdoiHCN7fHbxwO5CmO/0Bw=;
        b=JwPBxtXcNxLDbdGMyLUCSVrYD2qroJLqnd6U5hyFuojT689MXw+KKNvwREaZgDEy6e
         uINAUhHG0+EpA3Yk8r7jZuQe62Y/xyTI1PvyTYqiHXrBPEyIc16xtg8AFf4KfEwxc43y
         sIVwZZjTZfSJsBlIrjzAqypjVQNb7czxSugcA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722929796; x=1723534596;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6mk2bppyKJsnVJWowW5xQtdoiHCN7fHbxwO5CmO/0Bw=;
        b=w7Jhv4JSYUfjE41ObD93+Kk4lH9jG/3LFM7XjD/XVkdq25Z0owfROrco/sXQRqHfOO
         Syzyv/naGAkrQ8EbczVggz//k6HqpVotk3zoyLQ8aVujMSY0PN/JbtxkSKPu/X34ymst
         gQTGwlN5THlMJhounRzSTvTQ/7yx8xUOjGi4ADXJpFrWmgmweLLn5ESyYomjvPpRVA88
         yle409QEuH7nPnm71qONxip5lLTg5SI+hybAfYotFY+BlC7DqjSFIV45XRBPGVN/gCs6
         CG7CAdpFzkdE4spmswRlxSAA2DjwG7KYRikKpLAnycEwKaVhiz3M2ZoFt7UyN2u4Wy9W
         Pe3g==
X-Forwarded-Encrypted: i=1; AJvYcCWhlXQeELUGN2/RQogtsE0IDQ2JEr06NmPXm3bsbtXnMyFK+Yybc9kU8BaO3sjtF84hC3B70FRL@lists.linux.dev
X-Gm-Message-State: AOJu0YxtYIOXEnlCdmqJp1oH7zvuV6lUMeJ5UPIKevozyuvkhcwQxzFs
	8XxiIgLBlinWBwUXSk/iK+GV6Y4GvyykY0KsUS4gsnis1H8qB7CfzI9p5++t/gE=
X-Google-Smtp-Source: AGHT+IHp36jwmXv281xIil1Gmq67KWIYfMhgLPlQxDUcljWG7XdWSCCH5FHUuoURIkKftUhg7mwqgQ==
X-Received: by 2002:a50:cdd2:0:b0:5af:85fc:1a98 with SMTP id 4fb4d7f45d1cf-5b7f0bd9e72mr6518502a12.0.1722929796195;
        Tue, 06 Aug 2024 00:36:36 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ba8ddf4fe7sm3506750a12.92.2024.08.06.00.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Aug 2024 00:36:35 -0700 (PDT)
Date: Tue, 6 Aug 2024 09:36:33 +0200
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Itay Avraham <itayavr@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	linux-doc@vger.kernel.org, linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Aron Silverton <aron.silverton@oracle.com>,
	Dan Williams <dan.j.williams@intel.com>,
	David Ahern <dsahern@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, Jiri Pirko <jiri@nvidia.com>,
	Leonid Bloch <lbloch@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>, linux-cxl@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v2 2/8] fwctl: Basic ioctl dispatch for the character
 device
Message-ID: <ZrHSgfzb0lz-Qa9s@phenom.ffwll.local>
References: <0-v2-940e479ceba9+3821-fwctl_jgg@nvidia.com>
 <2-v2-940e479ceba9+3821-fwctl_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2-v2-940e479ceba9+3821-fwctl_jgg@nvidia.com>
X-Operating-System: Linux phenom 6.9.10-amd64 

On Mon, Jun 24, 2024 at 07:47:26PM -0300, Jason Gunthorpe wrote:
> diff --git a/include/linux/fwctl.h b/include/linux/fwctl.h
> index ef4eaa87c945e4..1d9651de92fc19 100644
> --- a/include/linux/fwctl.h
> +++ b/include/linux/fwctl.h
> @@ -11,7 +11,20 @@
>  struct fwctl_device;
>  struct fwctl_uctx;
>  
> +/**
> + * struct fwctl_ops - Driver provided operations
> + * @uctx_size: The size of the fwctl_uctx struct to allocate. The first
> + *	bytes of this memory will be a fwctl_uctx. The driver can use the
> + *	remaining bytes as its private memory.
> + * @open_uctx: Called when a file descriptor is opened before the uctx is ever
> + *	used.
> + * @close_uctx: Called when the uctx is destroyed, usually when the FD is
> + *	closed.
> + */
>  struct fwctl_ops {
> +	size_t uctx_size;
> +	int (*open_uctx)(struct fwctl_uctx *uctx);
> +	void (*close_uctx)(struct fwctl_uctx *uctx);

Just a small bikeshed, I much prefer the inline kerneldoc style for ops
structs. It allows you to be appropriately verbose and document details
like error handling (more important for later additions) or that e.g. they
all must finish timely for otherwise fwctl_unregister hangs, without the
comment becoming an eyesore.
-Sima
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
