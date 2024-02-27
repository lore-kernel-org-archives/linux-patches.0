Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC2113B2B4;
	Tue, 27 Feb 2024 14:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042817; cv=none; b=ACaCq/4fsAxkS/hG7XcIn7BdwR4vKQWn+R5Wiw+DOyy9Wo+LYQMtF4lfo+JuXVY/kzWvIuK1ZqS3/Q1vxym8QiOBvtnsMIRWEfWEuL8ABLp/5Nfs/jEj1JpbdmSm0QZoxvGBCWPzV2dhkG0tgtjxH2Mdwugh5Vaaj+/45ZGZfZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042817; c=relaxed/simple;
	bh=JKa5lZGZ46cUZNt+JlhtoTjpb3Wpy5bI/CxNwfHF95s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gO6Gv/pw/Y3f8x+GOrcSBTqwyjtzt2Y6pNNSkqvHTsTvllKA41cqJa5BVZE29rjkAves+FovQ8EprCFQRzNA41XKVDcibEEXlnSt05iYFWy3mab6Vv+4sPebNnFOj4fws4iwvSRABy1vHH4P9qfZq0mghCDxPPcWFaEWTZOYX6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7sfOWYU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7sfOWYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28681C433C7;
	Tue, 27 Feb 2024 14:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042817;
	bh=JKa5lZGZ46cUZNt+JlhtoTjpb3Wpy5bI/CxNwfHF95s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7sfOWYUncrhil6GY7O6R51G6pEPgrwahKMsGbPdyO7fCCkdxUIhR6NHmeKEAViaT
	 AH6skHCHRKDEfE5crEn48OOz3x7wLoVbEHACes5mDiFQZB4oeZJ66ajUyZtHUu7w6E
	 ZTyxjKW8WLWrekx4bzM+HaTU6ldZeUATgvJSTW2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Bernard Metzler <bmt@zurich.ibm.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 132/245] RDMA/siw: Correct wrong debug message
Date: Tue, 27 Feb 2024 14:25:20 +0100
Message-ID: <20240227131619.504942413@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoqing Jiang <guoqing.jiang@linux.dev>

[ Upstream commit bee024d20451e4ce04ea30099cad09f7f75d288b ]

We need to print num_sle first then pbl->max_buf per the condition.
Also replace mem->pbl with pbl while at it.

Fixes: 303ae1cdfdf7 ("rdma/siw: application interface")
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Link: https://lore.kernel.org/r/20230821133255.31111-3-guoqing.jiang@linux.dev
Acked-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index 9c7fbda9e068a..124242e387a59 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -1492,7 +1492,7 @@ int siw_map_mr_sg(struct ib_mr *base_mr, struct scatterlist *sl, int num_sle,
 
 	if (pbl->max_buf < num_sle) {
 		siw_dbg_mem(mem, "too many SGE's: %d > %d\n",
-			    mem->pbl->max_buf, num_sle);
+			    num_sle, pbl->max_buf);
 		return -ENOMEM;
 	}
 	for_each_sg(sl, slp, num_sle, i) {
-- 
2.43.0



