Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841DC25393E;
	Sat, 12 Sep 2026 07:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199776; cv=none; b=neqBgqSEHhj5iVOj4gUSjYz1xH2lb4MZhqdrXIVfPcGO57OPSeDtNILI062yTsH/jOG8x/T0SFmHcl8WXAxa8Qh7k6mhyQ5oKHW1pwALCrHpmsCM7Hen9K2K2sHgGatTgK1NYX6InEmB4fgubEvGlnkqGlKhL7KCuE99kjnaoqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199776; c=relaxed/simple;
	bh=phqXpva2DkXfrK6pir9Kai+5HY+de3yX8EDN0IO4KfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VWfMzOOQr0IguzCR9b8cO6isTlXv45PeCePH+wd+zRK75znPslLthsc9zYWSPZ+GNN5Qy+C7qVnkDahre0BHMxRj9MMXlRGbZmgTh+oa3Tv7M1Sk+rHlBXfkm70blLXvyGz6BQ0yMO2/R+YEZbSO0UnyR1ng9SJcL15pY2Og/Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rRFhLKfZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rRFhLKfZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CEA1F000FF;
	Sat, 12 Sep 2026 07:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199775;
	bh=cIIRSVuR8wM5Qj50BNkD+hb9os8lPE+qqcq8hVdChew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rRFhLKfZNc9MUebH8DdbY7NNRrsDPBqkm2JkKjERFaIrIIs1rjBCESB1qlRXJvV3n
	 ZQOXzMoVIIJR7xKJnohJjNQ0wQjQstQZvf7hTOOzN6puf5+cXE8oE73ds5xeXjKyj+
	 KJT3aipCyNk/F3hBOWUCZSaSTV8WAoW+OzBiD4fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0655/1815] riscv: dts: spacemit: improve RTL8211F PHY configuration on K3 Pico-ITX board
Date: Sat, 12 Sep 2026 08:40:05 +0200
Message-ID: <20260912065704.257188659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aurelien Jarno <aurelien@aurel32.net>

[ Upstream commit e0c1145f4c8ea0515b32e0b9620412528a4312b1 ]

Vendor kernel enabled ALDPS (Advanced Link Down Power Saving) on the
RTL8211F PHY to save power when link down.

Vendor kernel also disabled the 125MHz clkout clock signal, and indeed
the schematics confirms that it only goes to a test point (TP14), so
let's do the same.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Tested-by: Yixun Lan <dlan@kernel.org>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Link: https://patch.msgid.link/20260623204431.498700-6-aurelien@aurel32.net
Signed-off-by: Yixun Lan <dlan@kernel.org>
Stable-dep-of: a225e19a4cc4 ("riscv: dts: spacemit: Add enough deassert time for the PHY on PICO ITX")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/spacemit/k3-pico-itx.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts b/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
index 509cebc0c9568..1b535226e3ce0 100644
--- a/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
+++ b/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
@@ -196,6 +196,8 @@ phy0: phy@1 {
 			reset-gpios = <&gpio 0 15 GPIO_ACTIVE_LOW>;
 			reset-assert-us = <10000>;
 			reset-deassert-us = <10000>;
+			realtek,aldps-enable;
+			realtek,clkout-disable;
 		};
 	};
 };
-- 
2.53.0



