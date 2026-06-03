Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDBD38CFE1
	for <patches@lists.linux.dev>; Wed,  3 Jun 2026 22:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780526603; cv=none; b=l0AIPm8tHQrbh/hs2P/UNKXHx1M9jRg1Aw8uCgxvAj8cfWJKKVvVbPTAjrQLiuuzUdaSwUddhwwXpv2CuItajfYuAVDjjWyZinkCC5S/chbvcrQiPYHGHwaHkMNJxpnvLhiriAtVQSk8FC/g1hfOjV2euMXfQ4dD2gLVLb3MFU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780526603; c=relaxed/simple;
	bh=bpSKopOh+lqC+IlYALKlFknmtsR6CYYa845dkB+uwqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RF2e5DhK0o9ziYBssAAtupUmpcYU2ri4irxmnpb0I8Q7/oFFZ2U/9kJaK/t1ZSGYYlcztDKdDbZh9M+OlpwPK+OVvrwCU5tEU2sXuTtLHFGXme8jEygIWLMBskfarIejRw1weSWt6hmHHVl2tcX+PG/LsYw3D+vVtx9e8ZwN4ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K2cI3haZ; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K2cI3haZ"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490b613a17bso571175e9.3
        for <patches@lists.linux.dev>; Wed, 03 Jun 2026 15:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780526601; x=1781131401; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iTE44OxcHCqYjYX+doIy+3NqUmI4SQrZkrHVFocDs+M=;
        b=K2cI3haZgqn7pGadUAqPsuoKmBHd7CYXfCChXKi2VJMPU+EVrcl2lUnLtnciibRXRc
         1zwPsjB9W2pyaDn4HWWPy22rl5poGbiqSqOPuq89UYgxqrdmGQXzS2pM32alNF4OtT9E
         KrGsj5BzZ6h6ydTtBWD/SeECMmVSwVhJ8oJYZgQlDlzRuzlKCb0GmR2lq3E6wNELJFx0
         g8AlRreU7Q0WW9KRJF9CTGOI5H/qCtZJv6Cw/cHiFQVPWlR6Mnb/jSgDSqh4j8faFNOC
         HhHEc0qpZQtcDz2s4RUnXZc/85ebxaUw8jmZYrkpbWC0IfBAmGZlC9hibAmW2QO6K2DO
         mo9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780526601; x=1781131401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iTE44OxcHCqYjYX+doIy+3NqUmI4SQrZkrHVFocDs+M=;
        b=FgL+F6PFZOolHD8QWFvhAaMFcNML8gJUcMUZk74UiRAcabIAkJNvV8cKNJoxw6bwxe
         CZV12vbtGjkd1Whg+XxXckzEvOekaIInsP4cCcuqIzuWNiX7HlX+9Aj4zljT9Jy3xCto
         bXw2h+GerJA5/SEjtRTS7cRaaNkh3TdN561+/6tpparKbPITiaJYWJ2DakElxznvT0/s
         KRWSWbTJ8gHlRX/Ier9jxmwsnwBLiDCEBj0TYetsqxKpuah0H4ZSI2QBKpf2/8uInyOZ
         k3KiAMHDvstaFUbphGEfFfM443Gi4kxXs9+gGnnYUwFplad46QBRAUsdoLsDBh89JtI+
         OMJw==
X-Forwarded-Encrypted: i=1; AFNElJ9PLMFJp9hj2cXnbV85kMu+pODajIBtO8a9EcY0uuDL1U4itsuObdFh/1XU55ohB0W0xsw1EuAQ@lists.linux.dev
X-Gm-Message-State: AOJu0Yx8QrHNF7a5/JlbfvOPxtiyD1BAMP7Rt2MdPhagOULzS8+On5o4
	s4t8p4BFBfqzGW6eAktgxL6Fy9wjI6nViLfLqQwGbTKtLf02ZjWezG0c
X-Gm-Gg: Acq92OEyLVpWHd1mo9/Dvm9Oyg3vJ1yKEvgQYNDbxGJv0/aiJsijgpnXsxsbdHgHtQe
	xfvO0Lu1yhZnbYjzIRJM7a41kpw+kMYk77fPRPCJcj13UMBJ9YIpyOs/q8+9KaISfXQRjRHqC8z
	5D+QCfkayX3aULwPl/L0q4XphWVUGwPRd1lCeBb2BEq+h4FQRNfGoUmF96pO26ErCr8BrkiqLDZ
	vsKkMkl7kY56w74prnVU+3nBXepmGfBByKCmccqcnvH3Rwdco8+MFculdanS800tC3ouirDAhBh
	RgicT+WCW3HoWEMap4wsoN08ICLklo/nUYxbvLCZdKasJuqd1yFCkGcVI4JN0SDdxeL+DADNk1d
	mPfmEswxdxOdcPdX9k+cXjbQ2E4zXSrk+eXMoLl+RJ5s9cbyuM6DxIK2Pa745MnFT8QeA3cfYSx
	EBVHk+W3O6RMQtf3YLnI1q56WIxGrcEw==
X-Received: by 2002:a05:600c:a09:b0:490:688b:f9f8 with SMTP id 5b1f17b1804b1-490b5fe6672mr83368675e9.27.1780526600498;
        Wed, 03 Jun 2026 15:43:20 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-490bc391aaasm29855955e9.1.2026.06.03.15.43.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 15:43:19 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: luto@amacapital.net
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	brauner@kernel.org,
	david@kernel.org,
	dhowells@redhat.com,
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
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Thu,  4 Jun 2026 01:43:11 +0300
Message-ID: <20260603224311.834796-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALCETrW3XcNLuB1Y6PSkxQDSK2o+=EB2AAd25SjWQqcJemwnbw@mail.gmail.com>
References: <CALCETrW3XcNLuB1Y6PSkxQDSK2o+=EB2AAd25SjWQqcJemwnbw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Andy Lutomirski <luto@amacapital.net>:
> Maybe we should keep an API that does an optimized copy, from one fd
> to another, that can send from a file to the network with at most ONE
> cpu-side copy.  Not aiming for zero like sendfile / splice.  Aiming
> for one.

Yes, this is what my hypothetical future patch will do.

One copy from pagecache to pipe, and then network uses that buffer
directly.

> But splice_to_socket involves
> MSG_SPLACE_PAGES, which I think is a part of the mess that you
> dislike.  And the path where one does copy_splice_read and then
> splice_to_socket has to be a bit complex because of tee and (I think)
> because splice_to_socket cannot assume that the incoming data is just
> ordinary unshared buffers.

My future patch will provide new guarantee: pipe buffers are always
stable, i. e. they will not be externally-modified.

So hopefully network code will be adjusted to use this guarantee.

But pipe buffers will not be "ordinary unshared buffers".

They still may be shared with other things because of tee(2).
(But they are still stable! They will not be randomly modified!)

But network code can do "pipe_buf_try_steal" and thus ensure that
these buffers are not shared with anything else.

So, network code can be modified to use "pipe_buf_try_steal", and you
will get "ordinary unshared buffers" exactly as you want. This will
give you in total exactly one copy.

Also: as well as I understand, previously, pipe_buf_try_steal was
kind of lie. It may return true for buffers created via vmsplice with
GIFT. (I did not check this, but I think so.) I. e. pipe_buf_try_steal will
return "true" in this case, but pages are still shared! But, thanks to my
vmsplice patchset (which is already applied), this is no longer true!
So now pipe_buf_try_steal is absolutely safe to use!

Finally, we can degrade tee(2) to copy, and hopefully this will
allow us to always be sure that pipe buffers are not shared with anything.
This is possible future direction.

-- 
Askar Safin
