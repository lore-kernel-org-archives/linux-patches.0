Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6001359A6F;
	Wed, 20 May 2026 17:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298526; cv=none; b=Mz8uhuP9wWruIbXdy8UvMPe66cFLTZ4riD4E4oejrmzowRZyojyWYitsDmeHTDeN38OqqXIRWE0IXg46QBczhhI0r2gLasoo7KbYiHsxm/knLo4kgz8LrHxjNWnzfgasuDaMEEBUpu+WMGXYkcQ7qoT+95RmbiIaHgX5r/Cy0XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298526; c=relaxed/simple;
	bh=MP15r/+URbnaVYHIn3IvP+ssA7iXaRna2UHCtbaPhKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkiAKKg4phHUM+ptdu4XxsuYfqwBQZDyDTSF3JuxMJNlHKnMF/TONejQak9QjqLc7njsbu6VamErzMnEhkaZ9Z894vkh0lssCqfyeMubRp8vRIRq6pyVfI9olGWaVUNdlQSR82qvgNInuuth0+ofgpGo4bvRTFddgnv+0P3oJzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7Z5bjN7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7Z5bjN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4F91F000E9;
	Wed, 20 May 2026 17:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298525;
	bh=KRPOC2XqBSf+Z3WEVXq5V/9Wabe21SvadRrS/pW8vnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m7Z5bjN7SgzEP3amviSyLaWIlutilc8D1LmrciM71wL7rTq+5WEd158lR+eb0RGFo
	 gliY2ra/Z7E0BRM0NfPYpsgmGx9BNyYSWrgfg19DlJnscSxws/P3OcpCYOglgvcCld
	 POHS9Liut49cTNDo6w9TPvP8GNx4x9Dh+mls3/50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 403/957] arm64: dts: qcom: sm8750: Fix GIC_ITS range length
Date: Wed, 20 May 2026 18:14:46 +0200
Message-ID: <20260520162143.263723546@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit c2f1f8874fda674af1efaa9a90efbdea8b6834ff ]

Currently, the GITS_SGIR register is cut off. Fix it up.

Fixes: 068c3d3c83be ("arm64: dts: qcom: Add base SM8750 dtsi")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260317-topic-its_range_fixup-v1-6-49be8076adb1@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8750.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8750.dtsi b/arch/arm64/boot/dts/qcom/sm8750.dtsi
index 33963fee1f699..3e1d1133792bb 100644
--- a/arch/arm64/boot/dts/qcom/sm8750.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8750.dtsi
@@ -3299,7 +3299,7 @@ intc: interrupt-controller@16000000 {
 
 			gic_its: msi-controller@16040000 {
 				compatible = "arm,gic-v3-its";
-				reg = <0x0 0x16040000 0x0 0x20000>;
+				reg = <0x0 0x16040000 0x0 0x40000>;
 
 				msi-controller;
 				#msi-cells = <1>;
-- 
2.53.0



