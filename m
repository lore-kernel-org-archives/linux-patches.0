Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8035B17BEA5;
	Thu, 15 Aug 2024 13:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729913; cv=none; b=Pe6LNqFwYY3mz4fENQ//vPmUVrCq0B5dpNFjZb6l+6eNUy+OjlU63EI9UOngET1Y6i6R0JLj/Xb+pxvuyhfT+GQQiw+dZMGTfNkwmJsZyPCUw++98kx4JkkcV7JHR6jce20c8eL4S64cL9//63PiOJjOLNjCEy0SUuyTLSEhU6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729913; c=relaxed/simple;
	bh=Ng/Ool4SHzc3fGv64Ys9YStgelWSVdWYlGP7j6YHKqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9Y/yr040+62a2VpwDiGuXTGruqJwGwCMU/nIrbYDHiDr+nhPNErT4BOQmkxyvRZHcxpZLkC0R7hJ4T8XlJdmTrFG4Iwzu18QaM/oxChc2bqD1NHYhjsJfBSVdKlzGkSh0ZoQaMQNqlEw9cTvcDVF/XxolPZGpMn2Bjk8Z4rcYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R2/0JAo5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R2/0JAo5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04985C4AF0A;
	Thu, 15 Aug 2024 13:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729913;
	bh=Ng/Ool4SHzc3fGv64Ys9YStgelWSVdWYlGP7j6YHKqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R2/0JAo5rn5P2OTgzcJWAmz+FcA06WHs358unZG0lTDEA/tx211xFXT/BJV052U32
	 yuljXi/oROokp7uuI1zsoegfj/TnPjPN+YeLuqSlWgyKsTgMPF5JylisNM4CN1/tGf
	 XACn1dUdvrqEtt35jqFdY5kJLEPStPM7OC/6Co7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.15 247/484] MIPS: dts: loongson: Fix GMAC phy node
Date: Thu, 15 Aug 2024 15:21:45 +0200
Message-ID: <20240815131950.940082494@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -125,7 +125,8 @@
 					     <13 IRQ_TYPE_LEVEL_LOW>;
 				interrupt-names = "macirq", "eth_lpi";
 				interrupt-parent = <&liointc0>;
-				phy-mode = "rgmii";
+				phy-mode = "rgmii-id";
+				phy-handle = <&phy1>;
 				mdio {
 					#address-cells = <1>;
 					#size-cells = <0>;
@@ -148,7 +149,8 @@
 					     <15 IRQ_TYPE_LEVEL_LOW>;
 				interrupt-names = "macirq", "eth_lpi";
 				interrupt-parent = <&liointc0>;
-				phy-mode = "rgmii";
+				phy-mode = "rgmii-id";
+				phy-handle = <&phy1>;
 				mdio {
 					#address-cells = <1>;
 					#size-cells = <0>;


