Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7041035CB7D;
	Tue, 16 Dec 2025 12:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887142; cv=none; b=UxWFH2qxm3SsNLLaV/S/4EatUEigJGzcieqeAHHmTwLQP2x74ijzYxcVlVJvi0lHPkVTuwNc9RcKKs6P5dxr3XEq4WZfNMMR1pG9BIFXoFpcz4wncP43OuADZeELLg/w+SSwWpPB8TTYSBdOeRLSdXO5iR1UtPTmymF7Igp9gRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887142; c=relaxed/simple;
	bh=3bw4jfvUT9hQiDQnsDd/XFPFn3NNNGUM/VF7wUb5NTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQB2fXYJ9YOlY+isVXMUJfIISqy1d73pWBWH9saSo58aJww59sT/3J+HoVRy0Ms9rXDUbJxFEeeWEmapK1knajHGPqFb8RycVQ99JeiKcrr7AT5SxCyC9Nq1IP00jNzfqJCr4ekq3562EL2VwTK2mtpCo4tNpCatNdUiU/u+sLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WgHRmre/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WgHRmre/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36EAC4CEF1;
	Tue, 16 Dec 2025 12:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887142;
	bh=3bw4jfvUT9hQiDQnsDd/XFPFn3NNNGUM/VF7wUb5NTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WgHRmre/yTsYG43my4/DFsCyrESTzZyg7ACCMbouqg04gULllzmZ1SdER4RUTCDQL
	 SarZUr6EG3eGacQct4AGGHm8B7F1p6CY8u7MDO7yZsS3r8yzJzgGa4lvzrjLd4c2Yb
	 W+q4z7qY5KXhwnzFuIVehw+G/BGtx2OLXaRUewtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 132/614] ARM: dts: renesas: r9a06g032-rzn1d400-db: Drop invalid #cells properties
Date: Tue, 16 Dec 2025 12:08:19 +0100
Message-ID: <20251216111406.118025836@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit ca7fffb6e92a7c93604ea2bae0e1c89b20750937 ]

The 'ethernet-ports' node in the SoC DTSI handles them already. Fixes:

    arch/arm/boot/dts/renesas/r9a06g032-rzn1d400-db.dtb: switch@44050000 (renesas,r9a06g032-a5psw): Unevaluated properties are not allowed ('#address-cells', '#size-cells' were unexpected)
	    from schema $id: http://devicetree.org/schemas/net/dsa/renesas,rzn1-a5psw.yaml#

Fixes: 5b6d7c3c5861ad4a ("ARM: dts: r9a06g032-rzn1d400-db: Add switch description")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20251007104624.19786-2-wsa+renesas@sang-engineering.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/renesas/r9a06g032-rzn1d400-db.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/renesas/r9a06g032-rzn1d400-db.dts b/arch/arm/boot/dts/renesas/r9a06g032-rzn1d400-db.dts
index 3258b2e274346..4a72aa7663f25 100644
--- a/arch/arm/boot/dts/renesas/r9a06g032-rzn1d400-db.dts
+++ b/arch/arm/boot/dts/renesas/r9a06g032-rzn1d400-db.dts
@@ -308,8 +308,6 @@ &rtc0 {
 
 &switch {
 	status = "okay";
-	#address-cells = <1>;
-	#size-cells = <0>;
 
 	pinctrl-names = "default";
 	pinctrl-0 = <&pins_eth3>, <&pins_eth4>, <&pins_mdio1>;
-- 
2.51.0



