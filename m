Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D777307AC6
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 01:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824889; cv=none; b=YqyL5H3oTTJPMQZkjHS0u8zgu0ukVgghgm0qFLRUAvrS0c1SOu5rVISMrTaHUr1q8aP4Xxfi1P+hteTfj6Hmc66l2+XlBDgv1bJoS6frdjVTviWZEizHCX56d0KHKRxDGHpw7i9ONvis9F2m6VJ3GpQRzy67CyDEHCPf4nPVRTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824889; c=relaxed/simple;
	bh=G9s9R549Bj0/8DmLMijlDCCQFUoEsEcNQ4J5IbrxMCo=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=EiECiIGJNivKDTIR7wM8xGFVs9A/qe940JYriKL2h1Ra6Bjh7TriJp0lYay0brhOpEddjx5QyQv74o5RxuXS3UCmEQSQb54rQPKScPCI62fA+ZGcCDYA++xrVDjf6aoCAiQ7imBjxl5VvOAR0hnfq7sRqivBy4IadpuWtKpJU+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-4331d49b5b3so2502295ab.0
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 17:34:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762824887; x=1763429687;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iFdhnMtQbvk+cxGkbCmb0GUX1So7hpWDFjTG3gplQc0=;
        b=E0VyG98Nlb5B6c2FvoLW+AnFolSAo3jIpxl7NfXlY0qpHtNxqIe+0EcrEscKNJmHWb
         5ZaxIoFycG4uH5oIpLmHf5XRbVgWfULwCcWk+psOwcG+Tqq8v3v76SV+a9SaY5ATWoRv
         mt34hDPcHlT4yJI97WH2W+OgGebIj53UzhdiQQptspexqypQtClTyAksU+XCjv1O0yMf
         6aHEeRug+B9UOFPIWmu3rB3xVvhXI2FIRYePysxIJmKIJcfhT1WM/VzRjXAeXjwL5Ehg
         aaIuDDzBk4KJM04Bu6dcUUa4rseWZNPVUEoHLyuke0jRo8JHnpoiwWEXCjPWb/KT4g2v
         tc0w==
X-Forwarded-Encrypted: i=1; AJvYcCV+pD8uR5GnkVH3GWD3H9kUu1ZwvSGBqfbH8PMkxqKc6dI01zR27UIvnFghNCU+q3dn1sDbr9XK@lists.linux.dev
X-Gm-Message-State: AOJu0YwZVL+7oCmncYRwCUQwCWdu3wVb3L7B+HzthwgDsFQ3Z0KFpXYx
	HTvSNYwZrcs9Rxz7AJ3L7/mVu1EjTS07cWRO7cX4BYwZqkWtIT0PdwpbvMkJ6Nzd2a1Oc00AQ41
	bb+GWLRLlW9Zc5DNBuEi/0aT4EScSXxgntnNwMJY555E7NMmcmfGmoJFuojk=
X-Google-Smtp-Source: AGHT+IHSHE/ZwvX7/pJgiSzkq1D2fW7OKj4ywqUFD2FdrJzS5Suqixrr3UkXqTx5ck6CZwqCjmTC4ff7cxFBFIS4FV83DNAeGizX
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:228f:b0:433:28c7:6d7c with SMTP id
 e9e14a558f8ab-43367df3b3bmr173309345ab.12.1762824887377; Mon, 10 Nov 2025
 17:34:47 -0800 (PST)
Date: Mon, 10 Nov 2025 17:34:47 -0800
In-Reply-To: <20251111004550.712161392@linuxfoundation.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691292b7.a70a0220.22f260.011c.GAE@google.com>
Subject: Re: [PATCH 6.17 591/849] jfs: fix uninitialized waitqueue in
 transaction manager
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: gregkh@linuxfoundation.org
Cc: dave.kleikamp@oracle.com, gregkh@linuxfoundation.org, 
	patches@lists.linux.dev, sashal@kernel.org, ssrane_b23@ee.vjti.ac.in, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> 6.17-stable review patch.  If anyone has any objections, please let me know.
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

