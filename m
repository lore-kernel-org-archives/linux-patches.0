Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017789;
	b=0QpqUV325xCQG/UpZdx8rUYsP2V3BMW/TWQ13rZdqRpMIXp65jg+qrkCLbhYhZg4Pofp
	 mWqgmpVUN4mPhpJWmNrxXey82c+Op163yoqCrLN4NTjxtz1SFF3mmRpWu511V2MfBNrAC
	 VMH1i4iV/I/B6SZcgY71yA5+YSI87SAVIR2k/Ei+/XXBUiTC/sNVNG+Vu00U5v9L2WP6m
	 XgHyuF081Z4cOhBEI3HKecmLI9Lct9KBv8FQSnnoClN85etBrPvxMMKxPSI7OFnLPTw8T
	 ZbT7HvgBKmgR0AontyhYsRHIWwHVcLJyaCY4sBDpLyShfRVx9si26cpLYR/exeLuEDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L3JeChRR3u99/CXx99Vb02/+4hQmxKb3roOlG29z6rA=;
	b=wXgo7g87QCFS6Ba6UeJ8uHyLyGvyM4TmkbIrHaOg1WbtvEyzh03UO14/VYy/mSy+N9LR
	 cnO3+dIL7sgTUh1+Zz/L/FS27IgBLoONi0jkksypkzQxgd/qiHd7HL4wbM7rMPKKBKPHk
	 iJFxXv69TKbh2KtDihKDzBVeQcw11hdA1MypR9vU2wWrpa2pzS/g60uaz0k7Jj7lUtPiS
	 13blJFYiZOELe7kJFkSYFNRk6sigZ0cQe+vDn2fGgPr9Bcz4DNDX1XYXgeN5GrEo+xlhH
	 agViFzy65X4xH21q6Ey+EvL0OqpIPdvmbmCnWJAwco1hQVt4/7M7lV5XfPPSY2NHPcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zKSG1IWW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0159A606A31C;
	Wed, 18 Nov 2026 16:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zKSG1IWW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2431C1F000C4;
	Wed, 18 Nov 2026 16:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017788;
	bh=L3JeChRR3u99/CXx99Vb02/+4hQmxKb3roOlG29z6rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zKSG1IWWJOS61OeQIwOuI+HJC9pCKBzRYKcbQ68tiVzth2sqIYgi8VBefkFHFvNIX
	 HdqWEwH91tZkaStePH+QB8ClF7VlEtQbY/0ADUJaeI6cDHOWAHLuXMGQmAzQL1Ux9a
	 q3bTKMjAcX3b6EZHBh1Qw5grragZhibK2LhlXERY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1010/2651] RDMA/bnxt_re: Detect wrong sge_len passed for inline
Date: Wed, 18 Nov 2026 15:37:30 +0100
Message-ID: <20261118150324.278556470@linuxfoundation.org>
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

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 81551ece0864c346080d241719d458c93f0e7fc9 ]

Avoid handling wrong sge_len by adding extra check
to see if the passed length is more than the inline
size supported.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 9775a22b8d0d0..c293c30da13e2 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -3169,8 +3169,9 @@ static int bnxt_re_copy_inline_data(struct bnxt_re_dev *rdev,
 				wr->sg_list[i].addr;
 		sge_len = wr->sg_list[i].length;
 
-		if ((sge_len + wqe->inline_len) >
-		    BNXT_QPLIB_SWQE_MAX_INLINE_LENGTH) {
+		if (sge_len > BNXT_QPLIB_SWQE_MAX_INLINE_LENGTH ||
+		    ((sge_len + wqe->inline_len) >
+		    BNXT_QPLIB_SWQE_MAX_INLINE_LENGTH)) {
 			ibdev_err(&rdev->ibdev,
 				  "Inline data size requested > supported value");
 			return -EINVAL;
-- 
2.53.0



