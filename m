Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031669;
	b=rUdqlX0GVOjGLVK0op4rbauVmospqN7RYY8WZJNHHsUGncFZb8cO08by0Bqi0Zd+nBcZ
	 jU/o1rnDjjhTq41rbopoAedXfCuj3kFBAbATb+wypS+tH+sxsmoqAqpsBZfT5Iy6CFN1g
	 S+qoVtup0eYrvh6hqUPt/tu6HQtw3ohl4mUN7oPL8RHm+sBpELLT9SNvJA3vuwUry9OX0
	 NXhBwUansDGjWGGqb7fmfE6k5GDvT2CSiKae1TneCRpKyAK9+Q1Vk2MXchxTyt4S0KBOe
	 m2Uh+zodeZWkJKSAamqyJlsj5XbdYtGLv2JXNiRVaefTFcSaWjcnSQ+SapcVAHigQhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0kI8ndKUeBkelYIwNj5F7XPnQYdusj56fTWTPu4PErg=;
	b=YNIzNHngIu0VdODYbU4J6YB1THI6eVhlJ5Rmk5Jz5sIfaOmjxvrlo0kU2vOiqHnkpAkB
	 bsuvCAqHLOsfpjVhZn8+zmYYfxz1n0DA23+pxVEMl9zT9E7kT5NHostQPQ3BgL/nqhPSE
	 Mxupzytea3fGMI/q/PrOmFAbPGRK9JP4Shg7F88KguD2mcn0aR0QtyxaR0k1hXGm8XVAk
	 MMc/JjSeds7/J++3mDHz+7ajWEZa5ST22HFkUnxptjcnseiD2LqaEcffF+0WDAc6lXvBo
	 YuqE3tmIb05ZnKY/JXL8KyL1GbW2jsP4pNuBMAZlNiqjcow+doI6tFcoyMoEiwDkuXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mb1ApTtU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3221E606A320;
	Wed, 18 Nov 2026 19:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mb1ApTtU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B72A1F000C4;
	Wed, 18 Nov 2026 19:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031669;
	bh=0kI8ndKUeBkelYIwNj5F7XPnQYdusj56fTWTPu4PErg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mb1ApTtUS3rme0BvNitWreKmpZTpCHnG20T6YoTir1/6/H31qA9079ogvn3J5wmtW
	 rDvgooXwNRgmRhIoAa207pOHYsXdolAIvMWK9GeNCUNLksDuIQmrftz9d4B04mFzd4
	 mq1ThnVhPzpQq16t4m3yEGxoiS4XHmuVMd4Ub24k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1138/1756] clk: qcom: mmcc-msm8960: Configure PLL15 only on APQ8064
Date: Wed, 18 Nov 2026 15:54:25 +0100
Message-ID: <20261118150055.357848477@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit 342db3b6cf7bad2a53ccd5e2d844faf260953d9d ]

PLL15 is specific to APQ8064, but the shared probe function configures
it unconditionally, including on MSM8960. Its configuration registers
at offsets 0x33c through 0x348 exceed the MSM8960 regmap maximum of
0x334, so regmap rejects these accesses. The PLL configuration helper
ignores the errors and probe continues.

Only configure PLL15 when the selected descriptor is for APQ8064,
matching the existing variant check for the GFX3D clock adjustments.

Fixes: e216ce60a9e0 ("clk: qcom: Add support for APQ8064 multimedia clocks")
Assisted-by: LLM
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916-clk-qcom-mmcc-msm8960-fix-pll15-config-v1-1-11fae0be111d@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/mmcc-msm8960.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/mmcc-msm8960.c b/drivers/clk/qcom/mmcc-msm8960.c
index 3f41249c5ae43..91bf9b15ad010 100644
--- a/drivers/clk/qcom/mmcc-msm8960.c
+++ b/drivers/clk/qcom/mmcc-msm8960.c
@@ -3120,7 +3120,8 @@ static int mmcc_msm8960_probe(struct platform_device *pdev)
 	if (IS_ERR(regmap))
 		return PTR_ERR(regmap);
 
-	clk_pll_configure_sr(&pll15, regmap, &pll15_config, false);
+	if (desc == &mmcc_apq8064_desc)
+		clk_pll_configure_sr(&pll15, regmap, &pll15_config, false);
 
 	return qcom_cc_really_probe(&pdev->dev, desc, regmap);
 }
-- 
2.53.0



