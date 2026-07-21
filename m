Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B0838D3E5;
	Tue, 21 Jul 2026 15:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648269; cv=none; b=Hht0jogONBG3cT8cd3b2LHg9tdaR7/WUBAq24aBMRYVuRE2LBoWEexkpQLgxvD47RQVLCGnyNQEvm85Lvqioehr/vDbjpSCgAQf4Dv0EEQm6fIkuBUHvqN1lqt9zzEA9WC73h/XVRgna8cDij2CNEkkPrlInCARo+H/ZPIDCy+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648269; c=relaxed/simple;
	bh=jdHrv5M2rFvpfjp4IMkQB/wJWF0Y+d2j8W7+OvWd7fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W49FA1a9+P4NWXW44v7VCG8v4Tt/3aZhIJpdqt5S62WjcL45s9mzRkE0GC8qnWd3ll2h7E/i1oEqcdBX9LnHNt8n7G7ELN/oQ+gRru6bIHgV0ZceGLjZsZPVZY/l0Ve2iNQZTnxun02cJRlqqcTXD/Jnk7i8cvnYx7YGgO63g5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ndXYiNj9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndXYiNj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094041F00A3A;
	Tue, 21 Jul 2026 15:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648267;
	bh=8N01bmhngR140cVao/gkFm5/BSK2yi7MjhD/4lSevHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ndXYiNj9gszi5pAS70sa+VJNTiDxh8y7dL2d2W/gKfR282mKflVGh0nlTdVVroxln
	 yKG3vwpNEl+yGWrdAP+CoFfhlBxhCEReWPgWwqGAojgcVgwYflQcvikfFgwonQobtn
	 Z2SWAdZ62qhTAHyN+Vva2JunTL83gagSyAx67jss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Alexander Koskovich <akoskovich@pm.me>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0082/2077] arm64: dts: qcom: milos: Reduce rmtfs_mem size to 2.5MiB
Date: Tue, 21 Jul 2026 16:55:55 +0200
Message-ID: <20260721152554.630211022@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Koskovich <akoskovich@pm.me>

[ Upstream commit 1f820571ca7c64d3fd5bd9bf653b571cb3350703 ]

The rmtfs_mem region is currently sized at 6MiB but the default for
milos downstream is 2.5MiB. This causes remoteproc crashes on devices
that expect the smaller size:

modem_ac.c:281:Access Control Error: Could not protect the region specified:Start:e1f00000 End:e2180000, PID:1

Reduce the default to 2.5MiB to match the QCOM downstream config, and
override the size for FP6.

Fixes: d9d59d105f98 ("arm64: dts: qcom: Add initial Milos dtsi")
Reviewed-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
Link: https://lore.kernel.org/r/20260323-asteroids-v2-1-1a35fa9e178a@pm.me
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts | 5 +++++
 arch/arm64/boot/dts/qcom/milos.dtsi              | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts b/arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts
index c1899db46e7141..5dc7c950e60d65 100644
--- a/arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts
+++ b/arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts
@@ -786,6 +786,11 @@ &remoteproc_wpss {
 	status = "okay";
 };
 
+&rmtfs_mem {
+	/* Increase the size from 2.5 MiB to 6 MiB */
+	reg = <0x0 0xe1f00000 0x0 0x600000>;
+};
+
 &sdhc_2 {
 	cd-gpios = <&tlmm 65 GPIO_ACTIVE_HIGH>;
 
diff --git a/arch/arm64/boot/dts/qcom/milos.dtsi b/arch/arm64/boot/dts/qcom/milos.dtsi
index a6e463f3885dc6..c4e373872e8c6f 100644
--- a/arch/arm64/boot/dts/qcom/milos.dtsi
+++ b/arch/arm64/boot/dts/qcom/milos.dtsi
@@ -642,7 +642,7 @@ cpusys_vm_mem: cpusys-vm-region@e0600000 {
 
 		rmtfs_mem: rmtfs@e1f00000 {
 			compatible = "qcom,rmtfs-mem";
-			reg = <0x0 0xe1f00000 0x0 0x600000>;
+			reg = <0x0 0xe1f00000 0x0 0x280000>;
 			no-map;
 
 			qcom,client-id = <1>;
-- 
2.53.0



