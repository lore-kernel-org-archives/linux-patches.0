Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBDC23A9BA;
	Thu, 13 Feb 2025 14:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458086; cv=none; b=Si9R/RE6XtI6EEPIkPet8GaNQVnz+6OZ/Ggxw/a73+ghz70ObLMwlvFeoLOjCNjMVU1iKwqK2NDbqWj47Y+/j43fqAWyohzdodnrxmFoK0IHH7Nf5ZlmBu325zzBfnOdz6UXAh6Ti9wAS3Su1cqYmH7ARncqhmpJgcn70wXCHqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458086; c=relaxed/simple;
	bh=5w4Ip2U4q1phtG+Gix7I2Y2ucoMJJg0u421YxYChsX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbcMj4ZanTQIYYwz8BQf6p9OTRS41ToaTzOHJCAXPNHyxhbYSQZmX7qMfIM9sbu3o1XKbMRAZ5NnJEt6IvuXAVLqit/6EP043RZzIajaBAg/yAYM5x6kTDEGpbbrq5Txet4G9p+dQ/G+L6vHz8l+oruQ97yFZHAmTy2F2D2FAy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kfp9tFcG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kfp9tFcG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B59C4CED1;
	Thu, 13 Feb 2025 14:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458086;
	bh=5w4Ip2U4q1phtG+Gix7I2Y2ucoMJJg0u421YxYChsX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kfp9tFcGxMjlTrI7wXGSkXYAyBtKtZcb664Cq9qM1Ze1S/07sdUUe4L6BHj5xrMuu
	 b5j2Ololpx9WaFCJAzettDBH3eioTM2fJB6kRYfjFhYDVxD4CHSYSGRbe/kx0y21Io
	 V4Y3jvx+bNCYNaXB4xDczRgBalAdNrEwfvxCPFZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Ivy Huang <yijuh@nvidia.com>,
	Brad Griffis <bgriffis@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.12 296/422] arm64: tegra: Fix typo in Tegra234 dce-fabric compatible
Date: Thu, 13 Feb 2025 15:27:25 +0100
Message-ID: <20250213142447.964440067@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumit Gupta <sumitg@nvidia.com>

commit 604120fd9e9df50ee0e803d3c6e77a1f45d2c58e upstream.

The compatible string for the Tegra DCE fabric is currently defined as
'nvidia,tegra234-sce-fabric' but this is incorrect because this is the
compatible string for SCE fabric. Update the compatible for the DCE
fabric to correct the compatible string.

This compatible needs to be correct in order for the interconnect
to catch things such as improper data accesses.

Cc: stable@vger.kernel.org
Fixes: 302e154000ec ("arm64: tegra: Add node for CBB 2.0 on Tegra234")
Signed-off-by: Sumit Gupta <sumitg@nvidia.com>
Signed-off-by: Ivy Huang <yijuh@nvidia.com>
Reviewed-by: Brad Griffis <bgriffis@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20241218000737.1789569-2-yijuh@nvidia.com
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/nvidia/tegra234.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -3995,7 +3995,7 @@
 		};
 
 		dce-fabric@de00000 {
-			compatible = "nvidia,tegra234-sce-fabric";
+			compatible = "nvidia,tegra234-dce-fabric";
 			reg = <0x0 0xde00000 0x0 0x40000>;
 			interrupts = <GIC_SPI 381 IRQ_TYPE_LEVEL_HIGH>;
 			status = "okay";


