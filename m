Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095F9429CDA;
	Sat, 12 Sep 2026 10:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209031; cv=none; b=lePLhHUn/MJVd5xXhAnVPW6v+hZze4ksTcW76+EUQYFAF44TBEZfmYecfgm56nscI1tnZN6gc7wDqA2gDCb2/s5Vmzpipii5MdLtVDbQ6KEWMC0y1yyTCahtQnUKl3IVTGSIxJ2Kij5Nknwh4ny+a1f5WC5kwoE+6+DNwKA+UL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209031; c=relaxed/simple;
	bh=xK3VW9Vtg2Z/5a+HGCaFfaZBpCet0S6Y+puLnkkLy6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRehtslBJqxvxDhA608cITeq9v+DoJ3ttpqwm76rxMeH6kRBLoap90MK6SeQWOapdynykxOljiVXVmBDtkZC/vqwptoJGlWoTWT1I/TT7wJVPwck9jFEwxInoS44Pqx27cl/xnCMGzAru7jBxDIyXWfja1RE6OI1kbg23td9jaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wwPZaN6g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wwPZaN6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D10931F000FF;
	Sat, 12 Sep 2026 10:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209029;
	bh=tRlc7m2mhlhr2WfF/i9q5nZdNjInZQapvNqr8s8V/iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wwPZaN6gOytxFamtUHOMh+Zj4qS6Dfct+Qk699uvyi+NjZnowAw0Wv7qoKS3Euh+4
	 /tRPLPUrKu2xgPcJJHK4CTP+//mAND3M/9nS7GgmQ+psSoBn2XklfI/x20janziQIU
	 aypARRdwLXGypppxNVW64UP405N+BQkAYZn0IbLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0695/1518] arm64: dts: qcom: lemans: add refgen regulator and use it for DSI
Date: Sat, 12 Sep 2026 08:47:44 +0200
Message-ID: <20260912065639.158354269@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 7522c9ffaa97041a1a5dfdcb460d2a2b89f860b1 ]

Add the refgen regulator block and use it for the DSI controllers.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250921-refgen-v1-3-9d93e64133ea@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 19b4c47fc973 ("arm64: dts: qcom: lemans: Fix the PCIe iommu-map entries")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/lemans.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/lemans.dtsi b/arch/arm64/boot/dts/qcom/lemans.dtsi
index 085129870e42a..9ea0bf47851b1 100644
--- a/arch/arm64/boot/dts/qcom/lemans.dtsi
+++ b/arch/arm64/boot/dts/qcom/lemans.dtsi
@@ -3979,6 +3979,12 @@ usb_1_qmpphy: phy@88ea000 {
 			status = "disabled";
 		};
 
+		refgen: regulator@891c000 {
+			compatible = "qcom,sa8775p-refgen-regulator",
+				     "qcom,sm8250-refgen-regulator";
+			reg = <0x0 0x0891c000 0x0 0x84>;
+		};
+
 		usb_0: usb@a600000 {
 			compatible = "qcom,sa8775p-dwc3", "qcom,snps-dwc3";
 			reg = <0 0x0a600000 0 0xfc100>;
@@ -4904,6 +4910,8 @@ mdss0_dsi0: dsi@ae94000 {
 				operating-points-v2 = <&mdss_dsi_opp_table>;
 				power-domains = <&rpmhpd SA8775P_MMCX>;
 
+				refgen-supply = <&refgen>;
+
 				#address-cells = <1>;
 				#size-cells = <0>;
 
@@ -4986,6 +4994,8 @@ mdss0_dsi1: dsi@ae96000 {
 				operating-points-v2 = <&mdss_dsi_opp_table>;
 				power-domains = <&rpmhpd SA8775P_MMCX>;
 
+				refgen-supply = <&refgen>;
+
 				#address-cells = <1>;
 				#size-cells = <0>;
 
-- 
2.53.0



