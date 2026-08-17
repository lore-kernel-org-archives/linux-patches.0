Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB3F424D75;
	Mon, 17 Aug 2026 13:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974666; cv=none; b=Srh3r2oZ23eRnPdxcUQUK/iXCt0PBj4GvTemJei+wrUSGRRMmmbE8PJ0iFjUoxfgqzz2IK0yOIsLaaTKjI96/S98h6b+laykTv2fzHS1btZPGOoiJWNJcCyNmLrLQLvN3IWp3wAdq59pELZ/Hf/noZYkqAVEogC1YPaKf6mGuRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974666; c=relaxed/simple;
	bh=MgaZS1M1cLYDnmwiDn7WZqInU41A8/jCiDYAyPM6izk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S9VmYmcbm/2YAEiTcNBGSB+TltMBU/0xvXaGpMnfSFHFP59VEY+Duzo0BU+I9/eP5qFmdiUWyLdXCrZ2tvbX8y0wmEBdU//TkxB2/iVtLlaA1NpM6e4rNy6hqcS0c51TI4dvEqNLMbKT1xmlywa8A5sAiuNel7eIkrpRdikDnyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fw22X0sg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fw22X0sg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538991F00A3D;
	Mon, 17 Aug 2026 13:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974657;
	bh=H1aIq2nvb1G96qTN4XfMzOysFNwmhRycMHgGOHBgF7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fw22X0sgDb+h7GnFEbujW370LkzM64/biU24H0o2ErggJGHEgQfG67jJsXuZUSv1h
	 wGzBkFJUf0fhj+RVm/5uJbYJABqfoQv3EUfVu+ebbweLzbA8JL+Fbb3g6dkCyXTPaU
	 GB4x7bMQI1QBbnjxFZ7+XauBdToCL1otw6C2bw7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 010/250] arm64: dts: qcom: rename x1p42100 to purwa
Date: Mon, 17 Aug 2026 15:29:31 +0200
Message-ID: <20260817132536.875990928@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

[ Upstream commit ef659a5bd91bed7fae2c2a150f8ecca06599ac03 ]

Follow the example of other platforms and rename X1P42100 to purwa.dtsi.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251030-rename-dts-2-v1-3-80c0b81c4d77@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 4cd774c1feb3 ("arm64: dts: qcom: purwa: Fix GPU IOMMU property")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/{x1p42100.dtsi => purwa.dtsi}    | 0
 arch/arm64/boot/dts/qcom/x1p42100-asus-zenbook-a14.dtsi   | 2 +-
 arch/arm64/boot/dts/qcom/x1p42100-crd.dts                 | 2 +-
 arch/arm64/boot/dts/qcom/x1p42100-hp-omnibook-x14.dts     | 2 +-
 arch/arm64/boot/dts/qcom/x1p42100-lenovo-thinkbook-16.dts | 2 +-
 5 files changed, 4 insertions(+), 4 deletions(-)
 rename arch/arm64/boot/dts/qcom/{x1p42100.dtsi => purwa.dtsi} (100%)

diff --git a/arch/arm64/boot/dts/qcom/x1p42100.dtsi b/arch/arm64/boot/dts/qcom/purwa.dtsi
similarity index 100%
rename from arch/arm64/boot/dts/qcom/x1p42100.dtsi
rename to arch/arm64/boot/dts/qcom/purwa.dtsi
diff --git a/arch/arm64/boot/dts/qcom/x1p42100-asus-zenbook-a14.dtsi b/arch/arm64/boot/dts/qcom/x1p42100-asus-zenbook-a14.dtsi
index 7ccb2076bab66..22470a97e1e39 100644
--- a/arch/arm64/boot/dts/qcom/x1p42100-asus-zenbook-a14.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1p42100-asus-zenbook-a14.dtsi
@@ -6,7 +6,7 @@
 
 /dts-v1/;
 
-#include "x1p42100.dtsi"
+#include "purwa.dtsi"
 #include "x1-asus-zenbook-a14.dtsi"
 
 /delete-node/ &pmc8380_6;
diff --git a/arch/arm64/boot/dts/qcom/x1p42100-crd.dts b/arch/arm64/boot/dts/qcom/x1p42100-crd.dts
index cf999c2cf8d4e..7ed4116b95904 100644
--- a/arch/arm64/boot/dts/qcom/x1p42100-crd.dts
+++ b/arch/arm64/boot/dts/qcom/x1p42100-crd.dts
@@ -5,7 +5,7 @@
 
 /dts-v1/;
 
-#include "x1p42100.dtsi"
+#include "purwa.dtsi"
 #include "x1-crd.dtsi"
 
 /delete-node/ &pmc8380_6;
diff --git a/arch/arm64/boot/dts/qcom/x1p42100-hp-omnibook-x14.dts b/arch/arm64/boot/dts/qcom/x1p42100-hp-omnibook-x14.dts
index 47ab0c5b30341..0f338e457abda 100644
--- a/arch/arm64/boot/dts/qcom/x1p42100-hp-omnibook-x14.dts
+++ b/arch/arm64/boot/dts/qcom/x1p42100-hp-omnibook-x14.dts
@@ -2,7 +2,7 @@
 
 /dts-v1/;
 
-#include "x1p42100.dtsi"
+#include "purwa.dtsi"
 #include "hamoa-pmics.dtsi"
 #include "x1-hp-omnibook-x14.dtsi"
 /delete-node/ &pmc8380_6;
diff --git a/arch/arm64/boot/dts/qcom/x1p42100-lenovo-thinkbook-16.dts b/arch/arm64/boot/dts/qcom/x1p42100-lenovo-thinkbook-16.dts
index f7d372d2e9612..3186e79e862de 100644
--- a/arch/arm64/boot/dts/qcom/x1p42100-lenovo-thinkbook-16.dts
+++ b/arch/arm64/boot/dts/qcom/x1p42100-lenovo-thinkbook-16.dts
@@ -13,7 +13,7 @@
 #include <dt-bindings/pinctrl/qcom,pmic-gpio.h>
 #include <dt-bindings/regulator/qcom,rpmh-regulator.h>
 
-#include "x1p42100.dtsi"
+#include "purwa.dtsi"
 #include "hamoa-pmics.dtsi"
 
 /delete-node/ &pmc8380_6;
-- 
2.53.0



