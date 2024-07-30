Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F20B1A76AD;
	Tue, 30 Jul 2024 17:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360653; cv=none; b=Bbpgvyo/RTAwBbm4qc7+UC1pWBSceTEtwDn2syVnpJWUqpk3v+fvJIingOCxF+3YMuRN6poh3rOQdIl+S2hwa45FZBQJ3V/tuVZTm6Aq4yibJDdEUel59DBuOTz/HhDv5UoLV97cMHjilULbYpDm+Ort/VD5iEaZCxWJPtpeKmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360653; c=relaxed/simple;
	bh=G05NPqL+b4QPHnUz/9/pvkEpp9sKxD9un9bHwxB1Ub4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QX8NO6Q3DyIWiyt86GpCzUvaJKbtpbUc15CXqt7AhIrhAe3hUyuIwMRYSVShqC+iri8/FTqBhSXLSWhgAC5N0caKbPXTB69MGdknmOcTgJtFg7NdJ4YL+XXq6NC1IFDEsItI35yZtPDpG8Rk/Jp4RAefOQTuiJ4En7lBpwZzVPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2bwdbwI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2bwdbwI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4ABC32782;
	Tue, 30 Jul 2024 17:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360653;
	bh=G05NPqL+b4QPHnUz/9/pvkEpp9sKxD9un9bHwxB1Ub4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2bwdbwI7QN+IYj7zIkp4jvABIEWs7vK4nE8fGHnCNUXf05GKUEE967spYE+5TGZDi
	 AXogg8MHlKl/1ncdNQGS0KJNtt8Zz4FFoXIn4+sz5kPHrMJB0l2bmiDejiln5dIoQ3
	 xIVdjjEkfaDsPAGF1C5Ui9rjU6YcTKg/7SHReX9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.10 724/809] MIPS: dts: loongson: Fix GMAC phy node
Date: Tue, 30 Jul 2024 17:50:00 +0200
Message-ID: <20240730151753.534431176@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


