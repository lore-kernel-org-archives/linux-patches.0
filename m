Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED224166316
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 21:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722460715; cv=none; b=NoE9IcIsXyo0MhZ9P/Qx5gTpGkEG4qHViV1cYeiun2vV5aRNzJfA+PArSf1D1FgmG2BrOJl56bIBr5PV00WM5APpcC+FRWxv2P873DF4EZbeRiEao/2OI7omy4yctrRfb822E1iA8eIpILEt9IRUtk7UM/CVX67lJZv+d6KkA6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722460715; c=relaxed/simple;
	bh=NqiclvbCP2OQ7Ina8jDYF9/McnZrsd+Z4GR+MnQQhls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=ZALs+pgRiYIAV+YsluQbtu1VZ/cpWQgg65hxXW96ayPqRg8YcgyATFPq2bVwf4rSK0kKRpsehPLq1Lkc2Kl45va26WHIS1GUfJkZj1b46DnslgX3FkKYcCGkh0qkgodpBKq2w3uPqtHb1+wrKXftd2tYhEAAguV/ZFzLuNTvUug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gW8tycoB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gW8tycoB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722460712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bKdInG1OtpKpxRilEfiRw+XNZcY8cbOzLiAZonQhq90=;
	b=gW8tycoBJO1ORvyVeCX7SwITAU3n1uxR5hkxPeIcR/u7UubyGI4xztkgQ3SPD3N8qSxPu8
	rZoTRwLYanOD2wwcnu/+q0EMdB044J9l+kUkuuPURU758HtzVh85VvA/OY+rEApxVZNpat
	5TxvNVGsudeU1dqXT6RX6ivdRXH3h+Q=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-696-ne2wDfxqPm-1fC45mtHFwA-1; Wed, 31 Jul 2024 17:18:30 -0400
X-MC-Unique: ne2wDfxqPm-1fC45mtHFwA-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-52ebdbf8a7cso4856181e87.2
        for <patches@lists.linux.dev>; Wed, 31 Jul 2024 14:18:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722460709; x=1723065509;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bKdInG1OtpKpxRilEfiRw+XNZcY8cbOzLiAZonQhq90=;
        b=vKtgLWvOLLrhkaD4/ipkm6dn7pVJPnE9MrF+VY6rxVeWzsLmCyWcRexCwtzgbHbgxy
         5/MBR3BRungnR6ksSQy/7WhtbQMB3IRimX8jJsBQvvJZ7GQrOcX3Y/4WPVCuKAdLEUHu
         KUv8A/dltAn72MXFmG2PAWkyaMPZJKbtzMsNPH+8TFNacn+6aFZlR+BmdgfhCi6LqmUh
         7OyAoVYd+6JumGsti8F93GN/q7S0g7W9HwkCj3C+spqpIehK7w9ywRhkb+thoZ62I0w6
         bvkRcc/H+ANVO2pc1mBGh4kPq0Q5MZzvi69vYKvPrAy3ejvEtwEYpoSWDkX2G2fsszco
         1VlQ==
X-Forwarded-Encrypted: i=1; AJvYcCX7jQQkRs+5QSH3VIQ5W9+6ETtElR/3an842Y9S4OlPhIFczyywKejUi2aEjxpRG1MngnrKEVS2KUSi/47c4UvhIx6f7dJwuQ==
X-Gm-Message-State: AOJu0YyQ//OM97wVLdV3ZbHayDgR0rYaFKkkYSQ0LgJnXkRHf5cGnyOJ
	OsIadUCn5Cd7eruvKGishViTxvnBvmfi1a1WCSoA817gjdcRTqS7aI9vgm7YiMxbaSjUdxco7FN
	IY4IijBSUevjKRjDDZZb/quI8FQhMMeeJMPsaGtX7DzJ16D7qAuE5XIU=
X-Received: by 2002:a05:6512:b05:b0:52e:9fd3:f0ca with SMTP id 2adb3069b0e04-530b61c8b29mr166280e87.33.1722460709331;
        Wed, 31 Jul 2024 14:18:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFAl7TOmiwrb7SR7IgnOM2SF/1zCAF5fHO3YQpg6C1uxKqXSkE3RpxPj0fCYXGG+w88vd9rOw==
X-Received: by 2002:a05:6512:b05:b0:52e:9fd3:f0ca with SMTP id 2adb3069b0e04-530b61c8b29mr166260e87.33.1722460708510;
        Wed, 31 Jul 2024 14:18:28 -0700 (PDT)
Received: from redhat.com ([2.55.14.19])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ac63b59c95sm9280320a12.50.2024.07.31.14.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jul 2024 14:18:27 -0700 (PDT)
Date: Wed, 31 Jul 2024 17:18:22 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Pirko <jiri@nvidia.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.10 259/809] virtio_net: add support for Byte Queue
 Limits
Message-ID: <20240731171750-mutt-send-email-mst@kernel.org>
References: <20240730151724.637682316@linuxfoundation.org>
 <20240730151734.824711848@linuxfoundation.org>
 <20240730153217-mutt-send-email-mst@kernel.org>
 <2024073119-gentleman-busybody-8091@gregkh>
 <Zqph1kRQx0FU4L3I@nanopsycho.orion>
 <2024073128-emergency-backspin-11ff@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <2024073128-emergency-backspin-11ff@gregkh>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 31, 2024 at 06:12:35PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Jul 31, 2024 at 06:09:58PM +0200, Jiri Pirko wrote:
> > Wed, Jul 31, 2024 at 07:46:26AM CEST, gregkh@linuxfoundation.org wrote:
> > >On Tue, Jul 30, 2024 at 03:33:18PM -0400, Michael S. Tsirkin wrote:
> > >> On Tue, Jul 30, 2024 at 05:42:15PM +0200, Greg Kroah-Hartman wrote:
> > >> > 6.10-stable review patch.  If anyone has any objections, please let me know.
> > >> 
> > >> Wow.
> > >> 
> > >> It's clearly a feature, not a bugfix. And a risky one, at that.
> > >> 
> > >> Applies to any stable tree.
> > >
> > >Now dropped, thanks.
> > 
> > I wonder, how this got into the stable queue?
> 
> Stable-dep-of: f8321fa75102 ("virtio_net: Fix napi_skb_cache_put warning")

Well, hmm. Something to fix in the auto-backport machinery then.

-- 
MST

