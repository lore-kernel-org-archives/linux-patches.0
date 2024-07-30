Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1841078F;
	Tue, 30 Jul 2024 16:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358290; cv=none; b=VKPluvXCLb4RY5XksG2Vxu8/R4O+Gvq3E1xE6Ohn/4URz2B3y5fDxDVKC0i3zGC7SZkaGZjDM08vkDgxny/bRtMTVCBzqoraXzJqzA4VPEOB8t2mmVOom5pD3vB5Qf888jPnOyhSkn/ciyCoHOSZSM1aAOS1OTDahhhkodka3Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358290; c=relaxed/simple;
	bh=JP0aczD3cjPfHlDdwjz4kk38X3hJBPXt+EC9FDms+pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6Q1m9pQA4mZ8ki7vtlYq85+fb9YVg7ePJJxpYZnT3mIa6OFGtNVviRHPrLo0xh8XPKhMXO+rvMuHM15ElEmome5F02idBMpVllmClFFO0oOlIaJ85TpqsbQ7gLGkFrMQs2n2zVDTwSevGM2WZx5khHfVKAjUQTk0cHgseXYywE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1oYSC5OQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1oYSC5OQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F57C32782;
	Tue, 30 Jul 2024 16:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358290;
	bh=JP0aczD3cjPfHlDdwjz4kk38X3hJBPXt+EC9FDms+pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1oYSC5OQqz6ymkNhjxjajtg1AWebViRRFbaA+xDJ/kbQSp1wspSkqaDqTZxhG3PBx
	 Lfvds1gUeaXXj18R1XsYbCKaX/Md1pMAnQRkEhuyF7LQD0WwwGOj7ihmlNVqqB7dcm
	 uO5x5HVyqR15gKaCZG4bMOBtF2iXctHtc0W9ml3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.1 374/440] MIPS: dts: loongson: Fix GMAC phy node
Date: Tue, 30 Jul 2024 17:50:07 +0200
Message-ID: <20240730151630.421427896@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit 813c18d1ca1987afaf47e035152e1baa1375b1b2 upstream.

phy-mode should be rgmii-id to match hardware configuration.

Also there should be a phy-handle to reference phy node.

Fixes: f8a11425075f ("MIPS: Loongson64: Add GMAC support for Loongson-2K1000")
Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
+++ b/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
@@ -137,7 +137,8 @@
 					     <13 IRQ_TYPE_LEVEL_LOW>;
 				interrupt-names = "macirq", "eth_lpi";
 				interrupt-parent = <&liointc0>;
-				phy-mode = "rgmii";
+				phy-mode = "rgmii-id";
+				phy-handle = <&phy1>;
 				mdio {
 					#address-cells = <1>;
 					#size-cells = <0>;
@@ -160,7 +161,8 @@
 					     <15 IRQ_TYPE_LEVEL_LOW>;
 				interrupt-names = "macirq", "eth_lpi";
 				interrupt-parent = <&liointc0>;
-				phy-mode = "rgmii";
+				phy-mode = "rgmii-id";
+				phy-handle = <&phy1>;
 				mdio {
 					#address-cells = <1>;
 					#size-cells = <0>;


