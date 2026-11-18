Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031531;
	b=PG6f97M4mGp3GK6EoojQuqZJEQk9eBGiYk/WhLymK9vsVxYu7fzkBbzVbpNNWGk9sLNO
	 4qgCtIJl5aj3uAAwatnwoGQcTFTZZjAUxrVWlvlimJ6pJWkmju3T+X8/yTVneQ1tErdID
	 HwA6Y9UeZVkisPqx5cHL3gc2jx1mbY3NuALaLkjYsL+G+axyOEG5QE/4KpmY84xMoPOrK
	 QTn1Ezd255Ttom+j/KyGv1tzQqllT4+3bClTXthnXfPly+AfON0EUAtNVLIp3U8LRRfUC
	 5UmREaKeo7CQ/1/TCr8N9RJnIL/KIi5sv2HN0d2W+PKG7+Xrhv4pa9itls0GRtwrylw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031531;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4Q1FR5kjqSrZIhQPPkEw3ZEF4P5QlQdetAcLQVPukco=;
	b=cCFz3jnOTfjxl/LSpgFBzLGXF8/y1ghNaiQpsPH0c6G1L5mIBM0kGWjIFlHgafhEMbPc
	 HSCy4V8AoGaSEE2Qw9LfcpJ0CvrAl+hcBvDpd3CRA+tg11OLCRo7BeRcntVPRxLZzFpAB
	 HePmWASB1vpz+eIbdO+AFRRMBZUEGv8HufsBS4hQJqPIvYia6v2lawyUyIt4kiZzCBMMK
	 d6klmJHMJNR2/NNEThTRwBRuZ/BnJ+4jcvq6z4q3Ant7DCn3E18yki3Fu6PckXmRh5S54
	 dyfwLmJLxL+Yr4JjosNl0mvq8inhUBam5hycVkeCC7B1VZ0XJ5UlCKfJDIi1vrIOrjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ahIO7jwI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46ED6606A32F;
	Wed, 18 Nov 2026 19:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ahIO7jwI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7211F000C4;
	Wed, 18 Nov 2026 19:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031531;
	bh=4Q1FR5kjqSrZIhQPPkEw3ZEF4P5QlQdetAcLQVPukco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ahIO7jwI+xJDU8dJ1/9oz9Oquf2umVfRw9nMFc8fHup0sJXTiTH6XC7EXW48ERKpn
	 tJq7tIh39q/526NuGbzGyGkfZbL0UzNjnq3DEuxPbwGJZ0Pt/HKgcKVflZ8xj+dpfc
	 Le8RkBINJ1LM/8IZ9yZEQQuq7sOTaD+vRbiSGESU=
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
Subject: [PATCH 6.12 1090/1756] mm/hmm/test: reject overflowing page counts
Date: Wed, 18 Nov 2026 15:53:37 +0100
Message-ID: <20261118150053.572623607@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 62d4872232951..dfb33b0660cff 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1323,6 +1323,8 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
 
 	if (cmd.addr & ~PAGE_MASK)
 		return -EINVAL;
+	if (cmd.npages > ULONG_MAX >> PAGE_SHIFT)
+		return -EINVAL;
 	if (cmd.addr >= (cmd.addr + (cmd.npages << PAGE_SHIFT)))
 		return -EINVAL;
 
-- 
2.53.0



