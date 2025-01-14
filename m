Received: from gw2.atmark-techno.com (gw2.atmark-techno.com [35.74.137.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1BF246344
	for <patches@lists.linux.dev>; Tue, 14 Jan 2025 07:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.74.137.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736840366; cv=none; b=Zd/niunNJfDBaMs3GeMoOtZDeD/APWbnPRcPL4WX1d5O7+oLgGWLvpHxGYCh+uoAAd9SKbYuEtaplTpq/3919uo1p0MLrVccJ+nIiX9kEaACtcoze3Nvdz3Cmz1cl64gG3u/byZFqQwWJo0qL9NUArKoYoVRe458IcDdmex/sMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736840366; c=relaxed/simple;
	bh=k360k2nENChaTtsCY0XTSnXsQJWoAdUqBiBV+ls1PWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SVY6ZAWB8eQgNaDnE1WXrYdqibjdcRuXrtXt3a7WPxpCCj93mdMqhsuOPKiQ3CRZwJ2RFGUEwDEh++ETpjrUONumwyCjsyAFAc5WZu9rMDkuNshhY6/b2m6J+st3B1jkfhDq2GAWVIYzUFFjxZOLN1cpInrZAqIKbiefYnOA0AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=atmark-techno.com; spf=pass smtp.mailfrom=atmark-techno.com; dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b=GPJAHQ0E; arc=none smtp.client-ip=35.74.137.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=atmark-techno.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atmark-techno.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b="GPJAHQ0E"
Authentication-Results: gw2.atmark-techno.com;
	dkim=pass (2048-bit key; unprotected) header.d=atmark-techno.com header.i=@atmark-techno.com header.a=rsa-sha256 header.s=google header.b=GPJAHQ0E;
	dkim-atps=neutral
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by gw2.atmark-techno.com (Postfix) with ESMTPS id DCFCBA5C
	for <patches@lists.linux.dev>; Tue, 14 Jan 2025 16:39:17 +0900 (JST)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2ef114d8346so9004099a91.0
        for <patches@lists.linux.dev>; Mon, 13 Jan 2025 23:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atmark-techno.com; s=google; t=1736840357; x=1737445157; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PNYhzp6T4J8POxGMu2wCD4gj9nKfcrDVmiBH3+FTTC8=;
        b=GPJAHQ0EDDaYMjURoaCvsfShWYZOpZjUmgwpVbw+iYq2HubGKFr0attegk1sU7P/fQ
         pQxu0as2QM+41sRXMtK0aK1L3+UoBdd92QolbnNFP89vm0tAbQtYlvSQYHYgRR9tZm9T
         l1MDUtaIzyXUNZ9ABBiu9pO02SqEpEbhMf967Mu2lp4c/XYsXw/e1Y4dfv+HDYQk8Qqb
         Jf1DCXo+I4QOiC+mAdcNOoeblH3oZsZfygUbyyNruZph84jtSkdCScqSYFk00SfV38Gw
         jRugvZ1cSCUYKUZ+XXCuCW0sFEM+Pkh3CNB0fqT6cBXbJxdRK0Xbm608/5JxFxNcGEW8
         fb0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736840357; x=1737445157;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PNYhzp6T4J8POxGMu2wCD4gj9nKfcrDVmiBH3+FTTC8=;
        b=d2uE70smFEQ/7cApiFjM5pO0+5mg/te2G4WZstWOueHh4xjZkp8bdJuG3yiDHEtA7t
         FUJ6CCv3RAR8aOoS30YO9w0ahAPzFvoq3DFbWhhAkX8r935qEIH1ROhmR0NrYelFG61L
         DCu0gMYeMOhnNiigo0GyZNde0rNjOL0HUzTbfN92UFnWk7GHOYJeT2wnbm9ZhxqxoUcx
         GWUb5yGvQ/+gDtUOdhp3HPvQjGHf+CtK3EkEzGt4YnNifavXAMP7rXyQ29tBbxtn/XYp
         8hesfvx5aVE4SyvgoMt4XIerVenQNRsCGhaUuGo5q4WJlyVBBFn5fPiqLk1qalMO7kx7
         1gyg==
X-Forwarded-Encrypted: i=1; AJvYcCWjwKZ/z2RszyUSTabDlMXtSqkxSVfRcJVixyjSVTMGVb6bSG5N4sNyrDrZVg6p78miKBLBaLU+@lists.linux.dev
X-Gm-Message-State: AOJu0YwxOzeA8e5vdemEh13zx/kgq9YFDFLjbDW40lPYigZl2OlA+cCS
	hEEHSoxE/XbhVi+B+epqZ8nxVFxLl+9x8z2YG4O4mopPBJHCIdNjcRzzuj0pIp7mriMTOisqLkV
	3GRj8MwFgnR1G/KULIRu6Db1WMURfxGBlK3VABZO3x4jRaCFQsNZlH2l1
X-Gm-Gg: ASbGnct+7SeyojSfMy/zdG2irYVUU3MsVnnWM+1nmpZlksdLfMpcwLWgfvIH474lGgv
	DOZUIyQWY8jbCv7U9aKJPlWALp5J8Ks85tMmCmmdph2azCihKZIRM+5V4gP65eZTlWz3r5BbhyX
	l1wPnVtejGSMgmF6Wj2CH/BTbex84hh0RghZl7BZO94XuJCiFYmrscgdwmBpV8O1XGZkbnurMmQ
	VSDtw8pTFJakJpk/99qBGrm4R0VlXdfKjlJA7Q/Z19fC3HXQH+ski0wJzdCrvak1in/1QV2DT2V
	pl/EPt1DXKqnvYyAzESnPhcWocCgP09t+Facl4ti
X-Received: by 2002:a17:90b:2c84:b0:2ee:8430:b831 with SMTP id 98e67ed59e1d1-2f548f1628fmr36874510a91.2.1736840356844;
        Mon, 13 Jan 2025 23:39:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFucZTLJamv/CQ5nIk/KY9RsHieGOsTWABI4Y2zHT3k7z/UYGhJL1HzEwHdatKUJuyyrTaJ6A==
X-Received: by 2002:a17:90b:2c84:b0:2ee:8430:b831 with SMTP id 98e67ed59e1d1-2f548f1628fmr36874486a91.2.1736840356480;
        Mon, 13 Jan 2025 23:39:16 -0800 (PST)
Received: from localhost (117.209.187.35.bc.googleusercontent.com. [35.187.209.117])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f559469fa0sm8902619a91.44.2025.01.13.23.39.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Jan 2025 23:39:16 -0800 (PST)
Date: Tue, 14 Jan 2025 16:39:04 +0900
From: Dominique Martinet <dominique.martinet@atmark-techno.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Desheng Wu <deshengwu@tencent.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 0/3] ZRAM not releasing backing device backport
Message-ID: <Z4YUmMI5e2yPmzHl@atmark-techno.com>
References: <20250110075844.1173719-1-dominique.martinet@atmark-techno.com>
 <2025011201-scorebook-kebab-2288@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2025011201-scorebook-kebab-2288@gregkh>

Greg Kroah-Hartman wrote on Sun, Jan 12, 2025 at 11:03:42AM +0100:
> On Fri, Jan 10, 2025 at 04:58:41PM +0900, Dominique Martinet wrote:
> > I've picked the "do not keep dangling zcomp pointer" patch from the
> > linux-rc tree at the time, so kept Sasha's SOB and added mine on top
> > -- please let me know if it wasn't appropriate.
> 
> It's tricky to know, I dropped it and took what was in Linus's tree as
> Sasha didn't actually review this one.

Thanks for saying this; I hadn't actually checked the stable backport
(enough) either so I had another look, and the 6d2453c3dbc5
("drivers/block/zram/zram_drv.c: do not keep dangling zcomp pointer
after zram reset") backport by itself is wrong even if it did
cherry-pick cleanly from master and a quick test appeared to work.
The commit messages says "We do all reset operations under write lock"
but that isn't true without also backporting 6f1637795f28 ("zram: fix
race between zram_reset_device() and disksize_store()"), so with the
current backport we've traded leaking zram->comp behind with a data race
on disksize and comp.

With that extra commit as well, I think we're sane enough, but I'm not
familiar with the zram code so I might have missed another prerequisite.


With that and the previous problems, and given that manipulating
zram devices is a privileged operation (so we're not looking at a must
fix vulnerability), I'm actually rather inclined to just drop all the
zram patches and not backport these to 5.15/5.10 unless someone actually
reports problems around zram reset (or perhaps keep 5.15 but skip 5.10
as you see fit)

(
  I'm not opposed to Kairui or someone else actually do these backport,
  but I'm not confident it's worth the effort and think we're trading a
  known problem (current behaviour) with potential unknown ones if
  we're just cherry-picking an arbitrary subset of patches.
  If someone wants to take over, the commits I had identified (from
  Sasha's initial backport and this mail) for 5.10 were as follow:
3b4f85d02a4b ("loop: let set_capacity_revalidate_and_notify update the bdev size")
5dd55749b79c ("nvme: let set_capacity_revalidate_and_notify update the bdev size")
b200e38c493b ("sd: update the bdev size in sd_revalidate_disk")
449f4ec9892e ("block: remove the update_bdev parameter to set_capacity_revalidate_and_notify")
6e017a3931d7 ("zram: use set_capacity_and_notify")
6f1637795f28 ("zram: fix race between zram_reset_device() and disksize_store()")
6d2453c3dbc5 ("drivers/block/zram/zram_drv.c: do not keep dangling zcomp pointer after zram reset")
677294e4da96 ("zram: check comp is non-NULL before calling comp_destroy")
74363ec674cb ("zram: fix uninitialized ZRAM not releasing backing device")
)


Thank you Greg for the follow-ups, and thank you Kairui for the
suggestions during my earlier bug report.
-- 
Dominique
