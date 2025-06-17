Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC5E2ECEA9;
	Tue, 17 Jun 2025 15:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175426; cv=none; b=hQoemgdH+TRLwHRnvfvlAuULjnPIR2qRCj6r5AphEQfEd2AFDt7BAgr2PQGUZ6ixo5RV/PUlCn0gNMvG1WHkKE1cUgO4HMGUMK7M5SY8CWjrPNNo1soU46VposvlW3XhSZey6ENS1tJ14z19jWDSCkmXCadIJI2ORYv9B7zuYHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175426; c=relaxed/simple;
	bh=Yg3RDksUnKPSIaYWd1RALRW3PTIz3jZPGCJToQHSUxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxEbMxFPiahwsY0/xGAJ2yU1rbiFEEG5KLpBuy5cqjhnfrtP/fj44IEHQc/AtxLd2ym9NG72Iqaja6RLZ8OHjSLHFv1de5nYMOsqZrhtmtsPJFFbPwTOCiV1eIVngMRKbK484MeU0bt8sSTDRGSXSbUdlz0oCkvJTDuOna+Vu7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EgMZXKwx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EgMZXKwx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B817C4CEE3;
	Tue, 17 Jun 2025 15:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175425;
	bh=Yg3RDksUnKPSIaYWd1RALRW3PTIz3jZPGCJToQHSUxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EgMZXKwxq4DGoRVLVystDoMJJYwv20efsYvfMdkqTlBENTe9bjbHY6UAzym41PKMh
	 Bd2BzNKtQBpmbN8SIutpLnHdUXf+p2HkJ0ZTlO9hzO/IeD+dq3BuFQApuKsv7X3rfy
	 ZxRiM8x2rKOXkCnNYiko1GSZGn5w9ktYpzOJn9lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Minnekhanov <alexeymin@postmarketos.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 175/356] arm64: dts: qcom: sdm660-lavender: Add missing USB phy supply
Date: Tue, 17 Jun 2025 17:24:50 +0200
Message-ID: <20250617152345.257393619@linuxfoundation.org>
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

From: Alexey Minnekhanov <alexeymin@postmarketos.org>

[ Upstream commit dbf62a117a1b7f605a98dd1fd1fd6c85ec324ea0 ]

Fixes the following dtbs check error:

 phy@c012000: 'vdda-pll-supply' is a required property

Fixes: e5d3e752b050e ("arm64: dts: qcom: sdm660-xiaomi-lavender: Add USB")
Signed-off-by: Alexey Minnekhanov <alexeymin@postmarketos.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250504115120.1432282-3-alexeymin@postmarketos.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts b/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts
index ec4245bbfffaf..8221da390e1aa 100644
--- a/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts
+++ b/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts
@@ -107,6 +107,7 @@
 	status = "okay";
 
 	vdd-supply = <&vreg_l1b_0p925>;
+	vdda-pll-supply = <&vreg_l10a_1p8>;
 	vdda-phy-dpdm-supply = <&vreg_l7b_3p125>;
 };
 
-- 
2.39.5



