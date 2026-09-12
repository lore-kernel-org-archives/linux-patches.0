Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF00288B2;
	Sat, 12 Sep 2026 10:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209885; cv=none; b=E1zXNYeGGcJVsjvsELNbavN6lkWkhyeTDZEd7+BitX7MTuPpZf7aJQGRUHL3JRpLSujaGUdxMxpCISHCMLz1MpEk//s3WRSZ4+E7Pl6IYeY5YQ2F97n6L6JrVGqAmB7bWhzl+/4eQUWOXxa7xaNmajUynkzzDLHPGxrzjSPzlxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209885; c=relaxed/simple;
	bh=LhmxBoAdJlMfwBI+kmVi1tJD3LL0gvvpz7cpNsXeDGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jz6jmjxNqFUphuhkvRuaF6WapiOdjuPxX8O6AV8y/0dI++DhvTxQRNz6Dns+2eXov5xytZL7Hi1Lr0cdY5pYkkFFDdpO5pPtIPbGblm7RrSi0AJMtpXupvyqF4aOVD7kpGYudZLQEQ02ClAt5Azr+nKX7IF0XRfzu/BSdU8iKEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h3TI6OT6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h3TI6OT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DC71F000FF;
	Sat, 12 Sep 2026 10:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209883;
	bh=eEg5+YBwm7rghKRsfiT/YdpMPk8sOr8Mc3jTkSENMUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h3TI6OT6tsARPrGMZiqLlNH4tEpXP26gJ9DicD9ly4fbNDRctNTO2BezueJBBVuhx
	 tqE56Zn77H+QYiC5On0ivIbwJPuZvCQoj10ImmLVV3DOieShlBbMOKLbFO8E4ngft2
	 BtVdqLNcAOq/F9h5E2LKOFQ+ziAyRy7Wr0NLODuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0876/1518] arm64: dts: qcom: agatti: Add missing CX power domain to DISPCC
Date: Sat, 12 Sep 2026 08:50:45 +0200
Message-ID: <20260912065643.265476371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e0e400fdd2497..5a817824f924b 100644
--- a/arch/arm64/boot/dts/qcom/qcm2290.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcm2290.dtsi
@@ -2006,6 +2006,7 @@ dispcc: clock-controller@5f00000 {
 				      "gcc_disp_gpll0_div_clk_src",
 				      "dsi0_phy_pll_out_byteclk",
 				      "dsi0_phy_pll_out_dsiclk";
+			power-domains = <&rpmpd QCM2290_VDDCX>;
 			#power-domain-cells = <1>;
 			#clock-cells = <1>;
 			#reset-cells = <1>;
-- 
2.53.0



