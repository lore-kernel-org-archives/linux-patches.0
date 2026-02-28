Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E614B34250D
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301854; cv=none; b=WjgoFY7xe19lHh7J/TJyvfmBEMIiF4Prc7C7SAsqqNsRmBGlASMKoT+vS9Em8AWkuIHpkR45v9pmFLHWomjZAOE0qEsq5CMSV3WKb22r5rdnIDMg4rvChybbwZhn0EB76SYOThBKi1V2fZluOYwtR1H29lwq0p3e8WqFbs+HduU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301854; c=relaxed/simple;
	bh=ZqQ6puuSvlsuWi6Nrf1K49wZBg29pAfRT8NnBsnaeas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n5Qsg1VGHb1JK6NIq853l80k4FNnJN4OHzEAXDbvbDaWGYJ7cDnF/RE6HvNG8mhdRGdbI9n01SMc62HhcfFz36xLmrhIWWwSpb2is6patBV+xqUe+1Te9rtay9e/KBPbBxVDnQX2Jr/LQmLvHsbc4mt4svwVS86d/bUsp2xBLr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W93u84gT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W93u84gT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E2EC19424;
	Sat, 28 Feb 2026 18:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301853;
	bh=ZqQ6puuSvlsuWi6Nrf1K49wZBg29pAfRT8NnBsnaeas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W93u84gTjpumwKYHQkWjSHyV7tjI4Z26ARoIkVwIkTp8UznB6qjfIxOoMYe4RuTNX
	 6hKW20utbN2sl+VR7ZtoHmHeUjeSRK5dpjme0OEsZtDjNPJja5/5/AxdqMKxBq2edL
	 xZrS3w2lQBT9BDqVFX91kZRvrxN0gahtVLiILV3OoprhiBaxz1Nj4szb0cqvLZ3VBB
	 CGh/260w97YWqYPvmN5UViVHMNBY5U0S5FsoN2pK0Vx8EGm35gfUe85FkAz5FTOenB
	 wgr4pSG7kflZCcpnYGzJ4gRksp3Zp8+nHIAmX21R4X/Utxp7/uqMz+IU5ALArdAXiF
	 Rk/R7G1lChXMw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Mario Limonciello (AMD)" <superm1@kernel.org>,
	Yijun Shen <Yijun.Shen@Dell.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 274/385] crypto: ccp - Factor out ring destroy handling to a helper
Date: Sat, 28 Feb 2026 12:58:16 -0500
Message-ID: <20260228180011.1568201-274-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Mario Limonciello (AMD)" <superm1@kernel.org>

[ Upstream commit d95f87a65bce5f2f2a02ca6094ca4841d4073df3 ]

The ring destroy command needs to be used in multiple places. Split
out the code to a helper.

Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://patch.msgid.link/20260116041132.153674-5-superm1@kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 7b85137caf11 ("crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when PSP_CMD_TEE_RING_INIT fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/tee-dev.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index 11c4b05e2f3a2..ef1430f86ad62 100644
--- a/drivers/crypto/ccp/tee-dev.c
+++ b/drivers/crypto/ccp/tee-dev.c
@@ -86,6 +86,29 @@ static inline void tee_free_cmd_buffer(struct tee_init_ring_cmd *cmd)
 	kfree(cmd);
 }
 
+static bool tee_send_destroy_cmd(struct psp_tee_device *tee)
+{
+	unsigned int reg;
+	int ret;
+
+	ret = psp_mailbox_command(tee->psp, PSP_CMD_TEE_RING_DESTROY, NULL,
+				  TEE_DEFAULT_CMD_TIMEOUT, &reg);
+	if (ret) {
+		dev_err(tee->dev, "tee: ring destroy command timed out, disabling TEE support\n");
+		psp_dead = true;
+		return false;
+	}
+
+	if (FIELD_GET(PSP_CMDRESP_STS, reg)) {
+		dev_err(tee->dev, "tee: ring destroy command failed (%#010lx)\n",
+			FIELD_GET(PSP_CMDRESP_STS, reg));
+		psp_dead = true;
+		return false;
+	}
+
+	return true;
+}
+
 static int tee_init_ring(struct psp_tee_device *tee)
 {
 	int ring_size = MAX_RING_BUFFER_ENTRIES * sizeof(struct tee_ring_cmd);
@@ -137,24 +160,13 @@ static int tee_init_ring(struct psp_tee_device *tee)
 
 static void tee_destroy_ring(struct psp_tee_device *tee)
 {
-	unsigned int reg;
-	int ret;
-
 	if (!tee->rb_mgr.ring_start)
 		return;
 
 	if (psp_dead)
 		goto free_ring;
 
-	ret = psp_mailbox_command(tee->psp, PSP_CMD_TEE_RING_DESTROY, NULL,
-				  TEE_DEFAULT_CMD_TIMEOUT, &reg);
-	if (ret) {
-		dev_err(tee->dev, "tee: ring destroy command timed out, disabling TEE support\n");
-		psp_dead = true;
-	} else if (FIELD_GET(PSP_CMDRESP_STS, reg)) {
-		dev_err(tee->dev, "tee: ring destroy command failed (%#010lx)\n",
-			FIELD_GET(PSP_CMDRESP_STS, reg));
-	}
+	tee_send_destroy_cmd(tee);
 
 free_ring:
 	tee_free_ring(tee);
-- 
2.51.0

