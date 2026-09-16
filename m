Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62512AE7A
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 04:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789533117; cv=none; b=MlcTZMhutN/SF9KdNpHHslgzpmFhBAKccoSoFINLvjCp+hR3XDbxOXB3ULZLPs2NTCWBkdVUamM0+hSHZU/TvRxHW9UlL8b2vh+LZUtCC5kgl/NmxeLp4sUKQhHGB8s827jHegJw+i2jwC+NdXL7tHYqO9h0K3GLGMwGJXXL4/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789533117; c=relaxed/simple;
	bh=7IwvsDFXIGyQVneiPjkwDIbm4hBjCNGR6zBXmO3NAvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WO3iM0ULkxEwyicsqOtS/+88vT0hLcbOz5WfJYzqlWNP3N4dbzPAgyOIpTJCntp8vRRQ3BpR0Aj8LIcosRmtyrQKiLncq2UsSk4rn4wr2v9y0WEl6La5aavFQbsSEqxzAstdgA3VJpgp9AQl9/u98hzfEI0tgviljEUHINPV8kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nUwXA0fE; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nUwXA0fE"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912e64ccso3171215e9.0
        for <patches@lists.linux.dev>; Tue, 15 Sep 2026 21:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789533114; x=1790137914; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iN5gALzSQ3UoTSX0lJ7ZMyS+cbSjkoJk3CwTBaiWM2k=;
        b=nUwXA0fECkNIMs76qS+Ky699bFkRq97+b1FuZkGrFt6D40K3B+yEQEqejYDdg67nSt
         NlP+O9OqF2EqonveTsTXsC5DwbWr++7n8OzDRmm6ArHbJxkaHEFc53sNZrXaJCdm06g8
         iC95PCRaJmaQgnGthFRwAThI284eHjqo77cQYVtev3rmgijaIQW+u/UH4sWWH1QaFfny
         tHSzl/L/rvx5UJnb7z4QbxhmKjL5oGuirqc2TeBRcRHnKalNLhb6K1lR9w3eDLica+Gr
         xek+S0MbmUe7LmHL4cCOYivVDTmXp39nxCHJw67WiPSMsNmEXF5X00ahomqwzb85n20k
         CpRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789533114; x=1790137914;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iN5gALzSQ3UoTSX0lJ7ZMyS+cbSjkoJk3CwTBaiWM2k=;
        b=oA5FSR/F5YOZ7JoBWk6gWpSeMxwpfI1ANpvn098siTrVzPyZLUpCMbJXxEz7tWQLgR
         craM/6n0QrCbxLA+TOGTwJcB8k+DqSMJqOr6UwRyJ2T0iU/xRfK1tPPrr4XJqVCrr4Yz
         MQUnUsRvNB8ct/yA3ObJ+soryLM55D35m7jSBn+5PVzCDh6PlYlgQw3lVnm/C6uSt4+K
         fn7I/8EjUO+i+wPLE5xtJOQm4IschZkzlyjm1IPTRjPL8JvXlGSP5DpkarVRVhb+2HLg
         eF6u3o1Eq5wT0GjNJ3kqzgUHx8YMZfKd7MZyFDkTubL4vPEn9AbzykRpysQk3K1qBSQ4
         TdXw==
X-Forwarded-Encrypted: i=1; AKwUvBxvSd+NknhY1E75tRzR2jghToZXJEUpOLxcGkmssGzkx1MOUO5xhQJyBiPg6QA46tL+W1CFr000@lists.linux.dev
X-Gm-Message-State: AFuF++knHv/IsMX+vHYT5kULnGUbqb7EDIy619Meu6nNB2RnqdsJ4Jdk
	v5xDV78jo/o3zqA9HTYP0pR7vz6u8+2bSM94stCLqlgASm7OSEN7J4wO
X-Gm-Gg: AYBFou1WdU+ZYgo8UBGsSmGIfbBkuZrNi5rBvnhq7rC7QViwtduDEB6jpU2NN2uDs4h
	1F4Yz8hRZvE7VKo4p/GdHMILErgONr7bcjdbS/Luehr1a6nPtn3rW4wzlP4nY6pGpkntvnFNIyq
	0dhs0sPXynwfZX3gNWzydZgP/dnQEcnQh4y+uKGz4fSGmxQ/35TIwdPn3PM9V8gp64IiK58P8id
	4UpxTX9OdodRM/BHGICHg7Lb2+d+BWWVqiwBj+pqyOyfwrxB5YDCt46jlMqUR3ogMsxP1f4xG97
	gdfT9D4aRB3E4zDFakohxUhkHHRY80A/FnqL6qIXbxhpPfEi9SMqYz9zpR1MNZiRD8ubPxV2dfr
	N6sMIFUhOQfPYNrimEr2jvD6WXKBeKwKMeh7xVz/O+IuWBIkWTrx7ru4LyDw2cObjuYCJ6kyTUB
	iOBWy05EdCBFyaVmvraoopKbv9GigkkgrdpTEbV3hXZ+5tVzoK4IBAcDdXvb1/wi0zlvXh8iyUV
	X11IQWPZHmHRGWsmJZduWDklyLLQIwkcDdhg+9ZDaHYScJAPthFOnQ6Bh0vsPCBPcS2TYdeR+Ze
	kAKWWxr0h61VO4zoFj/qeUJORavGb6OXLTFIKPuPIWxw+ba6IlBnAcoatFVug7iMc78nIXc=
X-Received: by 2002:a05:600c:c48f:b0:499:a277:e8b5 with SMTP id 5b1f17b1804b1-49eac4638e7mr16972695e9.3.1789533113835;
        Tue, 15 Sep 2026 21:31:53 -0700 (PDT)
Received: from MBP-von-Karl (dynamic-2a02-3100-adf7-5a01-5cac-d7ee-c105-a566.310.pool.telefonica.de. [2a02:3100:adf7:5a01:5cac:d7ee:c105:a566])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e847ecf52sm27170775e9.2.2026.09.15.21.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 21:31:53 -0700 (PDT)
Date: Wed, 16 Sep 2026 06:31:51 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Edward Adam Davis <eadavis@qq.com>, Luiz Augusto von Dentz <luiz.von.dentz@intel.com>, 
	syzbot+b7f6f8c9303466e16c8a@syzkaller.appspotmail.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5.15 879/935] bluetooth/l2cap: sync sock recv cb and
 release
Message-ID: <aqoaFdvSsDiiLb5I@gmail.com>
References: <2026091453-unwary-delete-b272@gregkh>
 <daily-reply-20260915-0012-re-l2cap-recv-cb-5-10-revert@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <daily-reply-20260915-0012-re-l2cap-recv-cb-5-10-revert@kernel.org>

On Tue, Sep 15, 2026 at 09:52:17PM +0100, Sasha Levin wrote:
> > Now dropped from 5.10.y and 5.15.y as for some reason this is marked as
> > adep of something that is not actually in the queue.
> 
> 5.15 dropped it, but 5.10 did not: the backport of 89e856e124f9
> ("bluetooth/l2cap: sync sock recv cb and release") is in v5.10.270. So
> the recursive chan->lock deadlock Karl reproduced is live in a released
> 5.10 kernel. I have queued a revert for 5.10.
> 
> f1a8f402f13f ("Bluetooth: L2CAP: Fix deadlock") cannot fill the gap on
> either tree, since hci_sync.c and hci_sync.h do not exist there.
> 

Those files are only touched by an unrelated cleanup in that commit, a
conversion of hci_dev_cmd() off the old hci_request API. The deadlock fix
itself is the two l2cap hunks, and both apply to 5.10.y and 5.15.y
unchanged.

While testing I hit something else. Without 89e856e124f9 there is no NULL
check in l2cap_sock_recv_cb(), but l2cap_sock_destruct() still sets
chan->data to NULL, so recv_cb does lock_sock(NULL). Closing receiving
sockets while L2CAP data is inbound, under QEMU+KASAN:

  v5.15.221 as released           NULL deref in recv_cb, fatal
  v5.10.270 + the queued revert   same
  l2cap hunks + the guard         clean

  BUG: kernel NULL pointer dereference, address: 000000000000008c
  Workqueue: hci0 hci_rx_work
    lock_sock_nested
    l2cap_sock_recv_cb+0x36/0xf0
    l2cap_recv_frame

So the revert on its own trades the deadlock for this. I will send the
l2cap_core.c hunk, which also fixes the unbalanced unlock you found, plus
89e856e124f9 without the recv_cb locking. I will repeat the runs and test
on some real hardware before sending.

Thanks,
Karl
