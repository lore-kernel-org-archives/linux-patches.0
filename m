Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA6B1A76A5;
	Tue, 30 Jul 2024 17:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359512; cv=none; b=jK8/K4Z9ymOuZscuG8GDVSIAqGniOXbPyXbMY3MpehLPXYdydyiWAFNxkFZyi5hAOZTTCzrDTPN1fAsP+W4FQw53ZmMCYJJPu2nLsAUqtn2dacMHEF8KGXiEM9gX41UAGlU5vE2lo07doJAOQ6Buryb8sYBIktP8BuuFIx7tGOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359512; c=relaxed/simple;
	bh=CMqw7h2oW4BEo97qFZIJT71FPU5I6OpmpIkzqZ2r0Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbJuf3C4x6UDD7xKVCc/vUwSz1LYjzclrzeSJOZ4bGp7oVE3Dv0MP2W/NXaJD+SvCrPJ8zwwgoHIEDbv+Ez94Mkb+oBdJN4UQFV6smvUFHrXJvTmuOsoOQZYTBe1n9uHfOBRerOkbk7UAGvUyIBrBeL0aFPNMvVwClPQ8oXfSkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCahxMYC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCahxMYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917C6C32782;
	Tue, 30 Jul 2024 17:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359512;
	bh=CMqw7h2oW4BEo97qFZIJT71FPU5I6OpmpIkzqZ2r0Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCahxMYCIvbKT+Mklx4n337xh257goq08vJJ6T2/qZSM9RE5vQ05LmiB+qor1UPOA
	 zYvPKz244yqF7AAc0SufJW4NK66D2hkX1RaY3lxFHu4+s+tdoeHcXjZ8ZbZO/aZVoJ
	 j9Fa3gJv0H4BtsCkGLidW7DJFIBXQCnifEKAB9hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.6 495/568] MIPS: dts: loongson: Fix GMAC phy node
Date: Tue, 30 Jul 2024 17:50:02 +0200
Message-ID: <20240730151659.375738565@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -144,7 +144,8 @@
 					     <13 IRQ_TYPE_LEVEL_LOW>;
 				interrupt-names = "macirq", "eth_lpi";
 				interrupt-parent = <&liointc0>;
-				phy-mode = "rgmii";
+				phy-mode = "rgmii-id";
+				phy-handle = <&phy1>;
 				mdio {
 					#address-cells = <1>;
 					#size-cells = <0>;
@@ -167,7 +168,8 @@
 					     <15 IRQ_TYPE_LEVEL_LOW>;
 				interrupt-names = "macirq", "eth_lpi";
 				interrupt-parent = <&liointc0>;
-				phy-mode = "rgmii";
+				phy-mode = "rgmii-id";
+				phy-handle = <&phy1>;
 				mdio {
 					#address-cells = <1>;
 					#size-cells = <0>;


