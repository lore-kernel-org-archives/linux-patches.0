Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F653074BB
	for <patches@lists.linux.dev>; Sat, 25 Oct 2025 16:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409171; cv=none; b=Bel+3vOgUwOYMiar9uOqB/rxZ57abTtUg0Tr6fu4o07d3DS6rsdycL9w6v5dKsN6owSezxaxsiGUmtyXloA3iWVe1xVzh7UG3kfz38RgKvWppC+945rCCWrG77hkazki/iAT12Bl6H/vxn3PiNJDqdEW1Ux/K/+0Ur0KUThA2Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409171; c=relaxed/simple;
	bh=1UAhRNMwiY8e1loSbd3FnzSqcx+pE0AoZQ5cdLLzwYw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=DGMKZvZ2iFlA/rvy43S0zGKWpxWwjC7QlYrn5YAJlXM4VPyLWhJpP/Q5jPVujECLtEOVg41IeKaK2pjPLscmDa30WBq5Az3sGrmVDGKqA3YLlbUOk/xU6Px7ZHsDqK/qlHvXVTMRTp9Y6mWmKPcWzt/M06yWzEsTGZqwgfBiXgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-430d789ee5aso40933265ab.2
        for <patches@lists.linux.dev>; Sat, 25 Oct 2025 09:19:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761409168; x=1762013968;
        h=content-transfer-encoding:cc:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xDL5qUn8r7zj0sFG8H7qyEhZdijB3u/BoMNxYA4F7hU=;
        b=d86wq/ymBi/8y4YA5YUnNz+cWz/Yanx/S20DqtxqHyeg57K5isEieDk1boOCw0dYwz
         TfY798vuTpy+3gsRPlg7mS6D9rGHHAotjw2ucI3PU94FVIuIyzbW8PJ6fx8M92JQXuOC
         Yttu7mBUyNqqRidAiH7QCq/kpbcHDn4eHuCQSWOzFGEl93LGn9PFmMhkZXqFZ40Es6li
         BO83fgmEz2Dz2IUNCMfk8QYG0EExTRN6BX8LpPNHQN2vTDe3fqtCKI4eM12D3TEZq095
         Zox5g7VP8R0lEUA0oEXe953WjyMqJaTA5oU56vseWP0OJtPGvYzwAKQmenkq4gfFg0Y4
         65MQ==
X-Forwarded-Encrypted: i=1; AJvYcCWM1o8IoQVS676Jtk8m+FLkATXZc+1hMYY9wr6Dp3HiarFX+mByuMM65+Ygvx0lwCa0V7mCPV6X@lists.linux.dev
X-Gm-Message-State: AOJu0Yxo/v0LuhjPHMbhhHgVlrrFoY0PZJsX0Luq0WP5dm0qReWqeSeZ
	DnKsWT7rYTE5NflJxxZ1q+Oqt4WrVFS9f4elq+XGpQEtrPYZllUXvLaCHZH8waoWiUI+27a+TU9
	rNKWZYBoaqaTrh55VyFMVKYZpNhRc4MyJmYp7o4k3OIkCtMAAZCIpvp8pxjc=
X-Google-Smtp-Source: AGHT+IHyDU/FUDHCCq350lspC6NErVthfk4ehnVafDPOWHBjDawZElv4u2ug0d6cNWNJu99xYN/guv5PQJiajp22dXZ/SBHCYA4i
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2307:b0:42f:a60a:8538 with SMTP id
 e9e14a558f8ab-430c52b5afemr394804655ab.16.1761409168407; Sat, 25 Oct 2025
 09:19:28 -0700 (PDT)
Date: Sat, 25 Oct 2025 09:19:28 -0700
In-Reply-To: <20251025160905.3857885-227-sashal@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68fcf890.a70a0220.12011.0001.GAE@google.com>
Subject: Re: [PATCH AUTOSEL 6.17-5.4] jfs: fix uninitialized waitqueue in
 transaction manager
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: sashal@kernel.org
Cc: alexander.deucher@amd.com, alexandre.f.demers@gmail.com, 
	dave.kleikamp@oracle.com, jfs-discussion@lists.sourceforge.net, 
	patches@lists.linux.dev, sashal@kernel.org, shaggy@kernel.org, 
	ssrane_b23@ee.vjti.ac.in, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> From: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
>
> [ Upstream commit 300b072df72694ea330c4c673c035253e07827b8 ]
>
> The transaction manager initialization in txInit() was not properly
> initializing TxBlock[0].waitor waitqueue, causing a crash when
> txEnd(0) is called on read-only filesystems.
>
> When a filesystem is mounted read-only, txBegin() returns tid=3D0 to
> indicate no transaction. However, txEnd(0) still gets called and
> tries to access TxBlock[0].waitor via tid_to_tblock(0), but this
> waitqueue was never initialized because the initialization loop
> started at index 1 instead of 0.
>
> This causes a 'non-static key' lockdep warning and system crash:
>   INFO: trying to register non-static key in txEnd
>
> Fix by ensuring all transaction blocks including TxBlock[0] have
> their waitqueues properly initialized during txInit().
>
> Reported-by: syzbot+c4f3462d8b2ad7977bea@syzkaller.appspotmail.com
>
> Signed-off-by: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>
> LLM Generated explanations, may be completely bogus:
>
> YES
> - `txInit()` previously skipped index 0 when priming the `tblock` wait
>   queues, so `TxBlock[0].waitor` stayed uninitialized
>   (`fs/jfs/jfs_txnmgr.c:270-284` before the patch). When the filesystem
>   is mounted read-only, `txBegin()` legitimately returns `tid =3D=3D 0`
>   (`fs/jfs/jfs_txnmgr.c:348-354`), yet every caller still executes
>   `txEnd(tid)`. `txEnd()` immediately calls `TXN_WAKEUP(&tblk->waitor)`
>   on that reserved entry (`fs/jfs/jfs_txnmgr.c:500-506`), which trips
>   lockdep (=E2=80=9Ctrying to register non-static key=E2=80=9D) and can p=
anic the
>   system, exactly as reported by syzbot.
> - The fix ensures both `waitor` and `gcwait` are initialized for all
>   `tblock`s, including the reserved slot 0, by running a dedicated loop
>   from 0..nTxBlock-1 before wiring up the freelist
>   (`fs/jfs/jfs_txnmgr.c:275-283`). No other behaviour changes occur: the
>   freelist population for indices =E2=89=A51 remains identical, and slot =
0 is
>   still excluded from allocation.
> - The bug was introduced when `txBegin()` started returning 0 for read-
>   only mounts (commit 95e2b352c03b0a86, already in 6.6+ stable). Thus
>   every supported stable tree that contains that change is susceptible
>   to an immediate kernel crash whenever `txEnd(0)` executes=E2=80=94trigg=
erable
>   by routine metadata operations on a read-only JFS volume.
> - The patch is tiny, localized to initialization, and carries negligible
>   regression risk: initializing a waitqueue head twice is safe, and no
>   concurrent activity exists during `txInit()`. There are no
>   prerequisite dependencies.
> - Because this resolves a real, user-visible crash introduced in
>   currently-supported stable releases and does so with a minimal, well-
>   scoped change, it squarely meets the stable backport criteria.
>
>  fs/jfs/jfs_txnmgr.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
> index be17e3c43582f..7840a03e5bcb7 100644
> --- a/fs/jfs/jfs_txnmgr.c
> +++ b/fs/jfs/jfs_txnmgr.c
> @@ -272,14 +272,15 @@ int txInit(void)
>  	if (TxBlock =3D=3D NULL)
>  		return -ENOMEM;
> =20
> -	for (k =3D 1; k < nTxBlock - 1; k++) {
> -		TxBlock[k].next =3D k + 1;
> +	for (k =3D 0; k < nTxBlock; k++) {
>  		init_waitqueue_head(&TxBlock[k].gcwait);
>  		init_waitqueue_head(&TxBlock[k].waitor);
>  	}
> +
> +	for (k =3D 1; k < nTxBlock - 1; k++) {
> +		TxBlock[k].next =3D k + 1;
> +	}
>  	TxBlock[k].next =3D 0;
> -	init_waitqueue_head(&TxBlock[k].gcwait);
> -	init_waitqueue_head(&TxBlock[k].waitor);
> =20
>  	TxAnchor.freetid =3D 1;
>  	init_waitqueue_head(&TxAnchor.freewait);
> --=20
> 2.51.0
>

I see the command but can't find the corresponding bug.
The email is sent to  syzbot+HASH@syzkaller.appspotmail.com address
but the HASH does not correspond to any known bug.
Please double check the address.

