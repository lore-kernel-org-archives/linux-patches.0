Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E121A340A59
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301022; cv=none; b=Lej52QeP2k5HuCGxUdoJYtZF9SFL+WUsEUCT2xpcyaU+WJOGbT0floh8ejmX1n1JR7i60giB+/pPUNivYdxNgXI1vcuNlILkZdQ5c2tMDGo/p167vwpHx9DXXOKtS0M0dsaWbmRbn3RGr1ZiCs65Y4/f7DmkPsT3ptPnv7/ohhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301022; c=relaxed/simple;
	bh=wIL6RIeDlixo/m7iEcvBLlVuDm1p821+/SN5yYQKWf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ottRX51kSBE3zdc2Mz7QFopNCZzy0iTO2lMRBLCyhFRtKkiDjSnCnF5MusoctwZLzM632AykI0OK1D9fAIaOgN9fSnSI539cU9GAPmt4FlGsXXCBYuFxkeTriS0eJd9CukvlC3Z17j1dFdlMX7gifd/kH2YBj3qfB3/nWxRFANA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OrbWgyCB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OrbWgyCB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCE6C116D0;
	Sat, 28 Feb 2026 17:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301021;
	bh=wIL6RIeDlixo/m7iEcvBLlVuDm1p821+/SN5yYQKWf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OrbWgyCBuQXMKQkAt4Duxx9O6iy3kqSDNyLRAPj7m/CrJNZqvNK3Yjo26FpCXp4PE
	 hVRR5bjDR6uCJQdeS652imGIq99yjunai+djFLWdBJS+B6WpEDBKvc7rTYUVJiILJN
	 rv3NByx/VbxMq9XlSGMuucOEALvhvzVTziCecKUkw55oJYk7S7685zV6jQQT3SL7AM
	 DDQtJeQNMXO7SLOxEmgIdfw3+OCbhv0KhJT3MV7YF4sVui83CGoRPC+2+dPZlW28oL
	 mVq1WDvaA0tKUz2Xpo2b2Tcb6rUEatOaLj0tn4HJem/jC/tHWxyKqi2DY4AmjeK0gI
	 uY4sqgjW9a5AQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
	Bryan O'Donoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 158/752] media: qcom: camss: Do not enable cpas fast ahb clock for SM8550 VFE lite
Date: Sat, 28 Feb 2026 12:37:49 -0500
Message-ID: <20260228174750.1542406-158-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit a89e490ba3551823511588b7b3828d67f8b82954 ]

The clock is needed to stream images over a full VFE IP on SM8550 CAMSS,
and it should not be enabled, when an image stream is routed over any of
two lite VFE IPs on the SoC.

Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Acked-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss.c b/drivers/media/platform/qcom/camss/camss.c
index 2fbcd0e343aac..fc838b3d22038 100644
--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -2561,12 +2561,11 @@ static const struct camss_subdev_resources vfe_res_8550[] = {
 	/* VFE3 lite */
 	{
 		.regulators = {},
-		.clock = { "gcc_axi_hf", "cpas_ahb", "cpas_fast_ahb_clk", "vfe_lite_ahb",
+		.clock = { "gcc_axi_hf", "cpas_ahb", "vfe_lite_ahb",
 			   "vfe_lite", "cpas_ife_lite", "camnoc_axi" },
 		.clock_rate = {	{ 0 },
 				{ 80000000 },
 				{ 300000000, 400000000 },
-				{ 300000000, 400000000 },
 				{ 400000000, 480000000 },
 				{ 300000000, 400000000 },
 				{ 300000000, 400000000 } },
@@ -2583,12 +2582,11 @@ static const struct camss_subdev_resources vfe_res_8550[] = {
 	/* VFE4 lite */
 	{
 		.regulators = {},
-		.clock = { "gcc_axi_hf", "cpas_ahb", "cpas_fast_ahb_clk", "vfe_lite_ahb",
+		.clock = { "gcc_axi_hf", "cpas_ahb", "vfe_lite_ahb",
 			   "vfe_lite", "cpas_ife_lite", "camnoc_axi" },
 		.clock_rate = {	{ 0 },
 				{ 80000000 },
 				{ 300000000, 400000000 },
-				{ 300000000, 400000000 },
 				{ 400000000, 480000000 },
 				{ 300000000, 400000000 },
 				{ 300000000, 400000000 } },
-- 
2.51.0

