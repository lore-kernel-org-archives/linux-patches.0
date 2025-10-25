Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11AE238142;
	Sat, 25 Oct 2025 16:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408914; cv=none; b=p6RgtMuZMk6tY1WZf3nFkkLv6u4IB0fKm2r6yLeveCKA0YYuJOzaY8f3kBxNSdF7mV4KK3WdsO7iJ60eYcw3KnO7QnmcUCEVwBlmmeTRQ0SvnHq57pQhcHiKQwbEbFLmKARVxXDDhFXgBOGkg35tfaKk6UjXnGSe/mJXQ2IgxOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408914; c=relaxed/simple;
	bh=DBe2+Jht5iI3EKB/ylRG9TOBM76wBtbt2Pul9IeTvc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a0dE0nehUSklayRtTB5gOkehtW4CEnEkGAtut+CPqIbY5PgLB/n0tvJvf1mK9LFgYs7auCg5s/TZd7DBwVlzblQkQ9qljEl3s0Lx+8v8TBOHPcROVhDsYed14K6jRnTpQNGWAU6+1QDbMqy6QdG8yFtSWhKtyYs4QtGHXJeR9gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yb5xjoPm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yb5xjoPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB5DC113D0;
	Sat, 25 Oct 2025 16:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408914;
	bh=DBe2+Jht5iI3EKB/ylRG9TOBM76wBtbt2Pul9IeTvc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yb5xjoPmxNfHOp9LDOR7VNKZYBv5jU3yRgeFjRhVTVkC2QID9Jvi03jVs6gt0aNPZ
	 LubH9iP78DjcfjLXkh/pl/ah7IRa51YKu+XMWcFrQNG8WufaPcCuIKvaevVNYDhtFt
	 l9F7bWjIE+UwboOqrnK5V90P9dc0gN9N0J3RDSrxylgIp17amkfKe+ZfF8o2ubl8B2
	 n4ZYfFzIkAJZTXCAYjMIx8FYHChNwmb7m8Hr1z6EAUdhH4kZSVe5EmGW4/ZlvkMp7N
	 DdbRk3ZuyE93q0lBSsZhH2eYUFmJWmDyY069Y6hDZCGFPAXpjKYUX5tnSeMymC+VAB
	 APUTXXiLcr+CQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Marcus Folkesson <marcus.folkesson@gmail.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.17] drm/st7571-i2c: add support for inverted pixel format
Date: Sat, 25 Oct 2025 11:55:59 -0400
Message-ID: <20251025160905.3857885-128-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
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

From: Marcus Folkesson <marcus.folkesson@gmail.com>

[ Upstream commit e61c35157d32b4b422f0a4cbc3c40d04d883a9c9 ]

Depending on which display that is connected to the controller, an
"1" means either a black or a white pixel.

The supported formats (R1/R2/XRGB8888) expects the pixels
to map against (4bit):
    00 => Black
    01 => Dark Gray
    10 => Light Gray
    11 => White

If this is not what the display map against, make it possible to invert
the pixels.

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Link: https://lore.kernel.org/r/20250721-st7571-format-v2-4-159f4134098c@gmail.com
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Fixes a real user-visible bug: Many ST7571/ST7567-based panels wire
  pixel polarity differently, so a “1” stored in display RAM can mean
  black or white depending on the glass. Without a way to invert,
  affected panels show inverted colors/gray levels. This change makes
  that correctable in a board-specific, opt-in way via DT.

- Small, contained change with default behavior unchanged: The driver
  still programs “normal” mode unless explicitly told to invert. The
  only behavior change is when the new DT boolean is present.

- Specific code changes
  - Adds per-device state to track inversion:
    - `drivers/gpu/drm/sitronix/st7571-i2c.c:154` adds `bool inverted;`
      to `struct st7571_device`.
  - Parses an opt-in DT property for both variants:
    - `drivers/gpu/drm/sitronix/st7571-i2c.c:796` reads
      `sitronix,inverted` in `st7567_parse_dt()`.
    - `drivers/gpu/drm/sitronix/st7571-i2c.c:824` reads
      `sitronix,inverted` in `st7571_parse_dt()`.
  - Applies inversion during controller initialization:
    - Previously hardcoded to normal mode, i.e. `ST7571_SET_REVERSE(0)`.
    - Now conditional:
      - `drivers/gpu/drm/sitronix/st7571-i2c.c:879` uses
        `ST7571_SET_REVERSE(st7567->inverted ? 1 : 0)` in the ST7567
        init sequence.
      - `drivers/gpu/drm/sitronix/st7571-i2c.c:923` uses
        `ST7571_SET_REVERSE(st7571->inverted ? 1 : 0)` in the ST7571
        init sequence.
  - The command used is appropriate: `ST7571_SET_REVERSE(r)`
    (`drivers/gpu/drm/sitronix/st7571-i2c.c:61`) toggles the
    controller’s normal/inverse display mapping, which affects both
    monochrome and 4-level grayscale mapping uniformly.

- No architectural changes and minimal risk of regressions:
  - Change is confined to a single driver and two init paths; no core
    DRM impacts.
  - Default remains normal (non-inverted), so existing systems are
    unaffected unless they opt in via DT.
  - No userspace ABI changes; the interface is device-tree only.
  - The property is boolean and optional; absence preserves legacy
    behavior.

- Stable backport criteria fit:
  - Addresses a correctness issue for real hardware (wrong polarity
    makes displays appear inverted).
  - Patch is small and straightforward, with clear, localized side
    effects.
  - No new features visible to userspace; it’s an optional DT quirk to
    match panel wiring.

Given the above, this is a low-risk, targeted fix enabling correct
operation for affected panels and is suitable for stable backporting.

 drivers/gpu/drm/sitronix/st7571-i2c.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/sitronix/st7571-i2c.c b/drivers/gpu/drm/sitronix/st7571-i2c.c
index 453eb7e045e5f..125e810df1391 100644
--- a/drivers/gpu/drm/sitronix/st7571-i2c.c
+++ b/drivers/gpu/drm/sitronix/st7571-i2c.c
@@ -151,6 +151,7 @@ struct st7571_device {
 	bool ignore_nak;
 
 	bool grayscale;
+	bool inverted;
 	u32 height_mm;
 	u32 width_mm;
 	u32 startline;
@@ -792,6 +793,7 @@ static int st7567_parse_dt(struct st7571_device *st7567)
 
 	of_property_read_u32(np, "width-mm", &st7567->width_mm);
 	of_property_read_u32(np, "height-mm", &st7567->height_mm);
+	st7567->inverted = of_property_read_bool(np, "sitronix,inverted");
 
 	st7567->pformat = &st7571_monochrome;
 	st7567->bpp = 1;
@@ -819,6 +821,7 @@ static int st7571_parse_dt(struct st7571_device *st7571)
 	of_property_read_u32(np, "width-mm", &st7571->width_mm);
 	of_property_read_u32(np, "height-mm", &st7571->height_mm);
 	st7571->grayscale = of_property_read_bool(np, "sitronix,grayscale");
+	st7571->inverted = of_property_read_bool(np, "sitronix,inverted");
 
 	if (st7571->grayscale) {
 		st7571->pformat = &st7571_grayscale;
@@ -873,7 +876,7 @@ static int st7567_lcd_init(struct st7571_device *st7567)
 		ST7571_SET_POWER(0x6),	/* Power Control, VC: ON, VR: ON, VF: OFF */
 		ST7571_SET_POWER(0x7),	/* Power Control, VC: ON, VR: ON, VF: ON */
 
-		ST7571_SET_REVERSE(0),
+		ST7571_SET_REVERSE(st7567->inverted ? 1 : 0),
 		ST7571_SET_ENTIRE_DISPLAY_ON(0),
 	};
 
@@ -917,7 +920,7 @@ static int st7571_lcd_init(struct st7571_device *st7571)
 		ST7571_SET_COLOR_MODE(st7571->pformat->mode),
 		ST7571_COMMAND_SET_NORMAL,
 
-		ST7571_SET_REVERSE(0),
+		ST7571_SET_REVERSE(st7571->inverted ? 1 : 0),
 		ST7571_SET_ENTIRE_DISPLAY_ON(0),
 	};
 
-- 
2.51.0

