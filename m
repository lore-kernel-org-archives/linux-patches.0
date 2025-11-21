Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C941B314D2F
	for <patches@lists.linux.dev>; Fri, 21 Nov 2025 13:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732817; cv=none; b=R8nOXYhw4+bwsIlQEnB5b+FI5CXY4Mq2aLt+wGSIxjrmeQB+g8TivW9E3ho9jUCbQ7d+rorZijShd1nqZiRu4hNnyl7DtMaxNUsf3dGbb4ZaWJX2tgGH6gs27VrTjdqMOjPqmFaJd/j66bHLkDFly6idKrCP4xv9g/5PsPo89Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732817; c=relaxed/simple;
	bh=kS3u8fbyJUVfH7ZouDgx6pPG5LryYlblfHXZF1UMjzc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=YpVvIrFjuPj+RHh7QD7ZqYnPfCio72MApm6cu8kpiH4I/jQt9Yc+CvcSCIoB9P85jXeE4LzuEIs+IlO/ZR/xjqFVfcRPU6zJEeG/PhV0A2V4Iqd10UHsUl6YiXRElH0ZJyP6GYNZRnrR264nKXbVTLyspuGjMwl6WvSk2pfwGCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-4330f62ef60so19246075ab.0
        for <patches@lists.linux.dev>; Fri, 21 Nov 2025 05:46:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763732815; x=1764337615;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jfM96cPDGqpbPBn7PPbQ4n5yVw9OLFafeLZIYjP6vEg=;
        b=J0tWMFSwuf2goEtOXj+qj3LDkl5qLafSAgstinuJ1t2CVhJnzeDJZYiWkK6IEwdspM
         MNae9dd9pQADk/07N6CzhczIH3pQe+LWlEdVYwkLIpuuk0gthvDhUlgmewIRBu4dou3U
         joKsR9GHxJD8GcDtw5HByxEIXRuEIpXaMT2e7KCKfCfvTqIrLAI07aSyrrmG08DswWb+
         GTMxTTbi5NnRGNvNzUAI+M8brqLgG6A6cUVT9/5E//vv+zdWL9Xg4h0UAlIE4pNAOBcR
         POTPsC+1ubPbQ8fB6tHUfSRELu2inThUcW0eOTPSRqQzrF2FZKq2Di6u+yn9aXvqcLsJ
         wrng==
X-Forwarded-Encrypted: i=1; AJvYcCUsdUeenNdFp2wDWkW0IuqZ84rOsK6aq0jKKlDPoB/2FoaJeknarEgvRANdnDA+cata5sC1y28/@lists.linux.dev
X-Gm-Message-State: AOJu0YzS6YWjyHuNPp8GZcdWu/soCjWCnw+ucqWiGfHianAAnCvD56xc
	aSs5xRM2YLnJ+aF2xyWm53iI0pw3fNNprQNl4h7RWMgRZF7bZs95FbizJKWdFD9yaH534sQavpY
	zU/jCTO2PArIRDBwWD5sOPSrm9iBr2Rmsq0HNZURtHFtKJRbMreVGT2KPkxA=
X-Google-Smtp-Source: AGHT+IHaeW1/gE1ZzEFWFfTj6KK9QOuddSw168iFNmQa5PZLlhIEVAFnmkaLSDS87hZOc0qRjL8wFnvOvPIkFlAaq3urMSTR6Xub
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1aab:b0:430:c491:583b with SMTP id
 e9e14a558f8ab-435b8e598d6mr18972995ab.14.1763732814933; Fri, 21 Nov 2025
 05:46:54 -0800 (PST)
Date: Fri, 21 Nov 2025 05:46:54 -0800
In-Reply-To: <20251121130240.021598827@linuxfoundation.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69206d4e.a70a0220.d98e3.0046.GAE@google.com>
Subject: Re: [PATCH 6.6 253/529] jfs: fix uninitialized waitqueue in
 transaction manager
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: gregkh@linuxfoundation.org
Cc: dave.kleikamp@oracle.com, gregkh@linuxfoundation.org, 
	patches@lists.linux.dev, sashal@kernel.org, ssrane_b23@ee.vjti.ac.in, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> 6.6-stable review patch.  If anyone has any objections, please let me know.
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
> index dccc8b3f10459..42fb833ef2834 100644
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

