Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AA734F24E
	for <patches@lists.linux.dev>; Tue, 16 Jun 2026 01:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781572528; cv=none; b=I8jKm6WSoTjYSw1kvFLi64mbDZz15UWErT4XscDGzQnK5pJg886IwIqPGXdKxo8vuX8ExY2+BqK7qhGZzhBO2kXAeMvuuZuu6Q8e/KKYS1x9q+QkgEXCL3d0ntEpESs17wzpLgvF4zbQguYeUl8xD+JEcnlH+yQ/K0KRMzDTcpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781572528; c=relaxed/simple;
	bh=qSWoZgNw3PpVwHOk9/H/f2RnG3uRakwqaf1M/1PGtU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jixU3q8eNIr0Vr0ltBhi4w+5oN0k1SH1b5xImfEGt92WJ0OVeqfxqF2xHCwbVQTurxdTnLZ0JjUHK7ACVQISoIdijDczE+RfPYtJl8YhlWerQIiUyZ3jGKL9HJ2+tDME6OTR5NKsAhxeYvzpdqQFcOIl116l5X1mmKiJLfLAOIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bljNPmjL; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bljNPmjL"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-490b3637b90so30177135e9.3
        for <patches@lists.linux.dev>; Mon, 15 Jun 2026 18:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781572524; x=1782177324; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=53973eSawR2ZjjRuPt5kDFsVlZ1YHqdNePsF+6+pfeM=;
        b=bljNPmjLs1lGBwjb3GD3PjkBsFiktN/LU741oyYo2k0jo31hktcnv2UhjWFBtHupwd
         Rf4ofmQk7paZ7oiyhlrl2kepldm7c3O4B5D1+bsZRJg8vQ1i7ujUtmqHELf7kLKXZhyT
         TNff8JE31GfMjCA1asvB0rpWb2WgwngX54bOKd8BwYl7zzOwINAUEJcHFmBEIm/RlYeU
         mSen/dFh4coOoTsIahggC/GXAleUBIRTRnkOzFZkEFqq/gP9navWlEautzKWxKaOgThm
         PaC9pJt24w7v3IZX7InB6KVEqa0ZPeY/EGitl2NLwQ0oVvD+Ok85OFJ+ux+Fr4J9Yp9s
         YWOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781572524; x=1782177324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=53973eSawR2ZjjRuPt5kDFsVlZ1YHqdNePsF+6+pfeM=;
        b=N1SXdaB7FLkoVKNxnsmnUY+6b6JC144rHAm7fIkQapgUDuW7MeOuJBiR1QRMiBdLsJ
         B2LKsSrWLF7gWREMq+fx2klQkaXgE+IcweoOuxwNhk0firq+1VYvz6x0D2+pp2HPkF2e
         IXJn7P6qDHEZ8GYLEE/fSXNZKCCenrn2kUshFju7uKCVRfc/MCFH2Y1MeLFF5yTrw3GY
         TQxhL0MeeMFDmI8/wpevaNkk4eDpZepm10Lx+jm3c016AuYhAsgwxQuLo73vm15b8iLe
         4ZAmCY1CCTnKNbEwgvLlB/pAG7QSdnNsa5lZEZsMMM4y1Wx0QkbONM4kuV2NKCHToOZC
         ZvOQ==
X-Forwarded-Encrypted: i=1; AFNElJ8Oj4Wmhee+3dAHXmDw2G6IJNWSg76N8dsWidkkucsFIXVtC2kBxj3wC0myH4+8XgIXmEZVb+qh@lists.linux.dev
X-Gm-Message-State: AOJu0YzX/Qjyf6xODVfBZkGYAHN41R4d9NA6jP1x9f1JknWFyy/tEKfi
	I4wXXvZcq3fP5T39Tm8sgiqtAjBgJ7fUkK4lSBDlkX+ZhRTQpcIJfpos
X-Gm-Gg: Acq92OHsVUWv4hIsKDLaSpN/YAwrdcXHM8LYHyKJXm2z6NSpHqk4HK8NDq9tpGHVBOB
	W1XLudWc4PiwfWXwYrR7RlTq118b0RNqhLNPIvkJQF28CF7dfI2Lgu9eFnztLhV+FBvmBnvhsne
	UW89p6DKpXF27TJRz/w1DG9odvPn7nnqTEj15fKm67zNwO8qX6oUoASw9cOaGao3/juppDMdfDG
	FCRRyFxFnBZUlIc2ZLxPf5qf+AgRDP885R7N/4x2rsR6rpT3kUeEcItnYcSVOVEVNKrucwp84QE
	RSx8BFCg5hIkpDZHXmBW6fLx3wCgaAuz7jkzmyg9xxfx0oaPq1Uyzo2tFgwRPr+8dih27DnNvzE
	+PhiFiJtoSVYxqERnSb1K8lBaNzXQT0AS4dUu6jBHkX3om73SXQIatO+9OPDk/tXngwTUTi6yms
	ZqVEiHLGlUuL9yCNFjiP8=
X-Received: by 2002:a7b:cd0b:0:b0:490:b2c9:e284 with SMTP id 5b1f17b1804b1-49220143bc6mr120782165e9.30.1781572523711;
        Mon, 15 Jun 2026 18:15:23 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4922fa47da9sm43123095e9.5.2026.06.15.18.15.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2026 18:15:21 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: joannelkoong@gmail.com
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	bernd@bsbernd.com,
	brauner@kernel.org,
	david@kernel.org,
	dhowells@redhat.com,
	fuse-devel@lists.linux.dev,
	hch@infradead.org,
	jack@suse.cz,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	val@packett.cool,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Tue, 16 Jun 2026 04:15:09 +0300
Message-ID: <20260616011516.4039110-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAJnrk1Y9egYizkx1H9K0cqxSYuB+7vLvQbV7Tf4C5eHFqnnC-A@mail.gmail.com>
References: <CAJnrk1Y9egYizkx1H9K0cqxSYuB+7vLvQbV7Tf4C5eHFqnnC-A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Joanne Koong <joannelkoong@gmail.com>:
> > speaking of fuse_dev_splice……_write actually, this series has broken
> > xdg-document-portal!
> >
> > https://github.com/flatpak/xdg-desktop-portal/issues/2026
> >
> > Specifically what happens is that the EINVAL is returned due to oh.len
> > != nbytes:
> >
> > fuse_dev_do_write: oh.len 16400 != nbytes 15526
> >
> > (where 16400 == 16384 (read len) + 16, 15526 == 15510 (file len) + 16)
> >
> > After reverting the series, there is no error because oh.len
> > becomes 15526 too.
> 
> I think this is because of how libfuse handles eof / short reads. When
> it detects a short read, it fixes up the header length after the
> header was already vmspliced to the pipe because it assumes vmsplice
> mapped the header's page into the pipe by reference. It assumes that
> modifying the header length in place gets then reflected in what the
> pipe later splices out.
> 
> The logic for this happens in fuse_send_data_iov() [1]:
> a) sets out->len = headerlen (16) + len (16384) = 16400 in the
> stack-allocated fuse_out_header
> b) vmsplices the header to the pipe
> c) splices the backing file to the pipe. if this hits EOF, it'll get
> back 15510 instead of 16384
> d) detects the short read [2], fixes up the stack out->len = 16 + 15510 = 15526
> e) splices the pipe to /dev/fuse
> 
> After this patch, step b) is a straight copy which means step d)'s
> fixup doesn't modify what's in the pipe. This could be fixed up in
> libfuse to not depend on modify-after-vmsplice, but I don't think this
> helps for applications using already-released libfuse versions. I
> think this patch needs to be reverted.
> 
> Thanks,
> Joanne
> 
> [1] https://github.com/libfuse/libfuse/blob/master/lib/fuse_lowlevel.c#L846
> [2] https://github.com/libfuse/libfuse/blob/master/lib/fuse_lowlevel.c#L956

Uh, this is very unfortunate. But I still want to remove vmsplice.
Maybe we can somehow save my patchsets? For example, let's return EINVAL
for this particular combination (writable pipe + SPLICE_F_NONBLOCK).

-- 
Askar Safin
