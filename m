Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2434B30170C
	for <patches@lists.linux.dev>; Mon,  1 Dec 2025 11:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588569; cv=none; b=f5rNoK1DSeEp7gc0VvERtV26adISzwHL68xP9r/1j7pmu+49oePUdWZHCM0BVLG7qthyr4XLcOy70ufdGfYjFCeYdUkBbwAjuerojtouKI8a0BdD76x3iaDnuASTFdTt35sLup65upU769Rin7TQTCdxAenDg6HCRT5UIdVmK8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588569; c=relaxed/simple;
	bh=1e3xXhcPNHWgicbIPtgAm1Z3M8jEizauH6ZfvImQYHc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=QwRlho1b/1DQOo0Bc6IN92BDdR+SoWRGT6tQFBvQah+yzmC/qZvxjZJsl62EjS8gykccfDFgtRAOQziFuN8pZGQ0x/hVroLP+1ruIPiospGwvHkTtvv0tyMDZB6F2GCWTqq8K/L2xYD+ANhtumMlYQVHu5MS9Qbh8f4erePGmkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-9490559deffso245509539f.3
        for <patches@lists.linux.dev>; Mon, 01 Dec 2025 03:29:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764588567; x=1765193367;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EfHZ+dazpAoEJkFZ0dyA7E//xH/NuSxVKK2DI5VlixI=;
        b=LH1vKBOuY4iTkfe+M6NqEKiRJbp2DI4qAZOx3q/RgmX4Iu+LHCkAqDKVOPAmRo6Bee
         RIC7IMckvkL3tBhhBhT10g2guK1CRy0XLu4UmMw35tBCZ0KSAs9zgei6XWNMq71XMHxA
         Q5vrUIGSEwyBVO1M5CxX6klknglU2cjkb5LcJYzy9QvJXznYtOfd7vzRZzhZKI9faljy
         QtITF6bR/Olmmru02KjJwEJ0Bx1U5H4aPQU3RcTvox7K3+6tG4QKGtBCsct6WpuEqUVo
         tOusRTSh+dhiVjr+f5bfkPmdBe+LCVLT0OJoFGwJcINsbOX60CNXcQTy9wruBVNNPu4P
         wbDg==
X-Forwarded-Encrypted: i=1; AJvYcCWpkv8TlCmBZiHQdemaFlCLxh3Ga7Su+VLr3FozKE5gAyxMyNGcjfkb9tmYSKMcjT4kdJ8Tdi6u@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4o9sUDHRdldYrqq25GopAAQkyGgJnlKq63sNaDj9y+0xQBcGm
	4mj1iuo6C/ptwrR03k1bxAixPI/twRJoiKXb9j4N7px+FRxU/Kc7PP+AWFV/UcOOe8zRF68bQpJ
	NqmKgRn4NbZ8tQ9Gi2Ab9rjc6QcDbTHLAGpJr32TKBEnrjB3kaj0fk566SUk=
X-Google-Smtp-Source: AGHT+IGnOvmSMJiHTilz4QuvC4k33TNb6q929ZN9GMb5ns1D6ua+GNTnzx+AdRtKSiWT2jPRvhmUSNF7ofcblWO29+0vvE0jiKUA
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1589:b0:948:89f2:ea34 with SMTP id
 ca18e2360f4ac-949488ffe08mr3497024139f.5.1764588567171; Mon, 01 Dec 2025
 03:29:27 -0800 (PST)
Date: Mon, 01 Dec 2025 03:29:27 -0800
In-Reply-To: <20251201112244.638235384@linuxfoundation.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692d7c17.a70a0220.d98e3.0185.GAE@google.com>
Subject: Re: [PATCH 5.4 094/187] jfs: fix uninitialized waitqueue in
 transaction manager
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: gregkh@linuxfoundation.org
Cc: dave.kleikamp@oracle.com, gregkh@linuxfoundation.org, 
	patches@lists.linux.dev, sashal@kernel.org, ssrane_b23@ee.vjti.ac.in, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> 5.4-stable review patch.  If anyone has any objections, please let me know.
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

