Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017341;
	b=Ciwr0memma/MBaRscct51o+ez4AMpiAumluXVcl5cAJpIwwxozD0auHHmNQRIrvZE/pD
	 gkhODVnE57GJsoRuxs4X91PLsMyCd/7rxLgA/iV4fyJO2wygusHIO0G8CBs//5EbFN5tR
	 Q0DIY44mfyb1oBX/gN9NNM05q228K2VJDz9FrInVfn1FFR/TOcITgnkR/aDpLUDWypmg2
	 58GNe4UXNWmNvBryZzeqMUBmOs59bLSzPxA6/cbvo7/9WhyDBmHWLsqFW0VlL1eBGpV/j
	 VRrLToMdQwTvar8fMQHeTnyBe90k7fOw4rUi0J7D+bPIB+RebBf7tzCS0vfFvsQZHww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ra85Cds9zmxeLi8N8uI0UNM5s75r2ImNZXluUL6njZQ=;
	b=mUuYFvcOAVjG3YN2FOgsksDD3i4JNNn2PQgQp0TTwrzBfZZeszgCKTovunwbIG0Xvsyv
	 1CHAo9/FyRhKWzL6UhWmnTZFUPQkPrNdqnZHl/t1qviOpEyMHK9ZgyQUpASWBwXTqiY3R
	 C9QmntGgKZFtuhtj5pHBUes67FWPM9vJwHUV6MgGUyPurpAbFdohcS3z2eFpgTZ/Qc0dy
	 Dnz8mouoPsBfuMa8P36Lbg9V7iDNwAOJHu5UbzrWpa1Wt1RNmH+xgykPfF475TqQzfSxS
	 ugXwHgq6mKv9hbMGfBzp7/rbR5HmiPREeiMWgmXXdxJSYQB0kLS/Ou5yW+BFAXyqqsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PlbkDv4x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A50606A31C;
	Wed, 18 Nov 2026 15:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PlbkDv4x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A8B1F000C6;
	Wed, 18 Nov 2026 15:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017341;
	bh=ra85Cds9zmxeLi8N8uI0UNM5s75r2ImNZXluUL6njZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PlbkDv4xDm754sMk2SA7e9g/FNEEOxql4QzctoKcR7a7wXxGvf3Jv96PXvxPgv6io
	 /IHnMfa2eAZLsruELxdR/3p2cQqHgaSjBAaHWhlr5SJo3LtdUnRBRrc6kBhbhhKo2t
	 TPbmqTQEDK7n9hpGoHsmTWPH0ZkJcR0fKU2L8cS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0850/2651] clk: qcom: gcc-qcs615: Fix GCC_CPUSS_GNOC_CBCR offset
Date: Wed, 18 Nov 2026 15:34:50 +0100
Message-ID: <20261118150318.475540966@linuxfoundation.org>
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

[ Upstream commit 51ff9ffa18758c465a1a67ca36a78c2a8a5f3b2e ]

According to the documentation, the offset GCC_CPUSS_GNOC_CBCR is 0x48004.
Drop the extra zero, otherwise we land outside of regmap range.

Fixes: 39d6dcf67fe9 ("clk: qcom: gcc: Add support for QCS615 GCC clocks")
Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260924-clk-qcom-gcc-qcs615-fix-cpuss-gnoc-offset-v2-1-67275f94aaec@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-qcs615.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-qcs615.c b/drivers/clk/qcom/gcc-qcs615.c
index 57f8c80c6f324..1a6a1e74e805c 100644
--- a/drivers/clk/qcom/gcc-qcs615.c
+++ b/drivers/clk/qcom/gcc-qcs615.c
@@ -2999,7 +2999,7 @@ static int gcc_qcs615_probe(struct platform_device *pdev)
 	qcom_branch_set_clk_en(regmap, 0x71004); /* GCC_GPU_CFG_AHB_CLK */
 	qcom_branch_set_clk_en(regmap, 0xb004); /* GCC_VIDEO_AHB_CLK */
 	qcom_branch_set_clk_en(regmap, 0xb040); /* GCC_VIDEO_XO_CLK */
-	qcom_branch_set_clk_en(regmap, 0x480040); /* GCC_CPUSS_GNOC_CLK */
+	qcom_branch_set_clk_en(regmap, 0x48004); /* GCC_CPUSS_GNOC_CLK */
 
 	ret = qcom_cc_register_rcg_dfs(regmap, gcc_dfs_clocks,
 				       ARRAY_SIZE(gcc_dfs_clocks));
-- 
2.53.0



