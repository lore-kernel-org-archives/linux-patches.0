Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0D215FA91;
	Mon, 27 May 2024 19:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837786; cv=none; b=Ti0qDsZifPpqof18zkapOjSHRaVZT73BiZ4jELJ+LixeNI79tYL3iNbN39FlbonYPGykLxwjuYlOk1S/njMjk6VLY5iKmev5fw6ptmkjT6gbsWf0dkY/b9NLXsCZ/28UknaDEO6hPBrwShjOTGj9Okgfkt21hh6q8Dgi4VWQGy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837786; c=relaxed/simple;
	bh=7KHY4BTf1gJ3m1LAPSut2xbzSmdsL116GDKMw7ddda8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WW174jlZqI6lnIkdOLE2pMlez0OIFUCtzgYE4jibrrSYAZpGGAb7LDfU5srYuIzCAUJmXwDmIOUNScjAUDMuMuq+vOcYoo1TFV9nMHsc2ayavXgoE/0Zc5gi09747fsvRBXkc9x92OIpnnj6IM8fouDJyKWFz3tcxFFqnHyJGrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uGNu3hlq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uGNu3hlq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92D0C2BBFC;
	Mon, 27 May 2024 19:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837786;
	bh=7KHY4BTf1gJ3m1LAPSut2xbzSmdsL116GDKMw7ddda8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGNu3hlqL3H5Rc9nWciIbEmcqhZxux/n7wKEig1JdhIrMX/QzGRLZHl+BVYqSw6i7
	 pMdBrjeEiC4Iwgd6MuwOHeqUVddD7Ex1yo8z06jl2d4YkSFccsI6coT/+1uKGQc5B4
	 jV1o4Vn6UgUfWqEposVbjoPoYy6jJJ3LmNTucvnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 145/493] soc: mediatek: cmdq: Fix typo of CMDQ_JUMP_RELATIVE
Date: Mon, 27 May 2024 20:52:27 +0200
Message-ID: <20240527185635.186710140@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



