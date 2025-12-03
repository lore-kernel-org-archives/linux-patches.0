Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127D9344039
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 16:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777853; cv=none; b=bwLzS0wvIBA4V5c6OdX56brK7r6kxEl1mYC0vrzIcgyic0pqszN1vBm8uVbORkMFDecO1U/6/RmXoDwIU7N1vQQP2IBJ7i2vfZEfBwMiany8H/76mppkuGnh+uW4bANuZ/LXBRmRs2iHIzq+Qe6uhB5gzsqcl76CXfAZT7NKMj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777853; c=relaxed/simple;
	bh=nJqjEdow/Zt/TuLDaoijl8cu4nclMMywIodJXAD54i8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=JWbPJsISOKl1106NdH/SmWYO+we8h/w2cIYoS/ihyd6kZEGgKOa1rwHvHBpW0cVZvmZ1M+OoifLjzFociZMQiABz6ZPSt9nm0u+Lssb5WNToDxkyIfRp6SL6tWTIbLAOTUyQreREFLQTDtjN9o7jOml1+ZtWLTMY1ECGjVip4cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4501b05fcf1so2887514b6e.3
        for <patches@lists.linux.dev>; Wed, 03 Dec 2025 08:04:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764777851; x=1765382651;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CJDgUU97V4GjWs3LWgSaDK8Muw/itNKU1HQ88yeQQgE=;
        b=NTyU+ghQSKUCfV/2KhjVaTYems3aOZP4HywSMhhL5GOTz43Xi952Ng6fRPZgSxLUA0
         ZT13Xgb3uP5qXktvi4c2SaRiINiG8KVnoie7aiWAkYiHJFPpWRL3ctLEDc6yRknPtgc6
         sfqfcWNn1/LeStlOJ9YhiDzzWIGULOmqiB48wP9NHxP1LXxyWj/qOwdE3+CAhLMf+xi2
         WBEOBGZh7mtTeNoZcIA6AeMoixxZvwF63S1Nvg7QZpB3mV/pO083Ty4sCub4XEWyQ98d
         n0LDg1XPQ6/657dUlz3eQ+cH26QDuz6MGOS7RgWiwR7x5vH8KMyCaQzmcZXbA0207l+v
         edRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXeYTtRFDOnKs/CIPb5R4yu+yrRN8F+yWMAocSzOvV5btmgb9l671a8UXo2OpBzK5zbLaaiA0YT@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0jrfGR1Q+UdfL336wKxF/2oNQpKTyVz4B3UTP/gKXxDI9Azcf
	rnWwLUb+O8tz8s6aXTq9t0SWNTWm8bb4EdbI7yOK5dgf4X3BeAMGi9hWaYT2zS1WFy8U/ggcgL+
	PgBdsBetC8xvLnkxq8Y9tB+o6ImXCtk5ywFcWQBylGG3oRkp4794jbyzbDvg=
X-Google-Smtp-Source: AGHT+IGIMPejztAdrOQZy+vUI1/EMQ6vqwWNhRz4fHJX8PNwx1mu3VnZup8np2VmdmJ5HnNUv0iFfcAQ+xerwSOAbzmr3iffr3L7
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:150f:b0:450:c0ef:8092 with SMTP id
 5614622812f47-4536e51a33amr1440205b6e.34.1764777850859; Wed, 03 Dec 2025
 08:04:10 -0800 (PST)
Date: Wed, 03 Dec 2025 08:04:10 -0800
In-Reply-To: <20251203152420.150891955@linuxfoundation.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69305f7a.a70a0220.2ea503.00d3.GAE@google.com>
Subject: Re: [PATCH 5.15 165/392] jfs: fix uninitialized waitqueue in
 transaction manager
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: gregkh@linuxfoundation.org
Cc: dave.kleikamp@oracle.com, gregkh@linuxfoundation.org, 
	patches@lists.linux.dev, sashal@kernel.org, ssrane_b23@ee.vjti.ac.in, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> 5.15-stable review patch.  If anyone has any objections, please let me know.
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
> index 3a547e0b934f2..d322a22477e49 100644
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

