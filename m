Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061492;
	b=jg3GuSdzc0aSjS33hMYMDaRMdMkZAeex+Vrl9dk97xw3iOI8Utmzq9gixn52gzqdsOoP
	 BBwjMB9wUyze0s5pOwCBWqzdjPoZUOh0rWT+kDBDm9ljMXt0Tenms9Vdk69AWxtI8H899
	 uqpSNHKzCuf81aSMV3qA69nNNrs6FlW0DbFiHfmLEfkSX8/ic7xYNVUGfwqKswO1j5m30
	 el1Xk47G0Qia1e6/pzm6I4afGk3lHng6QCmlwy9xYFm6iLsQQFlE3nYWWND6hx1dP+ppX
	 WsbjQSdxplC25cr4zq4Or4QnSmQYi16XF3leVZ/Zq1a4oK0VL1F5PqyxVEOquxRqbVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061492;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r0GKlXLML1V4tohw/hPK4aGsUH7NM+ibDDCWzPwAAso=;
	b=hImoliBzC2q1RPFHmImjioq57gyRDAa2nZJFJc4MWmgtkoZSirCfasAiV8SnmIS8xrjz
	 fsPj/LZn8FtBkabmudIm2M4b1M+QR19fAHJY8XO1CN1x3Dp6fgTXMBF/CqCCwMG9IuIcB
	 uOEZY4AzUF2xwT4D9WiAjltwqSWkJNR4YiqFAEaXz5hlKJapTpNc4kE0kNMwme5z+hj3v
	 iZE6T5XB9gwlEXE8usYwpDd+uSy3877ndq01AiaAC8UVYXhBqzxvuroFfij6o/gNS2ZWN
	 RGEn/tQUVBcG6UtSiU7hSFLunIPx6EHxKI9o4sK48Q0n0lK10KkJQ/zvhdkEV9mJMXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wkLB9BL4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2899606A33F;
	Thu, 19 Nov 2026 04:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wkLB9BL4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CDF1F000C4;
	Thu, 19 Nov 2026 04:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061492;
	bh=r0GKlXLML1V4tohw/hPK4aGsUH7NM+ibDDCWzPwAAso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wkLB9BL4OCHVu7wAE30NqTeRrHe9jDX4BcrF/VFqgQlvAhVeCd92qG4KjDcPFiROK
	 C3uc8uNEdOwMXQ/gxoYVACI6zJqzdvYp2fbwSPgn21UR43iwonmTn4AUMfaxcVEiPL
	 AaMTUrNR9c2Loc+S4W/T2ufSvD7fxXbx0tm1Lu0M=
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
Subject: [PATCH 5.10 1572/1848] mm/hmm/test: reject overflowing page counts
Date: Wed, 18 Nov 2026 16:00:10 +0100
Message-ID: <20261118150025.357336698@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e602053ec3ca0..dcfe420701a18 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -930,6 +930,8 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
 
 	if (cmd.addr & ~PAGE_MASK)
 		return -EINVAL;
+	if (cmd.npages > ULONG_MAX >> PAGE_SHIFT)
+		return -EINVAL;
 	if (cmd.addr >= (cmd.addr + (cmd.npages << PAGE_SHIFT)))
 		return -EINVAL;
 
-- 
2.53.0



