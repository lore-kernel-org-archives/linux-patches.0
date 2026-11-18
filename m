Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026429;
	b=08njMlj5u8lOZkMiw2ZEVmT4ikZn2+V+EVslg+NTrD9dc6oJQdXZParOP0WPZr/XuBUi
	 8ZjRKPYWWxfUi5HD/i5GRiNYOwwJrGaX8oRYGQKul8EYCUERK2UeEG98sk3rqhRaZBXf/
	 Q0Fu2hyjiUD/rR2enOZGB0A/iE8VNSnYR3bSFSnetf5SKoPuCzVKDhuU2RYtZ5bJJLj0x
	 HFtdiPBpkyVKcMWmsUC/s5VLsPv/c374sw90H1oDelLTEkJlU+STnK78/YsR6VVpYxCjm
	 rkIwYEzsHs+/ZwkfTmPVoZ54pZoGhqVUG5zW0riKbb9sCFf7pGv+meXDKIcPJA9Gbfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rl+CWXTGRu9pRYIOevzFG3CaxOA0dlA1s75UBUL+55k=;
	b=IGGwbqoHmxqhbAdNYns3okYzcv9UYZQykTzxmgcdLrs10FRT5xeikYDENcuYo4VY7wco
	 n2/A+tnADaiU/RC20i9Ufsj8v3QDipEZ9usYU+Aq74RX4mDJsuggdvRBuDSC1rxbxY+Xb
	 zIYGUW7SCMX/jV/zKgnu45sOfIJRgzqDpcn/39KiON1cR7mfk6GHDyvYUCupMogugtuZW
	 HJfPNrmeOSg0ie7TJ3BrjWUA6xcMlbO1FQiI2Ku2FjKTLAU8MMLdua1x2dwxgy3ZwW+JB
	 I5AbmF7t3EyL4NNkC553GxNIUcKwCEhjIv4XxZYF9SkqgOMnCkpV7rov5xEQIRTKA8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XfDTAHlO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663FE60A2601;
	Wed, 18 Nov 2026 18:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XfDTAHlO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F691F000C4;
	Wed, 18 Nov 2026 18:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026429;
	bh=Rl+CWXTGRu9pRYIOevzFG3CaxOA0dlA1s75UBUL+55k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XfDTAHlO1rRUa/5X7Mgvmmne7UNwVqao918Lk6p5PCJqiA/AOEDjaie3YLHEYdeCY
	 WfOWRVh3k6SmELX2KVJBquX/adhcT3IghVURjcG14496oqyFTNSyFj97XAkbyGu0b+
	 mD+XvabIRImcs1kbgpfiAl7q3Y6ru66YhJZ9Pr/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1433/2151] clk: qcom: mmcc-sdm660: Fix MDSS AHB clock HWCG register offset
Date: Wed, 18 Nov 2026 15:52:48 +0100
Message-ID: <20261118150214.135246751@linuxfoundation.org>
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

[ Upstream commit c5f338329a2d0d60f7874aa7a1addaa0e4e75a3b ]

The MDSS AHB clock HWCG bit resides in the same register as the branch
enable and halt status bits, at offset 0x2308. The current HWCG register
offset of 0x8a004 exceeds the regmap maximum of 0x40000, so regmap rejects
the read in clk_branch_in_hwcg_mode(). Since the read error is ignored,
the helper uses an uninitialized value to decide whether to skip the
halt status check.

Correct the HWCG register offset so the helper reads the actual hardware
clock gating state.

Fixes: 5db3ae8b33de ("clk: qcom: Add SDM660 Multimedia Clock Controller (MMCC) driver")
Assisted-by: LLM
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916-clk-qcom-mmcc-sdm660-fix-mdss-ahb-hwcg-offset-v1-1-30dcf09d907c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/mmcc-sdm660.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/mmcc-sdm660.c b/drivers/clk/qcom/mmcc-sdm660.c
index dbd3f561dc6d0..6d57aadedd2de 100644
--- a/drivers/clk/qcom/mmcc-sdm660.c
+++ b/drivers/clk/qcom/mmcc-sdm660.c
@@ -2018,7 +2018,7 @@ static struct clk_branch csiphy_ahb2crif_clk = {
 static struct clk_branch mdss_ahb_clk = {
 	.halt_reg = 0x2308,
 	.halt_check = BRANCH_HALT,
-	.hwcg_reg = 0x8a004,
+	.hwcg_reg = 0x2308,
 	.hwcg_bit = 1,
 	.clkr = {
 		.enable_reg = 0x2308,
-- 
2.53.0



