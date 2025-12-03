Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120713148D6
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 15:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776260; cv=none; b=iuTDy7PkFO4Beq3WoAApkjApRfpVsYm5QAsUkocAHYdDiIuAitnIvQ/HVzbvLwi4P22kS/64Wptlk0spd1FdBu+BoYAQ3CG5TdDG/WwHsLGczkw3qEVHYYH2oQt/1Xo/MlVpGHThP+awJWonfjAgUOa1Igi0uVsvBApv+1lFJsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776260; c=relaxed/simple;
	bh=URwIkXoJGIhaf6h4erzozKo5YdtNlIml7iZ5wYMoZNY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=nTR+t1Glv5iYi77jv0u98s0dv2sE4LwNtHHu/wzqYiLD8pDJ5341eLGko7B5z3t1pec1x3pwAI8Kvw82Plp771H/w1Sa+Yik4tXwCSr+EE0vBRWyxboEaeUw3vwOdWGHizmGgpIFgCMHCLaMhLRQ619Wro5/+kngllUzlwkJpXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7c7611165b3so5258417a34.2
        for <patches@lists.linux.dev>; Wed, 03 Dec 2025 07:37:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764776258; x=1765381058;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/elcimwPgXstgKnTlIN9KfZhixTnvPoLHjpdzZzVoOY=;
        b=Mf0Hy6vaS6Q+619dfXPFIpuH+O2A8/YQnalypbdMe9SeX2iwaATT8m7AnBjbOl9PHd
         Cq7M1It/S5yprzHN5MQ7f8nHykp3de2NXOzhuqSCh2Aubw5vU8o4ayznoCXCBzMB5a/y
         yv8SsFYuANPbq+5yxduhs8lsdyp6XENGuifA5K72Fruvz01meK/AGkPx1qJy6xTz6sgo
         AxnCpXoX6F94aqRDE+SRDi+iQfaHxE2nBbvuMzoRCNE8oldUIh2WxwwcbQwpGynEBMC4
         tSoPrKsTnrd5lzws5VKWV4q6/7hSB2YPpVKYy0q1Oox0HXfsSceU98q0sXXWTZBiR2Un
         xDXw==
X-Forwarded-Encrypted: i=1; AJvYcCUQtxFWW1AhCji7WcnJKsmnH+JbW+Dal4cARFcdNp9EXDKoKHrGzgryCT+BbpkcDcWB/26eP7lZ@lists.linux.dev
X-Gm-Message-State: AOJu0YxoFPIP+aIdHGdByaCaG2J4WWBmGb1nf16Pgoh9ccQDK/VwPnK0
	y1G4RIYmiS7FCe7Ww4eZgTK/qlQRGVaxZGmFcrs4WgG5HdqaO3F4OAqgiNKjJUUcl8yk7GnVuta
	cfM95lAToIhyZsYBjGUzvaz++sFnCehHkInyAvSTrFlcgSERJxx2tN7D5p4E=
X-Google-Smtp-Source: AGHT+IF/HJsWGbBN8Hj0XK2wsI5QnGAyQ231nFm6XhVliXXmKL+EBsLT0hjyi+becUo9ruJxPN0hqSM6G8/bFhVyeFdh1xNyhduY
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2209:b0:451:4d82:b6e1 with SMTP id
 5614622812f47-4536e3ae6a6mr1322895b6e.13.1764776258114; Wed, 03 Dec 2025
 07:37:38 -0800 (PST)
Date: Wed, 03 Dec 2025 07:37:38 -0800
In-Reply-To: <20251203152405.317330579@linuxfoundation.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69305942.a70a0220.2ea503.00d1.GAE@google.com>
Subject: Re: [PATCH 5.10 127/300] jfs: fix uninitialized waitqueue in
 transaction manager
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: gregkh@linuxfoundation.org
Cc: dave.kleikamp@oracle.com, gregkh@linuxfoundation.org, 
	patches@lists.linux.dev, sashal@kernel.org, ssrane_b23@ee.vjti.ac.in, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> 5.10-stable review patch.  If anyone has any objections, please let me know.
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
> index 6f6a5b9203d3f..97a2eb0f0b75d 100644
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

