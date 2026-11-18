Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057209;
	b=fetDxRIa1IEa22A39k7UJ4H+EwbkaC4y1ZURadPlejrvqDOIMuUCrsQ7C1BXXJKIqNY/
	 bqJ6oh62EXPHRAaz8lpWc9BnbtnmpyJXkWnc6Odk8JH1iEabfTGZ2dzXtbxlkiZlLYiqv
	 PEDf+DTCKNqBkT2SW0SPD/+nINr4/KBExEhEKCGR0J0JCRwIy5hKsG+9vFUZbGaGkY6aO
	 M9b1llU5JoaD6u/aYdeUqXG1ltg/sO3WyNgPGZ8RZV+gD8NKnrECKLA+m/4xS+0nzQaO1
	 G/ocBmucEJRbnDj8cFK498H1eYZdo9UYDWObfaLxDx7H1U5/PN4K9NrraIC26h2oGDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057209;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TtfwzXcW461vMgGTBX1I9BlySDcULqggi4062xXlod4=;
	b=g88bB+akoxnnU2WPfN7Uvj3euURsyaxEv+PF2MRSav3Hw4oIvAC1uCcrja3D8uVcR/ww
	 75pvspfTJL4biIEPj6ga0mK+9b9bYQBxHibMnJpvH+5Mk7JlVq7IAfbTu4ayMRroFjxaV
	 iQvK7UYVAgiZL6iH0M+g7x4YManTlZj5R8+INlC7EmnMo53vav60CSgvNCe1p+wt9iHY8
	 a5j6EB56C63qrveCGhPNSVhoxXOzsIpp/e+x7yceonmyr/aKs59HaMdEeWbST4DnoWdmK
	 82r1kfAvMhu21T62gk+FQ9bzbzqUiP0GB/VmBE6LllszCQPXT6AbpdDQ87CRztxX8Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L38juMhT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A101606A339;
	Thu, 19 Nov 2026 03:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L38juMhT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A25C1F000C9;
	Thu, 19 Nov 2026 03:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057208;
	bh=TtfwzXcW461vMgGTBX1I9BlySDcULqggi4062xXlod4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L38juMhTPpBtpfNxB5y44bPLn9dcIWzMej1dunLl+1K8CYcENjkxEpAkPvmuzSETE
	 vEvQFzJdTmwhtkWP5sTG9L2HwO8Jh8Y4qmzkXB8pzNCg+VKVcymBhoYT5UqikIf+tR
	 1nz2QiGdbPHNS9QiQHNsYSFrkGOCF/wfxJMvyYV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0047/1848] dmaengine: pl330: remove debugfs file on teardown
Date: Wed, 18 Nov 2026 15:34:45 +0100
Message-ID: <20261118145913.067412427@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 627aa9e9bc12a..f7731e9abe9b6 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -502,6 +502,7 @@ struct pl330_dmac {
 	struct dma_pl330_chan *peripherals; /* keep at end */
 	int quirks;
 
+	struct dentry		*dbgfs;
 	struct reset_control	*rstc;
 	struct reset_control	*rstc_ocp;
 };
@@ -2963,14 +2964,24 @@ DEFINE_SHOW_ATTRIBUTE(pl330_debugfs);
 
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
@@ -3219,6 +3230,8 @@ static void pl330_remove(struct amba_device *adev)
 	struct dma_pl330_chan *pch, *_p;
 	int i, irq;
 
+	deinit_pl330_debugfs(pl330);
+
 	pm_runtime_get_noresume(pl330->ddma.dev);
 
 	if (adev->dev.of_node)
-- 
2.53.0



