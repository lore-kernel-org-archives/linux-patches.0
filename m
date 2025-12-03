Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4692134C826
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 16:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779385; cv=none; b=bIlgRWcDXONWEMzErfDObdKfHaJqM+L0ocCSF6/wgPvaT89qFyPyYinexZkJiWUEU+jSeFJ3JnwINfjjntWbrdpDLTvBZZ+LbeSn5kQ9yUfZFAmmlMUM5RMFxJncHjrTA0rBM87hOUoeUW5iPPE8Q69D+wT3llqoOR4eaAbz+80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779385; c=relaxed/simple;
	bh=nT2H6GYXcpaFlrJsU3PaeOyF2JYj4sF+H5+pMOguJy4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=DhofjuS1pjvACDgvyYWrcoO2SCFZgsi0D+TR5Y8OnH5iNEJkiFeaY/6EGwQ0WIDABJtKfC95Bz/wJ9c/SYg/L62TJ9dwoP9KeRqPHYhfbJkCkDuQ1NZJeLc/MrEnR0knR5KB7ureYoBJAI+fEwKcKpkKWEYLcgRmWMkKUCuY0ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-65747d01bb0so10190400eaf.0
        for <patches@lists.linux.dev>; Wed, 03 Dec 2025 08:29:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764779383; x=1765384183;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VmenYvner1gF0AcLKuVQeZezdlsynCmlN1QS7SOEg9w=;
        b=vP1gg5pnnUXnDDzIgb5KR1axy5LFiCypxAK/uzVbeUUOxHDYzcjmOuIW9O4H9nHcm4
         PG4oME26BBxsnJPC9mqvxyGs58fvn8RUGq+b1TArUmSUtm6DqHj+BtONzzaDiMlscQ9R
         zN7DDtVXW9UF4VKNpfgu+132nUTS35NRG8Kyqt/7PA8++p0oSMpKjpi1SYuwPR7aq3TI
         DhEvtW0R+LGi7+bdoINwNE3tX19x5dPmgyokqxGFrC51hVhaGcSUPUdCii4c+sACzsJr
         w3cPfA/hBpd1aPklmV2fn20HqMrRpob0gqVpWVqeZ1LguaYwVAhjJ9Jnv1F7EC+MogFV
         YI3w==
X-Forwarded-Encrypted: i=1; AJvYcCXckf0MCTJ120j5IJqULaeKifma2Q3cNbdjk5OEcuyBbCh9dsxhmiLjuiZctAejJYAnWkLDBqjh@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3ztCPUYHVRlbgnuASjtDW4XHYHaQlz2JxDnAUh4QLB3zqXpNc
	kOumIA48+/dTjbheWqOfrkNb7O5IPIhjRIVtdFQPzr35kcPZlqUzDLMgPYX9sYXB5j+310diyRO
	CxHVREOqLxnpH8c7x5EUl3v1oBRLnY1ZkWTOzACQPYVJrJECeAIayHYbZfJg=
X-Google-Smtp-Source: AGHT+IGF1mvlwtf789Qboy6BF1yW/rvB6yb3TeT1HWfTMIdKo30IOKdbywSzRX940k+AxpeVqts9s3njzaXd9Mwd0NZD8cJ+rq/v
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:181a:b0:43f:76b4:816e with SMTP id
 5614622812f47-4536e3af7b0mr1406748b6e.4.1764779383377; Wed, 03 Dec 2025
 08:29:43 -0800 (PST)
Date: Wed, 03 Dec 2025 08:29:43 -0800
In-Reply-To: <20251203152449.510968694@linuxfoundation.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69306577.a70a0220.d98e3.01b9.GAE@google.com>
Subject: Re: [PATCH 6.1 240/568] jfs: fix uninitialized waitqueue in
 transaction manager
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: gregkh@linuxfoundation.org
Cc: dave.kleikamp@oracle.com, gregkh@linuxfoundation.org, 
	patches@lists.linux.dev, sashal@kernel.org, ssrane_b23@ee.vjti.ac.in, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> 6.1-stable review patch.  If anyone has any objections, please let me know.
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

