Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AC131F9BE;
	Wed, 20 May 2026 16:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295644; cv=none; b=FOnpLnhW3txOYs0FNYbG8jIbKH/IFf3QjjDPnE5Dgu1O8x+CRXeoNI6VT6WkaLstmRB4jDq7Yr2xNJuXVoEPCrqVKGAkcK3RtFUIKzuAjXhpM7hRQUe64ZoPNiq4L9oZPObmkRhrECoeuBBHnoywXdHgAIpObXhE9wvkBLRoo/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295644; c=relaxed/simple;
	bh=3ISGNAYadrqBpacr2c7WcgM8EfPyQ/f5FLwyFxcDcu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/xlfC9q/utihWfgk/F4z2InHsgBKnUKDn2gKCx6l9nT78NZtrwAY5QkeSKeR/hnb6F1uNAeVXicVzx4cNqsqAghrUQfGuX/a3h+1ixzQwplYf8rmtC1iffy+92ce/v7Ks9oyDFt2aBOjtwacgiqFIMIFzM9Wdw+xL2I0hNBckY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdUywiyK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdUywiyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034C51F000E9;
	Wed, 20 May 2026 16:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295642;
	bh=7W4iFepCU/n3j52SFCmf5ZA7L8XHmddSylP77BRwUs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DdUywiyKlo7xtx/C1g5dAzt0pU1I9H6eoNxGRukBHj+ivxLKjDX9tuapuKBL/jncc
	 v4y2dCfT2JhLI3vW0lo6l+najY/now6EDa/YP1mf1zybZCdx5DgbfA32XIrT2O12BJ
	 O0ovXT9fUA643YtHc1Rh5aOiDb5KINPjsEvdKtjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <rob.clark@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Akhil P Oommen <quic_akhilpo@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0497/1146] soc: qcom: ubwc: disable bank swizzling for Glymur platform
Date: Wed, 20 May 2026 18:12:27 +0200
Message-ID: <20260520162159.441338145@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit e031e7ceac4ee04973bd77362c363734e79dd08c ]

Due to the way the DDR controller is organized on Glymur, hardware
engineers strongly recommended disabling UBWC bank swizzling on Glymur.
Follow that recommendation.

Fixes: 9b21c3bd2480 ("soc: qcom: ubwc: Add configuration Glymur platform")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Acked-by: Rob Clark <rob.clark@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Reviewed-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Link: https://lore.kernel.org/r/20260228-fix-glymur-ubwc-v2-1-70819bd6a6b4@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/ubwc_config.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/soc/qcom/ubwc_config.c b/drivers/soc/qcom/ubwc_config.c
index 1c25aaf55e523..8304463f238a6 100644
--- a/drivers/soc/qcom/ubwc_config.c
+++ b/drivers/soc/qcom/ubwc_config.c
@@ -231,8 +231,7 @@ static const struct qcom_ubwc_cfg_data x1e80100_data = {
 static const struct qcom_ubwc_cfg_data glymur_data = {
 	.ubwc_enc_version = UBWC_5_0,
 	.ubwc_dec_version = UBWC_5_0,
-	.ubwc_swizzle = UBWC_SWIZZLE_ENABLE_LVL2 |
-			UBWC_SWIZZLE_ENABLE_LVL3,
+	.ubwc_swizzle = 0,
 	.ubwc_bank_spread = true,
 	/* TODO: highest_bank_bit = 15 for LP_DDR4 */
 	.highest_bank_bit = 16,
-- 
2.53.0



