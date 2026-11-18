Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049535;
	b=ToOxvoZULeMIlP4kGD43qLDwzkGend2aNolI63Gm9gSZv0pNqSf0p3x+MALvZiEiOze2
	 xzRRuVF+d6axHH5/oF72P3VpLHzqYbje/d94bQgvWjHR8oeWEHmql628AJZXOhvK0vA/v
	 TVSIhtjwkQU0QnvcuCJECIO5Gj6RnLXrbpXIVtqPBFFDiUK5UJb5f95L5e1/jeiTf6LqL
	 XT8Wbr1TutZI6/FHDkhj0Eg6GR7q4+11PKeh5ve6xCn+Meh5j5BewSs74QndR7pHdWH3N
	 0Qvbqt6s8RQKXdkerNNbkDrTxVskqY9Igh8q2XvKbOw+WpEO2glZ92HODY5aVMjDB4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZG0rojApCUeo2aAlCqLPy7pPNeqwTkcgxmMXBybDL6s=;
	b=ut4bCBfoQmueabKObfOEfdVj+ynARjTWgawYg8P+C/F400D7cQAREs/iqpmaqru34X9z
	 B6hCQW/Fq/FVPFyzx/CyTlC7z+SmpumuyUFHx/1Q7NWhFeEy6U2VuwEebILSohYlsu8pD
	 AMXfnXJ9BLNZplfdBtX6yWRkqooKf0AxPlK9cuZ+XiUBvNyhKS1U5wf49Bj6xOYQ/9gVf
	 2CSvBICMK2LcExwjPiL6PuOM/vx3wO8H1m6ekOD/XV3wpbZOCisYSu1QByXd2H+XsXV2U
	 pVfcBWbIg+z6cYtvny70SOFSu/5Bt5NGKfkZUj3p3ehZokBuAP/lv3UeF7kbmTsbENg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q49mbxq4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A6C606A32A;
	Thu, 19 Nov 2026 00:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q49mbxq4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35BBF1F000C4;
	Thu, 19 Nov 2026 00:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049535;
	bh=ZG0rojApCUeo2aAlCqLPy7pPNeqwTkcgxmMXBybDL6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q49mbxq4J6U/hgJWByBtPV43s7CcnoV474MuejkV4vAdb4DrInIn59T0y6lyKfFKx
	 phnw6mdFhbUtelK2xwxa3TgGk6gy1/RlrzMpyXczLekjzpa9y3XV2ARCI86xANtHl/
	 ANiK2YR7iJqmtna0yYIFvDtwsRQgPFxzKW8cUaGU=
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
Subject: [PATCH 6.1 2386/2857] mm/hmm/test: reject overflowing page counts
Date: Wed, 18 Nov 2026 15:57:00 +0100
Message-ID: <20261118150327.436403428@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b0010b15aec5c..b96b07b23bfa8 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1332,6 +1332,8 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
 
 	if (cmd.addr & ~PAGE_MASK)
 		return -EINVAL;
+	if (cmd.npages > ULONG_MAX >> PAGE_SHIFT)
+		return -EINVAL;
 	if (cmd.addr >= (cmd.addr + (cmd.npages << PAGE_SHIFT)))
 		return -EINVAL;
 
-- 
2.53.0



