Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2772C3262;
	Mon,  2 Jun 2025 14:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872868; cv=none; b=lnkWihefwweb54tJ/ExgLMJdaE/eq5OiwB2UhZCMTb26KPuziIbBEqHkFCEwyj6iBBABcoqxpIytWPWNp5BuT251wtWJSh6Zl2euz0hXnm08VbIgUI1dFwn9SjC7fki9QXMcLZz6bXff2fjmbovRZVugG8UxO5NHcqYtBT6Dg8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872868; c=relaxed/simple;
	bh=H/KpKZVkrPVl7Zvdvcl9JR4voyk6G8jcotwB0aE73r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2tvGcAZ4UtMXIR1M1dxtZNkGXxUY7LCjoXLFm6xjrHIVhOD0tTQthAbnoV2ScKfdlcaL1jWsSAH4jX6lYAuye57tbkdp6m0LHaBOYhsQ3I1DUcw7ocMgtOIgClkY+pZHi2ITR2qHV4PFGt/gwZvsaT1JUDKDULItRiwPTp7av8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hOU63MnS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hOU63MnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC8CC4CEEB;
	Mon,  2 Jun 2025 14:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872867;
	bh=H/KpKZVkrPVl7Zvdvcl9JR4voyk6G8jcotwB0aE73r0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hOU63MnSFQiBLWt9HQKUT584Xpq2gp8J4vSgDD9gzQrZNTjodPF3KzfA7eLolzn3A
	 4hzEeoM5ARv5qXn2VK2XX+qhUQHJrr+X5whDwu9djmoPwCTGPkx5UPIfJy+7Ux2Gg4
	 NnA+udzpafln4bX6fCjJmjnhQuXDDwDpmzbpf6hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Neha Malcom Francis <n-francis@ti.com>,
	Jai Luthra <jai.luthra@linux.dev>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.12 20/55] arm64: dts: ti: k3-am62x: Rename I2C switch to I2C mux in OV5640 overlay
Date: Mon,  2 Jun 2025 15:47:37 +0200
Message-ID: <20250602134239.076346709@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
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

From: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>

commit b22cc402d38774ccc552d18e762c25dde02f7be0 upstream.

The OV5640 device tree overlay incorrectly defined an I2C switch
instead of an I2C mux. According to the DT bindings, the correct
terminology and node definition should use "i2c-mux" instead of
"i2c-switch". Hence, update the same to avoid dtbs_check warnings.

Fixes: 635ed9715194 ("arm64: dts: ti: k3-am62x: Add overlays for OV5640")
Cc: stable@vger.kernel.org
Signed-off-by: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
Reviewed-by: Neha Malcom Francis <n-francis@ti.com>
Reviewed-by: Jai Luthra <jai.luthra@linux.dev>
Link: https://lore.kernel.org/r/20250415111328.3847502-8-y-abhilashchandra@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62x-sk-csi2-ov5640.dtso      |    2 +-
 arch/arm64/boot/dts/ti/k3-am62x-sk-csi2-tevi-ov5640.dtso |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/ti/k3-am62x-sk-csi2-ov5640.dtso
+++ b/arch/arm64/boot/dts/ti/k3-am62x-sk-csi2-ov5640.dtso
@@ -22,7 +22,7 @@
 	#size-cells = <0>;
 	status = "okay";
 
-	i2c-switch@71 {
+	i2c-mux@71 {
 		compatible = "nxp,pca9543";
 		#address-cells = <1>;
 		#size-cells = <0>;
--- a/arch/arm64/boot/dts/ti/k3-am62x-sk-csi2-tevi-ov5640.dtso
+++ b/arch/arm64/boot/dts/ti/k3-am62x-sk-csi2-tevi-ov5640.dtso
@@ -22,7 +22,7 @@
 	#size-cells = <0>;
 	status = "okay";
 
-	i2c-switch@71 {
+	i2c-mux@71 {
 		compatible = "nxp,pca9543";
 		#address-cells = <1>;
 		#size-cells = <0>;


