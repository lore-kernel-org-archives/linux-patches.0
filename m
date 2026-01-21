Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F1134AAF2;
	Wed, 21 Jan 2026 18:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019775; cv=none; b=bbJIKADQ7rBud4YggJ1VSd+dHahoJF3Jb2p3oToGgRbnZAywjX/vOr7XN42DBl+an0T1Lf+P7ATOPcrtQawh+pzgu48l+o+Apsv+g9LKR4lSXVQBrO2fI87BzYaaElzrW7jP6ANZU4IeFDqSs9TuGUAAPglN+P253NqQrD3TjWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019775; c=relaxed/simple;
	bh=qCYy7gBNAW7r3B6sgGVYnOdZrCO2uLKKJIvjcvLQULY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bi/nrVKPhy5xR9btv7HAgsX9lPP/5iQTcpdBgwyskP9KPLul46lj0Y6LyMnF388xkttsctyxwpyrXiiTy74bBVTUhvRP1dzk/Lin62I+if33B5nxiGIP4DfEdT2RxreUvvRbWP4gR15qLo9kQSQ3H/7ToBDPHj1Dz1TlHhsYn1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OxmcN/b0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OxmcN/b0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F23C4CEF1;
	Wed, 21 Jan 2026 18:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019775;
	bh=qCYy7gBNAW7r3B6sgGVYnOdZrCO2uLKKJIvjcvLQULY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OxmcN/b0M5iZkgk2RLfbZ4yBc1nRvFtjKDNQvYLA2VMJ0bCY5ZDFFwvyImkQ949te
	 G5RQ8c/ywFDJLBvaXkvLElWgFgySjli71jGivK8zYIqI9g2qzVKRwLsZcQMeXcB3mN
	 JabLIjGgSYCn6NTwke0RN8PBbchwkJVmXm+lZFzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 105/139] LoongArch: dts: loongson-2k1000: Add default interrupt controller address cells
Date: Wed, 21 Jan 2026 19:15:53 +0100
Message-ID: <20260121181415.227540437@linuxfoundation.org>
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

commit 81e8cb7e504a5adbcc48f7f954bf3c2aa9b417f8 upstream.

Add missing address-cells 0 to the Local I/O interrupt controller node
to silence W=1 warning:

  loongson-2k1000.dtsi:498.5-55: Warning (interrupt_map): /bus@10000000/pcie@1a000000/pcie@9,0:interrupt-map:
    Missing property '#address-cells' in node /bus@10000000/interrupt-controller@1fe01440, using 0 as fallback

Value '0' is correct because:
1. The Local I/O interrupt controller does not have children,
2. interrupt-map property (in PCI node) consists of five components and
   the fourth component "parent unit address", which size is defined by
   '#address-cells' of the node pointed to by the interrupt-parent
   component, is not used (=0)

Cc: stable@vger.kernel.org
Signed-off-by: Binbin Zhou <zhoubinbin@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/boot/dts/loongson-2k1000.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/loongarch/boot/dts/loongson-2k1000.dtsi
+++ b/arch/loongarch/boot/dts/loongson-2k1000.dtsi
@@ -114,6 +114,7 @@
 			      <0x0 0x1fe01140 0x0 0x8>;
 			reg-names = "main", "isr0", "isr1";
 			interrupt-controller;
+			#address-cells = <0>;
 			#interrupt-cells = <2>;
 			interrupt-parent = <&cpuintc>;
 			interrupts = <2>;
@@ -131,6 +132,7 @@
 			      <0x0 0x1fe01148 0x0 0x8>;
 			reg-names = "main", "isr0", "isr1";
 			interrupt-controller;
+			#address-cells = <0>;
 			#interrupt-cells = <2>;
 			interrupt-parent = <&cpuintc>;
 			interrupts = <3>;


