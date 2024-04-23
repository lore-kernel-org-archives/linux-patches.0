Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B26085274;
	Tue, 23 Apr 2024 21:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908508; cv=none; b=YUp5UdjHuYU+BudhlW8pvR5f3wsFzpBCqv7drAun5c2dhdEdR3ZOsph7FLD4p1ZTUuKKQ6n3D1+4hGaxhfsxvVsW02ykkEDXoF72tVbYfJVrY8ycvM86pTRirtoc0fqcxQfYrqQ5z/WjRu6pIL4UOH1JrirtdETdZfZCkSK43cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908508; c=relaxed/simple;
	bh=bZ9PiPN5aV/VTmDPUoxPI5oG2EFbu5yglpKhO0HnYz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNk7HayV6DzqTM/ucmOx4jofBRovBebdI3lQGT/mVkqt9iE/Xqo9jUdTnvCC3kzRuIlk2b7eFmmQ5B+8KDVCz9em3HBuoduTq7vv+Hakxl8I5kP0g/1MCQqij9dsEJjWiTpdQUvkAeSskSyaqkTzie0knz3Iqrb3yY+OLHGvt04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S6+24Ll3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S6+24Ll3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08230C32783;
	Tue, 23 Apr 2024 21:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908508;
	bh=bZ9PiPN5aV/VTmDPUoxPI5oG2EFbu5yglpKhO0HnYz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S6+24Ll3ukWEoxMzbS8O45AGb6ldl37YLVtTN0MLKchkkkON+Iax4CXX6VtGhNfti
	 z5XK56rsDif6ELTYNAdSLiQ8vom3tjQ94K70HZObGRvl619S66yQwgjWKqNexxqGlx
	 U0ZeaD73eVPICeW8s0Z4zFoimD5sFnRvd3Od0lYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Shih <sam.shih@mediatek.com>,
	Daniel Golle <daniel@makrotopia.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 083/158] clk: mediatek: mt7988-infracfg: fix clocks for 2nd PCIe port
Date: Tue, 23 Apr 2024 14:38:25 -0700
Message-ID: <20240423213858.644701202@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit d3e8a91a848a5941e3c31ecebd6b2612b37e01a6 ]

Due to what seems to be an undocumented oddity in MediaTek's MT7988
SoC design the CLK_INFRA_PCIE_PERI_26M_CK_P2 clock requires
CLK_INFRA_PCIE_PERI_26M_CK_P3 to be enabled.

This currently leads to PCIe port 2 not working in Linux.

Reflect the apparent relationship in the clk driver to make sure PCIe
port 2 of the MT7988 SoC works.

Fixes: 4b4719437d85f ("clk: mediatek: add drivers for MT7988 SoC")
Suggested-by: Sam Shih <sam.shih@mediatek.com>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://lore.kernel.org/r/1da2506a51f970706bf4ec9509dd04e0471065e5.1710367453.git.daniel@makrotopia.org
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt7988-infracfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/mediatek/clk-mt7988-infracfg.c b/drivers/clk/mediatek/clk-mt7988-infracfg.c
index 8011ef278bea3..df02997c6b7c9 100644
--- a/drivers/clk/mediatek/clk-mt7988-infracfg.c
+++ b/drivers/clk/mediatek/clk-mt7988-infracfg.c
@@ -152,7 +152,7 @@ static const struct mtk_gate infra_clks[] = {
 	GATE_INFRA0(CLK_INFRA_PCIE_PERI_26M_CK_P1, "infra_pcie_peri_ck_26m_ck_p1",
 		    "csw_infra_f26m_sel", 8),
 	GATE_INFRA0(CLK_INFRA_PCIE_PERI_26M_CK_P2, "infra_pcie_peri_ck_26m_ck_p2",
-		    "csw_infra_f26m_sel", 9),
+		    "infra_pcie_peri_ck_26m_ck_p3", 9),
 	GATE_INFRA0(CLK_INFRA_PCIE_PERI_26M_CK_P3, "infra_pcie_peri_ck_26m_ck_p3",
 		    "csw_infra_f26m_sel", 10),
 	/* INFRA1 */
-- 
2.43.0



