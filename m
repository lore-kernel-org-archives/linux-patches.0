Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E0F19753C;
	Thu,  6 Jun 2024 14:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683171; cv=none; b=R5zik5x8y3mbKaKAV/A25Ojq3bbjOL94e+VNuFAujFxwd0kahbkKUnreHVlfgNory8LzS1xtTi4bgMFCv/RVGJF9hgFKQrsVMQ6fJuQ599CvjzhOIo9OX0ldElAApNswxT9KsPxdHGaMSLlZj9L/yCTt66sQP4nsevWxCamMvVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683171; c=relaxed/simple;
	bh=XA9a+DdUCMcRnjsBhaJVYDfr7Gv9sqMTO+6LLYlHxfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VhaJsG0SQYkqY0vWliUejku+qU5yG78/3pwJ3r33zpsWhSPtH1P2P1D1qxeyvDF2Nhp53eMMjiX8tnxl0bRSlYtAbOUZ2+jFE2pT2jvZ30Q6a+NGWZtmNltzdcjGENYqYsQoPiZ1iF8mRDaBojQujQM9tOUDsOQo05WgOUGrsaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6Dyk0O7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6Dyk0O7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6237CC32782;
	Thu,  6 Jun 2024 14:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683171;
	bh=XA9a+DdUCMcRnjsBhaJVYDfr7Gv9sqMTO+6LLYlHxfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V6Dyk0O7sJfZhD/bclHSkRE6FMlhGAGvabhg0DNfSToxsq+cGq1F9PgUDwpPrSnJe
	 QEgNjMlUx55eS3fh9moG09VEPL4oGLh/USgylMbHfG4jl8qlgMR+IMLbzN5L3vbbbn
	 wc0Gof9HszHfdD/t+wB+VXPCS6AfBYRSDyT5s8OE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 116/744] soc: mediatek: cmdq: Fix typo of CMDQ_JUMP_RELATIVE
Date: Thu,  6 Jun 2024 15:56:28 +0200
Message-ID: <20240606131736.121205199@linuxfoundation.org>
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

From: Chun-Kuang Hu <chunkuang.hu@kernel.org>

[ Upstream commit ed4d5ab179b9f0a60da87c650a31f1816db9b4b4 ]

For cmdq jump command, offset 0 means relative jump and offset 1
means absolute jump. cmdq_pkt_jump() is absolute jump, so fix the
typo of CMDQ_JUMP_RELATIVE in cmdq_pkt_jump().

Fixes: 946f1792d3d7 ("soc: mediatek: cmdq: add jump function")
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240222154120.16959-2-chunkuang.hu@kernel.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-cmdq-helper.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/mediatek/mtk-cmdq-helper.c b/drivers/soc/mediatek/mtk-cmdq-helper.c
index b0cd071c4719b..0b2e5690dacfa 100644
--- a/drivers/soc/mediatek/mtk-cmdq-helper.c
+++ b/drivers/soc/mediatek/mtk-cmdq-helper.c
@@ -14,7 +14,8 @@
 #define CMDQ_POLL_ENABLE_MASK	BIT(0)
 #define CMDQ_EOC_IRQ_EN		BIT(0)
 #define CMDQ_REG_TYPE		1
-#define CMDQ_JUMP_RELATIVE	1
+#define CMDQ_JUMP_RELATIVE	0
+#define CMDQ_JUMP_ABSOLUTE	1
 
 struct cmdq_instruction {
 	union {
@@ -397,7 +398,7 @@ int cmdq_pkt_jump(struct cmdq_pkt *pkt, dma_addr_t addr)
 	struct cmdq_instruction inst = {};
 
 	inst.op = CMDQ_CODE_JUMP;
-	inst.offset = CMDQ_JUMP_RELATIVE;
+	inst.offset = CMDQ_JUMP_ABSOLUTE;
 	inst.value = addr >>
 		cmdq_get_shift_pa(((struct cmdq_client *)pkt->cl)->chan);
 	return cmdq_pkt_append_command(pkt, inst);
-- 
2.43.0



