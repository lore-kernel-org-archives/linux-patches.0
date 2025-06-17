Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C6D2F547F;
	Tue, 17 Jun 2025 16:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176591; cv=none; b=e8Go84jK+ioythmfiZP3jSJX2b4GLAhw8ad9bap2xGL8ifSNeMKv38BGLDuX1JDZ6DpAZkoU59ui5eb+qm4iQ6KApPggstKvTVhV12bGz6uavYof37fIfz3PaRIMO5K0EoCfuY+7ObXgNOGRNB/+gJxCVEnfPRqAPUHrJ7x0KIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176591; c=relaxed/simple;
	bh=AOSefvfGhQQ1cMMqPXLrkNo6jRjjUT0XrAhoeqoWNBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=asqwFP7vfTpgSD3jYKBFg+qzRyB7LvJ1zeEjXJ6cwIwOyYvoOs9actXD7W61TN601m7HUPS9zrUdOyLeNSjqavlJo4Gtl2ELgAa4jwEIX8Z29SgssiGvD2FlQethXja56i1neKdUHp5jKaWETMMWQ9W1/CJZBcwwJyVBWXk98Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zIXWCP9c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zIXWCP9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6075AC4CEE7;
	Tue, 17 Jun 2025 16:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176590;
	bh=AOSefvfGhQQ1cMMqPXLrkNo6jRjjUT0XrAhoeqoWNBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zIXWCP9crnOgwhVtON/KpRXIDjkXLIbQ54ELN5u5AkdEq+z9JPM4kucB0FW3WVQCh
	 UQkGS6qoWAcW1LigSl+yW4q/18SeNCkcgzD2z8t2u9LOuA02qR9watGb2+dU54Y1Dg
	 IZG+1fBlSICUP0eolE2L1q/7R/JkKU+CHNU8Df4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 245/512] arm64: dts: rockchip: Add vcc-supply to SPI flash on rk3566-rock3c
Date: Tue, 17 Jun 2025 17:23:31 +0200
Message-ID: <20250617152429.538507612@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Peter Robinson <pbrobinson@gmail.com>

[ Upstream commit a706a593cb19796f31d3a888423ef1a71885ae72 ]

As described in the radxa_rock_3c_v1400_schematic.pdf, the SPI Flash's
VCC connector is connected to VCCIO_FLASH and according to the
that same schematic, that belongs to the VCC_1V8 power source.

This fixes the following warning:

  spi-nor spi4.0: supply vcc not found, using dummy regulator

Fixes: ee219017ddb5 ("arm64: dts: rockchip: Add Radxa ROCK 3C")
Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Link: https://lore.kernel.org/r/20250506195702.593044-1-pbrobinson@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-rock-3c.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-rock-3c.dts b/arch/arm64/boot/dts/rockchip/rk3566-rock-3c.dts
index f2cc086e5001a..887c9be1b4100 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-rock-3c.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-rock-3c.dts
@@ -636,6 +636,7 @@
 		spi-max-frequency = <104000000>;
 		spi-rx-bus-width = <4>;
 		spi-tx-bus-width = <1>;
+		vcc-supply = <&vcc_1v8>;
 	};
 };
 
-- 
2.39.5



