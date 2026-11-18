Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017077;
	b=pL+7UJ44IkVJ9gvEvGhOa0+rSd+zAR6py7LCt/orrjzwbcDDMlnMJKg838L84l3A9ekV
	 wtmz+7A7eVVNM2q4s0cumTeR6i3ubmWetEYKrJG1hxbH2ni9AmUtWqhA/QoXFrOCH2iNM
	 rAxM9NKQiOHIF4F7LGYwOTnegtGJQCjw8N5KZWIiMjUxRZMJW3w1riYNnVL6YR3cVE05x
	 MougdBs4fqjppsv/lHZzmYwzgZ/K4fblnTKLAzmC/BgUgvGX6PZxlE+QaQJoxi3A7dAv9
	 rhbVtu162hFgWynw/ph7CCO0J3XP8uIfMLUKAAoGLDViuaMy2hNpNR3eVp3G1ZNW1+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jyvj5nq/ssT0ni3dxcTvj9ArgZwX1Gd9ZY1kJdkg3AU=;
	b=jBljQfH8OHgMBfoJRDR8nwq6mab2I/VUnV4XCJKZRWfFt/eihRB0ym5DnVCOuwzf+wla
	 CdgfJPV0GhQllcbzK0EALpdTP/VjIBZj8MN69eSINGMqqMAWHdHGuXiUI4LHBRPOZvFBz
	 80YZKBbusJltSEVQdVFxgVxDr5WmgaKL9P/lsE2GFfHc6kXVtvv9aGxvvwIc769eC2bjk
	 v3ajYAfsvhlVasmkycMdrfZnr5qnUpDRfu1AMQDaj9H5VVjB4/X+1ut3Bw6zKo9vU+3Ko
	 8vZ3JdjLoi69M5sl8s6OIen7zBcv57TiRiAQBWQDU5G/eM3rNsrcS0q7V1XGFKVAwxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xuIk4Ue/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4CF606A31C;
	Wed, 18 Nov 2026 15:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xuIk4Ue/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DE71F000C7;
	Wed, 18 Nov 2026 15:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017077;
	bh=Jyvj5nq/ssT0ni3dxcTvj9ArgZwX1Gd9ZY1kJdkg3AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xuIk4Ue/Jc2JRMbAFjKWkH1Q7T9c5zKv+/Y/NPLr+S2Ah9IkeJUpFt9ctywGGNEvr
	 Cf5fAhyEQ0eWSJGWY8++zyvsKErHtGPIbA7CdoKG5hEO7uCMxlwuA0MOfH73zbzkO0
	 3LGFS9zUhwBfOnchRLE/QaBnZvLXj1r6p56wCye0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0756/2651] clk: qcom: fix SM6115 lpasscc register offset
Date: Wed, 18 Nov 2026 15:33:16 +0100
Message-ID: <20261118150315.097435520@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

[ Upstream commit 689364ac19e4680e09d100c743f8797da127609a ]

For some reason we ended with incorrect register offset for soundwire tx
controller reset and the regmap register max was also incorrect it was
0x1000 instead of 0x12000 which is full register range for this IP.

This was somehow compenseated in DT reg property which got it working so
far.

Fix this by correcting the actual offset and max registers as per SoC
documentation.

Fixes: b076b995e225 ("clk: qcom: Add SM6115 LPASSCC")
Cc: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Reviewed-by: Alexey Klimov <alexey.klimov@linaro.org>
Link: https://patch.msgid.link/3a4e8d1115a46c45cb34193b6ceeb02891fdf716.1790114902.git.srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/lpasscc-sm6115.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/lpasscc-sm6115.c b/drivers/clk/qcom/lpasscc-sm6115.c
index 226dc02fc42da..fcc1512d4a991 100644
--- a/drivers/clk/qcom/lpasscc-sm6115.c
+++ b/drivers/clk/qcom/lpasscc-sm6115.c
@@ -34,7 +34,7 @@ static const struct qcom_cc_desc lpass_audiocc_sm6115_reset_desc = {
 };
 
 static const struct qcom_reset_map lpasscc_sm6115_resets[] = {
-	[LPASS_SWR_TX_CONFIG_CGCR] = { .reg = 0x100, .bit = 1, .udelay = 500 },
+	[LPASS_SWR_TX_CONFIG_CGCR] = { .reg = 0xc100, .bit = 1, .udelay = 500 },
 };
 
 static struct regmap_config lpasscc_sm6115_regmap_config = {
@@ -42,7 +42,7 @@ static struct regmap_config lpasscc_sm6115_regmap_config = {
 	.reg_stride = 4,
 	.val_bits = 32,
 	.name = "lpass-tcsr",
-	.max_register = 0x1000,
+	.max_register = 0x12000,
 };
 
 static const struct qcom_cc_desc lpasscc_sm6115_reset_desc = {
-- 
2.53.0



