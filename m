Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AA017FAC2;
	Thu,  3 Jul 2025 15:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555990; cv=none; b=S7CCvpzVgDq6EFFX5mRlz+nUDHozG+fl9g070ELdSfb0O5O2reCBI92AdEe/54h+WhK7mZQ3z2k2VIwpL1Vk95I9WaexCZSc9CYhi4w7lMHmnInq4nIYWIzc2IG1OWqcltBatPSR7JFPTynxrQYUeAuK/LVHgxosJkOrP4edgS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555990; c=relaxed/simple;
	bh=j7nT4QLn9zCoBsnvYDJuj+EJPa+eNn0UA3ViAYDEOso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ruzwp1Jt29GjKgGk6ivtCjWDtab0bgjebaA7Os6g6Ee1TLQfUDMJLVhNfUFLaQeC8aQqZHOsujcLp6s3ia3ku9O0BbgqoT+RhvvNdOMCSFQSREc4/66erZKBH+drY9gouBE+lyvQqJDB9m+t4YhXfRuLMOwe6Ab2w9oPwgAPhFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UraIrLxv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UraIrLxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1246C4CEE3;
	Thu,  3 Jul 2025 15:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555990;
	bh=j7nT4QLn9zCoBsnvYDJuj+EJPa+eNn0UA3ViAYDEOso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UraIrLxvq/Z2CJRsg5Au/qcLPnoDMa9dwFDlJ1mS2JeYjN61O/AAjCPFSkQTeE9C7
	 TyTIkTWT5z7hwl0GAKVOnIF6lfAtQvR9rQtJ0Ad9tcDslMY/EjXkxWZDzZf3urjsNK
	 8cuFJK2Y1TZTAp87UgABfMimFivP1MTXH85joPMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <wangborong@cdjrlc.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/132] media: imx-jpeg: Remove unnecessary memset() after dma_alloc_coherent()
Date: Thu,  3 Jul 2025 16:42:10 +0200
Message-ID: <20250703143941.040841239@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <wangborong@cdjrlc.com>

[ Upstream commit 2bcc3b48c8ddf2d83cf00a00c0d021970c271fff ]

The `dma_alloc_coherent()' already zeroes out memory for us, so we don't
need the redundant memset().

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: 46e9c092f850 ("media: imx-jpeg: Move mxc_jpeg_free_slot_data() ahead")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
index 7d6dd7a4833ce..c3655ab4511b4 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -519,7 +519,6 @@ static bool mxc_jpeg_alloc_slot_data(struct mxc_jpeg_dev *jpeg,
 				     GFP_ATOMIC);
 	if (!cfg_stm)
 		goto err;
-	memset(cfg_stm, 0, MXC_JPEG_MAX_CFG_STREAM);
 	jpeg->slot_data[slot].cfg_stream_vaddr = cfg_stm;
 
 skip_alloc:
-- 
2.39.5



