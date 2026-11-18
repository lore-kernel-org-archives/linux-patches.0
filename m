Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026432;
	b=rN11fa3i/olhfbpejDSQ9mEM/dJD3DdTKUcrwYZXVb+0qYpkz2y78XAE+VxxaeIXy39E
	 EDNWDzGb9OjvHmqo/BffLN/CeafxcZpORhLMMdxsOjvX0/YRDcNACNNhpKvrSBu0SFnuo
	 5VKSc0QAtFYy5+3orPoTImr2pWyeI+U+AlZ2ohrV5X17uQug+wQkpKPl+VBfWNesJNwhN
	 Am3SQSek8eUtewP5UI9cWM1dKSgJb9p3tNL+HfNmIom7KZp5CPrM1+KBvLKxbvgwAwkky
	 Q8TEdSn9y1hXjinM/QEagITdvPuHTfdE0tZOlq3N306KLuw4Jveb0x8GbhUy0KfBwxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026432;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DcHNePSKfZW+YShy1p2+weMw9K66ji1f2szsQro+lz4=;
	b=fjLxz6xO8ahXU39iiRf9aPb+1LoPZVWhp3lPtcwYJnhKPPmntIGGbYKX359Knjn2xONR
	 UetWMkzy3xF5Q0ds1r2yD56MYTGnPbJ4h0vW4o4NmowYc67rJKhycijeZK7hZ3u1/pRvR
	 MG84LECg2hemH2EjGqpzgryE29Ukl9znlcFZBVWnCSj1yznRM5ku4k0WgMPsUrqegnvSB
	 oTEw0Rp/SYDX+51BmyuKEjyeBO/CeCWqgIYKS1PdBUO3SmHSCKHZrwiTBcLLmCQHVPeZk
	 XKva7Q4Biy+MMO8FrD56PdBjcDCKygjJbQxygSdbWzQ+fD7/9ejXyWuMyERy3h2OVFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AhAO1yud;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEDC606A339;
	Wed, 18 Nov 2026 18:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AhAO1yud
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA4D1F000C4;
	Wed, 18 Nov 2026 18:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026432;
	bh=DcHNePSKfZW+YShy1p2+weMw9K66ji1f2szsQro+lz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AhAO1yudKVofOj5cY+WOt0v1VGm5ZLz5TRcEhW8mcP7cTvV2Heucd9bhXLFkHmqHf
	 fByQVfQeQjY2Yx+clah5DKKgp1LrEPYIoL2R0k5M8T6oI/x6zK13bdHSKmyZUc7wXM
	 o2dymDzRcTcwDeCaxMmS01m5EFawIaRGe9U2CctE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1434/2151] clk: qcom: mmcc-msm8960: Configure PLL15 only on APQ8064
Date: Wed, 18 Nov 2026 15:52:49 +0100
Message-ID: <20261118150214.171783483@linuxfoundation.org>
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
index cd3c9f8455e5e..2e1551226a619 100644
--- a/drivers/clk/qcom/mmcc-msm8960.c
+++ b/drivers/clk/qcom/mmcc-msm8960.c
@@ -3171,7 +3171,8 @@ static int mmcc_msm8960_probe(struct platform_device *pdev)
 	if (IS_ERR(regmap))
 		return PTR_ERR(regmap);
 
-	clk_pll_configure_sr(&pll15, regmap, &pll15_config, false);
+	if (desc == &mmcc_apq8064_desc)
+		clk_pll_configure_sr(&pll15, regmap, &pll15_config, false);
 
 	return qcom_cc_really_probe(&pdev->dev, desc, regmap);
 }
-- 
2.53.0



