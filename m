Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203B7143C52;
	Thu, 13 Jun 2024 12:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280213; cv=none; b=jwvjm+ptpbSQ76NKuL8Kbrq4GvDQo2AAvSRQy77A/gWdmnjCxMDnRAHLcwWEuI3Ht9PzcP9aXLBbtHdvbCxeZV3DUk/TUCLJy3RdnceabhULPBOSCv8GccnfxzBZ0v6QR85L2vpeBg0MQ59q1kwrjkgwP0CEBQTCqEl/8jebDZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280213; c=relaxed/simple;
	bh=aGGWRGbTvfUbCqeWZi99hPPtXY0r1D4edy8YMU39yAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMeGiysHe/hTkVUJtD+buSPQYyCUk/+rZlzDpz/znSGfuzrSS82xyAINtRUv1NxB4E+ln4IMQGi4dwIgqMM7X5zKxa4KDwoUDYjHcksSI6bcDQephJxjCg4WzLoRZNfeRoeFuRJBfi5WE5E4pfMlOiTSL7nztZykhNBd2iQJ8TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L1VSl6Qd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L1VSl6Qd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CAB5C32786;
	Thu, 13 Jun 2024 12:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280213;
	bh=aGGWRGbTvfUbCqeWZi99hPPtXY0r1D4edy8YMU39yAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1VSl6Qdae3TPkvtKb8MAJiTCo1xdOL9+yzCGTlgAyavnQMOzYOD5xie3fJzFP3tL
	 vWxlLNOZIzr6D1ts+CccKlXwJrg8GPR+RDTgdicBFKCJrzDUwP8y/h+gupcp4BMhNO
	 XhORe8zXgN+nSAMb1/w7cjHt+kJzdzVFFt/XXR6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiwen <forbidden405@outlook.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 5.4 180/202] arm64: dts: hi3798cv200: fix the size of GICR
Date: Thu, 13 Jun 2024 13:34:38 +0200
Message-ID: <20240613113234.685290570@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -58,7 +58,7 @@
 	gic: interrupt-controller@f1001000 {
 		compatible = "arm,gic-400";
 		reg = <0x0 0xf1001000 0x0 0x1000>,  /* GICD */
-		      <0x0 0xf1002000 0x0 0x100>;   /* GICC */
+		      <0x0 0xf1002000 0x0 0x2000>;  /* GICC */
 		#address-cells = <0>;
 		#interrupt-cells = <3>;
 		interrupt-controller;


