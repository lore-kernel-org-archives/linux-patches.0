Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019677;
	b=T2zy9Nw68XeDCx/ILmNYD58fJZJBFCS6Ay08XoAZpNLrCTO1qTaRJWeK4H4JUTv2WCBy
	 QuetzWI/PyEeZ5hBa9L1iAxmigbl416mfBITVk9bGVXgXkKGw5J72MBgYNh5Hsb+4tTkX
	 sXM77rUZaxe+EoFnn7TiQKgmyXbZnRasdME+dfByTtuN08sAoBEaXqEoRjSpb5Y1rzZPY
	 b028pz3F5JR9fdtPjfwBPHE753K7uOVbPzdvXBvbHcX6vpATwL0xxk9I1RS84N56+CwJw
	 K1N1OiZJgBI850Z298oorJH5SZ72488Tf1DgwU+8eofrAquYB72VQH+Lw/UaWnqlxUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019677;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1v+YQb6ppzyE5k44JlS0p+QhaS+nWjuqat558LA5JuQ=;
	b=KQsS2EUUTEIlwUGtc5f3hfSrmjW7UmuFkU6lKOiul2v+hmu9oyomgcPPS01DC0pefq2p
	 +nlDa/ndygo9W+IMa9gqMRPGFQ3Z2qgPvrFMWTc158m1Vvtm9826RDWaAXJZRTHmNb3tG
	 5ZZsd9Ryjzxlc0TB4qag7X53vOX60bk+mqd6QiaZs7ki63muYVO4cVebN3J5fEqPpPSn5
	 I0Yo/xGjuEsAowMLOJHnnmZl5F3bRUR9yF/m1OcZporgdud7KQPluFpNGQ6+8SFamwnlu
	 OV2txGmRs6AbeKSS++9dO6YVxwLB5uJj6OGbhl91omBIDKll7ARGVVtv/gGclrWqHyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=azqHe8L6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52054606A320;
	Wed, 18 Nov 2026 16:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=azqHe8L6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58BB1F000C4;
	Wed, 18 Nov 2026 16:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019677;
	bh=1v+YQb6ppzyE5k44JlS0p+QhaS+nWjuqat558LA5JuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=azqHe8L68S8dhmYjk6zGLCs117Cy8+iTxlWNNVCMf+bnT8g14ItM2RMx4QeZpmnfV
	 F0hgMGP3RzXN+xs9E8N4LDkZjjsbGunxRBppT+MBgooLaDWyMhrx4p6motjjvRuIdy
	 1KZeBsE40wE1SfAE5uE1s+NeljzLLkZAxsdRHznA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jerome Glisse <jglisse@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Wei Yongjun <weiyongjun1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1681/2651] mm/hmm/test: reject overflowing page counts
Date: Wed, 18 Nov 2026 15:48:41 +0100
Message-ID: <20261118150348.199798502@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit b59925301211ccc351d98d70b11f6d1b2c63150f ]

The number of pages comes directly from userspace.  Shifting a value
larger than ULONG_MAX >> PAGE_SHIFT discards its high bits before the
existing end-address check.  A request for a huge number of pages can
therefore be accepted and processed as a much smaller request.

Reject page counts that cannot be represented as a byte size before
performing the shift.

So far as ChatGPT and I can tell this doesn't cause an issue in practice
but preventing this integer overflow is the correct thing to do.

Link: https://lore.kernel.org/6f0d39089e938d4f53dc72632eb84aca34de7015.1789457465.git.error27@gmail.com
Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Assisted-by: ChatGPT:gpt-5
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_hmm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 6911daa9f8543..b409c42bfe6fc 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1624,6 +1624,8 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
 
 	if (cmd.addr & ~PAGE_MASK)
 		return -EINVAL;
+	if (cmd.npages > ULONG_MAX >> PAGE_SHIFT)
+		return -EINVAL;
 	if (cmd.addr >= (cmd.addr + (cmd.npages << PAGE_SHIFT)))
 		return -EINVAL;
 
-- 
2.53.0



