Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208940;
	b=D+o4oiGx6lbHuJBRKexyALc3orJBbUNDGm5Q3Bzz1ne5ytvbEbnk+551Cw0T3zCtpzkj
	 ANJN4kyS+xmQ3OXqTb/8pEIJviPHkUStmhjFyJCFgyY9deyNIGuoa1C2QirrsO0U3bWx7
	 RDnKbXNHehJMwGtCuijv4WecVI+EdSeCKrZmbUnPEqWVJPbSzWyYSuwttfClOCCOKnQWe
	 RR/tkLuwUUg8t7va1rMYapvYylygQx2fghpLkdeeUvFiLFFQsgDHvp/CBn24cn1ba3MFU
	 xxDOeLjboM0+U/HfXmL2c8e3sUesfQepM4VZYOb76KolbVv3c8MZ4qdaS+hesEPu9pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=MgrwY2MVeVd9GanpqSJVbUqZblBkpH8U2daZZorZiMs=;
	b=vSYL92bKlqHmNlkROqEvfMjgdvpJ2fQD//ojn87Z8aFZ0WdfY6pw2o37xsyu3pI5ej0/
	 W4qs4akkxH0PDsQ7A4qR5Wa8OC9WLoqV1p32rJXKcob1wOrnsLMPWV9/UMKA+Gp3Q1J3x
	 rXMnIVtFg5ro8ljmG2+WDVo/JhbUtZuGQ7QUXY2SqO1LXfCCXV5DtTpxZnWEF7a8bsaxJ
	 gFM+GeLVjQuWuNMt2Jc/0M9QLldJ43Uftnv5LSJktrIztAwHV5ZuechqpQUTCYgfl6N30
	 DEZZw51FnfpSmpawf5VFI4saRlfvaWT8wRd5W1aylJ9dr4m7IoH/IMZt1k4/a2wsgZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DNsQe27D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A757606A331;
	Wed, 28 Oct 2026 17:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DNsQe27D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B394A1F031E2;
	Wed, 28 Oct 2026 17:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208940;
	bh=MgrwY2MVeVd9GanpqSJVbUqZblBkpH8U2daZZorZiMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DNsQe27DzCGV+0goM4vCbN0Qg1XC7UUR8alOuoQW1+N0S1mGLB2Q5PYHWhr5d6Yf/
	 EUT2fZFHanp+Cayn8NY6O9CHr6K3YYDWmM8fLrbCRx2s76O4S8OJ0hDPuienTotLzb
	 6Y+FPu+4iVws5n80/RdEfP+tTnozrywnqEwIYrSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Xu <han.xu@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 297/516] mtd: spinand: Enable QE on all dies
Date: Wed, 28 Oct 2026 17:57:29 +0100
Message-ID: <20261028170010.527451612@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Han Xu <han.xu@nxp.com>

[ Upstream commit 63d6cace2c4a7f36c1cb44f1bb5e0f3ef19e5c7f ]

The QUAD ENABLE (QE) bit is stored in a per-die configuration
register on some SPI-NAND devices. When a device contains multiple
dies, updating the QE bit only on the currently selected die can
leave the remaining dies operating in non-quad mode.
 
Iterate over all targets and update the QE setting on each die
during initialization to ensure consistent quad I/O operation
across the entire device.

Tested on ISSI IS38SMW04G8B.

Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
Cc: stable@vger.kernel.org
Signed-off-by: Han Xu <han.xu@nxp.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
[ sashal: retained local enable detection in spinand_init_quad_enable() instead of using an enable parameter. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/spi/core.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
index 8794a1f6eacd9..953202e711da4 100644
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -172,7 +172,10 @@ static int spinand_init_cfg_cache(struct spinand_device *spinand)
 
 static int spinand_init_quad_enable(struct spinand_device *spinand)
 {
+	struct nand_device *nand = spinand_to_nand(spinand);
+	unsigned int target;
 	bool enable = false;
+	int ret;
 
 	if (!(spinand->flags & SPINAND_HAS_QE_BIT))
 		return 0;
@@ -182,8 +185,22 @@ static int spinand_init_quad_enable(struct spinand_device *spinand)
 	    spinand->op_templates.update_cache->data.buswidth == 4)
 		enable = true;
 
-	return spinand_upd_cfg(spinand, CFG_QUAD_ENABLE,
-			       enable ? CFG_QUAD_ENABLE : 0);
+	/*
+	 * QE is a per-die setting on some devices. Program each target
+	 * individually when enabling or disabling quad I/O mode.
+	 */
+	for (target = 0; target < nand->memorg.ntargets; target++) {
+		ret = spinand_select_target(spinand, target);
+		if (ret)
+			return ret;
+
+		ret = spinand_upd_cfg(spinand, CFG_QUAD_ENABLE,
+				      enable ? CFG_QUAD_ENABLE : 0);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 static int spinand_ecc_enable(struct spinand_device *spinand,
-- 
2.53.0



