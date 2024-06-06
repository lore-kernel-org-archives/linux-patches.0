Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D16319923B;
	Thu,  6 Jun 2024 14:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683739; cv=none; b=qirDV8T0gipWDBWGb1A1/3YUQw/nnr8Z9Yjm/eUvvieuM9XxKhS+uhZH2T2R88uB5iTamV0LMFKh5dfrDptbOgSavEU+muwgJxr8IIUcIPlRXPs7Cn7tEqNkDJ+3Bo6uoU4Yek+pTQntsg+CruOhqN7W8StvfRGPYxkPcJsGR3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683739; c=relaxed/simple;
	bh=VvqN5q/Gtyz2hgpqupIBHfUGANzi3Bhebwn8E/EUH6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPOF0YeE9BPmlSanPzzFeLk9S287/HybGvOUggEUxZYTkSZNLqL/2AK4kNmOU6ptqN44vpj5EEuJlZv9Lp1bXdk6LnI7UU72da2EJaD8ZKG2RUO19U0nvNDVDtjsrAwEn+OfJzd8jIKz57ZLei2d61kOKP4fcfns/ezcUnJr9Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QyPeUlut; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QyPeUlut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D71C32781;
	Thu,  6 Jun 2024 14:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683739;
	bh=VvqN5q/Gtyz2hgpqupIBHfUGANzi3Bhebwn8E/EUH6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QyPeUlutMycdyztDdJCWJ5mmQv9xaa8BrtB5S0JgIar05Tlaj/V6006ie+M7bzrZG
	 fP/lNeEqdLvgyhdk1AbgOgg/XabeCnWbJ4SO06Ooi6PK2pR5p/a/jTOSUt/fu4KD9k
	 PhcvOuNf+a1Vcr2K7pI40rqNFTMnPJildLEseZU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 657/744] i3c: master: svc: rename read_len as actual_len
Date: Thu,  6 Jun 2024 16:05:29 +0200
Message-ID: <20240606131753.535678215@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 6fb61734a74eaa307a5b6a0bee770e736d8acf89 ]

I3C transfer (SDR), target can early terminate read transfer.
I3C transfer (HDR), target can end write transfer.
I2C transfer, target can NACK write transfer.

'actual_len' is better name than 'read_len'.

Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20231201222532.2431484-5-Frank.Li@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 7f3d633b460b ("i3c: master: svc: change ENXIO to EAGAIN when IBI occurs during start frame")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index c395e52294140..d8d817858e000 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -134,7 +134,7 @@ struct svc_i3c_cmd {
 	u8 *in;
 	const void *out;
 	unsigned int len;
-	unsigned int read_len;
+	unsigned int actual_len;
 	bool continued;
 };
 
@@ -1024,7 +1024,7 @@ static int svc_i3c_master_write(struct svc_i3c_master *master,
 static int svc_i3c_master_xfer(struct svc_i3c_master *master,
 			       bool rnw, unsigned int xfer_type, u8 addr,
 			       u8 *in, const u8 *out, unsigned int xfer_len,
-			       unsigned int *read_len, bool continued)
+			       unsigned int *actual_len, bool continued)
 {
 	u32 reg;
 	int ret;
@@ -1037,7 +1037,7 @@ static int svc_i3c_master_xfer(struct svc_i3c_master *master,
 	       SVC_I3C_MCTRL_IBIRESP_NACK |
 	       SVC_I3C_MCTRL_DIR(rnw) |
 	       SVC_I3C_MCTRL_ADDR(addr) |
-	       SVC_I3C_MCTRL_RDTERM(*read_len),
+	       SVC_I3C_MCTRL_RDTERM(*actual_len),
 	       master->regs + SVC_I3C_MCTRL);
 
 	ret = readl_poll_timeout(master->regs + SVC_I3C_MSTATUS, reg,
@@ -1075,7 +1075,7 @@ static int svc_i3c_master_xfer(struct svc_i3c_master *master,
 		goto emit_stop;
 
 	if (rnw)
-		*read_len = ret;
+		*actual_len = ret;
 
 	ret = readl_poll_timeout(master->regs + SVC_I3C_MSTATUS, reg,
 				 SVC_I3C_MSTATUS_COMPLETE(reg), 0, 1000);
@@ -1157,7 +1157,7 @@ static void svc_i3c_master_start_xfer_locked(struct svc_i3c_master *master)
 
 		ret = svc_i3c_master_xfer(master, cmd->rnw, xfer->type,
 					  cmd->addr, cmd->in, cmd->out,
-					  cmd->len, &cmd->read_len,
+					  cmd->len, &cmd->actual_len,
 					  cmd->continued);
 		if (ret)
 			break;
@@ -1243,7 +1243,7 @@ static int svc_i3c_master_send_bdcast_ccc_cmd(struct svc_i3c_master *master,
 	cmd->in = NULL;
 	cmd->out = buf;
 	cmd->len = xfer_len;
-	cmd->read_len = 0;
+	cmd->actual_len = 0;
 	cmd->continued = false;
 
 	mutex_lock(&master->lock);
@@ -1263,7 +1263,7 @@ static int svc_i3c_master_send_direct_ccc_cmd(struct svc_i3c_master *master,
 					      struct i3c_ccc_cmd *ccc)
 {
 	unsigned int xfer_len = ccc->dests[0].payload.len;
-	unsigned int read_len = ccc->rnw ? xfer_len : 0;
+	unsigned int actual_len = ccc->rnw ? xfer_len : 0;
 	struct svc_i3c_xfer *xfer;
 	struct svc_i3c_cmd *cmd;
 	int ret;
@@ -1281,7 +1281,7 @@ static int svc_i3c_master_send_direct_ccc_cmd(struct svc_i3c_master *master,
 	cmd->in = NULL;
 	cmd->out = &ccc->id;
 	cmd->len = 1;
-	cmd->read_len = 0;
+	cmd->actual_len = 0;
 	cmd->continued = true;
 
 	/* Directed message */
@@ -1291,7 +1291,7 @@ static int svc_i3c_master_send_direct_ccc_cmd(struct svc_i3c_master *master,
 	cmd->in = ccc->rnw ? ccc->dests[0].payload.data : NULL;
 	cmd->out = ccc->rnw ? NULL : ccc->dests[0].payload.data,
 	cmd->len = xfer_len;
-	cmd->read_len = read_len;
+	cmd->actual_len = actual_len;
 	cmd->continued = false;
 
 	mutex_lock(&master->lock);
@@ -1300,8 +1300,8 @@ static int svc_i3c_master_send_direct_ccc_cmd(struct svc_i3c_master *master,
 		svc_i3c_master_dequeue_xfer(master, xfer);
 	mutex_unlock(&master->lock);
 
-	if (cmd->read_len != xfer_len)
-		ccc->dests[0].payload.len = cmd->read_len;
+	if (cmd->actual_len != xfer_len)
+		ccc->dests[0].payload.len = cmd->actual_len;
 
 	ret = xfer->ret;
 	svc_i3c_master_free_xfer(xfer);
@@ -1351,7 +1351,7 @@ static int svc_i3c_master_priv_xfers(struct i3c_dev_desc *dev,
 		cmd->in = xfers[i].rnw ? xfers[i].data.in : NULL;
 		cmd->out = xfers[i].rnw ? NULL : xfers[i].data.out;
 		cmd->len = xfers[i].len;
-		cmd->read_len = xfers[i].rnw ? xfers[i].len : 0;
+		cmd->actual_len = xfers[i].rnw ? xfers[i].len : 0;
 		cmd->continued = (i + 1) < nxfers;
 	}
 
@@ -1391,7 +1391,7 @@ static int svc_i3c_master_i2c_xfers(struct i2c_dev_desc *dev,
 		cmd->in = cmd->rnw ? xfers[i].buf : NULL;
 		cmd->out = cmd->rnw ? NULL : xfers[i].buf;
 		cmd->len = xfers[i].len;
-		cmd->read_len = cmd->rnw ? xfers[i].len : 0;
+		cmd->actual_len = cmd->rnw ? xfers[i].len : 0;
 		cmd->continued = (i + 1 < nxfers);
 	}
 
-- 
2.43.0



