Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019985;
	b=QXUPrsKFBo0WVNKInx1+XwNWn3dDTFCTOBByxq8pvMhlJlhcfrHwmHh0n5hL++UKwKn/
	 a8NJOpFqsmu7T+lWsC1CrKpGzZREAl2+ATXQbQBNBCESHgpAuiYWTpsB6k0cFcSzJkYkD
	 AoM6o096KRwlm9fALLqyICsz0+nDDklrY0lVshSvGx07VGwYSH9JwjxlGoWnlMVHV0X7L
	 lqBn+syEovrlZqu1bOtXOb4T77fyYFpyha1X0ZB0AW4bIDPpHwdHQxksDkksjpnjrCDdD
	 L2+bkw9jz2eYOUKKvmyRKA1rakXFzCL/8IsTptGBxm9YsHDsylAmAB4wN7UxkJ5H/mQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hpgHrS2WXZpv5xCHHnGrj815zvDRMgTU0ynA9Er11WU=;
	b=Bxi97fwv06iymB2U0iDbJPV9ki9BXRnCnwSslQpMpjgVO8a0QG6cpQHCRBn54cdG6pBD
	 EngNWNElS2jI/OGjABqxaAQp3be+1fW/DhXGTL5DaF5RnUDazZFWdOhjnZb8L7VaOWDhP
	 HO/iIBvtfNQenKZBylHmxWXiq3+5Wp287W2Y2W+FkKrCdabuUSZfDieDzi1yfWXY28E4B
	 2zCzZNFhoRflmKT+JVFzn8pILXToubts2lQPBMxByr74TVVF4PZkjqq3GlutIPmHqt+zp
	 /eAsrXIy0Nw1mbrSf2Iw3dPVgVDBXQXkyXR6USQBwjWh+8glcZINsAn2tSLDTDYz6Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IEUN6+t+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E871C606A32C;
	Wed, 18 Nov 2026 16:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IEUN6+t+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4349F1F000C6;
	Wed, 18 Nov 2026 16:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019984;
	bh=hpgHrS2WXZpv5xCHHnGrj815zvDRMgTU0ynA9Er11WU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IEUN6+t+atwGa88Z6opo5w8WVltNIQgAApyZEuLGZ4PN9inpKn2uLUfsdT9C3gNcJ
	 11JhTISQnLAqq+8mUtB0MiSvmJHk3bJ2RF4TMQIBQjGKe4RE4UzAVLaiCsydPNb4am
	 lAfxu69Lg9qko4679H+O3VBZcc0ijv+09uOWlpAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1749/2651] clk: qcom: mmcc-msm8960: Configure PLL15 only on APQ8064
Date: Wed, 18 Nov 2026 15:49:49 +0100
Message-ID: <20261118150350.483710586@linuxfoundation.org>
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
index a23440e13b71d..a67df833592a7 100644
--- a/drivers/clk/qcom/mmcc-msm8960.c
+++ b/drivers/clk/qcom/mmcc-msm8960.c
@@ -3170,7 +3170,8 @@ static int mmcc_msm8960_probe(struct platform_device *pdev)
 	if (IS_ERR(regmap))
 		return PTR_ERR(regmap);
 
-	clk_pll_configure_sr(&pll15, regmap, &pll15_config, false);
+	if (desc == &mmcc_apq8064_desc)
+		clk_pll_configure_sr(&pll15, regmap, &pll15_config, false);
 
 	return qcom_cc_really_probe(&pdev->dev, desc, regmap);
 }
-- 
2.53.0



