Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8D02DFF2A;
	Tue, 17 Jun 2025 15:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175268; cv=none; b=sS58SHAYYs0kPFIztnxi7s/BvKl32/499wLInU7RrtS9SHLS9VY7jQ8Ph6dWBAzrf34PpkGxTMcPZ2tJyNpG4xtOR9TjM7HynMClteR5L9qDTG1SQdisTmyPCM8EgfNtE/CTGw3rqm/DMj1+gEent067377Ar+t1h3iFVeK7F1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175268; c=relaxed/simple;
	bh=WQObP/BVuVZ0nKgakB8RkZok6WHADFyuLJmGvqztvs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ss7hhhlqStpsEYA1thKoflA+2o3NcnO45NMGP6giHfIxoCSLis273XvPdwa1snWl3FPqzBolB5GRmeQi3P3bEYLP+V9mT1wlPl1V9nzMurKFrguLM88bsM6s4y73hrWke1eKyNFum0UZJCJ7QJ4Dc9Jtk1KrLV0jfxhno5Bknmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1saB+E0H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1saB+E0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CE2C4CEE3;
	Tue, 17 Jun 2025 15:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175267;
	bh=WQObP/BVuVZ0nKgakB8RkZok6WHADFyuLJmGvqztvs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1saB+E0HlMqPjSvaDzu4XbDfp+JPW2Shb+Njp2nGk7EcfSChDPaIE8JvJ7se4QLea
	 13vC86lY/Rt7RBOnSYOuo56BBEeMv7YvG33dV13z9IRJhpx14IVlUyocf9suUAtYfa
	 w06UuiTzZagHcQ9xwUuT03W+3Be7yaYIFL1/ABtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dzmitry Sankouski <dsankouski@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 159/356] arm64: dts: qcom: sdm845-starqltechn: refactor node order
Date: Tue, 17 Jun 2025 17:24:34 +0200
Message-ID: <20250617152344.624112934@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dzmitry Sankouski <dsankouski@gmail.com>

[ Upstream commit cba1dd3d851ebc1b6c5ae4000208a9753320694b ]

Fixes: d711b22eee55 ("arm64: dts: qcom: starqltechn: add initial device tree for starqltechn")
Signed-off-by: Dzmitry Sankouski <dsankouski@gmail.com>
Link: https://lore.kernel.org/r/20250225-starqltechn_integration_upstream-v9-4-a5d80375cb66@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
index f3f2b25883d81..8a0d63bd594b3 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
@@ -382,8 +382,8 @@
 };
 
 &sdhc_2 {
-	pinctrl-names = "default";
 	pinctrl-0 = <&sdc2_clk_state &sdc2_cmd_state &sdc2_data_state &sd_card_det_n_state>;
+	pinctrl-names = "default";
 	cd-gpios = <&tlmm 126 GPIO_ACTIVE_LOW>;
 	vmmc-supply = <&vreg_l21a_2p95>;
 	vqmmc-supply = <&vddpx_2>;
-- 
2.39.5



