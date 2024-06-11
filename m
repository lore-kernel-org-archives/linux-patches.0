Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1221762C9
	for <patches@lists.linux.dev>; Tue, 11 Jun 2024 16:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718124855; cv=none; b=ums0USPGKaWOkXAICg9s1ikdkaSaju5R/pCw5RHuCzUZhswvTfZJM+pQSTg/xJIgr6F5Of9H2Bk7T26jbl0LBQpj2dd6HB/aIef3cEIhHIfNtgTymhAj4nPJ6gWUzd6vwFCiA92Ake9piYDyaZKf5jl5omKth4sTZEkYWUcPhxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718124855; c=relaxed/simple;
	bh=OrAb1OwSBRL1RD+bjKynk7YcqN0JqRD4WxAvQ9xdhGM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BKNTP2b3cS8wLg5OXTewLutfTes8/0LjLP/2vqBmH+W4s3J0CbezUK34esvD2A86V9mKFHZnDCqImTYvPURDctay8n8cfc707Bb6YtZFxJm+FDwmst2t5v4hrjk78/hjFqe4frEEPYC2yodKfHWUM03Z0XskCawLqnMHSIk4nJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch; spf=none smtp.mailfrom=ffwll.ch; dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b=XjgK3yBt; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ffwll.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="XjgK3yBt"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-35f1edc71e6so273542f8f.0
        for <patches@lists.linux.dev>; Tue, 11 Jun 2024 09:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1718124852; x=1718729652; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hw7drFVos6OlmlZtZxQCwliUjnhCqtU/xBm51s1JLQM=;
        b=XjgK3yBthC/pu23ZqjhZ1dGHErVohPR14RoVj0DDXLKzmr5GCIiEBKwgBPgPTk/p5w
         eWPwHEHJdM+5xYjip1aUdvvoB6z6L6lc8bo7om2O7B5XOagvIroeew7dwsfzN3Fkqpra
         IWkLzYWJ4z0MSMeIqFYztHPK8uqF2lBchuEMA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718124852; x=1718729652;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hw7drFVos6OlmlZtZxQCwliUjnhCqtU/xBm51s1JLQM=;
        b=OeUVFcNn69xG+Ta1zbnt5Tfkok5V8aXBdYH/I55gR6LRj/2/8x6/6XEXsx4fJTFGlO
         wYwmy5KEZv/GJxX6FK7OatGA0Y33TG2c88k5paIC3nII1S+/EEtwYARluYaXqc4nPAD4
         NEdE4BPZa6MEvoFZsqLH1KGGYQVy8+3qUwMMtM6qy/fG2Obt/p9ayF6AfcUtRAcNghHQ
         Pd60XQ8Fx+8OH+1+9GMT6WHo+UAM1m4h5miJqv2RpDimJG8rwZmwrngmszIasxagzaGi
         01iaMINYxQPp56JY/w3qngkfEgn/Tk/hUFBudhNprJjvhBp/0Zb5hKjpsGf8/atBXHs9
         h4FQ==
X-Forwarded-Encrypted: i=1; AJvYcCUAJBh06HASMOyfm9K82sUM7eJ4TuVTI9J+alp6tD2i19iBfXw1xSabaB/Z435jyvOJrUB93UsQfqliSgbi0J2qs9pSeS0rGg==
X-Gm-Message-State: AOJu0YwgBUQn9riB0W5Ehl80s8jyW7SDPyQ0y+6uAWxfilgZ5OjGOnQC
	rXAxfMjUsaI2Qus+p9fk+B1fKqvc3wFtVxhMiSWAqMEfE0XbYn+/jan64jleunU=
X-Google-Smtp-Source: AGHT+IFqYYsM2rMGUiy4YX7UaTF7NtCBy9ybwdgfBPKd11ZbCqkMYHqVBlUahONglj3MfDEkw3vRUg==
X-Received: by 2002:a5d:464b:0:b0:35f:247e:fbcb with SMTP id ffacd0b85a97d-35f247efda6mr4003276f8f.2.1718124852018;
        Tue, 11 Jun 2024 09:54:12 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4217f633f2asm111068895e9.28.2024.06.11.09.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 09:54:11 -0700 (PDT)
Date: Tue, 11 Jun 2024 18:54:09 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Daniel Vetter <daniel@ffwll.ch>,
	Dan Williams <dan.j.williams@intel.com>,
	Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Itay Avraham <itayavr@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, linux-doc@vger.kernel.org,
	linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Aron Silverton <aron.silverton@oracle.com>,
	Christoph Hellwig <hch@infradead.org>, Jiri Pirko <jiri@nvidia.com>,
	Leonid Bloch <lbloch@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>, linux-cxl@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH 0/8] Introduce fwctl subystem
Message-ID: <ZmiBMYlJ4q2xPOEY@phenom.ffwll.local>
References: <0-v1-9912f1a11620+2a-fwctl_jgg@nvidia.com>
 <20240603114250.5325279c@kernel.org>
 <214d7d82-0916-4c29-9012-04590e77df73@kernel.org>
 <20240604070451.79cfb280@kernel.org>
 <665fa9c9e69de_4a4e62941e@dwillia2-xfh.jf.intel.com.notmuch>
 <20240605135911.GT19897@nvidia.com>
 <Zmhu8egti-URPFoB@phenom.ffwll.local>
 <20240611161702.GU19897@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240611161702.GU19897@nvidia.com>
X-Operating-System: Linux phenom 6.8.9-amd64 

On Tue, Jun 11, 2024 at 01:17:02PM -0300, Jason Gunthorpe wrote:
> On Tue, Jun 11, 2024 at 05:36:17PM +0200, Daniel Vetter wrote:
> > reliablity/health reporting. That's a lot more vendor specific in nature
> > and needs to be customized anyway per deployement. And only much higher in
> > the stack, maybe in k8s, can a technically reasonable unification even
> > happen.  So again we're much more lenient about infrastructure enabling
> > and uapi than stuff applications will use directly.
> 
> To be clear, this is the specific niche fwctl is for. It is not for
> GPU command submission or something like that, and as I said to Jiri I
> would agree to agressively block such abuses.
>  
> > Currently that's enough of a mess in drm that I feel like enforcing
> > something like fwctl is still too much. But maybe once fwctl is
> > established with other subsystems/devices we can start the conversations
> > with vendors to get this going a few years down the road.
> 
> I wouldn't say enforcing, but instead of having every GPU driver build
> their own weird vendor'd way to access their debug/diagnostic stuff
> steer them into fwctl. These data center GPUs with FW at least have
> lots of appropriate stuff and all the vendor OOT stuff has tooling to
> inspect the GPUs far more than DRM has code for (ie
> rocm-smi/nvidia-smi are have some features that are potentially good
> candidates for fwctl)

Yeah "enforcing" to the level we do with 3d/vulkan would be years down the
road, if ever. Very unlikely imo for debug/diagnostics/tuning stuff.

> > In practice, it doesn't seem to be an issue, at least not beyond the
> > intentionally pragmatic choices where we merge kernel code with known
> > sub-par/incomplete userspace. I'm not sure why, but to my knowledge all
> > attempts to break the spirit of our userspace rules while following the
> > letter die in vendor-internal discussions, at least for all the
> > established upstream driver teams.
> 
> I think the same is broadly true of RDMA as well, except we don't
> bother with the kernel trying to police the command stream - direct
> submission from userspace. I can't say it has been much of an issue.

Maybe just a bit confusion, but all modern-ish drm drivers stopped parsing
the command stream a while ago. We only ever did that to fill security
gaps, never to enforce any rules about what userspace is allowed to do
beyond that.

The rule that the open userspace needs to be complete, for some reasonably
pragmatic definition of "complete", is entirely a social contract. And I'm
not aware of any real issues with enforcing that beyond just trusting the
established vendor teams. So yeah no real issues with uabi that allows
maximal abuse because it's entirely unchecked by the kernel code.

Or put differently, I think we're trying to make the same point.

> > tldr; fwctl as I understand it feels like a bridge to far for drm today,
> > but I'd very much like someone else to make this happen so we could
> > eventually push towards adoption too.
> 
> Hahah, okay, well, I'm pushing :)

Thanks :-)
-Sima
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
