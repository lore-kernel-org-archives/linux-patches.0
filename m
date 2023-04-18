Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5EA2572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:42:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4E5C433D2;
	Tue, 18 Apr 2023 12:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821770;
	bh=pFT8mW1rANlh4xPbqokWJfD5HFIWqXyYVX2wTOFvyJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4N/hQV34mS0VvjN7mQU0L7mPM1l2LYCjxIVg220Znt2R7agrtyy3payRnc3/X0Ow
	 iUM6MhV/7AMnX2PVzoPORUpuSc4InmdlulzKrCiOAVGQJZWCro2EIbz53EHwqBbShJ
	 XEaxA8S3z6ckmiZBLCYagoI3gRRtvDv3yQ0z4VQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/134] RDMA/erdma: Update default EQ depth to 4096 and max_send_wr to 8192
Date: Tue, 18 Apr 2023 14:21:30 +0200
Message-Id: <20230418120314.155944979@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cheng Xu <chengyou@linux.alibaba.com>

[ Upstream commit 6256aa9ae955d10ec73a434533ca62034eff1b76 ]

Max EQ depth of hardware is 32K, the current default EQ depth is too small
for some applications, so change the default depth to 4096.
Max send WRs the hardware can support is 8K, but the driver limits the
value to 4K. Remove this limitation.

Fixes: be3cff0f242d ("RDMA/erdma: Add the hardware related definitions")
Fixes: db23ae64caac ("RDMA/erdma: Add verbs header file")
Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
Link: https://lore.kernel.org/r/20230320084652.16807-3-chengyou@linux.alibaba.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_hw.h    | 2 +-
 drivers/infiniband/hw/erdma/erdma_verbs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_hw.h b/drivers/infiniband/hw/erdma/erdma_hw.h
index e788887732e1f..c533c693e5e38 100644
--- a/drivers/infiniband/hw/erdma/erdma_hw.h
+++ b/drivers/infiniband/hw/erdma/erdma_hw.h
@@ -420,7 +420,7 @@ struct erdma_reg_mr_sqe {
 };
 
 /* EQ related. */
-#define ERDMA_DEFAULT_EQ_DEPTH 256
+#define ERDMA_DEFAULT_EQ_DEPTH 4096
 
 /* ceqe */
 #define ERDMA_CEQE_HDR_DB_MASK BIT_ULL(63)
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.h b/drivers/infiniband/hw/erdma/erdma_verbs.h
index ab6380635e9e6..eabab8bba95af 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.h
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.h
@@ -11,7 +11,7 @@
 
 /* RDMA Capability. */
 #define ERDMA_MAX_PD (128 * 1024)
-#define ERDMA_MAX_SEND_WR 4096
+#define ERDMA_MAX_SEND_WR 8192
 #define ERDMA_MAX_ORD 128
 #define ERDMA_MAX_IRD 128
 #define ERDMA_MAX_SGE_RD 1
-- 
2.39.2



