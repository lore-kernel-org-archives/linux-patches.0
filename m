Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041411;
	b=hkvazs7wPCDuhi0mY0ldQCdq+pYmWmzwlwBqY+UxONHTXp8Cys6Lusauwwbc/vbTOeZY
	 GpCwHmkLEDDU0XxCDVCYfP+S3JM52dJwd+kGCH+3qHDaCB1/QyID3coL0QWPSlcvGigms
	 HdYL83oS9TSnxC7b3TMAhmd9l+sb0Jldacw9ThFt4IihQcVWdOVuHFvYknu1Jpg+eZZ2x
	 I4xCpibINS/Pg1ijBw0ZB7Bj6z9Ec9Y4l8tmJSTvcI39PEcPYGBudMWt7u6SzFfaXglb/
	 rzRhTOPAAI0qwg/1oFC5IUF6vQjT/GPGJVG7Y05H1lLY4IJJpf4tJaZOB023V0zjCqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Om/pxoDQwZUPi9lIipTwPrEqhV7kUWTT+rb/Cem4Rh8=;
	b=lACbzLz9kbro/cmKqvuh+Ht8pVKNHAGj1YriKrNxWh+JJ8FIBEYf5TXep6yL7TtE2YoD
	 cjHc1VxlBba2q1Y5ZQeUVKClk96DmHL068p8WbzeRKeEqvVHjdj+iLXxuRMyJYfKs8Y51
	 RabAvHA2eYDV+kwh4M3phASqPPcVAoKaU3etIcac5qkDEouYnIvNtspa9oxjym91dmV9o
	 TTfRaBMYw5dea4trexA0e7p+LmMeGV6g6Bs75GV9TzIr60oMgr1En41M9qtDFYRNAEeup
	 EFeTnqUYfsGXZud402Uaacar5ah6OEkDEKV735BtrxCaTGPgZXipXPk1gV0/TEnSACw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dEHc5Qos;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75C4606A32C;
	Wed, 18 Nov 2026 22:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dEHc5Qos
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C9E1F000C4;
	Wed, 18 Nov 2026 22:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041410;
	bh=Om/pxoDQwZUPi9lIipTwPrEqhV7kUWTT+rb/Cem4Rh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dEHc5QosF7CLuwpUQMqyiOghCW5Rv+9zEmFvOFqb9Dd9NMysJwiU7ypaLfTrrn/Kt
	 DTUOFeqK4B23er7nsgvFeWpgXI++q5DfY/kAyJWeGYi8vVkLI/TV6o+tsO4D2X3CTp
	 V9iG6x7qbuN50CHPW0XWHmaMWgllVjeRCvfEKFeY=
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
Subject: [PATCH 6.6 2763/3318] mm/hmm/test: reject overflowing page counts
Date: Wed, 18 Nov 2026 15:56:25 +0100
Message-ID: <20261118150443.617646706@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 943cb521429df..2c46231e9e398 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1326,6 +1326,8 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
 
 	if (cmd.addr & ~PAGE_MASK)
 		return -EINVAL;
+	if (cmd.npages > ULONG_MAX >> PAGE_SHIFT)
+		return -EINVAL;
 	if (cmd.addr >= (cmd.addr + (cmd.npages << PAGE_SHIFT)))
 		return -EINVAL;
 
-- 
2.53.0



