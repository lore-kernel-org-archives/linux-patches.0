Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D2E2F5324;
	Thu,  9 Oct 2025 16:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025639; cv=none; b=kpS9vi4EMrGsFdPyOyUgaPt9gPe2giico9ZC+snZHhM9j5pbwxCyS4gyN0P1X1+DPFyMtwdAUc0XRS8XW0K4MDwwU5XuAZntgxUoNcUD+qA5drK+Uf299vAIrwyrxGLQW3d4ctp7tEkkQQYCub9BYnGzffjW9C+9snoaSOTb7AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025639; c=relaxed/simple;
	bh=4devUkiUJ45SxtTYFgo9akTiO+CNe1YAFZ2rg7soOG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QPkS1BzFm6ad6ZVqI3sXVBdRAaK6HnR2vREfP+MFojNiXuK2mgbkSxLOjxu5FEOkXKBvG23LSEISHbamNFwWqJuL49GrXMV+IrPpjYBH3gZRyp1yeCb3jaswSqMzDu1ByoZb1EbhZXbwJL4sDe7pjQwBdJlL2Tmjn8JWs37Rbt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VhR/Yw1M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VhR/Yw1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF05C4CEF7;
	Thu,  9 Oct 2025 16:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025639;
	bh=4devUkiUJ45SxtTYFgo9akTiO+CNe1YAFZ2rg7soOG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VhR/Yw1Me7FBGrHAnWdE7k+o6g4EiqvHMMTL/zTh3qh4KaKDBy/OPM5Gj349NO5Mg
	 6Jg4HQwa5NN94DDQbOAWGguPUdMVxe5Jw6bWIG5AP7CUh1VUsVxfVrkJfRCym/SxOE
	 fCR0OmntjhCSR69pBozkTKAMJye7Om7o/Jx1k46AZ4dCYHzsUBjq+kx7Mb8nqxLknw
	 n3Jb13KbhQof5C3iSBmIZ5zC5BHuJAQgRxed3yAqUOiyCi5ezr0H8g9PWRwAer9E6x
	 2tDPsk/iPsT4EOVOrtb8dvlLl8Wu0PiZuDPbvEHBl3cvs7EjrXyz67ZjfDbGZcJcIG
	 atSaP9lzYgJvg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Svyatoslav Ryhel <clamor95@gmail.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jingoohan1@gmail.com,
	dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17-5.4] video: backlight: lp855x_bl: Set correct EPROM start for LP8556
Date: Thu,  9 Oct 2025 11:55:56 -0400
Message-ID: <20251009155752.773732-90-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit 07c7efda24453e05951fb2879f5452b720b91169 ]

According to LP8556 datasheet EPROM region starts at 0x98 so adjust value
in the driver accordingly.

Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Reviewed-by: "Daniel Thompson (RISCstar)" <danielt@kernel.org>
Link: https://lore.kernel.org/r/20250909074304.92135-2-clamor95@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Explanation
- What changed: The LP8556 EPROM start constant is corrected from 0xA0
  to 0x98. See drivers/video/backlight/lp855x_bl.c:25 (old 0xA0; commit
  changes to 0x98). The end remains 0xAF
  (drivers/video/backlight/lp855x_bl.c:26).
- How it’s used: The valid ROM window for a given chip is enforced by
  lp855x_is_valid_rom_area(), which selects the [start, end] range based
  on chip ID and filters all ROM writes against it:
  - Range selection for LP8556 uses these macros
    (drivers/video/backlight/lp855x_bl.c:114-116).
  - The write loop applies this filter when programming platform/DT-
    provided ROM entries (drivers/video/backlight/lp855x_bl.c:193-204),
    skipping any address outside the range.
  - DT parsing populates the ROM programming list
    (drivers/video/backlight/lp855x_bl.c:342-360), so the incorrect
    start value causes any LP8556 ROM entries in 0x98–0x9F to be
    silently ignored.

Why this matters
- Functional bug for LP8556: According to the commit message (datasheet
  reference), the LP8556 ROM region begins at 0x98. With the current
  code, addresses 0x98–0x9F are wrongly rejected by
  lp855x_is_valid_rom_area(), so intended ROM configuration may not be
  applied to LP8556 devices. This can lead to misconfiguration of
  backlight behavior on boards that rely on these addresses.
- The change is strictly a correction: It expands the accepted range for
  LP8556 to the true datasheet range [0x98..0xAF]. It does not alter
  behavior for other chips (LP8550/1/2/3 use LP855X_EEPROM_START/END at
  0xA0–0xA7, and LP8555/7 use their own ranges; see
  drivers/video/backlight/lp855x_bl.c:23-24,35-38).

Risk and regression assessment
- Small, contained fix: One-line macro change in a single driver file;
  no API/ABI or architectural changes.
- Low regression risk:
  - Only affects LP8556 and only the ROM programming acceptance window.
  - In-tree DTs for LP8556 commonly use 0xA0+ (e.g.,
    arch/arm/boot/dts/qcom/qcom-msm8974pro-sony-xperia-shinano-
    castor.dts:41), so existing configurations remain unaffected.
  - ACPI-enumerated LP8556 systems do not use ROM programming path (they
    read back registers), so they are unaffected by the range check.
  - Security impact: none; this is a correctness change to permitted I2C
    write addresses for the device’s configuration space.

Stable backport criteria
- Fixes a real bug: Corrects the ROM region mapping for LP8556 so valid
  configuration writes are no longer dropped.
- Minimal and clearly scoped: One constant change; code paths only in a
  leaf driver.
- No feature addition or architectural refactor.
- Touches a non-critical subsystem (backlight), and the behavior change
  is limited to enabling previously valid writes per datasheet.
- Reviewed-by and signed-off chain present; commit rationale is clear
  and tied to the datasheet.

Conclusion
- This is a safe, data-sheet-backed correctness fix that can affect
  actual device behavior for LP8556 users relying on 0x98–0x9F
  configuration. It is small, low risk, and appropriate for stable
  backporting.

 drivers/video/backlight/lp855x_bl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index 7075bfab59c4d..d191560ce285f 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -22,7 +22,7 @@
 #define LP855X_DEVICE_CTRL		0x01
 #define LP855X_EEPROM_START		0xA0
 #define LP855X_EEPROM_END		0xA7
-#define LP8556_EPROM_START		0xA0
+#define LP8556_EPROM_START		0x98
 #define LP8556_EPROM_END		0xAF
 
 /* LP8555/7 Registers */
-- 
2.51.0

