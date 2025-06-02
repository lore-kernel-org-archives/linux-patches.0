Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA05A1E1A3F;
	Mon,  2 Jun 2025 13:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872781; cv=none; b=pQ/j5iPWASmu50DDhCuAR/D4HVkYOPuGVhKqr2ytRZw9uzgrCvD+TxDf3Lupl6ToDQjgpd0Pj7W+Y3lnKiuSrmfx0C/ZSFdxCayEW+6aZh/wFhHw4Bf3nNXeaiKwM6pw0yNfRvq+79MAaxcy4w3lr9z7yoj+M2D7zWJEWg6vYLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872781; c=relaxed/simple;
	bh=Wk7aPHnliwnElzbS4Ph6NfXEen9aqTq6qv4FAATPvJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qENrOZcwWYWSgTo+ks2xq5E+Bv8T4dcUlzJ/hSIKrD/3GDcQwEPe32FWMJkuzByaRHTLMJdMxYoThd5BttIWUhmLjzpPGtEZ0GDdnPxhd+6JdfsgQzJN0BBzXf3ctiVPTJYp6N97KuaQLQEWPnR/8W9saQv23ibtUZRnL6Qg/Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZDHxRHQM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZDHxRHQM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5D2C4CEEB;
	Mon,  2 Jun 2025 13:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872780;
	bh=Wk7aPHnliwnElzbS4Ph6NfXEen9aqTq6qv4FAATPvJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZDHxRHQMd+tH5/AUR5W6kGNsXSmv3IGww2kFO14T/yIr20gWFs3UrFF4vDYPrftR6
	 X95s4LB7eydBpZbNDTXb/jC/xYZr+LzHDJjVOiNZ0GUc+GFzTt7rzBIY2jJSXqCxbw
	 kTWYHZdsM5jPwxiSIsNMJ4RORRi6J66F+ykOZWpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Neha Malcom Francis <n-francis@ti.com>,
	Jai Luthra <jai.luthra@linux.dev>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.14 36/73] arm64: dts: ti: k3-j721e-sk: Remove clock-names property from IMX219 overlay
Date: Mon,  2 Jun 2025 15:47:22 +0200
Message-ID: <20250602134243.120258886@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


