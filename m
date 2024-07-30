Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D563F1A76A1;
	Tue, 30 Jul 2024 17:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359498; cv=none; b=O31KTHzft1RY8JUQ+nSPLG9yqdF3SH0pyn1X4aMWcTdxX5J6RCTXqaI+vtuOkRhweQBd08UA7XNsEts9T/V6u3MiRTqZEwUEfqwbkA3y1MvdxwA+m86xiPkcyyj/Gc8FLv/zPOjh3q7xSJHrb6qbVS8rr5rXzEkoJcgydZyhoag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359498; c=relaxed/simple;
	bh=E1EbSlK9ba+HJaUFCaSsD5kOK4s/oKgMg6gFy39E3vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXr5cvSiSivvgWdeiJRvTaM5JbOTzkPcF0EF617FeAfe0kkmWADZrMJQokkx2cwVLhnjC5IGRPEgLtd96kLFrbF5/FGf+ZDIxVm7X0zrY3GbyLoP/i+Nrd0uRL+LCb2wCoglYUhEcLAuRono6+afj8tuZ5HSsviUgzeBFUxyT9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MmK7cCp/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MmK7cCp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F6EC32782;
	Tue, 30 Jul 2024 17:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359498;
	bh=E1EbSlK9ba+HJaUFCaSsD5kOK4s/oKgMg6gFy39E3vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MmK7cCp/bdoyE2wz4gQRf2xHgiu2xpslUGNv2pZ6G+mR8TQYOxDzM8/xDOZulL21B
	 7PXohw7Zc+zGSX3Bep4XFz0AvXCXmJNw9vmovUC4e5L3xQtE/fKKlO0YxvNtsUVnhP
	 QAy/rN47c5Rwle5DoWL/sB5i13eJ+VtRIRRcW9IA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.6 493/568] MIPS: dts: loongson: Add ISA node
Date: Tue, 30 Jul 2024 17:50:00 +0200
Message-ID: <20240730151659.298559739@linuxfoundation.org>
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

commit da3f62466e5afc752f8b72146bbc4700dbba5a9f upstream.

ISA node is required by Loongson64 platforms to initialize
PIO support.

Kernel will hang at boot without ISA node.

Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
+++ b/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
@@ -52,6 +52,13 @@
 			0 0x40000000 0 0x40000000 0 0x40000000
 			0xfe 0x00000000 0xfe 0x00000000 0 0x40000000>;
 
+		isa@18000000 {
+			compatible = "isa";
+			#size-cells = <1>;
+			#address-cells = <2>;
+			ranges = <1 0x0 0x0 0x18000000 0x4000>;
+		};
+
 		pm: reset-controller@1fe07000 {
 			compatible = "loongson,ls2k-pm";
 			reg = <0 0x1fe07000 0 0x422>;


