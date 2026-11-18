Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041532;
	b=2bqJxehxGR5Jm4XoSgUYC42X8dQpZXR1SAXs/Uf0kIFfK1rWgoHbgUGrkEeRXADj+1o2
	 FPbdq/eo9yfSIKeMhglv3tz97y4J4ih4uLqTs3pM2rgzytPefrpRmoM6IeruxizTJ79jp
	 U62kkqzEkgealG8E/Xjc95BeBBz8XlVsOZOE1YaNfPHMBDR62JCBkA6YZFInZgRjnysV/
	 eW9AUAQxu7tcVyU3XDbxdakOHyAOXEw17vELRiGqlzl4hUxoxFWlkYhzbuFzXB8FPzZOg
	 y8qCyWNTYOGeuWjIr29NDl/6vIJPKi6fKRTJP6Z6jaQRM7Bs+9HbHhIWqk8/SZG5G2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SwDoez+pnEf75ToBq+ZN9nTka1ZpR+lApS/9JbYVxwg=;
	b=pxRVaznVt/xVDHV3QkUm0sZtJAsbZetQnomtTQ55rQPQxwRZjIO68zNt+e3kVx80PB5S
	 JemvPjBgUQVfWsVBbxJtdAXAg43p4D2zBPxZPlzFfiVgU3QcVXnHPPVGWBYWGiBVizb9o
	 laiTY+owoWRj8AayrhXqqmVPQr+5AuSWnmGghk0U+WPLFgxG6mnIm91aelxmXK/wFyVM8
	 qeD6hoGtg2rxToOmwlQyDk2CtsWUtdUViuEXwRp8oIiIOgpB7N283F5Kp7dOm/NWh6m5U
	 53O3NF7PxglvGRxCGWA3Mh67WvKRaAQY2DnqG8zPUxD4iCdsBniYEpvvl68z/9uPnpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yRHbME3q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D0A606A32F;
	Wed, 18 Nov 2026 22:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yRHbME3q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54B81F000C4;
	Wed, 18 Nov 2026 22:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041532;
	bh=SwDoez+pnEf75ToBq+ZN9nTka1ZpR+lApS/9JbYVxwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yRHbME3qTqVG7KwqJUeBXu/YiyXs7H/ZHYESmtLFz+Ax39U0juBZr/8HXh7c0RMP6
	 laA0RdK5KZaeNGYtR7QUMY018qrnrTfwVM1D7md6dbGbP078iWZ4Djdf2pFHw2DI7f
	 P8fnOcE54k/dH0LfsR7H+N7c/gt29Bg9EtZqC14g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2806/3318] clk: qcom: mmcc-msm8960: Configure PLL15 only on APQ8064
Date: Wed, 18 Nov 2026 15:57:08 +0100
Message-ID: <20261118150444.849184275@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 50638ab341eca..5d6bc076efacc 100644
--- a/drivers/clk/qcom/mmcc-msm8960.c
+++ b/drivers/clk/qcom/mmcc-msm8960.c
@@ -3120,7 +3120,8 @@ static int mmcc_msm8960_probe(struct platform_device *pdev)
 	if (IS_ERR(regmap))
 		return PTR_ERR(regmap);
 
-	clk_pll_configure_sr(&pll15, regmap, &pll15_config, false);
+	if (desc == &mmcc_apq8064_desc)
+		clk_pll_configure_sr(&pll15, regmap, &pll15_config, false);
 
 	return qcom_cc_really_probe(pdev, desc, regmap);
 }
-- 
2.53.0



