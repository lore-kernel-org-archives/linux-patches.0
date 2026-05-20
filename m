Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9574363086;
	Wed, 20 May 2026 16:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295701; cv=none; b=fvrDsmO3Bl+mWVnEJeM5PfYw/nD4UN9NlLNGFugPlBM5BCA8wgEbNy/zFtr0OOYwGFhDz/xIwEX4aOvNSKQSpL+QwNrT93Hyqmh8XCsR0A2pwo3QhCLbR3GFuJ2QcAeVIcuKW5zaV36APWH+DcQz8d+HKpOQ/EYiINm0qJT62Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295701; c=relaxed/simple;
	bh=PT5VS9lgDI1YLn+fA1pdDWCqrNNHBaRD964Zw3NKbOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q8tsBbnF10rdWsS8blyL7ayhIFEAGNrLZv8wr4Kfagsa+xC5lqX2Si+EBiZbRbmPMLdiKLQhMDgGStm1oBhvScy0Xx67NLb/u/Pj1xmbzUUchYWKg0vMHGUMr+JjMZagm3HuU6a0uZmFtKq9SpX0FOaJOdU4f/PxDEALp5KATO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tF3H7t1F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tF3H7t1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D358F1F00893;
	Wed, 20 May 2026 16:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295700;
	bh=BRuR+mRl8EtSGwpbniwzaZDcSp6e2y8M2F9XR2dhj2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tF3H7t1F0Gb98prslaQedSbkHV67ClWMo5fsibHgGxYXwzuOTJ+Nk9C/vgP4ZGMo1
	 uE34OaIOcQIzoTX4HllGsVqGXVseUB5Q2gUic4DmT3hutw/3m0pAz7MRvRIFy34TPn
	 cYz/ziaZ20iaelT1ynChlxT5BAWZADoZfxfv6hVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0478/1146] arm64: dts: qcom: sm6125-xiaomi-ginkgo: Correct reserved memory ranges
Date: Wed, 20 May 2026 18:12:08 +0200
Message-ID: <20260520162159.010460924@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Czémán <barnabas.czeman@mainlining.org>

[ Upstream commit 242801cc24e865cb525ef7d826ce6ebeffcad606 ]

The device was crashing on high memory load because the reserved memory
ranges was wrongly defined. Correct the ranges for avoid the crashes.
Change the ramoops memory range to match with the values from the recovery
to be able to get the results from the device.

Fixes: 9b1a6c925c88 ("arm64: dts: qcom: sm6125: Initial support for xiaomi-ginkgo")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Link: https://lore.kernel.org/r/20260126-xiaomi-willow-v3-2-aad7b106c311@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/sm6125-xiaomi-ginkgo.dts    | 41 +++++++++++++------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts b/arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts
index bf03226a6f854..d5e5abdb3b2ff 100644
--- a/arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts
+++ b/arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts
@@ -13,6 +13,12 @@
 #include "sm6125.dtsi"
 #include "pm6125.dtsi"
 
+/delete-node/ &adsp_pil_mem;
+/delete-node/ &cont_splash_mem;
+/delete-node/ &gpu_mem;
+/delete-node/ &ipa_fw_mem;
+/delete-node/ &ipa_gsi_mem;
+
 / {
 	model = "Xiaomi Redmi Note 8";
 	compatible = "xiaomi,ginkgo", "qcom,sm6125";
@@ -36,28 +42,39 @@ framebuffer0: framebuffer@5c000000 {
 	};
 
 	reserved-memory {
-		debug_mem: debug@ffb00000 {
-			reg = <0x0 0xffb00000 0x0 0xc0000>;
+		adsp_pil_mem: adsp_pil_mem@55300000 {
+			reg = <0x0 0x55300000 0x0 0x2200000>;
 			no-map;
 		};
 
-		last_log_mem: lastlog@ffbc0000 {
-			reg = <0x0 0xffbc0000 0x0 0x80000>;
+		ipa_fw_mem: ipa_fw_mem@57500000 {
+			reg = <0x0 0x57500000 0x0 0x10000>;
 			no-map;
 		};
 
-		pstore_mem: ramoops@ffc00000 {
-			compatible = "ramoops";
-			reg = <0x0 0xffc40000 0x0 0xc0000>;
-			record-size = <0x1000>;
-			console-size = <0x40000>;
-			pmsg-size = <0x20000>;
+		ipa_gsi_mem: ipa_gsi_mem@57510000 {
+			reg = <0x0 0x57510000 0x0 0x5000>;
+			no-map;
 		};
 
-		cmdline_mem: memory@ffd00000 {
-			reg = <0x0 0xffd40000 0x0 0x1000>;
+		gpu_mem: gpu_mem@57515000 {
+			reg = <0x0 0x57515000 0x0 0x2000>;
 			no-map;
 		};
+
+		framebuffer@5c000000 {
+			reg = <0x0 0x5c000000 0x0 (2340 * 1080 * 4)>;
+			no-map;
+		};
+
+		/* Matching with recovery values to be able to get the results. */
+		ramoops@61600000 {
+			compatible = "ramoops";
+			reg = <0x0 0x61600000 0x0 0x400000>;
+			record-size = <0x80000>;
+			pmsg-size = <0x200000>;
+			console-size = <0x100000>;
+		};
 	};
 
 	extcon_usb: extcon-usb {
-- 
2.53.0



