Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F43137C0E2;
	Sat, 12 Sep 2026 07:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197687; cv=none; b=jeVti0u9f5RzOBNRKzRQkmDoKNoTuBPxovMTVn2TfIZgsJxqpvbnh+mwtkAUB31fKfOKwGHQaMZ+MaeIblxCA2VvFw4T8TifQCJhFUtUK5BpV4HS2WNMJAcYcQKO0lf/IqHPcUjGC2ksG6jTNemwz9WyViDmf5VRdJt0O7FblQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197687; c=relaxed/simple;
	bh=EFVmzhgzOQLCwSpsRpkhX86wltCSl1pkUmDQB+1rNNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4CCShuKik3YG/RcEllMgrFQVZ17qBMPXy+ceuAwRdotKLrh/lEXEYzqewDK0nbKsi/4y+K3N4Bnj+D7Kc7zxc4Kw4KI5yYAunWzMJKtN/hCgOrhrDj39SbtqXUznQFT6KgCBzy1av5OXD7u+BL4FVuffq5FfCmfqBMYyQB/AZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F04VwC1S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F04VwC1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0456D1F000FF;
	Sat, 12 Sep 2026 07:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197686;
	bh=JkEGSdbyMxUnpA21V68WLHyZ7nNfVbALOHJbVHdsoMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F04VwC1S5XbE9iDbdYRboH1W+CmgNAgVVhFC8vbv/rcnBDvKuRaf2VNqzbzR5W3uN
	 IX84JY0sgk3laY2af//E6tmOK/H+qKCFPzBXRkCHkXRAtK9QAKTN1GuyzG0jAAcJZ8
	 f133b+NwmKWZp3OH9NyljrszBZDjklQ0zlNwllOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0224/1815] arm64: dts: qcom: sc8280xp: sort reserved memory regions
Date: Sat, 12 Sep 2026 08:32:54 +0200
Message-ID: <20260912065654.253352272@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 53275adfb07d416a32004612227265939d0df00d ]

Move memory region reserved for the GPU to its proper place in DT.

Fixes: 6e9612ced0c9 ("arm64: dts: qcom: sc8280xp: create common zap-shader node")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260515-iris-sc8280xp-v7-2-2e21f6db1897@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index b0de9e262f299..d7d1279008fa6 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -692,11 +692,6 @@ reserved-region@85b00000 {
 			no-map;
 		};
 
-		pil_gpu_mem: gpu-mem@8bf00000 {
-			reg = <0 0x8bf00000 0 0x2000>;
-			no-map;
-		};
-
 		pil_adsp_mem: adsp-region@86c00000 {
 			reg = <0 0x86c00000 0 0x2000000>;
 			no-map;
@@ -712,6 +707,11 @@ pil_nsp0_mem: cdsp0-region@8a100000 {
 			no-map;
 		};
 
+		pil_gpu_mem: gpu-mem@8bf00000 {
+			reg = <0 0x8bf00000 0 0x2000>;
+			no-map;
+		};
+
 		pil_nsp1_mem: cdsp1-region@8c600000 {
 			reg = <0 0x8c600000 0 0x1e00000>;
 			no-map;
-- 
2.53.0



