Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056121;
	b=WgPKi+/nzdz5hIA2Wo/HN5H0yh7jZ1VpgCuEKhdFFZK8r7WKqTpuWPuaXvAXMP7sauw4
	 gv4SlZgj7R9z+nVA7MJhoAyfn0cekjBFZIGjwf/PbCQmOpR/lmOadJ5dIBgYOQB+2c7uU
	 ra8taStIcRzC5edH7Mt1XZgOcwUC4Xdi8C651UMNejgEEy6hEhiZRPx0Q9s5z3GEfBybu
	 dqRl3g2lm7iDGqALPAJiZM4PrSvLhPBgJrhWzY4YbjgoS4BdK08fM0XnUW9wGDM5Fxxwo
	 xqDP+XsnHZMt85otcha8Stn+uGNAH44Q2O64/659HsXM7ZBp93m+XGdhBCV4bvpfc/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fWVL8R8Ijy45dmUO2mR89vByQRxh8iY1cm0NUl5uGBo=;
	b=GUvP43FTIlSVZlQNVBey9B5Bikv+nawlBF8DOPcbBNTePPUHyXRDnMPqbSxOk0WgB/XN
	 BwRUfCcDu8hTaCJHwHtUd00RrtzcUUj3Xi4v9orNzCQHx+afEaj1msaVg1EiUoXFeuAjQ
	 mgeQtYx5o8X7eDJfDsC8IJlJ453SuufdqaaNS9PDxZnJdQ2ZB3bacA4dEKIhX5ZIbsY6i
	 GFNNoahg4VZq7yo137PK0taRQ0lxqpNu4cqeggpYCm4uuMjTQ6rq1b5EYytkG3AAhhMv5
	 OAhDCSBtCqc/5B9BgG3R0K6BRlOGJJiytlqoJoVQC6/rGFRyDM99CtZxP/BePDTVyXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XaY2JOLS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA795606A325;
	Thu, 19 Nov 2026 02:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XaY2JOLS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D591F000C4;
	Thu, 19 Nov 2026 02:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056121;
	bh=fWVL8R8Ijy45dmUO2mR89vByQRxh8iY1cm0NUl5uGBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XaY2JOLSoR0MC+EnW7xR/iamDkinrENTd35HHcUc9lk6gQAVgxSn8rYTR2bH81c1L
	 T88SRA4EmVxOO6YyGBoB246mPBbYUjoYzYi6iOgJLcGVAyFbTGsrPMx5pkc98j4olq
	 HG82Sugj6MPDUhuLZXm2wpczBWSdqxzc4zx6JQ8s=
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
Subject: [PATCH 5.15 1858/2214] mm/hmm/test: reject overflowing page counts
Date: Wed, 18 Nov 2026 15:58:54 +0100
Message-ID: <20261118150125.678522232@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b5f798ec90abc..02a9f43c04ab4 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1049,6 +1049,8 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
 
 	if (cmd.addr & ~PAGE_MASK)
 		return -EINVAL;
+	if (cmd.npages > ULONG_MAX >> PAGE_SHIFT)
+		return -EINVAL;
 	if (cmd.addr >= (cmd.addr + (cmd.npages << PAGE_SHIFT)))
 		return -EINVAL;
 
-- 
2.53.0



