Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B1A1527B4;
	Sun, 26 Oct 2025 14:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490248; cv=none; b=MfeOmorzkNSkjpnBNbYTxLR2bpUzDoRmomGGcLDqOX5dQzGbz9QR55I4OBfa3jYiVGRWRVRlrNOOTlHD6QpqFjIJykf7iUDp95E9qS+JLPIze8p5JIUVQwXil7zUuYKUjdRLWmQk4P7/izIElDLE2G6alNoexqrcnZtMI9i81bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490248; c=relaxed/simple;
	bh=dBHCT2N10+Es25smpKMfNxMlaeXmdbIXmLSM9/ZRbi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z12ogLDLWWEfAsz0+sXg/u2PIYzviBHKnd21Hmumm8QKB7DQ1L2lP4QwK03oCDZOl2UFYWog1OFRt/Sd2ckLX+R8I3LKPX8SPtb9ZKpPcKk+rtzMP3lVvFn0K/cn/4raQZstnf0o0+lBhTCK8VdKCiPDhk7nI7C5MPWbrclNMQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L77Rt45v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L77Rt45v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24872C4CEF1;
	Sun, 26 Oct 2025 14:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490248;
	bh=dBHCT2N10+Es25smpKMfNxMlaeXmdbIXmLSM9/ZRbi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L77Rt45vKRIGc9Be/izx33RAxsO1uz+Fzz3VJU8ajQuGvkdrw0c9ayhEGuGGh29hy
	 RBDqxZp0DzgxndIg2CWThue0afaDH7Y4FT5hWKrkJrz+9pyIp8PSqePJeUpRoGRZSn
	 GcfBmb7VccqUqaGJVFOMYxmb4pJN6u8s0Ry6K2LjVEdIFbnKXNgKPinmEUelpOv5AC
	 tRqROrX1h8107yQbHdWvqYcMNxGNBH4oSlJ/BkG+pwlm1kP7popxHI0bfQou+AV8o+
	 UUWlxdv+cQ13Yuo6gtrRFnzuL3G8DSwVWOOgu9D32M0Z5lnXO9CCvzBcPfvav247C/
	 bmO5E5G0YYIhQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Balamanikandan Gunasundar <balamanikandan.gunasundar@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Sasha Levin <sashal@kernel.org>,
	alexandre.belloni@bootlin.com,
	cristian.birsan@microchip.com,
	varshini.rajendran@microchip.com,
	alexandre.f.demers@gmail.com,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-6.12] clk: at91: sam9x7: Add peripheral clock id for pmecc
Date: Sun, 26 Oct 2025 10:48:59 -0400
Message-ID: <20251026144958.26750-21-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026144958.26750-1-sashal@kernel.org>
References: <20251026144958.26750-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Balamanikandan Gunasundar <balamanikandan.gunasundar@microchip.com>

[ Upstream commit 94a1274100e397a27361ae53ace37be6da42a079 ]

Add pmecc instance id in peripheral clock description.

Signed-off-by: Balamanikandan Gunasundar <balamanikandan.gunasundar@microchip.com>
Link: https://lore.kernel.org/r/20250909103817.49334-1-balamanikandan.gunasundar@microchip.com
[claudiu.beznea@tuxon.dev: use tabs instead of spaces]
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – the fix should go to stable.

- `drivers/clk/at91/sam9x7.c:411` now lists the PMC peripheral clock
  slot for the PMECC block (ID 48). This table drives the loop in
  `sam9x7_pmc_setup()` that registers every peripheral clock with the
  framework (`drivers/clk/at91/sam9x7.c:889-904`). Without the entry, no
  `clk_hw` is created for ID 48, so any DT request such as `clocks =
  <&pmc PMC_TYPE_PERIPHERAL 48>` fails at probe time with `-ENOENT`,
  leaving the PMECC clock gated.
- On Microchip/Atmel SoCs, peripheral clocks power up disabled. The
  PMECC driver programs and polls the engine via MMIO
  (`drivers/mtd/nand/raw/atmel/pmecc.c:843-870`); if the clock stays
  off, register writes and the ready poll (`readl_relaxed_poll_timeout`)
  never complete, which causes ECC operations to time out and the NAND
  subsystem to fail.
- The SAM9X7 DT already exposes the PMECC device
  (`arch/arm/boot/dts/microchip/sam9x7.dtsi:1132-1134`), so enabling
  NAND with ECC depends on the clock being reachable. The patch is a
  one-line data addition with no behavioural impact outside supplying
  the missing clock, making the backport low-risk and clearly bug-fixing
  for users relying on PMECC.

 drivers/clk/at91/sam9x7.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/at91/sam9x7.c b/drivers/clk/at91/sam9x7.c
index 7322220418b45..89868a0aeaba9 100644
--- a/drivers/clk/at91/sam9x7.c
+++ b/drivers/clk/at91/sam9x7.c
@@ -408,6 +408,7 @@ static const struct {
 	{ .n = "pioD_clk",	.id = 44, },
 	{ .n = "tcb1_clk",	.id = 45, },
 	{ .n = "dbgu_clk",	.id = 47, },
+	{ .n = "pmecc_clk",	.id = 48, },
 	/*
 	 * mpddr_clk feeds DDR controller and is enabled by bootloader thus we
 	 * need to keep it enabled in case there is no Linux consumer for it.
-- 
2.51.0

