Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C23D14265E;
	Thu, 13 Jun 2024 11:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279038; cv=none; b=IiGdX9iqOq/kiROS/m+QdNm+SKpu9CHCRziOxBN5IL5PYqwIwKRybhwcCbTXDRyr8P3/P2exsTWwEOWOsgDTN1phw/Bpaf4OEMs67f8PeAOGSHGE9ft4ptlkBYocoov12yLW69AEkjc2r9gNs3bEP4EIYCQsiTxrUJD1/a9KkDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279038; c=relaxed/simple;
	bh=XW/+ZZNX2PLvfYaaQsn3ACNIKCOy5eQZox3kidn5uiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfYK1YCgQ801lH7i3pk90FEyRuFentVemKLE2wXOXeDY+xBosu1A9EDv7rXtJDyorNBNqs0tpv2dXq6keNmnAQVAipkJSgK2p4dyxYXzKFehMLFsFv439abCed9jTpG6P2jNbkYWwBo3RR3dNyik5MBh/NYZRDvck/zNTpbrtCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oFwx/N1E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oFwx/N1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85BBC2BBFC;
	Thu, 13 Jun 2024 11:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279038;
	bh=XW/+ZZNX2PLvfYaaQsn3ACNIKCOy5eQZox3kidn5uiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oFwx/N1EXsTQ6MlIWu0HWjqh1wWWlvo3HKapYCjbJC7h+aMHA+90kj1OWc7MDg+am
	 BNrzM52Wa29yfvkRAqeuGl3hQSbsFHXzT8bqRSrV962B624k63NWJ/L4vQymvW7Gee
	 iF4vM/MemILsg2BKaZaP53dlvqF2wijuCjf7ELIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiwen <forbidden405@outlook.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 4.19 155/213] arm64: dts: hi3798cv200: fix the size of GICR
Date: Thu, 13 Jun 2024 13:33:23 +0200
Message-ID: <20240613113233.967934858@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Xiwen <forbidden405@outlook.com>

commit 428a575dc9038846ad259466d5ba109858c0a023 upstream.

During boot, Linux kernel complains:

[    0.000000] GIC: GICv2 detected, but range too small and irqchip.gicv2_force_probe not set

This SoC is using a regular GIC-400 and the GICR space size should be
8KB rather than 256B.

With this patch:

[    0.000000] GIC: Using split EOI/Deactivate mode

So this should be the correct fix.

Fixes: 2f20182ed670 ("arm64: dts: hisilicon: add dts files for hi3798cv200-poplar board")
Signed-off-by: Yang Xiwen <forbidden405@outlook.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240219-cache-v3-1-a33c57534ae9@outlook.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/hisilicon/hi3798cv200.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/hisilicon/hi3798cv200.dtsi
+++ b/arch/arm64/boot/dts/hisilicon/hi3798cv200.dtsi
@@ -60,7 +60,7 @@
 	gic: interrupt-controller@f1001000 {
 		compatible = "arm,gic-400";
 		reg = <0x0 0xf1001000 0x0 0x1000>,  /* GICD */
-		      <0x0 0xf1002000 0x0 0x100>;   /* GICC */
+		      <0x0 0xf1002000 0x0 0x2000>;  /* GICC */
 		#address-cells = <0>;
 		#interrupt-cells = <3>;
 		interrupt-controller;


