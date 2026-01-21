Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07F3387594;
	Wed, 21 Jan 2026 18:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020448; cv=none; b=kTVzMkbxZHsYW3TiwTa9E0Yaz2LO4KyYBJHL1joQIuZYnrB0F7kHT3EYNdDdYWEPcHmb6nZU9mvsqj/ZhjpZhNqrVyC77S1zce7z1a3ltBBSQu2FNHdIRj3R86FKOn04Vb28kZGSlViksb6Y6vbsq+9ZpxNM92tpuHHxAd5NyzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020448; c=relaxed/simple;
	bh=bUvC0SjooC32UFKGn5WitQDT3tvL+wZaIp5z8dGYxz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xa0S7i80w4lWqWt+7V7l5nvujxRM1heGLY665XKpv/rwPB2cmMqX7u9Ijgp/v7fTU1I6jZzdnZbzp2+VcF/dklhdZEQosUz7GgWPByTkXwKFz+Dy0Ic70ACQSNhjqP6BsAuGvGcfPrmwGQEiSQ3g3RvslOJL4I63EU4ofvY0Nlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WlCeQXV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WlCeQXV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E339AC4CEF1;
	Wed, 21 Jan 2026 18:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020448;
	bh=bUvC0SjooC32UFKGn5WitQDT3tvL+wZaIp5z8dGYxz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WlCeQXV2C6VL2uXUmDAuolFQHfJtKwqxNzF4XmlNbZmmtlMYvMXJf5/rE+SBGzJOQ
	 G3w3Ap+OdsAND2O2BSRU7m60OKZlx2fYT1qZVIQbb63NaSOxBf2jEaVx0UmaUq3woE
	 IwvI35JT28Ljyq+m5Wp+B+3DG4regBmmR50CfeqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 161/198] LoongArch: dts: loongson-2k1000: Add default interrupt controller address cells
Date: Wed, 21 Jan 2026 19:16:29 +0100
Message-ID: <20260121181424.345415448@linuxfoundation.org>
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


