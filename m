Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E56E194C8B
	for <patches@lists.linux.dev>; Fri,  7 Feb 2025 17:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738948021; cv=none; b=uG6wXuB2JjbWm312JURbrjKqHB/LAzTGNmWwNPR2mtTY/xCOeJQlWApZ0k+tEpcoRI9pkovt2FuZYEAhtfl7MEpaxj/YVChr1WvBPJU6tE9MfLOgE4WiGSaYJtvbli9b1dICVJ+0c3VwKlvaxWsrOE9svRM4+oCSqCuFeEiA4dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738948021; c=relaxed/simple;
	bh=WnxzVfiBDOWKlPrs8uy9gGAmG83nu7iJWuRjeGWbCNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TlyTFMS8ruM+5oAZDSSWfQASwFGLBb/FU84Q+4WLWouyO31jhN2TC2qLRH4PUxbG1kE6bjBLqcB3wc6x5dSQiCNxxYUgtqqrVo117p4P++LVEK/XCpfedlIcipwBdHwYfQxm+NEVGgDmvu0BUZFiK5MANL5Gm8uP6OpWY1VsGZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=jR3B2Uf/; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="jR3B2Uf/"
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 8AB8340110
	for <patches@lists.linux.dev>; Fri,  7 Feb 2025 17:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1738948016;
	bh=LpR99Ye14Bl3z61OmVYY2qgP2w3XFhQFmphCUyct0cQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:In-Reply-To;
	b=jR3B2Uf/5ZKIHOMLEi5Kwl1WL8YZTnFcpOBdO/IRTDmv3AB87MUNsUgEcSOEDAnSL
	 cTnhs+VnFT7UC8UrKBA9eIGi7y5TpBIENrzapTiX5LObkvoPCoctWRd25tQgv24KwG
	 GzsthQ/QJMmYNvsZ26OlWps+weysHVXkA4tqckewuL7riPzq6Mo7cOrwVaEcMNysLa
	 FJff4FW9S6UO6O5QPfDKdA0er82sT2MHdTLck1mcoJ5gPFzfkRnnbuf+acdH84sZZz
	 laRoZg483ezPhhvi8RYadKXN4nsdSR2iKxM7lrUn9PbRZUqxkgwQU9WrNbq3wSmWKD
	 5kSy+wd9at/sw==
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-21f078fc592so60469745ad.1
        for <patches@lists.linux.dev>; Fri, 07 Feb 2025 09:06:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738948015; x=1739552815;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LpR99Ye14Bl3z61OmVYY2qgP2w3XFhQFmphCUyct0cQ=;
        b=GC+Ixc+XNMVvNAdsoxZwLcCUW2SXocKjUZZOn5knQfumlPBK8E1x+OJI+qYmLgC3Tp
         IQ9ZHQPTtxQOT9cLpYon2VDzCQ9vn3XJKcUhqnkjMEnsgN+Y92qQEId/cuNGKfqR2r3a
         QHk88KTevWt4CBVmrvAfF1uP1OocL17DjpnMX5LB5Ek4VbzGh+0kh93Sn2IRi/eOD58r
         YsGstka7wjY8xnGAJkX+qSAJW9nS4ru+6qFcRUcDxDko1+SmMx6Z618c15FQa3Cdx6GR
         KOijNlXaVqUH8Dx8JGCobhFOmlD9uut4ebQzolxqs3AOif64cdyUuzs1Gb/KDy14otmT
         jIFw==
X-Forwarded-Encrypted: i=1; AJvYcCUirG0Npf+/od3tXkWt6vPrc1wGsRp0UlWthMe4/msml4q9PfeCouT0qomBgcYXYgFKg3rsHs8u@lists.linux.dev
X-Gm-Message-State: AOJu0Yzm5FbbzzNmYeqgxEy5zIGjZRIu2RRaht5Lzx/muktrquJ09BVU
	wTJSKIlG9v/quOf1c8mxBYaHibEgEhrhvT6l6kt10b7PdBFA0rq6z0kYy82cvOP32FcRd8CVxtL
	/zp+2fo6M+en3DC64p5N6s/83nE6bG9erMjeuU0WCydT/oZJWnFQlxLp/+peQ2spqjsJtKTd9OV
	jJ6G8=
X-Gm-Gg: ASbGncsXgBimFCYx7wcdEBMzWToUhCYi2vT28cg193IL7FGawkSPLfuqt+OvCLpZNg4
	x+7LTggIsggECeD20aqIOQblN/fJm7hVPNTY3SOh81QjSLPKvlFlfbCLCH5E1viUQloodxbcSEZ
	+j8FEhjftKFMNWaKnFRYzdtTmf82BoMvkI2+m6ZaFp/YJDSqu3KvfegCNYN7YFOP94NeAeMTnNN
	ufLTdhwxo2asz5EMTbB7xuyrsLGZ+zQ37+3H483S4OyA2RIHxeyRjstaTDtt1DfYHd3Zvortp7G
	GX/1ey4=
X-Received: by 2002:a05:6a21:3406:b0:1e0:ce11:b0ce with SMTP id adf61e73a8af0-1ee03b6d257mr8098787637.35.1738948014644;
        Fri, 07 Feb 2025 09:06:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEJBQDafFYhVotNsoO822rUdYxAjMfjIT6w0V06a6wSD3JLplbq4at3BA1ruD3EaS3VB7vGhA==
X-Received: by 2002:a05:6a21:3406:b0:1e0:ce11:b0ce with SMTP id adf61e73a8af0-1ee03b6d257mr8098734637.35.1738948014219;
        Fri, 07 Feb 2025 09:06:54 -0800 (PST)
Received: from localhost ([240f:74:7be:1:bf00:4534:dd5d:8dd0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73048bf14b1sm3334500b3a.91.2025.02.07.09.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2025 09:06:53 -0800 (PST)
Date: Sat, 8 Feb 2025 02:06:51 +0900
From: Koichiro Den <koichiro.den@canonical.com>
To: David Sterba <dsterba@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	stable@vger.kernel.org, patches@lists.linux.dev, Qu Wenruo <wqu@suse.com>, 
	Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 6.12 102/114] btrfs: avoid monopolizing a core when
 activating a swap file
Message-ID: <obtsofvu7o6mrgmf6u32hvly7zkgwxdqicorol4o64jqvyqe4n@kxz4jlgztzps>
References: <20241230154218.044787220@linuxfoundation.org>
 <20241230154222.045141330@linuxfoundation.org>
 <q6zj7uvssfaqkz5sshi7i6oooschrwlyapb7o47y36ylz4ylf7@dkopww2lfuko>
 <2025020634-grid-goldfish-c9ef@gregkh>
 <20250206174542.GM5777@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206174542.GM5777@suse.cz>

On Thu, Feb 06, 2025 at 06:45:42PM GMT, David Sterba wrote:
> On Thu, Feb 06, 2025 at 03:31:02PM +0100, Greg Kroah-Hartman wrote:
> > On Thu, Feb 06, 2025 at 08:41:33PM +0900, Koichiro Den wrote:
> > > On Mon, Dec 30, 2024 at 04:43:39PM GMT, Greg Kroah-Hartman wrote:
> > > > 
> > > 
> > > Hi, please let me confirm; is this backport really ok? I mean, should the
> > > cond_resched() be added to btrfs_swap_activate() loop? I was able to
> > > reproduce the same situation:
> > > 
> > >     $ git rev-parse HEAD
> > >     319addc2ad901dac4d6cc931d77ef35073e0942f
> > >     $ b4 mbox --single-message  c37ea7a8de12e996091ba295b2f201fbe680c96c.1733929328.git.fdmanana@suse.com
> > >     1 messages in the thread
> > >     Saved ./c37ea7a8de12e996091ba295b2f201fbe680c96c.1733929328.git.fdmanana@suse.com.mbx
> > >     $ patch -p1 < ./c37ea7a8de12e996091ba295b2f201fbe680c96c.1733929328.git.fdmanana@suse.com.mbx
> > >     patching file fs/btrfs/inode.c
> > >     Hunk #1 succeeded at 7117 with fuzz 1 (offset -2961 lines).
> > >     $ git diff
> > >     diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > >     index 58ffe78132d9..6fe2ac620464 100644
> > >     --- a/fs/btrfs/inode.c
> > >     +++ b/fs/btrfs/inode.c
> > >     @@ -7117,6 +7117,8 @@ noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
> > >                             ret = -EAGAIN;
> > >                             goto out;
> > >                     }
> > >     +
> > >     +               cond_resched();
> > >             }
> > >     
> > >             if (file_extent)
> > > 
> > > The same goes for all the other stable branches applied. Sorry if I'm
> > > missing something.
> > 
> > Hm, looks like patch messed this up :(
> 
> The fix is part of 4 patch series. The stable tree 6.12 has only 3 and
> in different order, so this one fails to apply due to missing context
> and got applied to the wrong function.
> 
> Applying all 4 in order to 6.12.y (same base commit f6279a98db132da0cff)
> works without conflicts.
> 
> $ git cherry-pick 0525064bb82e50d59543b62b9d41a606198a4a44
> Auto-merging fs/btrfs/inode.c
> [detached HEAD 0466e0dbbb99] btrfs: fix race with memory mapped writes when activating swap file
>  Author: Filipe Manana <fdmanana@suse.com>
>  Date: Fri Nov 29 12:25:30 2024 +0000
>  1 file changed, 24 insertions(+), 7 deletions(-)
> 
> $ git cherry-pick 03018e5d8508254534511d40fb57bc150e6a87f2
> Auto-merging fs/btrfs/inode.c
> [detached HEAD 1715e6abcf46] btrfs: fix swap file activation failure due to extents that used to be shared
>  Author: Filipe Manana <fdmanana@suse.com>
>  Date: Mon Dec 9 12:54:14 2024 +0000
>  1 file changed, 69 insertions(+), 27 deletions(-)
> 
> $ git cherry-pick 9a45022a0efadd99bcc58f7f1cc2b6fb3b808c40
> Auto-merging fs/btrfs/inode.c
> [detached HEAD 78d50f8c8827] btrfs: allow swap activation to be interruptible
>  Author: Filipe Manana <fdmanana@suse.com>
>  Date: Mon Dec 9 16:31:41 2024 +0000
>  1 file changed, 5 insertions(+)
> 
> $ git cherry-pick 2c8507c63f5498d4ee4af404a8e44ceae4345056
> Auto-merging fs/btrfs/inode.c
> [detached HEAD a162d2371965] btrfs: avoid monopolizing a core when activating a swap file
>  Author: Filipe Manana <fdmanana@suse.com>
>  Date: Mon Dec 9 16:43:44 2024 +0000
>  1 file changed, 2 insertions(+)
> 
> I have more trust in git patch logic than 'patch', this can happen in the
> future again.

As a side node, I just recently observed a quite similar pattern elsewhere.
Unfortunately, by the time I discovered it, the 6.11.y had already reached
EOL, so I didn't have an opportunity to report it for fixing.

The following upstream commits landed in the stable queue and were applied to 6.11.y
in reverse order (i.e. applied as #2 then #1):
#1. f3fe8c52c580 ("iio: adc: ti-lmp92064: add missing select REGMAP_SPI in Kconfig")
#2. a985576af824 ("iio: adc: ti-lmp92064: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig")

that appears to have resulted in the backport for #2 being broken.
(see https://lore.kernel.org/stable/20241021102302.767569469@linuxfoundation.org/)
Since there seems no "FAILED to apply" announcement, I assume this was
handled by normal patch(1) usage. Just as an extra side note, #2 seems to
have been applied twice on the branch.

So, even though the patch reordering and patch application strategy are
essentially seperate issues, I tend to agree that when the latter causes
problems, it sometimes indicates that an issue with the former is lurking.

Thanks,
Koichiro
