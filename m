Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFBD270545
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302186; cv=none; b=KcvDLqC9ArmoSNme/mMSjDwEsmYTAcdvqW5X64ZCWZHyaCTsT4aY8/Zt+I4Isw7Gn69od/lOafBY+tsf3qrSEqqUWxasM4lYry530VlD7njyseoa7TE9W1FYryRx1ll9jdOcXuHK4UH0Ry2E32mvwWZHvorkKiFshWRJ3hkDIUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302186; c=relaxed/simple;
	bh=vv/77SLaGxhjNeov5DC0PQ8wrez0Tt/Oh8KIZ+5vM6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dp7nlRcWxK2wWGUD8wiAeoAIiy9yfG3OeXTk4sMNc5BkTo5m/jR9/9CNlkbo0enQD9nUsH7cvnK4bLznkbRv19DlXP8XqoOgdZsD6wdz3CG/YPDBfwE9BIMFbyyq+bwDOoFcx20sKPQFrDmns7fkF4fGsDRRQ03ZkoaFRJ4YeNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tlc+c1sk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tlc+c1sk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52F1C116D0;
	Sat, 28 Feb 2026 18:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302186;
	bh=vv/77SLaGxhjNeov5DC0PQ8wrez0Tt/Oh8KIZ+5vM6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tlc+c1skFK79V+GitVcXHm3Z+RO+wTgztZ5Z/r0xuFZbYkXXhGYIGHzlDS16PEiMR
	 dpEUgSyCDL1vvaY2hFIPL7tpg4zRbwstZaM1qJ3D+vFZqNsBG+eutKWSCcZt6cA679
	 AiBwQB9oe+humu8v4KNP2U6hGgQ4MKZxtXQUZdXovbPipd4ZQpJjIUMVYJDJdAL1eL
	 5tESsQomaLZ5CCUSvh41VdKD6yiqOfBliRbGGIB6/t6gRbKZ85qG7uC7NBHKs9n+Lr
	 o/o6x3k/v+CvU0YcSUF/z+M47HZ4g1/5+Xoz+/M5mX2RGxNyuj+xhQyrJsVLlgLD3g
	 FlFRoxdgET63A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Mario Limonciello (AMD)" <superm1@kernel.org>,
	Yijun Shen <Yijun.Shen@Dell.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 187/283] crypto: ccp - Factor out ring destroy handling to a helper
Date: Sat, 28 Feb 2026 13:05:29 -0500
Message-ID: <20260228180709.1583486-187-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 0ccd0e29b0380..09b54bd9b3e3c 100644
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
@@ -136,24 +159,13 @@ static int tee_init_ring(struct psp_tee_device *tee)
 
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

