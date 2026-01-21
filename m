Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60A1318138;
	Wed, 21 Jan 2026 18:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019771; cv=none; b=ZG+agpV1MQQ8ybB1rHPzTqvXg9EgvrCp4rc3Upuy6Bw/7JhKNWxDKEyXSiww4tXOT5Z+9Rva2DBOAzBrnstoDRRk9O+jABmmZnMOM4XXhUw2Vb3ZKLJLUDv6xxw7AAT/KC+TnrjzN04bD8Vdt3dQp+B8xQdN4tzdZbnsQYK6Ito=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019771; c=relaxed/simple;
	bh=cXEX0kGovp0eaWsOZwn0ZbhyZqyX93rZO4HvxGqG2rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyvrBeQtk0bAidkahwDVt6pVNjfNLugqlFfDSqFHZGqN+APCZzcPTG0jqgx3pVmvQ0bDrc3WXR6V81MCkz4sfZD2muThuQct+PJbiWTV1K6bOKCtGRv/buWtwsyzGZNBxIfi8wwJz0FCU/bqKIZ14BHybBtMMUetuC5S/PQgvzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n2P7wAam; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n2P7wAam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580F8C4CEF1;
	Wed, 21 Jan 2026 18:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019771;
	bh=cXEX0kGovp0eaWsOZwn0ZbhyZqyX93rZO4HvxGqG2rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n2P7wAamqfglVDDHqSE+oLi6zr09wDufQmv68SCFw9/Gh4ECOLVJrVhVMc027VRR4
	 7JTw03KBAtipealwDMcdoZjTUQD73xHf7yoJBnNFXfsclUbwRd5jnNjoMfE09TBFyR
	 365IhBMgW/WdurvvsL9Ef25hesec6akQNLySHXcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 104/139] LoongArch: dts: loongson-2k0500: Add default interrupt controller address cells
Date: Wed, 21 Jan 2026 19:15:52 +0100
Message-ID: <20260121181415.192110997@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Binbin Zhou <zhoubinbin@loongson.cn>

commit c4461754e6fe7e12a3ff198cce4707e3e20e43d4 upstream.

Add missing address-cells 0 to the Local I/O and Extend I/O interrupt
controller node to silence W=1 warning:

  loongson-2k0500.dtsi:513.5-51: Warning (interrupt_map): /bus@10000000/pcie@1a000000/pcie@0,0:interrupt-map:
    Missing property '#address-cells' in node /bus@10000000/interrupt-controller@1fe11600, using 0 as fallback

Value '0' is correct because:
1. The Local I/O & Extend I/O interrupt controller do not have children,
2. interrupt-map property (in PCI node) consists of five components and
   the fourth component "parent unit address", which size is defined by
   '#address-cells' of the node pointed to by the interrupt-parent
   component, is not used (=0)

Cc: stable@vger.kernel.org
Signed-off-by: Binbin Zhou <zhoubinbin@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/boot/dts/loongson-2k0500.dtsi |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/loongarch/boot/dts/loongson-2k0500.dtsi
+++ b/arch/loongarch/boot/dts/loongson-2k0500.dtsi
@@ -131,6 +131,7 @@
 			reg-names = "main", "isr0";
 
 			interrupt-controller;
+			#address-cells = <0>;
 			#interrupt-cells = <2>;
 			interrupt-parent = <&cpuintc>;
 			interrupts = <2>;
@@ -149,6 +150,7 @@
 			reg-names = "main", "isr0";
 
 			interrupt-controller;
+			#address-cells = <0>;
 			#interrupt-cells = <2>;
 			interrupt-parent = <&cpuintc>;
 			interrupts = <4>;
@@ -164,6 +166,7 @@
 			compatible = "loongson,ls2k0500-eiointc";
 			reg = <0x0 0x1fe11600 0x0 0xea00>;
 			interrupt-controller;
+			#address-cells = <0>;
 			#interrupt-cells = <1>;
 			interrupt-parent = <&cpuintc>;
 			interrupts = <3>;


