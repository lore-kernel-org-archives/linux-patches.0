Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078ED30147E;
	Mon, 27 Oct 2025 19:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593399; cv=none; b=sDR52/5z1zyZWX8jUBALfb/d+7ZBJwK6eCMP2QkTyDhGn289KT43OewvYI0SBE7LERg5pV5iOw1bDvcKis3QtF7rf/UiTCUpd7rMfdKG3s9aIlz+tSbS/MvlQax7+JK87C9RUfPuHZpCEtN38HVo4fkDgcaW6/gPIuqm7nfwMow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593399; c=relaxed/simple;
	bh=7/9AA4v850YoTapy/uHllLi8X7lut94l4hS28FUBPsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgGxGTcQhBcEnoUSZ/RRWFXQ1tTQKct5Xm+bE1UwcW22d8OgoswDLhfXV1WYcj+J8eS4hrXzcbDvGU6FaRdfWKPB/VEDOs/dPDL5vHAk1jQd6X5MhOdAeq4HzKL5WG63iqCOvLncVvZu3fpBK206oFqsErDS6cRHIcdKUjb0gRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=saUF5z/Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="saUF5z/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68028C4CEF1;
	Mon, 27 Oct 2025 19:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593398;
	bh=7/9AA4v850YoTapy/uHllLi8X7lut94l4hS28FUBPsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=saUF5z/Q/IAWw2KrTRkqFrZGzwF0qUhAMUOl57KrTene3j62bsvYHhPaO3NpW3bmg
	 wgLuzNryMwRE04U1Xlec/H9x60e4IACmpxGKKbOOeWM8i+nvd70Lnk9g6vPbV43rVq
	 8s4vT/yQOk/02opEU7S8hdQUWxMpbkte+CIEGuGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Andrea della Porta <andrea.porta@suse.com>,
	Phil Elwell <phil@raspberrypi.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 122/184] arm64: dts: broadcom: bcm2712: Define VGIC interrupt
Date: Mon, 27 Oct 2025 19:36:44 +0100
Message-ID: <20251027183518.229635488@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Robinson <pbrobinson@gmail.com>

[ Upstream commit aa960b597600bed80fe171729057dd6aa188b5b5 ]

Define the interrupt in the GICv2 for vGIC so KVM
can be used, it was missed from the original upstream
DTB for some reason.

Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Cc: Andrea della Porta <andrea.porta@suse.com>
Cc: Phil Elwell <phil@raspberrypi.com>
Fixes: faa3381267d0 ("arm64: dts: broadcom: Add minimal support for Raspberry Pi 5")
Link: https://lore.kernel.org/r/20250924085612.1039247-1-pbrobinson@gmail.com
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/broadcom/bcm2712.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/broadcom/bcm2712.dtsi b/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
index 940f1c4831988..18e73580828a5 100644
--- a/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
@@ -271,6 +271,8 @@
 			      <0x7fffe000 0x2000>;
 			interrupt-controller;
 			#address-cells = <0>;
+			interrupts = <GIC_PPI 9 (GIC_CPU_MASK_SIMPLE(4) |
+					IRQ_TYPE_LEVEL_HIGH)>;
 			#interrupt-cells = <3>;
 		};
 
-- 
2.51.0



