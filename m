Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99761465B3;
	Thu, 13 Jun 2024 12:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280800; cv=none; b=GBe7EKTWMsRuj8vOlhiokQ2s3HVvai4V8Tnw7m6WXxkkBzm5+b+9uIXV4YHSR8LuaFc3yVztywbblfLHiL9uZs7DYOdxDtmHPx+IXMmIOy9HI+oINrSgUu2hs/Q7RfdoRRJCwoA08x4IWHCDuXuiRkijx+v48UmWNCwSupgHyGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280800; c=relaxed/simple;
	bh=4DT4Qd0iFsnJbaU0vm+rMzaD2O/tufW5UvtLMo6jS2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Np3tm0wWHFJlA+ZDETM6e9o6v+auUq4LvZOW/fvGKYoP2cjpYGkeieT7j9FhSG5K6eZTC4fusjqihBTQxmmV3jm3HhcrjMh7SL3gySKZMeIBfq7a7gko0YGsSg1kGk7Rv+kxpnisu8IjdRvfH/BMg2Dv/DtjLAIhwwN+2FyAa2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDtKLlb0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDtKLlb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E33C2BBFC;
	Thu, 13 Jun 2024 12:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280800;
	bh=4DT4Qd0iFsnJbaU0vm+rMzaD2O/tufW5UvtLMo6jS2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDtKLlb03axa/pnV2OctdmVQlXM79V7PttYPIQSnvb0TPS/Xf6PSbvVH8uA5qkGa3
	 n7UNrv+DWweorEE5fJSyQyvFTAkpn9qL6LcGMnqHZjyLcZW1SrNk3VkYcjHAtXEHj8
	 kxfuEVXDARCVAsFsvJVQSvyzpknNy9t10nbB94/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/317] soc: mediatek: cmdq: Fix typo of CMDQ_JUMP_RELATIVE
Date: Thu, 13 Jun 2024 13:30:49 +0200
Message-ID: <20240613113248.746327989@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 505651b0d715f..c0b2f9397ea8a 100644
--- a/drivers/soc/mediatek/mtk-cmdq-helper.c
+++ b/drivers/soc/mediatek/mtk-cmdq-helper.c
@@ -13,7 +13,8 @@
 #define CMDQ_POLL_ENABLE_MASK	BIT(0)
 #define CMDQ_EOC_IRQ_EN		BIT(0)
 #define CMDQ_REG_TYPE		1
-#define CMDQ_JUMP_RELATIVE	1
+#define CMDQ_JUMP_RELATIVE	0
+#define CMDQ_JUMP_ABSOLUTE	1
 
 struct cmdq_instruction {
 	union {
@@ -414,7 +415,7 @@ int cmdq_pkt_jump(struct cmdq_pkt *pkt, dma_addr_t addr)
 	struct cmdq_instruction inst = {};
 
 	inst.op = CMDQ_CODE_JUMP;
-	inst.offset = CMDQ_JUMP_RELATIVE;
+	inst.offset = CMDQ_JUMP_ABSOLUTE;
 	inst.value = addr >>
 		cmdq_get_shift_pa(((struct cmdq_client *)pkt->cl)->chan);
 	return cmdq_pkt_append_command(pkt, inst);
-- 
2.43.0



