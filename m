Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060627;
	b=fD2VZCmRJgEkQTdfJJFeYWdN0LTnBTpipe5uLf7F5Mal83QP3j1Wa+4YQN6MTqRYKZc8
	 A7GJVLl4i6VqlYOHtAsyz3KsUu/XeGzX3Zv8dCwpAa+a3ivEav8PNwL2y39AJLoCQquci
	 PcFH/k8dotonLuGfne0eai0VvMblHi1NnSMxWrJHcYyeR2zIlqMFilWOUa8SujFXbeaLa
	 CXo7IK1kTMtxDFCI58jDhbZHixcLw26PcsGGzDuRV5XFm45Hg9iLKhT3w3eJnzGI+gx2z
	 qCFiW/UNzCnlD3/tqXoZQ7VsTSHNo/gH3O6XHNzCfUO+BRuO1p7l7g5dpB6MdMIUdFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060627;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CRzyt9K0yuwWhL7dkUuTGJXxt1//KUbqqchUIT+aPBk=;
	b=vzDF0KMEnsYS8QMKvs5RGbpvtqIilQR3vzgqxF90Bd+Yvp7Cz8HG5JRPynevv2Ge3fGu
	 xG7VjWGvqQhNufa7v+IWKCdh8x0wRMEMvEG7T9eyy7xFE1Zsnf7WJUj0PCL7b1x1OxTCx
	 wozO99glQhXtgY120cGfEd1aIsMF5wxFaLgdAxWoPF83xd38D08UXrQzdYx/WFO1DZ4uU
	 EOlYHg1BgqfJ030wKmKrAYqLPPLq/SodFxCqnur1cDnsWFyTb7opMHnysAXdlT8Q1qtpw
	 +07ipCsZbE4KVBLyNSnHyJio14pKBdzmm40RcCotYdTZ03PJAnaGHEsm9z0C8TQDirQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rvgf+WrV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C0E606A32D;
	Sat,  7 Nov 2026 14:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rvgf+WrV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72A01F0089F;
	Sat,  7 Nov 2026 14:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060627;
	bh=CRzyt9K0yuwWhL7dkUuTGJXxt1//KUbqqchUIT+aPBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rvgf+WrVMJCWe/0pI86JU6s4HYk8X5tjRpNoFNDKdf4SMeMexV7rQX16SrhgX3+EY
	 jFvBazVFQurYSrSbagcaJfExA1tBW+oS6PLzv8C2w1RxMI2X6m5l5hyO76qYFdVx40
	 bL7bYQZccsLNjJur9xLazXrzZ2qOpmrAy2idbC8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0072/1536] dmaengine: pl330: remove debugfs file on teardown
Date: Sat,  7 Nov 2026 08:34:48 -0500
Message-ID: <20261107134959.694405218@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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



