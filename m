Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBF133A712;
	Fri,  9 Jan 2026 11:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959635; cv=none; b=s5MprZbPCHzY3JG8IiDWMC2Eo8hrGDVU6ojONkopnI15Sb8vDNc/PsQZUM3mLfUOKnr1mmOkvi3nGni81CdkUsBvhcQfN0luwd9mcCvVMs6jV4O6BbHO5oDYudzRc3CWKmXZ/Lv2CDxSBCSJr2Ar9NhYgkOFwksL7pds4Lfw5TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959635; c=relaxed/simple;
	bh=LORscZtCQnO/F+QAojE513MsYo60c/J6IYvM+TP/Y8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PckyTMMFu+KD/calK7akaSJ9vosD1guS/ay4DGT1EOHje4605b5qUk8PxUrgr47E6dHkGnGKnoDCriaCtoAqSXD8PL3MMhM3Ef8CX81tPitnjoHPAzJZBWZXB6318ix7KxPNeBQxGLQHIMQzexn3n15vM3vsvmXQ8VODfozxRv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=19ihHFfM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="19ihHFfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B1CC4CEF1;
	Fri,  9 Jan 2026 11:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959635;
	bh=LORscZtCQnO/F+QAojE513MsYo60c/J6IYvM+TP/Y8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=19ihHFfMXvaoGG3CmQRSfEXQ6QHFN2G3SGziBrJ/KcqyZM6cHH3E7UtmHksJ4Omyz
	 d+QXzQfx3Q7Zuh+tYcId1+1E2PqIKbU/7XDX5+pWIelYVKK1xp/15AYRSfGTPpcLGT
	 aRBHf5xQPq8Xps6HdhWqJidhO8nZ0hQ4cQ6/UGv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/737] ARM: dts: omap3: n900: Correct obsolete TWL4030 power compatible
Date: Fri,  9 Jan 2026 12:34:21 +0100
Message-ID: <20260109112138.593248177@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jihed Chaibi <jihed.chaibi.dev@gmail.com>

[ Upstream commit 3862123e9b56663c7a3e4a308e6e65bffe44f646 ]

The "ti,twl4030-power-n900" compatible string is obsolete and is not
supported by any in-kernel driver. Currently, the kernel falls back to
the second entry, "ti,twl4030-power-idle-osc-off", to bind a driver to
this node.

Make this fallback explicit by removing the obsolete board-specific
compatible. This preserves the existing functionality while making the
DTS compliant with the new, stricter 'ti,twl.yaml' binding.

Fixes: daebabd578647 ("mfd: twl4030-power: Fix PM idle pin configuration to not conflict with regulators")
Signed-off-by: Jihed Chaibi <jihed.chaibi.dev@gmail.com>
Link: https://lore.kernel.org/r/20250914192516.164629-4-jihed.chaibi.dev@gmail.com
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ti/omap/omap3-n900.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/ti/omap/omap3-n900.dts b/arch/arm/boot/dts/ti/omap/omap3-n900.dts
index 036e472b77beb..98f259dbcb0d5 100644
--- a/arch/arm/boot/dts/ti/omap/omap3-n900.dts
+++ b/arch/arm/boot/dts/ti/omap/omap3-n900.dts
@@ -508,7 +508,7 @@ twl_audio: audio {
 	};
 
 	twl_power: power {
-		compatible = "ti,twl4030-power-n900", "ti,twl4030-power-idle-osc-off";
+		compatible = "ti,twl4030-power-idle-osc-off";
 		ti,use_poweroff;
 	};
 };
-- 
2.51.0



