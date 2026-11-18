Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050989;
	b=2GVhxOve9rud1Jr9e/QCMAML9IQ7lwTldLkf+QVUq94ztnb5Dq+EOGPoDR4EcFxrGyFw
	 3AWLAgpgSLsdl+CrxySaDDo2h4vCyWnyn2RRZ5nNpw6hAgTe1lWLcdPrS8N0ZzsN64Qqf
	 1vzlTO9ai+qPe4GZY1LYSDhU0zX4znB3AX1b4q5OMgE5cZWhjF0pHUVTkYXo1zv64Mofu
	 nGiq45xyXO/l6VPAsx9Ocak9o6PQ8iSf37nshHp/wq8+d/kpH/ee3TcjgC60igMaI3BoK
	 w/0HhNkEnyLhP96NBQy2qIkOCEm3UwCXrRHI5a9dtBeZ8ns1DYbhIDQEVCZ6JCVAMcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ISBsm9i424w70pzVLsiGbvxN7J8Z25YGLsAuJ8z0+5U=;
	b=LotmhkS27scFwKY5NO0HOgrdmwLxSMgW3tVb5QdbDlS0lB+vsKR7b+TA/83PeWQiD7SR
	 v6tEeej7+FWs7Kz0oUKzBvyxcPQAcTsDtTN5Q5FcoY6n4llGzN898tXJ3r0/ocxEPTC3r
	 993mMii/eL/INGwJZqF+ZaRC08FcNbwwO4lq8M9Qo4KB5ZScmneqCKCvP2Ace+o9VNIho
	 IyVZpYcjYCRhkwVBG61e3/r98vm+WGQMdIVDU7dffA+4UR18zN9MPIkGQ7056CT/USTdK
	 eh7EwxsSFm3FsBsLAkaMnRv/rkHer5XmDogcuGLhLx7W0rAACQpS2e/j2iIAlLZMOSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q1NZUwrp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59868606A32C;
	Thu, 19 Nov 2026 01:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q1NZUwrp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B231F000C4;
	Thu, 19 Nov 2026 01:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050989;
	bh=ISBsm9i424w70pzVLsiGbvxN7J8Z25YGLsAuJ8z0+5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q1NZUwrpIt31W7gLzcfnqyAOsQxY8IKFb6H4XWJufiOuIEcvYAQXTi8BVbxEzNJRI
	 JHuJTHzy98p1tD5ZcE53TlvIxhMhqSXAgYLaxh4hOhkMbpizLZxwt8/5VHJHwiCWoL
	 xqg9FfsIheKOkWcve2oyncIAqiJl/XrcLZsJzlbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0050/2214] dmaengine: pl330: remove debugfs file on teardown
Date: Wed, 18 Nov 2026 15:28:46 +0100
Message-ID: <20261118150012.042017568@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 0d3e3376b289cdaff5b3b6c1581999926ff1000f ]

init_pl330_debugfs() creates a debugfs file with struct pl330_dmac as
private data. pl330_remove() then unregisters the DMA device and frees
the PL330 channel/thread state without removing that file.

Keep the debugfs dentry and remove it before tearing down the DMAC state
used by the debugfs show callback.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260615091645.28878-1-pengpeng@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/pl330.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index ec8a1565630b6..5ccf66842dc13 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -502,6 +502,7 @@ struct pl330_dmac {
 	struct dma_pl330_chan *peripherals; /* keep at end */
 	int quirks;
 
+	struct dentry		*dbgfs;
 	struct reset_control	*rstc;
 	struct reset_control	*rstc_ocp;
 };
@@ -2961,14 +2962,24 @@ DEFINE_SHOW_ATTRIBUTE(pl330_debugfs);
 
 static inline void init_pl330_debugfs(struct pl330_dmac *pl330)
 {
-	debugfs_create_file(dev_name(pl330->ddma.dev),
-			    S_IFREG | 0444, NULL, pl330,
-			    &pl330_debugfs_fops);
+	pl330->dbgfs = debugfs_create_file(dev_name(pl330->ddma.dev),
+					   S_IFREG | 0444, NULL, pl330,
+					   &pl330_debugfs_fops);
+}
+
+static inline void deinit_pl330_debugfs(struct pl330_dmac *pl330)
+{
+	debugfs_remove(pl330->dbgfs);
+	pl330->dbgfs = NULL;
 }
 #else
 static inline void init_pl330_debugfs(struct pl330_dmac *pl330)
 {
 }
+
+static inline void deinit_pl330_debugfs(struct pl330_dmac *pl330)
+{
+}
 #endif
 
 /*
@@ -3217,6 +3228,8 @@ static void pl330_remove(struct amba_device *adev)
 	struct dma_pl330_chan *pch, *_p;
 	int i, irq;
 
+	deinit_pl330_debugfs(pl330);
+
 	pm_runtime_get_noresume(pl330->ddma.dev);
 
 	if (adev->dev.of_node)
-- 
2.53.0



