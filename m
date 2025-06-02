Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8322C3247;
	Mon,  2 Jun 2025 13:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872218; cv=none; b=GsvX4HKultGL/iR9SWlX85tfqw5J6mbF/zPuFj+xuyq973twB56Fm68BzkN/Bn2PaFHv9d7JDYnFmvvcmrjIy+CLYkDfX4vqEK66hacSb1AykJjwiaQVkBstWSKKbC6z2gMMKszqrwEekfka2EmF2NvrLkZ8AcV48xHTS/OssmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872218; c=relaxed/simple;
	bh=OGojc85ugd54Ojk5ai7O7bq4KOuI0j73/BfnlKVAAf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jY+e2AI1PTcYSVSadg/bNThTpMhtUO/m2jW+QFwL+xOYlEaxx3TeogIhmzWw3/ds8DDC6hQoSzj6XoKYFauyohd6R33EoZb5snFuF6n7jU3jlGFLXD/kuI4Wfp6hkAnqeLvfXY6//xewwEtZ4FV2tZXcQoxSk2m0++H8z2owdh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b0oD+C/o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b0oD+C/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D576C4CEEB;
	Mon,  2 Jun 2025 13:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872218;
	bh=OGojc85ugd54Ojk5ai7O7bq4KOuI0j73/BfnlKVAAf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b0oD+C/og/CViyjrKThOw0ldpnT1xipGFiSF1XlU++h1F3bguajjx7/j0UqSV+XBX
	 8AkLaCH9kn4SQBG2okuaA1L0re0lua0YVvj7HSGw2iwTipib74rsThcPnpu8uxbqF9
	 xpYA0sP5BM4ihWR9KlHYAMExM0zIPKXmDcRcmaFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Neha Malcom Francis <n-francis@ti.com>,
	Jai Luthra <jai.luthra@linux.dev>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.15 36/49] arm64: dts: ti: k3-j721e-sk: Remove clock-names property from IMX219 overlay
Date: Mon,  2 Jun 2025 15:47:28 +0200
Message-ID: <20250602134239.354521646@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
References: <20250602134237.940995114@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>

commit 24ab76e55ef15450c6681a2b5db4d78f45200939 upstream.

The IMX219 sensor device tree bindings do not include a clock-names
property. Remove the incorrectly added clock-names entry to avoid
dtbs_check warnings.

Fixes: f767eb918096 ("arm64: dts: ti: k3-j721e-sk: Add overlay for IMX219")
Cc: stable@vger.kernel.org
Signed-off-by: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
Reviewed-by: Neha Malcom Francis <n-francis@ti.com>
Reviewed-by: Jai Luthra <jai.luthra@linux.dev>
Link: https://lore.kernel.org/r/20250415111328.3847502-4-y-abhilashchandra@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-j721e-sk-csi2-dual-imx219.dtso |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/arm64/boot/dts/ti/k3-j721e-sk-csi2-dual-imx219.dtso
+++ b/arch/arm64/boot/dts/ti/k3-j721e-sk-csi2-dual-imx219.dtso
@@ -34,7 +34,6 @@
 		reg = <0x10>;
 
 		clocks = <&clk_imx219_fixed>;
-		clock-names = "xclk";
 
 		port {
 			csi2_cam0: endpoint {
@@ -56,7 +55,6 @@
 		reg = <0x10>;
 
 		clocks = <&clk_imx219_fixed>;
-		clock-names = "xclk";
 
 		port {
 			csi2_cam1: endpoint {


