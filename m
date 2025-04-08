Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C412686AA;
	Tue,  8 Apr 2025 11:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110589; cv=none; b=s4ALSJXgFvDsgG3ELayg4tOefCsZxpN/iuOQBNkhFkytQ/lUm33Un69tkLATx9mttCM/jLzV0CJ8SwuoSimXpJpA3CyP2Knf3nJsdStVDm+WrhHjLVpcwL2HAaRQPuyNgSClCSbT3gZOqI9h7v3g6/5P2r3teOcmbNXBdhLvP9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110589; c=relaxed/simple;
	bh=MTwbwiu7U6d15uI3ss8LxYv2WuuHNU5VYN/V9jmibSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VHNGDP2iqUKdpLkANrHshZ1LE6XGNMAz8gUj2L3hDKPMr1UooISlZ75jxofVP0s0+X+02hwOEp3ot7fv2mU9z0IplcLBkHJPlMurIaOCcGvwSiHe5iLDYOy0Gxoth4YTlTwyFM7Ao3TUepEwQsMSfTZzpU2UscQsTztZWwqB8uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+WOIlUw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+WOIlUw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD39EC4CEE5;
	Tue,  8 Apr 2025 11:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110589;
	bh=MTwbwiu7U6d15uI3ss8LxYv2WuuHNU5VYN/V9jmibSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+WOIlUwsP1YQV8XwsAtRbHd0WP0PjATX1lxSZkpJxpdfJ+5zQRVyaZdt2/Dq3hOU
	 BicZQkI/PE5SdHEKjEAqK0lWoSykMcIF3FdPVZwU8Af7cthahVWHdfHfg7Y09Ia1u5
	 H/I5dhdBwaBtWqqj76kVQ+Um+yVbZ3ID2wBng0I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hrushikesh Salunke <h-salunke@ti.com>,
	Roger Quadros <rogerq@kernel.org>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 119/731] arm64: dts: ti: k3-j722s-evm: Fix USB2.0_MUX_SEL to select Type-C
Date: Tue,  8 Apr 2025 12:40:16 +0200
Message-ID: <20250408104917.045200962@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hrushikesh Salunke <h-salunke@ti.com>

[ Upstream commit bc8d9e6b5821c40ab5dd3a81e096cb114939de50 ]

J722S SOC has two usb controllers USB0 and USB1. USB0 is brought out on
the EVM as a stacked USB connector which has one Type-A and one Type-C
port. These Type-A and Type-C ports are connected to MUX so only
one of them can be enabled at a time.

Commit under Fixes, tries to enable the USB0 instance of USB to
interface with the Type-C port via the USB hub, by configuring the
USB2.0_MUX_SEL to GPIO_ACTIVE_HIGH. But it is observed on J722S-EVM
that Type-A port is enabled instead of Type-C port.

Fix this by setting USB2.0_MUX_SEL to GPIO_ACTIVE_LOW to enable Type-C
port.

Fixes: 485705df5d5f ("arm64: dts: ti: k3-j722s: Enable PCIe and USB support on J722S-EVM")
Signed-off-by: Hrushikesh Salunke <h-salunke@ti.com>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Link: https://lore.kernel.org/r/20250116125726.2549489-1-h-salunke@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j722s-evm.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j722s-evm.dts b/arch/arm64/boot/dts/ti/k3-j722s-evm.dts
index d184e9c1a0a59..adee69607fdbf 100644
--- a/arch/arm64/boot/dts/ti/k3-j722s-evm.dts
+++ b/arch/arm64/boot/dts/ti/k3-j722s-evm.dts
@@ -590,7 +590,7 @@
 		p05-hog {
 			/* P05 - USB2.0_MUX_SEL */
 			gpio-hog;
-			gpios = <5 GPIO_ACTIVE_HIGH>;
+			gpios = <5 GPIO_ACTIVE_LOW>;
 			output-high;
 		};
 
-- 
2.39.5



