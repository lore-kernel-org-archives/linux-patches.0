Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82D62ECE89;
	Tue, 17 Jun 2025 16:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176347; cv=none; b=azkPGEKCxzgPRnqN1tMrQ/ccGAxM2vuJyMWCRYV3U/OZbgFLHkeOKzmI5Mwx01mFTJGcvcw/UxrHlLR5bVSmivX9CLHiWOGN40seZBAeKJY9POwLgr40ChOzbnopzgBghix4nxYjUQciG+jMQoZ+o8Lvig+v+DZWrjOZal2TpZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176347; c=relaxed/simple;
	bh=OKh+BbTCiOMVnlXP0BqfrhFcWQvy9PMRzE81zwpDtg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4YO1DeX7Q7U4hDN0qJJOOLiswsRzN7hzT6xV4n46AO2Sf5mNbIcK2cYhGprd0CFOEjcffM3FFQD3wftipE8F/Tu4FGfWJB8Xc5vXWyDAlBQBhyPOrv8FmPDXibWJjP+NEckNt8Xzbjw3apRxnAdmChuk70FVaeccWeBTaVlEG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpA7f2D/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpA7f2D/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DF4C4CEE3;
	Tue, 17 Jun 2025 16:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176347;
	bh=OKh+BbTCiOMVnlXP0BqfrhFcWQvy9PMRzE81zwpDtg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpA7f2D/qhZ4Q+cFqnKo0EFoB6CUrtM3t60wodb/aH+UMD1UY7+avTo6xAloNCxbW
	 bqoxZYnXZq8L6LeQN6cw8TijD8j7+okb/DYJ76DjjAwTmLPCu3s3Kt/S/gKuSWKUiZ
	 D27JiocUHiALiUfas1CL5mB5GTO3bvjgAcKjGkRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 221/512] arm64: dts: qcom: x1e80100-romulus: Keep L12B and L15B always on
Date: Tue, 17 Jun 2025 17:23:07 +0200
Message-ID: <20250617152428.581178555@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 0783c8b3c06b9cf16b5108d558e2faffb8c533b7 ]

These regulators power some electronic components onboard. They're
most likely kept online by other pieces of firmware, but you can never
be sure enough.

Fixes: 09d77be56093 ("arm64: dts: qcom: Add support for X1-based Surface Laptop 7 devices")
Reported-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20250304-topic-sl7_vregs_aon-v1-1-b2dc706e4157@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi b/arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi
index 19da90704b7cb..001a9dc0a4baa 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi
@@ -267,6 +267,7 @@
 			regulator-min-microvolt = <1200000>;
 			regulator-max-microvolt = <1200000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_l13b: ldo13 {
@@ -288,6 +289,7 @@
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_l16b: ldo16 {
-- 
2.39.5



