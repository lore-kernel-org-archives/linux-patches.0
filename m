Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795688943;
	b=PHsDat0gXJ8Q/hJyTfIOzlnbwn2FU6+HFEyLmmd59XSdgNSeaEWY3R9u/7RK6spkCwwY
	 2V4ESXVvl2Oi75QoPdoPbHmKsp0tj3K5AXmrF7trSCO2sRzoGqEj43rcvXFtMC2fD/TvS
	 9x4NVPcklwjA4y8U2x3Ns8pAcGKr+12AOJbWHpWG8dMH9TgieRGwKv8NtLObUN2J7OSP5
	 GcGp2G0GGVn5Ep500NpspJvU5O78MRGu3eIkoT4tX5P2rrWAQqKVXkk5Pba6S4GA9fXl3
	 yBaRj+EOGI50iF623BYh/nmzFQkRWIg4dfNzOOLrE/xYiB6Nd96B1xpdizZm13ugf4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795688943;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=R+7rhXnZ1gY96gjLnofIqdr2fJQxfTPvt1Dq9WYDRV0=;
	b=YrV4qHNVGUsSCZyID24L7C1LUNWTQ8OpiUFGYoTGGkQ2rcJFe4yQ1Hmz1WNQIBiesY7Z
	 DyItLk1rgKP+x7SopwgwC9dZoAuWnhDSUx8ikr6VWFIZvACI8Dmg/B2xWexDLfkWCx3O6
	 Z0Ql4Ti6Bb/qs3hYQQafE/ryctXoy45lVouuBT7Fi66TO3BhfB+EIvAsJHY5UCBGhMh7o
	 HksiFfq3ZKbrqYn5bjoxsyH4hY8J2jeYKdpwpDvuRUE0Hybr5+HQppSGBLOOeICYZS/Tn
	 xSG198m/vgW6HJOFLyMnXn2KFplwkuMnlkGhirBvUe4XoYSI48YJe0gWeZuK5URyW9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wg0X+ZpM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96388606A31C;
	Thu, 26 Nov 2026 10:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wg0X+ZpM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6921F000C4;
	Thu, 26 Nov 2026 10:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795688943;
	bh=R+7rhXnZ1gY96gjLnofIqdr2fJQxfTPvt1Dq9WYDRV0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=wg0X+ZpMRSsq38JmN3ul2zxFrRFARxOvVOlGp0nBY9JA/0KRIT9uVLKTTert0KL+d
	 y+fY+IqqoMPd/McJ+geAG0QGUxK7nzvmm7iTExMSaRCEmdTlNqeoY4/KjN9EoAlbJV
	 6v0N+qxBxM01Rh3bKZT5a+YJFJ7R7hbiSKpUOG8o=
Date: Thu, 26 Nov 2026 11:29:22 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Dave Airlie <airlied@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 7.3 0395/1005] drm/xe: Fix build with DRM_XE=y and
 CONFIGFS_FS=m
Message-ID: <2026112659-swivel-catering-d9b6@gregkh>
References: <20261125143821.729802100@linuxfoundation.org>
 <20261125143830.996724307@linuxfoundation.org>
 <912422fe-72c8-498b-a210-e8c385840674@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <912422fe-72c8-498b-a210-e8c385840674@kernel.org>

On Thu, Nov 26, 2026 at 08:18:48AM +0100, Jiri Slaby wrote:
> On 25. 11. 26, 15:28, Greg Kroah-Hartman wrote:
> > 7.3-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Rodrigo Vivi <rodrigo.vivi@intel.com>
> > 
> > [ Upstream commit da475c094342b6d5c8bc020b19d6900130bed047 ]
> 
> This has a later (proper) fix to actually "select CONFIGFS_FS":
> c1234293de14 ("drm: xe: select configfs")
> 
> It needs a context update (xe_configfs_get_migrate_ulls_period_ms and
> xe_configfs_get_disable_vram_page_offline do not exist in 7.3 yet), though
> -- a 7.3 backport attached.

Thanks, I noticed that this wouldn't apply, but didn't do the backport.
I've taken this also for 6.18.y as well.

greg k-h
