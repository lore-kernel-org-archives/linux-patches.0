Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD531E0B62;
	Wed, 19 Feb 2025 09:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957083; cv=none; b=f9BWMoNx/ruWwBed24Z7hJrwaM3WK4e+uC8E/+rankcIn5T/v/Ub8uiPPjDgZNkIeL4/tN9O82WG3A2dstF+wpqTTBkTERibtt0XCYcBkESvPq8u9eevkiKB8215ReE9gw15Vb4T8bOWv/taJ518wt/dEMmGc45/u6z13Wh97O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957083; c=relaxed/simple;
	bh=1qnSFZFIEg04Fdm8jbKwPSrUMVMwNXc/nUuQCBKh2Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/+jCY0zGmGg0wphf6WQWgczqVTKeJoChgNyLq2LI0lSeq6Mmpn0vvpxXto6RYUwCvjQpPhhhSKID2Z7mgBJSub30PnQk4gcVhi63Pv7KEWhdsafZd+dSPm5jnfZnB+RLxU9PQHWSpy2HStUtO4kymGUHBpEgp1bU64wzAk43Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQQhcpWD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQQhcpWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247E3C4CED1;
	Wed, 19 Feb 2025 09:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957083;
	bh=1qnSFZFIEg04Fdm8jbKwPSrUMVMwNXc/nUuQCBKh2Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WQQhcpWD3mLiq0BH3c2RHiJSjRrWIqfXCqZk9rcKF1zL77Jm4PEePj+rGlSHyBD7y
	 phm+/HFcqV0p8lMlexbZtcd70JWHFooSdKKcfJ8myadneV0Rtcu1wm95BV8fydmJtr
	 l0ICSdG7CUVl3jlVMb+5lGBWeetXiZZ3qS8mafec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Ivy Huang <yijuh@nvidia.com>,
	Brad Griffis <bgriffis@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.1 402/578] arm64: tegra: Disable Tegra234 sce-fabric node
Date: Wed, 19 Feb 2025 09:26:46 +0100
Message-ID: <20250219082708.840860960@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1249,7 +1249,7 @@
 			compatible = "nvidia,tegra234-sce-fabric";
 			reg = <0xb600000 0x40000>;
 			interrupts = <GIC_SPI 173 IRQ_TYPE_LEVEL_HIGH>;
-			status = "okay";
+			status = "disabled";
 		};
 
 		rce-fabric@be00000 {


