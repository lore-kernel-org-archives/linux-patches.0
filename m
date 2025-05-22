Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25FF186295
	for <patches@lists.linux.dev>; Thu, 22 May 2025 23:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747957887; cv=none; b=uOR49AuR9xxHJeVjPd7m1DcvKlRU+A91vG+eng1PKDfEmqzrucifJchirBKaWSIIJtMrG/Mi0L8S79wt9BeBHtPyWKizUnMG+Rj91l5WzyxluClRxYUrE8JQ4Y88ApbRaFXGcHaziwVtx5++/mvKoYT5opBaqdduQkqE8p1SmW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747957887; c=relaxed/simple;
	bh=sgyFFJAnCJUBGKmWU1InDGZENXuXQ+nwvmLUPLlqVOY=;
	h=Message-ID:Date:From:To:Cc:Subject:MIME-Version:Content-Type:
	 Content-Disposition; b=DUFXEbq0Q1gCZjzRYLznfVkbsc/2SGbalFPHM7S5KBFZESyu4nkdtJ01yw5q1ldp/eB8z0qeWwDP/MbzmhMakvqIvEJpagulSNsWyD3q4ph/ZFK2j+lEdyQtneQpA0Rus85mnOROJMrONOH08oszYKC3SmNQ0l5ufzT9IkFwwlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D8kT7Xin; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D8kT7Xin"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43cfdc2c8c9so53020325e9.2
        for <patches@lists.linux.dev>; Thu, 22 May 2025 16:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747957884; x=1748562684; darn=lists.linux.dev;
        h=content-disposition:mime-version:reply-to:subject:cc:to:from:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=JdSGGP4i8x9bilkIzdRnc9XdO8ilTm4tAPeTA/a9Egs=;
        b=D8kT7Xin/czh4RpQ0jMbK/lktcTW6It2R47+I9gt5KE0C4NrnHdBe/Bk3ETXAVcXku
         TVerRR7eqXM7hiNcyi9qyHGXjXHdj4LD01BgdT3M884J0dTCN5aRsSoZPhHjvMNaGZuR
         uqksVN6A78UOAIkMzFSziX1R0UgMedNucTfA7bN5Ub1tuGPMrVjfeUHSqLw3mcCzd81i
         SRfwwRq+NQAuib0qQ1wu9U4rbvbQHEQSAs3RUAi75h3Se0PhL31IHYp4iDYzWHil/M3u
         1vsFEGnC7TV4Pm1z2dhZWY81b4/em2ygXLt1EOxHowWNJZ8Okb4AFPeoaCaD9HpqcYLe
         MuKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747957884; x=1748562684;
        h=content-disposition:mime-version:reply-to:subject:cc:to:from:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JdSGGP4i8x9bilkIzdRnc9XdO8ilTm4tAPeTA/a9Egs=;
        b=GW/YpMrnqLnpHe4SCqcmttn7Rb9GXmPlicmlQzSBi76F9xSdVW0l0RuxDnad71Vzom
         tAqfI4nu8Q/yP0rViLYHYixYe6UWia5822I1lb7lBJEQKt9OhPOqio0DlwfUWqPinNzm
         yMGauvOpHlAVPpdVaVjAtLls0Qg7nTIXRbe4smbXKgDt4aq2hjL9MBGlC6PyMX8vZk6p
         XCPXQKddHMjdobtAa4vS5gpVyzn1RR7GI9/pOg2TnYRsd2ATA3Fe4/2wc4NUgf7n5+Qr
         q1hNXNd612XE1FI61vI77eOKyPqT2XOeakWnG8CsjTQZRuBpGh3lcPyaiJez7xAqDNEt
         O+gA==
X-Forwarded-Encrypted: i=1; AJvYcCUlK9fm0p2QP7/Ptv6aS7kyBg9Zpfv/H0W7h+UimewQmyeT/KRDtY1ZkRV+bLbOEvPoWNt+2mO0@lists.linux.dev
X-Gm-Message-State: AOJu0YznHOduElnavW9xksAKyr1zWJu9cPdSLRJE/QJ69EsOICIV6eu2
	l1FO74uOjd9eC6gEDY6XoIBBL6J43LwxD+99emxOO+1hYtnyEDnd3AMR
X-Gm-Gg: ASbGnct3v5kuwg8c8cCfEOmC7NZE14Fc3Ndv3twgchF+A/7ERNh9OvP/etrLyeFMzqp
	clYN7DceJkl2BlPpmYs4D8CLCue8a9W6FKowI4pTdxD7hN20s7jmbY5m2F2LSt+r0peTpqvHpoz
	Cu6h60FVNMBTV5qW+J+cYPvb+jtbtJXz9wY8RpN+BmMt92L2LHnS4EL43A2zQONTceBMhHS2ngq
	q12XnxWgtQCan28UDgsdMh1mRFeJUHz+nkDtQg1eY1KX2HR87ZnvpJGawn2xFg+M0QqWfoBzyJ0
	k/PrHix87vhPg7D3tzkm33nr5EGrbgO5LeyVB8sUMQVoYvMJ1j0il+g=
X-Google-Smtp-Source: AGHT+IEfgibsCry+xPlNkoNT5afdLC9QRPTzl5aygSpWu90xdX49V0evjNDGo+MZuY+kRtIR6a99wg==
X-Received: by 2002:a05:600c:4f42:b0:442:dc75:5625 with SMTP id 5b1f17b1804b1-442fd60cb7bmr245173185e9.5.1747957883857;
        Thu, 22 May 2025 16:51:23 -0700 (PDT)
Received: from akanner-r14. ([5.151.48.227])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442ebdc362fsm243071505e9.1.2025.05.22.16.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 16:51:23 -0700 (PDT)
Message-ID: <682fb87b.050a0220.33d4e6.76e3@mx.google.com>
X-Google-Original-Message-ID: <aC+4ePTiiGBxzuJq@akanner-r14.>
Date: Fri, 23 May 2025 00:51:20 +0100
From: Andrew Kanner <andrew.kanner@gmail.com>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev, Li Nan <linan122@huawei.com>,
	Song Liu <song@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 005/568] md: fix deadlock between mddev_suspend and
 flush bio
Reply-To: 20240730151640.019989388@linuxfoundation.org
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> [...]
>
> Additionally, the only difference between fixing the issue and before is
> that there is no return error handling of make_request(). But after
> previous patch cleaned md_write_start(), make_requst() only return error
> in raid5_make_request() by dm-raid, see commit 41425f96d7aa ("dm-raid456,
> md/raid456: fix a deadlock for dm-raid456 while io concurrent with
> reshape)". Since dm always splits data and flush operation into two
> separate io, io size of flush submitted by dm always is 0, make_request()
> will not be called in md_submit_flush_data(). To prevent future
> modifications from introducing issues, add WARN_ON to ensure
> make_request() no error is returned in this context.
>
> [...]
> @@ -560,8 +552,20 @@ static void md_submit_flush_data(struct work_struct *ws)
>  		bio_endio(bio);
>  	} else {
>  		bio->bi_opf &= ~REQ_PREFLUSH;
> -		md_handle_request(mddev, bio);
> +
> +		/*
> +		 * make_requst() will never return error here, it only
> +		 * returns error in raid5_make_request() by dm-raid.
> +		 * Since dm always splits data and flush operation into
> +		 * two separate io, io size of flush submitted by dm
> +		 * always is 0, make_request() will not be called here.
> +		 */
> +		if (WARN_ON_ONCE(!mddev->pers->make_request(mddev, bio)))
> +			bio_io_error(bio);;
>  	}

Hello,

It looks we can hit this WARN_ON_ONCE() after which rootfs is
switching to read-only:

May 20 15:13:35 hostname kernel: WARNING: CPU: 35 PID: 1517323 at drivers/md/md.c:621 md_submit_flush_data+0x9b/0xe0
...
May 20 15:13:35 hostname kernel: XFS (md125): log I/O error -5
May 20 15:13:35 hostname kernel: XFS (md125): Filesystem has been shut down due to log error (0x2).
May 20 15:13:35 hostname kernel: XFS (md125): Please unmount the filesystem and rectify the problem(s).

Can you double check if the following regression is actual?

Since both stable/linux-6.1.y and stable/linux-6.6.y branches don't
have b75197e86e6d ("md: Remove flush handling") there is a minor issue
with this backport.

Statement "previous patch cleaned md_write_start(), make_requst() only
return error in raid5_make_request() by dm-raid" will not work for
both branches since 03e792eaf18e ("md: change the return value type of
md_write_start to void") was not backported.

So we should either backport it, or do error handling, not the
WARN_ON_ONCE().

-- 
Andrew Kanner
