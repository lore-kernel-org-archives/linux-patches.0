Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B06372B5E;
	Wed, 30 Sep 2026 19:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795766; cv=none; b=LaZKaczrd8vYinWMQk8j4y8N6oGQ9uUuCTSvY9LniXcDfEaR/4EtFszglYMWa2Nl0p/WnTswyPx3bwXcPgoCGmaardzaVUCKMp3O72TIDSjiQ28ub3LYga6u1CbRa6bG8N1S5KFaCOz8OtBe5x/D4ilh9/tFqxwbOMaPBpLvT0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795766; c=relaxed/simple;
	bh=0kYtGqen5JxuRG7uO0LkBgh5G/6i7qhKWxcZkeWBkXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCp3c8vDP8slt9vda8PvtYNzYCXHKOgC7CtFH9gGvEeIdd0o0h+KwTG5jPP1s+4nDkD+lXowzC+WaMsNobrZ1ppIddrimuHJNn1zT1TCdMmtgIvQSmOaom3xQrf1YWXfAmFwgUXK4OYEc2Kty+rZnz8zUKCSS/nnFEvLheSWBrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dl4A1D/G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dl4A1D/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9A41F000FF;
	Wed, 30 Sep 2026 19:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795765;
	bh=yJGbuNHbS3o27xQkkoON5BbdSOo1Y2nDZ7JfNXGR3zE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dl4A1D/GEPg2Ddej+IjEp+tyaFeMBLP4F0QecPy427hPVG4bl68j56GhEQN6CBRn4
	 kzs9xDVWExFJ90PNR7Sz+kMAMmD4Nwt97aNwHETKI0lJya9N3QuNXtx9dVMyv5Jlon
	 oTw3p+OZec6wdmdhjDSjvZwwH78oJ5ZrbiGEoenE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0677/1193] Revert "arm64: dts: qcom: sm8450: Fix the PCIe iommu-map entries"
Date: Wed, 30 Sep 2026 17:22:41 +0200
Message-ID: <20260930152449.287064797@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit de01d783368c5e11d384af51345b5745c82f352e.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 61c00d878ee48..0dad7b0866ea5 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -1811,8 +1811,8 @@ pcie0: pci@1c00000 {
 				      "aggre0",
 				      "aggre1";
 
-			iommu-map = <0x0   &apps_smmu 0x1c00 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c01 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
+				    <0x100 &apps_smmu 0x1c01 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -1919,8 +1919,8 @@ pcie1: pci@1c08000 {
 				      "ddrss_sf_tbu",
 				      "aggre1";
 
-			iommu-map = <0x0   &apps_smmu 0x1c80 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c81 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c80 0x1>,
+				    <0x100 &apps_smmu 0x1c81 0x1>;
 
 			resets = <&gcc GCC_PCIE_1_BCR>;
 			reset-names = "pci";
-- 
2.53.0



