Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065429;
	b=J42ms+aghdAZQb0MtqO2oM5mIrX/bFgem/xw0LG8kIuYAaTuE5Rp8YyzIkjQqlrNIXXD
	 dynTZQBHE+YYahu3dZWrwozQ2/lVpKBu32KmGZkOZQDm3bi+jB+pB3d2rayxJ2d64EEWU
	 GTJMxjKzBu2mmiz1JHLVEBTnR/jEdalhhpZTVoG+RX+rPdrWXV8qVdtim7FO2gNTkaRva
	 TtlwH7CNFtcaKggJIvmOuw3ifyCbJhz+z9fSuincg2K689T8LagFhIU7vSvdLlJCTRyGB
	 6208JQo7t6xD6YR5iAqPQ6eYcdPcS13qrMtYg1q5w39nJZygxT4Y4rhje/D47NVoB+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UWlktoF5DSeH+Nx6nUAY4fP67F/FDVlRY5gWWesci30=;
	b=XhI2MhktoI3ZMoLuqF2JH+PRHl+7zDmlOZSgBqVDgw3sHkQP2O4ZMflbULD2l9mglBsH
	 oqQL0T5kYT4imRjX08pifgS8f/6V4ocWg24/nhbICnzShPTjE9Y9YiiJlynlq68KiUOUA
	 Php5SThqBHf63A9sBvO4Fmx5iDlhhvex9VJED2cJYFYUZef8kQ4Rl/5vl69ezfXRIXOWx
	 dQfaJ6V7VrMaqjcqwVv+JmhDX2IApWHgUsBPYD4WFumcPk6KNjum/Gf8X7FrYzu1xM1bd
	 qPZXz/2BsFIT0vRnKQnz3yLMn5diDmJAK8hb5Xknz6EpRfJqinbOG202uv+uDpL8+lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G05Q85no;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7089E606A33F;
	Sat,  7 Nov 2026 15:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G05Q85no
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9C01F008A1;
	Sat,  7 Nov 2026 15:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065429;
	bh=UWlktoF5DSeH+Nx6nUAY4fP67F/FDVlRY5gWWesci30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G05Q85nobzVYSmCth+zy69mgL0hA/m0xzyF12juSw/S0wM2AUsLUs2Xd0usFbQ6Vy
	 53vlxaMtwaqAjcC7QmAU5V620OL6AKMYHeFXWbCY+yjRzDvHYzeLKVSWqy38rxPHxK
	 iYHLvx1Tde7nLe6ZnmOn3P6PN8t2aX947YaWnkwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Shawn Guo <shengchao.guo@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1140/1257] ASoC: qcom: q6apm: Clear the right handle on pos buffer unmap
Date: Sat,  7 Nov 2026 08:57:16 -0500
Message-ID: <20261107135010.713878914@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Shawn Guo <shengchao.guo@oss.qualcomm.com>

[ Upstream commit 43c69604271d8b54c494fde70bd4a9eaab7a974d ]

Push/pull graphs map two shared-memory regions per graph, the circular
buffer and the position buffer, and keep a separate DSP handle for
each. The map path tags its token with APM_MMAP_TOKEN_MAP_TYPE_POS_BUF
so the response lands in the right handle, but the unmap path sends a
bare graph ID and the response handler always clears mem_map_handle.

Unmapping the position buffer therefore wipes the circular buffer's
handle and leaves pos_buf_mem_map_handle set. A subsequent unmap of the
circular buffer is skipped, leaking that DSP mapping, and a remap of
the position buffer is skipped because the stale handle looks valid.

Tag the unmap token the same way as the map token and decode it in the
response handler to clear the matching handle.

Fixes: 7c1ac23b178a ("ASoC: qcom: audioreach: Add support for shared memory push/pull modules")
Cc: stable@vger.kernel.org
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Link: https://patch.msgid.link/20261021041044.2080369-3-shengchao.guo@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6apm.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/q6apm.c b/sound/soc/qcom/qdsp6/q6apm.c
index ed55747923ea9..1f8d915b5e699 100644
--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -327,8 +327,9 @@ static int __q6apm_unmap_memory_fixed_region(struct device *dev, unsigned int gr
 	struct q6apm *apm = dev_get_drvdata(dev->parent);
 	struct audioreach_graph_info *info;
 	uint32_t mem_map_handle;
+	uint32_t pos_mask = is_pos_buf ? APM_MMAP_TOKEN_MAP_TYPE_POS_BUF : 0;
 	struct gpr_pkt *pkt __free(kfree) = audioreach_alloc_apm_cmd_pkt(sizeof(*cmd),
-						APM_CMD_SHARED_MEM_UNMAP_REGIONS, graph_id);
+					APM_CMD_SHARED_MEM_UNMAP_REGIONS, (graph_id | pos_mask));
 	if (IS_ERR(pkt))
 		return PTR_ERR(pkt);
 
@@ -959,9 +960,16 @@ static int apm_callback(const struct gpr_resp_pkt *data, void *priv, int op)
 				dev_err(dev, "Error (%d) Processing 0x%08x cmd\n", result->status,
 					result->opcode);
 
-			info = idr_find(&apm->graph_info_idr, hdr->token);
-			if (info && !result->status)
-				info->mem_map_handle = 0;
+			graph_id = hdr->token & APM_MMAP_TOKEN_GID_MASK;
+			is_pos_buf = hdr->token & APM_MMAP_TOKEN_MAP_TYPE_POS_BUF;
+
+			info = idr_find(&apm->graph_info_idr, graph_id);
+			if (info && !result->status) {
+				if (is_pos_buf)
+					info->pos_buf_mem_map_handle = 0;
+				else
+					info->mem_map_handle = 0;
+			}
 
 			wake_up(&apm->wait);
 			break;
-- 
2.53.0



