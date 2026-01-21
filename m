Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6726F3B9617;
	Wed, 21 Jan 2026 18:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020455; cv=none; b=CJ3xLucqssfBXl40vd251AE05wtPpnisqgDyI0pQlZP6bO9061jHhXPozQQMx/InvOq3G/reiWvvuBhIJS9ANI/glla4QBwp8lRRqTT2JlAzt/b64zhHCrmRopRqgeTUcseWKvrsIZxnmoYWL1osDGf8f7k1Uz0nLB1WDGnHSa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020455; c=relaxed/simple;
	bh=oOcPI4QY/eL/Cmm/dgWFUHLS/urd+HBW0xtsw8bXzZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DV53VdZHEiyuTyEYl/D2afIajd9sZRxwFEeBGYArlLARXB95v//Yo31wyUAC3hC2VepQ+b2it5dc8Q/WMFPnylWGBm+xIdONw2eJNxJWcxcoLXxpHcpKDTTb8q1I/+U+u1RXbvVS9kS+wn3b2nyWmOcV5TILP6PwWuWW39GpU+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wcT7beiM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wcT7beiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0B3C4CEF1;
	Wed, 21 Jan 2026 18:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020454;
	bh=oOcPI4QY/eL/Cmm/dgWFUHLS/urd+HBW0xtsw8bXzZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wcT7beiM+i1JWBwQkP+zSZrfSv5YZ3pQgePXYLtgzjyqlOhKVJXcK9Oc20YDIZZvd
	 N25K1hiwkYSUQMNGBW3egUeYBE6SiHBmRDyebOp2zlKLRAlH8cm9TlSpS3qLM/vmlP
	 Q+F+Hwvv+fA4t9qGrljhRkdnmHxQxBQa8Tu2/N+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 163/198] LoongArch: dts: loongson-2k2000: Add default interrupt controller address cells
Date: Wed, 21 Jan 2026 19:16:31 +0100
Message-ID: <20260121181424.415360090@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Binbin Zhou <zhoubinbin@loongson.cn>

commit e65df3f77ecd59d3a8647d19df82b22a6ce210a9 upstream.

Add missing address-cells 0 to the Local I/O, Extend I/O and PCH-PIC
Interrupt Controller node to silence W=1 warning:

  loongson-2k2000.dtsi:364.5-49: Warning (interrupt_map): /bus@10000000/pcie@1a000000/pcie@9,0:interrupt-map:
    Missing property '#address-cells' in node /bus@10000000/interrupt-controller@10000000, using 0 as fallback

Value '0' is correct because:
1. The LIO/EIO/PCH interrupt controller does not have children,
2. interrupt-map property (in PCI node) consists of five components and
   the fourth component "parent unit address", which size is defined by
   '#address-cells' of the node pointed to by the interrupt-parent
   component, is not used (=0)

Cc: stable@vger.kernel.org
Signed-off-by: Binbin Zhou <zhoubinbin@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/boot/dts/loongson-2k2000.dtsi |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/loongarch/boot/dts/loongson-2k2000.dtsi
+++ b/arch/loongarch/boot/dts/loongson-2k2000.dtsi
@@ -126,6 +126,7 @@
 			reg = <0x0 0x1fe01400 0x0 0x64>;
 
 			interrupt-controller;
+			#address-cells = <0>;
 			#interrupt-cells = <2>;
 			interrupt-parent = <&cpuintc>;
 			interrupts = <2>;
@@ -140,6 +141,7 @@
 			compatible = "loongson,ls2k2000-eiointc";
 			reg = <0x0 0x1fe01600 0x0 0xea00>;
 			interrupt-controller;
+			#address-cells = <0>;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&cpuintc>;
 			interrupts = <3>;
@@ -149,6 +151,7 @@
 			compatible = "loongson,pch-pic-1.0";
 			reg = <0x0 0x10000000 0x0 0x400>;
 			interrupt-controller;
+			#address-cells = <0>;
 			#interrupt-cells = <2>;
 			loongson,pic-base-vec = <0>;
 			interrupt-parent = <&eiointc>;


