Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD2426B0A5;
	Thu, 13 Feb 2025 15:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459658; cv=none; b=e6hMoL/Yrt1WqYBCb8S9t3wIMihPg0i9iXhRpwnRYTI/+j/arR++PSSofxThu6PqD9vOOiyCZOSKOCvoASI0EKx5cZjgdBd7I/1BLy9OdtkminAbS0vjscnIzBWRNdZchK/Q7/8dDrmZ/Vng3ht8G1x8VVUNKMCf30YSLzOxc7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459658; c=relaxed/simple;
	bh=6fhyCImgHLaI32uB2pHYaIomRQpzG4gt8Sy0OM6PExU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tie0XxlTBYR8NiVeTQ+ZPlzESIvhOJkE+XXsqEaQDYvGEkI5DJVodl3+FPenASoECiuFIyaEJDH3mDpRE0kg7FaW0vLmKpIVdgDh2GopMolTRsAniBO+5kJ1P7Q5mYOgCjSeWZIh9+DlHcl2U9Xa8Wb1l3LPftoOZ6mFeArz5Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJoZzS8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJoZzS8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C245EC4CED1;
	Thu, 13 Feb 2025 15:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459658;
	bh=6fhyCImgHLaI32uB2pHYaIomRQpzG4gt8Sy0OM6PExU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yJoZzS8+nFtrQYYxLj3IGu81i9HaSbfXKOvXEV8a7EpYznTbM69YFFv3yu40dwT37
	 pEYjKjsWxFhokAuL/gP3Tj0QSYEr5yHSZcKosmqyWcGlgJbMvosnoObOviFcj7tCD2
	 qEgWW0woG4MDazXn1ppdKEBQevMrYQvYZFxlsL24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Ivy Huang <yijuh@nvidia.com>,
	Brad Griffis <bgriffis@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.13 326/443] arm64: tegra: Disable Tegra234 sce-fabric node
Date: Thu, 13 Feb 2025 15:28:11 +0100
Message-ID: <20250213142453.198534073@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumit Gupta <sumitg@nvidia.com>

commit a5e6fc0a10fe280989f1367a3b4f8047c7d00ea6 upstream.

Access to safety cluster engine (SCE) fabric registers was blocked
by firewall after the introduction of Functional Safety Island in
Tegra234. After that, any access by software to SCE registers is
correctly resulting in the internal bus error. However, when CPUs
try accessing the SCE-fabric registers to print error info,
another firewall error occurs as the fabric registers are also
firewall protected. This results in a second error to be printed.
Disable the SCE fabric node to avoid printing the misleading error.
The first error info will be printed by the interrupt from the
fabric causing the actual access.

Cc: stable@vger.kernel.org
Fixes: 302e154000ec ("arm64: tegra: Add node for CBB 2.0 on Tegra234")
Signed-off-by: Sumit Gupta <sumitg@nvidia.com>
Signed-off-by: Ivy Huang <yijuh@nvidia.com>
Reviewed-by: Brad Griffis <bgriffis@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20241218000737.1789569-3-yijuh@nvidia.com
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/nvidia/tegra234.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -3815,7 +3815,7 @@
 			compatible = "nvidia,tegra234-sce-fabric";
 			reg = <0x0 0xb600000 0x0 0x40000>;
 			interrupts = <GIC_SPI 173 IRQ_TYPE_LEVEL_HIGH>;
-			status = "okay";
+			status = "disabled";
 		};
 
 		rce-fabric@be00000 {


