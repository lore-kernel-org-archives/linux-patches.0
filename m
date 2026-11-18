Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016707;
	b=L40JI+nxhoi1WBGQfP9Oh+yLzm7I+Hakmm6SxioFpY10wGHGLCN1U2FPRVrqLnPszDd1
	 9Dy5Nt6a2xyEMqQoRpjzyx3YgdnPfLFJx+0kEAgGIIeUiuPVgZUZTfncdQSDea6NmX2NH
	 VzhGkyLPXrzN9TXrLvC5jMe5xG6rluMWiFho3tgtquAbQNSBtiKbyXJcKrYF3OfuaybmK
	 SmNrf25f9EqTuAtdAHgsMBVwI4dNGN0LMeBzMOhRYaOTOrb/uHTxaglmSOsgV8pqo4Gwy
	 oW+fMB9iRxSnJ8JRvJ9KKvbBcCCgSw0ePFgWMQo8X8mjaYpwaQ6JOZ6cQbN9IOK64Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EOqBzc2r9EMccmSY5beo+rQBrvMKc4Sk1gTmJlK2sMw=;
	b=hpwXLZcACrfAkOiyrpOKQMNd/HRaEqbrJwu0TbT8BJthvGz8/rDiFGbZ6mVPw6Jq8oiQ
	 aEwvWSm4vpcvLQMwpQVTK6C11FkmvBIokRWqA4nnxmWuKvKpeOoUuChtJ/VgPBR9ThXEl
	 pAg31sduVCW2TyhBqe/rMlcnjjKvIu13d/ZkmLYFzzRVbtKn9XZ4Rrdz33Gz/HFPa+S2g
	 2zAYpTnvMVR+ri/d0Ap9h0UA2sbhbhQvV50ExULQDHmI8ocmqzF7Br5ZZvtXE7mPxEzqE
	 HM+EjaoNkA0W6xew2Vy/A4kh4baUkNQuI3rWRl0hWk+THzJ23Wg+q24CRVT4roVKcYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="F/BYcnnO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5420E606A332;
	Wed, 18 Nov 2026 15:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F/BYcnnO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CED61F000D4;
	Wed, 18 Nov 2026 15:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016707;
	bh=EOqBzc2r9EMccmSY5beo+rQBrvMKc4Sk1gTmJlK2sMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F/BYcnnOic1jzzez8JhuGVBeUCql6GEa6xwtzN3A978vM/U9MnTMDXR4P2j5zy+Zk
	 P4xIbWdAnrk1OjbZcBYuRl7srO+shNNKJ6Nqsqz/JCeGAzRIqApzQjvFXqmVRPEaQg
	 HoUokfHT8hptB6/xDWDqTsszVCmzicoXnfURr3qY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0624/2651] i3c: mipi-i3c-hci: Move DMA suspend/resume callbacks
Date: Wed, 18 Nov 2026 15:31:04 +0100
Message-ID: <20261118150310.158841685@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit ae307311a69ed65c6219915d978ae322950ba906 ]

Relocate hci_dma_suspend() and hci_dma_resume() closer to the DMA IO
operations table in preparation for upcoming changes.

No functional change.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260920151248.46936-11-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 9796ccba1254 ("i3c: mipi-i3c-hci: Stop rings gracefully when suspending")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/dma.c | 46 +++++++++++++--------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
index a798b0648922a..ec4b469abd337 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -273,29 +273,6 @@ static void hci_dma_init_rings(struct i3c_hci *hci)
 		hci_dma_init_rh(hci, &rings->headers[i], i);
 }
 
-static void hci_dma_suspend(struct i3c_hci *hci)
-{
-	struct hci_rings_data *rings = hci->io_data;
-	int n = rings ? rings->total : 0;
-
-	for (int i = 0; i < n; i++) {
-		struct hci_rh_data *rh = &rings->headers[i];
-
-		rh_reg_write(INTR_SIGNAL_ENABLE, 0);
-		rh_reg_write(RING_CONTROL, 0);
-	}
-
-	i3c_hci_sync_irq_inactive(hci);
-}
-
-static void hci_dma_resume(struct i3c_hci *hci)
-{
-	struct hci_rings_data *rings = hci->io_data;
-
-	if (rings)
-		hci_dma_init_rings(hci);
-}
-
 static int hci_dma_init(struct i3c_hci *hci)
 {
 	struct hci_rings_data *rings;
@@ -1075,6 +1052,29 @@ static bool hci_dma_irq_handler(struct i3c_hci *hci)
 	return handled;
 }
 
+static void hci_dma_suspend(struct i3c_hci *hci)
+{
+	struct hci_rings_data *rings = hci->io_data;
+	int n = rings ? rings->total : 0;
+
+	for (int i = 0; i < n; i++) {
+		struct hci_rh_data *rh = &rings->headers[i];
+
+		rh_reg_write(INTR_SIGNAL_ENABLE, 0);
+		rh_reg_write(RING_CONTROL, 0);
+	}
+
+	i3c_hci_sync_irq_inactive(hci);
+}
+
+static void hci_dma_resume(struct i3c_hci *hci)
+{
+	struct hci_rings_data *rings = hci->io_data;
+
+	if (rings)
+		hci_dma_init_rings(hci);
+}
+
 const struct hci_io_ops mipi_i3c_hci_dma = {
 	.init			= hci_dma_init,
 	.cleanup		= hci_dma_cleanup,
-- 
2.53.0



