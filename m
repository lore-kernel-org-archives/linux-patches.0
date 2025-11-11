Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EE32DA757
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 01:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824123; cv=none; b=gzCU3E78JzMblu5DAa4c+MFteKkgFtre5lQKKn84MD2mdgT4EHPXTXwzUDiUf/K/IfGvbNSx8otdKfn7cdtSV90hR0HNDj8quUK3pXSRqwOm2tYfqu+nlCBpZt3TjinTby/rVac8hMcsR5x3PTn7/CzQFQzEl0dSGHWDFa3ETGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824123; c=relaxed/simple;
	bh=1Saewuj3B+oxPukwQPEoUCgMCPyS+mq1oCUOFby9KXU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=LyfzCHLmailTwUNY5hZJlVVxIbEAexxdHN/EikyNedO8vHXjzxD4z4ABdKUPh1vkDfBwwwOWwTRq3gFjaRZhl46p6CyHNsND+QJlMXdtwXEYD2pz4Kamij7M90gOWP2rZf+x70OqJ2yR3+0iKen2EYOYcEy0lFG4pubj5B8zgXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-43331ea8ed8so35876265ab.3
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 17:22:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762824121; x=1763428921;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jgTHUyA6jLiZEgsIlU1BHXJL99ZEBvfYu/B6KIbfPcI=;
        b=ZSBtITsvpTuO7HuKMqIYiobtxpc/wLZvq/Ucj+we+tH5fOhVKAjiV6CNzB2MTvVARY
         JnzvDQlXyFegcC0GCsVAIwiBq/0Vp9YDi6OKiHeJk8v68w7k2JCPSi42zGnSSfIa72X+
         SN/WOaBPZZM+nJEdpJTOwAtRVBBHAOt37+EOi/QckjGguwcJ4NI0bTxFLNflXiqYb49E
         yCr9O4vpFyd+C2JbCSYh6or5ndH9FpPcw2PKkVvNYrvPtJS65XfuIVe7LUqeujbbXeFw
         XnfK1FXs1Nk/ijzEcoqQDYIhelK10O1ycqvBDDeVH5RX9wdjmn7dY2TyGNEe8PxDBTnw
         NBjA==
X-Forwarded-Encrypted: i=1; AJvYcCWAEs6BVSqEwcYM4b6BUViVO/Xc38TgjKDhbf+rEbc8wD4n1rBzpyOd2IatSw+uc35leidtNUFr@lists.linux.dev
X-Gm-Message-State: AOJu0YxXPjsijlWXsLA4XRiV9x8bQlPC22HlrYRXoTwY2A5d7pWjf7+E
	YKH/okV0qjtQfWtvNZ5T6QhOVX+k7l3ia8/YsqKDAgnYFsX6iHIXXata0vYR41js7lkXFyVPHox
	W8+gHxT9xdP40aNIvlGCO1Fk28A4zcN/OsXoZDNimLmoKk+LNtVaeQPUFtq8=
X-Google-Smtp-Source: AGHT+IF3YFxFacr3KDbHpq5A+caT8jYHZKNqmASlSPxhn0zJLG8UjHgI2+NyHenfwkEKYFMzfCzIe/11H/4hPhr6H2dMvY/OyAng
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:d44d:0:b0:433:71a9:8f9e with SMTP id
 e9e14a558f8ab-43371a99638mr90879525ab.7.1762824121147; Mon, 10 Nov 2025
 17:22:01 -0800 (PST)
Date: Mon, 10 Nov 2025 17:22:01 -0800
In-Reply-To: <20251111004535.668292559@linuxfoundation.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69128fb9.a70a0220.22f260.011a.GAE@google.com>
Subject: Re: [PATCH 6.12 391/565] jfs: fix uninitialized waitqueue in
 transaction manager
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: gregkh@linuxfoundation.org
Cc: dave.kleikamp@oracle.com, gregkh@linuxfoundation.org, 
	patches@lists.linux.dev, sashal@kernel.org, ssrane_b23@ee.vjti.ac.in, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> 6.12-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
>
> [ Upstream commit 300b072df72694ea330c4c673c035253e07827b8 ]
>
> The transaction manager initialization in txInit() was not properly
> initializing TxBlock[0].waitor waitqueue, causing a crash when
> txEnd(0) is called on read-only filesystems.
>
> When a filesystem is mounted read-only, txBegin() returns tid=0 to
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
>  fs/jfs/jfs_txnmgr.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
> index be17e3c43582f..7840a03e5bcb7 100644
> --- a/fs/jfs/jfs_txnmgr.c
> +++ b/fs/jfs/jfs_txnmgr.c
> @@ -272,14 +272,15 @@ int txInit(void)
>  	if (TxBlock == NULL)
>  		return -ENOMEM;
>  
> -	for (k = 1; k < nTxBlock - 1; k++) {
> -		TxBlock[k].next = k + 1;
> +	for (k = 0; k < nTxBlock; k++) {
>  		init_waitqueue_head(&TxBlock[k].gcwait);
>  		init_waitqueue_head(&TxBlock[k].waitor);
>  	}
> +
> +	for (k = 1; k < nTxBlock - 1; k++) {
> +		TxBlock[k].next = k + 1;
> +	}
>  	TxBlock[k].next = 0;
> -	init_waitqueue_head(&TxBlock[k].gcwait);
> -	init_waitqueue_head(&TxBlock[k].waitor);
>  
>  	TxAnchor.freetid = 1;
>  	init_waitqueue_head(&TxAnchor.freewait);
> -- 
> 2.51.0
>
>
>

I see the command but can't find the corresponding bug.
The email is sent to  syzbot+HASH@syzkaller.appspotmail.com address
but the HASH does not correspond to any known bug.
Please double check the address.

