Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024291;
	b=T3+hRFuJhSDroN1DePTp/NPSStc93Nq+eAPgZCSbykt1EWP5zgTc2ONaT6YkP4znLT/8
	 Ahkrl53gxHWIWWfvNBotL7QSe0bXCxc7PV7yIV9UKPjg59OZV7kvJHMUZxyyStgvPbkId
	 LvpLIVF/e+CHx51QyZN9PovOumIbeI1A8Z7sgBqzbRg5pK+2V8SFT5vPKTOsaAuealg4b
	 3hyoqUP2gwviPkwFzDQG2qLRocrbROWbTQkRqnXKZeKJkvw2E4bSmZzfjm+wEe3OSPbUo
	 pnFRON+7t2SvFHgosWzhUvznUjiitQo2ufUThUManTPKqAvOODn3Ryu71C3gtTNpxvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qzLp4wtS1H4WTEgsY6h1ij0nsrSp9d7s3Js01TeJzXI=;
	b=wW+MVSRKmu7J2EF/D7f3TPfOVlv8ovmcXuP4BV/xjPozaIm99b3Z6b46vfKem6/exeB1
	 kbKKSm1w7WtHzOhqoBNzrnGTfyC/5LcB0xu725RktuzsH1tfcdlDOkaH4JtA/qs8TeVUj
	 M/mkGdtU1AYsBt2lqybixPv6PCGCka9rrqLdCo+w1U3w1eOiPEmWmyvTz+zRoHB93pyPU
	 3RG9BWHh6UU0E2ThY3YqIYNxrqE6WU8rkmy2rrB0YSRCWJdZduUFp2m3vTPKPhSwj0qaL
	 kysOau3lUPGevfKEG1fOTPx89Ei2iGBHUhVlJQ7SGkR8u3LgBNfyFfiTFtBBLkEKAfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lnkQhDJI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35FB606A330;
	Wed, 18 Nov 2026 17:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lnkQhDJI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3EF1F000C4;
	Wed, 18 Nov 2026 17:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024291;
	bh=qzLp4wtS1H4WTEgsY6h1ij0nsrSp9d7s3Js01TeJzXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lnkQhDJIAJUnJKW+LR9sh01BmNgUcLTiLty2h80qGPj7cBMrPmWlb83z5XYoo2sbC
	 DCn+QT75EmTKbRGFJkG6uQAJQEol8P2624VtgI0TqojUj7N+WudC2t0wftyQiYDJsV
	 1uMgTV+Hvjndt/6vGptk/Sp61VWoPyvuwUoW7gYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0673/2151] clk: qcom: fix SM6115 lpasscc register offset
Date: Wed, 18 Nov 2026 15:40:08 +0100
Message-ID: <20261118150146.334085898@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ac6d219233b4c..47adf4de2cca7 100644
--- a/drivers/clk/qcom/lpasscc-sm6115.c
+++ b/drivers/clk/qcom/lpasscc-sm6115.c
@@ -35,7 +35,7 @@ static const struct qcom_cc_desc lpass_audiocc_sm6115_reset_desc = {
 };
 
 static const struct qcom_reset_map lpasscc_sm6115_resets[] = {
-	[LPASS_SWR_TX_CONFIG_CGCR] = { .reg = 0x100, .bit = 1, .udelay = 500 },
+	[LPASS_SWR_TX_CONFIG_CGCR] = { .reg = 0xc100, .bit = 1, .udelay = 500 },
 };
 
 static struct regmap_config lpasscc_sm6115_regmap_config = {
@@ -43,7 +43,7 @@ static struct regmap_config lpasscc_sm6115_regmap_config = {
 	.reg_stride = 4,
 	.val_bits = 32,
 	.name = "lpass-tcsr",
-	.max_register = 0x1000,
+	.max_register = 0x12000,
 };
 
 static const struct qcom_cc_desc lpasscc_sm6115_reset_desc = {
-- 
2.53.0



