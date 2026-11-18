Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030384;
	b=UzX2rp53xHzx4NFlfX4sXiBh/2xlESG/ZEs0ho0Lqqus6oxLJhiBjgU06RZMVbs7/E4N
	 VQ6eFNAnTC+/fvqfETMCOcNfGmqrfPtjO+bpMevi0aN83kgLOIJU8DYAt4zUwNUdsa9Kz
	 rnF9Q9iMr+VIki3HYTupuJa6KlvOvAFcBAq+WJb1P2wQc69dZx4PmbAa8hsESp+2gqKFY
	 q4w7ovpBjph03AZxTXlux0uOc8qDXeOP1itvQvgSwVGRQzdOBwzeDB3EMYIH/6sxN9l26
	 4KP9+mD0vgG16LHvQE2cT1fBZqCJcAnrhU7Xwr3TWjCfu0QUftvHJsSXDCZaSzw2a5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030384;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kbCBFMzaRjhJhszQaS+SEFBaLaSB+x2sudg9873X8Nk=;
	b=4RGodOzgSqn8wuaMdIXmMT7wE6UAU/ynJFtH/SuR3hDVwkmGEjlRB6jwdq/FXVHmTohi
	 NEDBJCQac2SFbVOhQz4yD3wkhCtTMXg9tm4/QdeNrB/pCesl7LeXDIgQCCXCG+Oo1WJyd
	 pJNdcwtJ8NtcrQL2JutXWSwueYvYUosPQcc/rAYgydAi1Yb4JEqFfjheJ3xmoRQPmwrA5
	 e9/bCYHwTYtfH4bIlcUEIRwZf8JLMDDW7dTHMYPHWJUi382OnUz3Kv1I5QPMP91SCDQAT
	 lm/+jhXReL8MH2OLU/nw0b/OR2LZ1C+FVsDziqtPMuqxkSRpFKfAxYpug56dnl0ptzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ITDBLhaW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EA8606A7EB;
	Wed, 18 Nov 2026 19:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ITDBLhaW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2EE1F000C4;
	Wed, 18 Nov 2026 19:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030384;
	bh=kbCBFMzaRjhJhszQaS+SEFBaLaSB+x2sudg9873X8Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ITDBLhaWFMwmSeCoYby2kNNCFwneHX2yf24yFE2OabYSj7Z0X+4yRmLzl7+HHienw
	 BmDJXCjk+9gYLzCh9wBbOQFJKW5aua28ummdITEq3RmteOF4DDpUR41yw+PKEuo9Pb
	 /CZkrvscoCj8kGw2XxUUE5ubFJuflGdO4xexoxe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0684/1756] RDMA/bnxt_re: Detect wrong sge_len passed for inline
Date: Wed, 18 Nov 2026 15:46:51 +0100
Message-ID: <20261118150036.469124391@linuxfoundation.org>
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
index 2266eab78c22b..c180936e908b3 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2672,8 +2672,9 @@ static int bnxt_re_copy_inline_data(struct bnxt_re_dev *rdev,
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



