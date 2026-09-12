Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FDC47C107;
	Sat, 12 Sep 2026 12:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217189; cv=none; b=esTrOjxGcKh/MriJHOGDiquFZNEijanG3PwKxZ7uokG7Xy9mmcqsU6WWzNmtCSYShGRvKSQyqk0vQBK8h3gMSP+U1eZ7l7JIt6kfMIDU3TJ3al/LtxwNGbComJkut/WmvGcrz7ej5MGHjLSKZ6AQ24W2vJBgvhW3NdYybhwuWSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217189; c=relaxed/simple;
	bh=s7WjSAKSc8MTgw4VGekK+oeav/Tj0HgD9FXCdjAqGbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sz3Szheq5GAJ7bEdlbR1qc9bqg9eIPRUTZ65BF6bxSoD35uLctAU66Jc7lhVlCNeq+M/yzW0GWjkG7XP5j3F8i7DyqWmBhwqxbAOoywIH4zyuVpkx9nHQdHcjPrlv5DXElxs+PVo8CE8vtYvNQFJxjryWSHcatips7c91joa4Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PVxxYm8u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PVxxYm8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82821F000FF;
	Sat, 12 Sep 2026 12:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217188;
	bh=DLYbf3Zcv+KLlGI9VktSoM7m9NFKUspDw7yI4einwac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PVxxYm8uzdJ4T2tEut0IRQ6so8J2ZmyHdh8L44Yz23CqDA31n21j+93bQVrXDe8nZ
	 5l3xM6G6NqfyL3CaPE9QDdoJKsfzW7bthAkuRfR9Bl+T2uEylK13v7BUep2akHE84O
	 u+15uxglD7X+IV+ymd0uc2L1iZqs3qeKxpZlVx3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0891/1376] arm64: dts: qcom: agatti: Add missing CX power domain to DISPCC
Date: Sat, 12 Sep 2026 08:55:17 +0200
Message-ID: <20260912065627.421625470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imran Shaik <imran.shaik@oss.qualcomm.com>

[ Upstream commit 26d7b23caa4b1d8208e28c5981a85cf83e658e7c ]

Add the missing power-domains property to associate DISPCC with CX rail.
This is to ensure the genpd performance state votes on the GDSC to get
propagated to the CX rail and to avoid the rail under-voltage conditions.

Fixes: a2b32096709d ("arm64: dts: qcom: qcm2290: Add display nodes")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260718-shikra-dispcc-gpucc-v6-12-62703e05ef0f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcm2290.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/qcm2290.dtsi b/arch/arm64/boot/dts/qcom/qcm2290.dtsi
index dbc78b2d5095a..d50b36143ebda 100644
--- a/arch/arm64/boot/dts/qcom/qcm2290.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcm2290.dtsi
@@ -1798,6 +1798,7 @@ dispcc: clock-controller@5f00000 {
 				      "gcc_disp_gpll0_div_clk_src",
 				      "dsi0_phy_pll_out_byteclk",
 				      "dsi0_phy_pll_out_dsiclk";
+			power-domains = <&rpmpd QCM2290_VDDCX>;
 			#power-domain-cells = <1>;
 			#clock-cells = <1>;
 			#reset-cells = <1>;
-- 
2.53.0



