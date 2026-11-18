Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041487;
	b=hHZxDibCRhCYIC2MuCIVQdyrpA9d3BJZK8UZWtNtVYvyRADeOmv7VddxicfD7g1PlWlH
	 LRoJ/3KPZYYOvVCpyKXDxBQ/INfjoz/FX5Mk3U6aSuJoYgBxZoyIdJNkAw/pGgCrUQIY4
	 S9pRILPvC7M2MVYhLPd40Q6EaFh06k7j04G783EF9u/+3eTy15bP5NpDLcbJ1YIg3VTrz
	 x6H6RWTUl1kmlbpHX+7D0v+mjFAdvyxjccKQ4tv3ylkveYQQWPBZUzBQMsZTPCfdOva1s
	 rzPgEbxmB8kfDL21idtQsPpOMUw3VJFWPsTPHQsnu3TDQ9E2dWIozem0yxTD+Iv+pSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041487;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z35m/iIB9ou3bm9d/3EmTy/bOFuIw/RDyO+1LzyX73c=;
	b=tgyrXGPxgIvb+skgk2hd9lnYGJsi7RoyCuY9ckDPh+aGE6JhKeKA3Y2ITQwJb+ZCBiAs
	 G7xHFr4IwaBbHBVgn+7vfHE5ENzcH18zIEDe9/t+sXOkc4mDxOMWfmU+K/ey6jGtWCMUR
	 2TP3pyFyRQo69NMkB8Sk+UFkbd8YO2STMcbgM7qMxEoUcssP4rVGGqkIx6kmo+yrrazDk
	 A2J6+fP+1wjiut0wX9eg7r2LEHauRQD+6iiEdLDU+4PnsQ8CI3TLF8WnKNrk2dhAgcj1A
	 laqjH/aow64+9S2CoP/+syOVutWcDGuo8JjtqrifT8uLiNwGfccab15ZyYv3iWF8eRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AZcSC7qq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8B1606A6EC;
	Wed, 18 Nov 2026 22:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AZcSC7qq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246911F000C4;
	Wed, 18 Nov 2026 22:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041487;
	bh=Z35m/iIB9ou3bm9d/3EmTy/bOFuIw/RDyO+1LzyX73c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZcSC7qqjSeV6mbQa1Zr3fUEn6ehKnnTIQdzvMJwpBTt1lsJX9ACCqxIOxkUjT5fW
	 UD2P/xjberSdf8lzN210ZC3FHzm+62kr76vZXOUA7poZuyiLgFQoQR3h9de6clbNOX
	 zFEky6mZiSXAxgEV/Ek745E0aUdYqsKcuRn6aQ6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2804/3318] clk: qcom: mmcc-sdm660: Fix MDSS AHB clock HWCG register offset
Date: Wed, 18 Nov 2026 15:57:06 +0100
Message-ID: <20261118150444.791726405@linuxfoundation.org>
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
index 4d187d6aba734..fc2fc74d1c01d 100644
--- a/drivers/clk/qcom/mmcc-sdm660.c
+++ b/drivers/clk/qcom/mmcc-sdm660.c
@@ -2022,7 +2022,7 @@ static struct clk_branch csiphy_ahb2crif_clk = {
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



