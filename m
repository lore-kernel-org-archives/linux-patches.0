Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7609E50B8BF;
	Thu, 17 Sep 2026 17:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666811; cv=none; b=U6LBVszN7x2GgYGLjay/hGF/Sb6nKIbZlh/EXL5PttgexbusUhivIfdx5AKigqoxxmbD41EbuhWAs8ooTNl2UGoZ6GRnzDgilFojMShwf/IvtauPjDqs++JpLazQcFyKYUqtU2Zxb09MVfINlciiMK0dNhIsT0YcChQwyntzu20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666811; c=relaxed/simple;
	bh=5XeKzuBe1NqjZs9n3pJzJhgZqVzv8IAUvwJ7E6kyxNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KW3TURA48nfhBB3hOu0iq5NbZgfhuzC3thDmJZEfAeKbArmtCBge76qPwuEoXnLfedz/exa8Yx/XZJNL1pSbEBBq5p0ZH0nu0VBeJPDjl4FYbF7M82vY3KxRw9KKLN9hDG8USTA340r2XDuLorPlehp3a0whLCZcObUBDgmTaZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bvSN+0tB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bvSN+0tB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71E31F000FF;
	Thu, 17 Sep 2026 17:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666810;
	bh=b8XhVUwuiEffK1mvs1JQTlHg7umgiBkvVnGijSkcO3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bvSN+0tBa5AE1BO4H5FzBnsrOtcYLVXrGgRxmK/yQ+0LYuReA1g9dJbNVTUTGDcfy
	 BOi3s5n6kmfbV0L1C59n3wHw5Dc8H38P1vPLI045eN2k4Erc0G8tLzdUXfpNObfc6K
	 Kr1yrmCbFgWboGrSw1Hf9JQ+t6FAzDXIoe0WASJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1132/1250] Revert "arm64: dts: qcom: qcs6490-rb3gen2: Fix the PCIe iommu-map entries"
Date: Thu, 17 Sep 2026 16:15:27 +0100
Message-ID: <20260917151622.933539574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

This reverts commit 1a35eda51a50125d8e58b4f99f82034c58000630.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts b/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts
index 6be927c18482f..18cea88120014 100644
--- a/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts
+++ b/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts
@@ -823,15 +823,15 @@ &pcie1 {
 	pinctrl-0 = <&pcie1_reset_n>, <&pcie1_wake_n>, <&pcie1_clkreq_n>;
 	pinctrl-names = "default";
 
-	iommu-map = <0x0 &apps_smmu 0x1c80 0x0 0x1>,
-		    <0x100 &apps_smmu 0x1c81 0x0 0x1>,
-		    <0x208 &apps_smmu 0x1c84 0x0 0x1>,
-		    <0x210 &apps_smmu 0x1c85 0x0 0x1>,
-		    <0x218 &apps_smmu 0x1c86 0x0 0x1>,
-		    <0x300 &apps_smmu 0x1c87 0x0 0x1>,
-		    <0x400 &apps_smmu 0x1c88 0x0 0x1>,
-		    <0x500 &apps_smmu 0x1c89 0x0 0x1>,
-		    <0x501 &apps_smmu 0x1c90 0x0 0x1>;
+	iommu-map = <0x0 &apps_smmu 0x1c80 0x1>,
+		    <0x100 &apps_smmu 0x1c81 0x1>,
+		    <0x208 &apps_smmu 0x1c84 0x1>,
+		    <0x210 &apps_smmu 0x1c85 0x1>,
+		    <0x218 &apps_smmu 0x1c86 0x1>,
+		    <0x300 &apps_smmu 0x1c87 0x1>,
+		    <0x400 &apps_smmu 0x1c88 0x1>,
+		    <0x500 &apps_smmu 0x1c89 0x1>,
+		    <0x501 &apps_smmu 0x1c90 0x1>;
 
 	status = "okay";
 };
-- 
2.53.0



