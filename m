Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829374;
	b=uc0CwwtHaNU8bI7zqbVjVQeEyrOM4vhwY/zoJBzDB7NDhqgNRl6nJGXxApridWGFuMv7
	 kanjElQDZUQWVTqfDbFLCYKWIIRNlwe80epdt8KbgzL++x6GaA9n40oE3SkoYxc7/TBH6
	 ERoqUrHhO7L7tfNyFfKh2t3vbc9H4xCgNDjVzArQ+diXOufZypPpj1MF7PAdYtRQ/OvoY
	 gSvvvYQtbgPRtSjq0660shokq/BwPscY8OZpi+7JS3Iygvf8yGldxpoSPc5Ofc4SVL/Yy
	 L27ErNl2mDo5fvo0ZzpJdCjrdjJ+c7E73sBIRHSfPFpk7f0ZBwMmJiWhK8fzdAYlRxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829374;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bsnF+QwV8J0x/ME7BE6CWXhfASOCIU85nzR/+NiTy/Y=;
	b=wfsXUcsXxpuwD9Fx6M3Gt+n5JTy2ak7wOEuiw/NyAPBYgxNw9lzWx/z7vKPx/lP4cLet
	 w3CtGpuWIA/Y2pxuLIZlIxvXkhTkVlvPIRo/vqgfewxeX7qxTdwvc2/ewPS3dtabOqujL
	 oXIyIMwvhcnavM5YcdwMhIWy37tvydxSLtrxIaP/Zfa7NCP/AO3/6PvAQa51gK9KVhkGk
	 e4eMstJc5KLQjArXoY4VSG8HlY3NbrSiqhSQTq5qW7aGdp4psQ7q47KFkyl3THNPlwRz2
	 J42DpXLMBYQg4EnmZDfLfQVK/I/9gst33fc5oyWsbwvWdAFUU8l0NHPlWQQgPMshMQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qLXj30vC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E2F606A84B;
	Wed,  4 Nov 2026 21:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qLXj30vC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7F11F00919;
	Wed,  4 Nov 2026 21:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829374;
	bh=bsnF+QwV8J0x/ME7BE6CWXhfASOCIU85nzR/+NiTy/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qLXj30vC39YiJBVVu6neRFznrhfJQq0L7voV7bIAVDVuvssgc9tDJSm2XrlEZ9XVk
	 4U9gGlpg5n7oVAca2y7OC/EAozddHd/oU//qm/DCAiQwRdmfUawYBkAU4lJ9JahJ6u
	 H/zcYhfZAGNtXS36Ze4vgG9Fwn87lehs+GM/ZmmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0085/1005] dmaengine: pl330: remove debugfs file on teardown
Date: Wed,  4 Nov 2026 15:56:58 -0500
Message-ID: <20261104211046.009025443@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 82a9fe88ad54c..fe4d266ee611c 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -502,6 +502,7 @@ struct pl330_dmac {
 	struct dma_pl330_chan *peripherals; /* keep at end */
 	int quirks;
 
+	struct dentry		*dbgfs;
 	struct reset_control	*rstc;
 	struct reset_control	*rstc_ocp;
 };
@@ -2958,14 +2959,24 @@ DEFINE_SHOW_ATTRIBUTE(pl330_debugfs);
 
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
@@ -3211,6 +3222,8 @@ static void pl330_remove(struct amba_device *adev)
 	struct dma_pl330_chan *pch, *_p;
 	int i, irq;
 
+	deinit_pl330_debugfs(pl330);
+
 	pm_runtime_get_noresume(pl330->ddma.dev);
 
 	if (adev->dev.of_node)
-- 
2.53.0



