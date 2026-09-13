Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F5D36998A
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 19:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789327403; cv=none; b=MXFIpc4MuW4uApZZvGX90vp9lcVEnqlpa9vcp0V7E/Elwop4b5dJ/Km1rdF6Y9zwm/dPLpZOBK+WUDT4USCY/5l1Hm0il3+htXhHkPT/KQMdi+WzwY9NZ8TIyktU2Jh1BYn6ZtmeXSB+IMJRK3vF4WqCT/DRQHeGCaycJCUVcRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789327403; c=relaxed/simple;
	bh=cet9b/ZrUPSX83m87GOSBf1y+OWYLoqD1gBEkjB4pSo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=imGSfG1C96Jul4Bk8kpIRjY8thD+50tD3L4OKg69V/aMgZTNi3w1Fvf9qMXeY+ifGAsPCDQGdptdQ8pfVYHz3bgv8/KisHCu4N8DecoG3Xbe+31L0n0VeQLBqo99soNNZkzWw59tij7TYsyA6i8ZSTPxpgwqmjvQhRagg8PT7n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BcHqxUOW; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BcHqxUOW"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49e6e69d528so12432015e9.2
        for <patches@lists.linux.dev>; Sun, 13 Sep 2026 12:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789327400; x=1789932200; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cet9b/ZrUPSX83m87GOSBf1y+OWYLoqD1gBEkjB4pSo=;
        b=BcHqxUOWe9iHcYzYuczB4G/3qB+RzIHjozX7U3QMphX2uAkWRj0s2Ht1pX+8xXZyvj
         F2OWi3kmga+QuOSkuBcJz0im6L9sjFx+z0nyD6nNoNRE3kINhKioAtmi752ivPBSipIQ
         kHo5HN30Bz7+MgxqmmW1n3l443wwImjA7QHNuJ1za3CHYaiU/3G8mrYOXqHFIt7DR3H4
         USgVDzGdn7a9XTvy/QsS104X3fAcAwTTx/gz/Kad1qP32GQuzyF62EkpvQsqPE17xZdd
         SotVC6r4bXGGryp9pASO3unNvFHXzd9P+lQm2dC1xVNzu4bcpO8o78hKL5mNPdisVh4g
         7/7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789327400; x=1789932200;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cet9b/ZrUPSX83m87GOSBf1y+OWYLoqD1gBEkjB4pSo=;
        b=RA6rOxBRJngmryBjZZOSCU4kOzyS3D6YGv4Y+jx55iMYIYIeay9r/zghibFrwnrb0P
         sEVnk1q4u6SBtUga/Z+U6JSOszmPkRzVW6Wix+5TO+8rpPNu2pon9QnTX6GtuVM3fhtc
         2vEKiv1EzBNvIm5gzXvLpZe/QxqvEfVpwxb22zcllKRzxXHhsAZdcpEGJmMuOPIVt3nB
         JYg0neXpYZslsxKvLBeDsB6Tb8fjFZ+nEbDjTY1nnsNqAMDvIQF2uiwSg3gz6BbIrY4d
         zTACAud2TZAFyJrDlAdgp+SfTiWY26Jdcv01D6FULfxFhrPYy7CYTTqtNodWfg8SZ7H8
         vt8w==
X-Forwarded-Encrypted: i=1; AKwUvBwJ3iKxcS8FRGjXLMopKYIXja3CJ1W3D2xaUsLMJ7QKEQYwQCNb+Joe+Dhto0YF/aTd4C4vBjQj@lists.linux.dev
X-Gm-Message-State: AFuF++lES3d3VC0pMiOVVPOUUiiOA2JSkLOBu4OfP5s15trbW8vuZ5cF
	Atvkq3JGIlf8h5ohWt3IxZ77+rdg9hIS0r/9mBLJl4MQCX55Vo+BHJdw
X-Gm-Gg: AYBFou3XlUEvNOWpLslT4bAf7wuf4lkSy8Xtqw31Bc9ogjapI2EtK+m332x6OCnjUPs
	vljMmIi48tKWBRNo0yv6HLsKFG8RY2KCrI9rnIBDoI/YCZHTWpoPjbWqigB41T5TbzanxMzpel3
	F1WRdE/12YZpaCdLaDAWuSOjyG0RC4JnIACQAkX0VVlWjoEOE6xwrYwvcM3fXEQDFKeLKpmWLZ+
	JcYt9KUwL6El8/irwDRGrUjOXlEm+GRQUdKvJtYpUwljfNBim9kU//OXU3Md4vWZ4+M/BN4ru8I
	V748qpeQxSma+ygr6nrBu3vF3CdbGD/hyCVxg8hoQ4gRY+aO4uq8W9HAwgXz9PWKkWNeX25Fhi6
	71RMHL/dWIB/ZDsnYhou0QAonSiQvUu47bNxblKMIfCDSnydt+gink7d+nYGXcoEv2R+0M0dlIg
	MsJlFbxdR2Pni8B60nH6xl3YyxBSo/cx0OEP/wV+6EfpGyJaI8U9XQTPYd9KijtbMhXhQ3RqOlC
	/+scxQC8QsnOa84uk4INcWMDka8dPqgfnVhffa8ovGaLB5PBGDm0z+QfPdk+jXUt+5GXtrSJ/Yc
	iwVvnQl/itKKT63wFij78wRZ1tljtEQGpfFGxAo9ewpTL4hMQt4sIrrU3QmV51WlgvDfFygOqwN
	Pzg==
X-Received: by 2002:a05:600c:3104:b0:49c:eb16:9fd with SMTP id 5b1f17b1804b1-49e6197f6f6mr151860895e9.3.1789327400198;
        Sun, 13 Sep 2026 12:23:20 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a0e6-2301-7846-2cfb-35f5-6359.310.pool.telefonica.de. [2a02:3100:a0e6:2301:7846:2cfb:35f5:6359])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d26b7332asm336899905e9.0.2026.09.13.12.23.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 13 Sep 2026 12:23:19 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 0572/1376] bpf: Sync tail_call_reachable with callee state on entry
Date: Sun, 13 Sep 2026 21:23:12 +0200
Message-Id: <20260913192312.2402-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260912065620.278405277@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org> <20260912065620.278405277@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Please hold this patch unless a 6.12 backport of upstream commit
54c27ea6dadb ("bpf: Fix tail_call_reachable leak") can also be included.

This patch resets tail_call_reachable on callee entry, but 6.12 lacks the
parent-state restoration it relies on. Returning from a clean callee can
leave the root state incorrect and make the x86 JIT omit required tail-call
counter handling.

I reproduced this on 6.12.110-rc1 in QEMU: the unmodified kernel hit a NULL
dereference in generated JIT code at ffffffffa0000114 with CR2=0.

With the applicable 54c27ea6dadb hunk applied, the same bounded test
completed normally and stopped at 34 program entries: the initial invocation
plus the 33 permitted tail calls.

Thanks,
Karl
