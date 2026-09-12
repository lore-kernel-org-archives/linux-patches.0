Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8A13542F8;
	Sat, 12 Sep 2026 08:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200330; cv=none; b=SrWKlPlJbR/qKPm7GzJ8FWid456cxut+LNeEtfe2V4hCJc9J0EaDqQQjawbRyK0G4KiNgHuOeuYje6B7ljjn+CYP4Ac/7flozKlT1B8EtR7kffKpOTpQvtum9TPOsv2ufHf24eFCf76Fnod7l92G+kLE6OWNYBQi5uF/6/qFMGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200330; c=relaxed/simple;
	bh=KS9C6UJnM+g9PdpOsxwJAZKrktHCPUYAstdT9z4DNDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+TSCQbFBxpRfNwtxDeCZKPO0ZgESB5HScs07MAne2CVSjZ+OJ02XtBBFbElfoeDzjvpScGx8ci8KW9Lu+K26vXo+EWovrdXO2JnSxQdZz9A2RMTyGmYJsS54XbPNBwoqQwcSo+076xSd7LzCrPyZ7kikxEDfIGDLBKDFXDGVPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JKp87AXA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JKp87AXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905641F000FF;
	Sat, 12 Sep 2026 08:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200329;
	bh=7LKAS70in0haZLvy51GTkzxGeOs5CpxBYiRpbx9hSZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JKp87AXAhLuYzAPXGwvlKT7eQHt4p5tCuh5q3MZpSJcggPsqg07NAemgfj2dbdi9F
	 V6aPPQcbtQzXoYVRCj2Px5uTF+7Ff1Fa44CE45hyyOD88I6SZypoQd0G9jBuWfgpMn
	 VcaMPpjR21ohSxLyFhXK+7AN7WP46yaO9Np0+roQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inochi Amaoto <inochiama@gmail.com>,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0731/1815] riscv: dts: spacemit: Make dtschema recognize the etherent PHY correctly on K3 com260 board
Date: Sat, 12 Sep 2026 08:41:21 +0200
Message-ID: <20260912065706.061452588@linuxfoundation.org>
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

From: Inochi Amaoto <inochiama@gmail.com>

[ Upstream commit bff5af3c934740481a316c5ae1cd4a09a43134d0 ]

Since the previous commit does not change the phy node name,
the dtschema can not recognize the type of the ethernet phy,
so the following error is produced:

/arch/riscv/boot/dts/spacemit/k3-com260-ifx.dtb: phy@1 (ethernet-phy-id001c.c916): $nodename:0: 'phy@1' does not match '^ethernet-phy(@[a-f0-9]+)?$'
        from schema $id: http://devicetree.org/schemas/net/realtek,rtl82xx.yaml
/arch/riscv/boot/dts/spacemit/k3-com260-ifx.dtb: phy@1 (ethernet-phy-id001c.c916): Unevaluated properties are not allowed ('reg', 'reset-assert-us', '
reset-deassert-us', 'reset-gpios' were unexpected)
        from schema $id: http://devicetree.org/schemas/net/realtek,rtl82xx.yaml

Change the nodename to make the dtschema can recognize the right
PHY type.

Fixes: 9db839d52ccd ("riscv: dts: spacemit: Fix phy id check for the phy on com260 board")
Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Link: https://patch.msgid.link/20260729012418.154652-2-inochiama@gmail.com
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/spacemit/k3-com260.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/spacemit/k3-com260.dtsi b/arch/riscv/boot/dts/spacemit/k3-com260.dtsi
index 2a07cd8f2a562..c7a04a338d080 100644
--- a/arch/riscv/boot/dts/spacemit/k3-com260.dtsi
+++ b/arch/riscv/boot/dts/spacemit/k3-com260.dtsi
@@ -173,7 +173,7 @@ &eth1 {
 	status = "okay";
 
 	mdio {
-		phy1: phy@1 {
+		phy1: ethernet-phy@1 {
 			compatible = "ethernet-phy-id001c.c916";
 			reg = <1>;
 			reset-gpios = <&gpio 1 5 GPIO_ACTIVE_LOW>;
-- 
2.53.0



