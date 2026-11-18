Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033569;
	b=yvWvoXQZgfhPHxXdBNlqwnZrrxZn82DZ99xtPKJUiKeWxxHqBRpay9a2mXzLkGIIqvQW
	 t6F1xV1BdOBzDhmzKPrlfVEAoWDRFaMUtq65Kx0q3rv4Qci6Cik6tUxMozekm69ksBiyu
	 o7KFdr6RlpHPJxCgeruTcRKepZZMrYyhe/fGvEvLS61enbsJ2djEFGo3rO1GLSUCUUOwn
	 oWJYP3GQE5QHeSoiKJPPXYciZeYrcc8iami33bYTIzT1ggRwtKUmiDkbZcUSzXcnSBlen
	 55K6dkOII2CyEIDcaZoknVH0esjXSD84xbjTPdFRua5kTx39R42vMYM4Fmp7HBudUag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033569;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5RlgFpbB9prjd5bxO5lLke5vpCPGrxWpg/UfCEDxEgc=;
	b=tHJCQgBTgzqFLW437t86oQfRT548TjOINp78P1QoDWvS6sQ+NKSsZrEiZhyyHtCUz6+4
	 Ed1P6U90PIpyQAKzH2Kfa3RoSimT8UrUHf9J0LhY2EQc/5jjhYJw54S3RQgoruwwTzb9u
	 V7i6C70kqPgZod4LlilH/vH71DJpdvP3OdIdsAkrg0hn6OG3/PLvK+sOXB7YdFqr/jdu/
	 6/lETkR7F+VpJHDG66WScpwp9kuNnR7yQ7U5/SIGDwDGouo03sonwjZ0Y6Ow8cW8SP6q0
	 LqUWhA99FQvPEUFqkzTKLpGfWjFfUdOel0i2UBRDHqwmKYC+3cAaa8RC0t16uwsltbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="l/syO0vH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B624F60A2604;
	Wed, 18 Nov 2026 20:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l/syO0vH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134451F000CA;
	Wed, 18 Nov 2026 20:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033569;
	bh=5RlgFpbB9prjd5bxO5lLke5vpCPGrxWpg/UfCEDxEgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l/syO0vHFgNzUJ0O/2mAkKtWlgBbOKFjiKSvYw2jvueG9uQiO0PCyv4dGjYhZaFk6
	 XkbylzDzsk5eK+jWz/BVacBUdy4BZxqzToCgGKfPjRWS1qGUHZNquE6Wlh9yO2Aa39
	 S5OMBmyaYmAN9eVl322Oz3+JjNK/8DEZrNvL3sPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0060/3318] dmaengine: pl330: remove debugfs file on teardown
Date: Wed, 18 Nov 2026 15:11:22 +0100
Message-ID: <20261118150315.771837959@linuxfoundation.org>
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
index 3cf0b38387ae5..a33fb061fbd06 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -502,6 +502,7 @@ struct pl330_dmac {
 	struct dma_pl330_chan *peripherals; /* keep at end */
 	int quirks;
 
+	struct dentry		*dbgfs;
 	struct reset_control	*rstc;
 	struct reset_control	*rstc_ocp;
 };
@@ -2957,14 +2958,24 @@ DEFINE_SHOW_ATTRIBUTE(pl330_debugfs);
 
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
@@ -3213,6 +3224,8 @@ static void pl330_remove(struct amba_device *adev)
 	struct dma_pl330_chan *pch, *_p;
 	int i, irq;
 
+	deinit_pl330_debugfs(pl330);
+
 	pm_runtime_get_noresume(pl330->ddma.dev);
 
 	if (adev->dev.of_node)
-- 
2.53.0



