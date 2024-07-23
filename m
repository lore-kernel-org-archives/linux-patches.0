Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2605C13C3F5;
	Tue, 23 Jul 2024 18:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759890; cv=none; b=ckqZjUwFw01dOkS8+rlOYYa5lmxy078XfLgnra9gcEqb0YIw1c3DputnZ/4A89ssYoX8m55bcOO6fDYQBn1tejS7nmKBXaoPGtS8LJNpRW/gFbE104ChQrzawPZJnpVPxf/37Dp2LOxDwxTOOk6QdzX7BsPaZvCzTIHW7rpRl64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759890; c=relaxed/simple;
	bh=q4SkxXtfY4PeETKlI6OpeIfeXQ1xbBv0Wz8HVpF+3AI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wadq5/uMuAGLmbfP/H8E7D1mBSUrM0kLsVH6Kyc0OekNzfVkDqLY6Gnn9NajlHxhUA5zLxqY1bcAxcZ6VdGwMZPyfUk1ztDKVb1EX9fmbmYYYnvcIaDzTaPB9qpvKcXGBeP3HP40c/i+B4qmzbrVEU4dEgOMK0IiZMH7zCCMb2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9TP6rKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9TP6rKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F9DC4AF0A;
	Tue, 23 Jul 2024 18:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759890;
	bh=q4SkxXtfY4PeETKlI6OpeIfeXQ1xbBv0Wz8HVpF+3AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l9TP6rKKImi/HUiSxectNbsFFmUo5eI04bpdNU8o8PTdzShZALMiE66UQ9QRqPRct
	 plSHrEShdIXpWa8hXu7bhPNeO1ryFJ/McaNqLc32ZopCh2B0lZU24rQeM0IUo0Q3Xi
	 GDLOpeCBDsNgoeF/NsbQLbo7IsXrKTaNNpyEu5FU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 031/163] LoongArch: Fix GMACs phy-mode definitions in dts
Date: Tue, 23 Jul 2024 20:22:40 +0200
Message-ID: <20240723180144.673573994@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit eb36e520f4f1b690fd776f15cbac452f82ff7bfa ]

The GMAC of Loongson chips cannot insert the correct 1.5-2ns delay. So
we need the PHY to insert internal delays for both transmit and receive
data lines from/to the PHY device. Fix this by changing the "phy-mode"
from "rgmii" to "rgmii-id" in dts.

Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/boot/dts/loongson-2k0500-ref.dts | 4 ++--
 arch/loongarch/boot/dts/loongson-2k1000-ref.dts | 4 ++--
 arch/loongarch/boot/dts/loongson-2k2000-ref.dts | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/loongarch/boot/dts/loongson-2k0500-ref.dts b/arch/loongarch/boot/dts/loongson-2k0500-ref.dts
index 8aefb0c126722..a34734a6c3ce8 100644
--- a/arch/loongarch/boot/dts/loongson-2k0500-ref.dts
+++ b/arch/loongarch/boot/dts/loongson-2k0500-ref.dts
@@ -44,14 +44,14 @@ linux,cma {
 &gmac0 {
 	status = "okay";
 
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	bus_id = <0x0>;
 };
 
 &gmac1 {
 	status = "okay";
 
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	bus_id = <0x1>;
 };
 
diff --git a/arch/loongarch/boot/dts/loongson-2k1000-ref.dts b/arch/loongarch/boot/dts/loongson-2k1000-ref.dts
index ed4d324340411..aaf41b565805a 100644
--- a/arch/loongarch/boot/dts/loongson-2k1000-ref.dts
+++ b/arch/loongarch/boot/dts/loongson-2k1000-ref.dts
@@ -43,7 +43,7 @@ linux,cma {
 &gmac0 {
 	status = "okay";
 
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-handle = <&phy0>;
 	mdio {
 		compatible = "snps,dwmac-mdio";
@@ -58,7 +58,7 @@ phy0: ethernet-phy@0 {
 &gmac1 {
 	status = "okay";
 
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-handle = <&phy1>;
 	mdio {
 		compatible = "snps,dwmac-mdio";
diff --git a/arch/loongarch/boot/dts/loongson-2k2000-ref.dts b/arch/loongarch/boot/dts/loongson-2k2000-ref.dts
index 74b99bd234cc3..ea9e6985d0e9f 100644
--- a/arch/loongarch/boot/dts/loongson-2k2000-ref.dts
+++ b/arch/loongarch/boot/dts/loongson-2k2000-ref.dts
@@ -92,7 +92,7 @@ phy1: ethernet-phy@1 {
 &gmac2 {
 	status = "okay";
 
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	phy-handle = <&phy2>;
 	mdio {
 		compatible = "snps,dwmac-mdio";
-- 
2.43.0



