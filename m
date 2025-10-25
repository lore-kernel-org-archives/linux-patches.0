Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616532264D4;
	Sat, 25 Oct 2025 16:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409538; cv=none; b=fJ30FPI36qlPPW9ls8Rp/nfVsg9F9n1FWr1GLje6GaxJiceLAcEhtkmt1iXdv3RyRGDs0yxaqZ9eSxawOhhm9fijY+10KwbiDAVD1eOgjbLBzNiSC/ZKXGksCRcAlfnEAAgGIEi/pPvyRC830dCM8ofIolUUEfrQXKgiXHju5bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409538; c=relaxed/simple;
	bh=oyqJMmPN3rWN3AOJaDWHoJ6cDvlE3/0sQVpRawYc1yM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UYP/0WxWbCVe7nTziwqtTx25h6ZrKMCviPmywLtX8OCpJhqQnNaSiaUxL58gYKvRAueA1J+ltvUZm5uiPM98dqZIMpyMLgGYXwymVfetyf8/pQbdB5+/+2VRI8U9rJvvDajAY+E38pJQHHiz58AaS2sJnU8p2aUcFw/QUIuzUvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T1uWtxPP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T1uWtxPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CAF5C4CEF5;
	Sat, 25 Oct 2025 16:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409538;
	bh=oyqJMmPN3rWN3AOJaDWHoJ6cDvlE3/0sQVpRawYc1yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1uWtxPP0sVyox67+xQSc96PJ8sl9iMimaoTz/XCbMeAjW4hH8OfGn+TErsEUzzHM
	 8Hg5v1rpfv+37K5XqW8V0Ah/ZisBPjKn/Hw02TKRzu8Hb/L5xoQkT5JWyakvndqE6x
	 1n1PHOfPsbPtBaAYZafSXInE76LsA+l6W5kodv0G92lkW0NnvI24CDb6qNyaItfj11
	 1JIKm0ii03+uXcMKudoG/Z2+bIsafIEPmZairxFS3B3dHuW4eHjotzeyWv8dXxvAnA
	 1lF767cX5W+fX7Z4dYbS10qxdurdvhrlM9SEu5inaQr9s8VI67p28rTMveYMWPxbB8
	 V4eKqTJT+l9KA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	alexandre.f.demers@gmail.com,
	alexander.deucher@amd.com,
	duoming@zju.edu.cn
Subject: [PATCH AUTOSEL 6.17-5.4] media: fix uninitialized symbol warnings
Date: Sat, 25 Oct 2025 11:59:46 -0400
Message-ID: <20251025160905.3857885-355-sashal@kernel.org>
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

From: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>

[ Upstream commit b4c441310c3baaa7c39a5457e305ca93c7a0400d ]

Initialize variables to fix these smatch warnings
drivers/media/i2c/ir-kbd-i2c.c:339 ir_key_poll() error: uninitialized
symbol 'protocol'.
drivers/media/i2c/ir-kbd-i2c.c:339 ir_key_poll() error: uninitialized
symbol 'scancode'.
drivers/media/i2c/ir-kbd-i2c.c:339 ir_key_poll() error: uninitialized
symbol 'toggle'.
drivers/media/tuners/xc4000.c:1102 xc_debug_dump() error: uninitialized
symbol 'adc_envelope'.
drivers/media/tuners/xc4000.c:1108 xc_debug_dump() error: uninitialized
symbol 'lock_status'.
drivers/media/tuners/xc4000.c:1123 xc_debug_dump() error: uninitialized
symbol 'frame_lines'.
drivers/media/tuners/xc4000.c:1127 xc_debug_dump() error: uninitialized
symbol 'quality'.
drivers/media/tuners/xc5000.c:645 xc_debug_dump() error: uninitialized
symbol 'adc_envelope'.
drivers/media/tuners/xc5000.c:651 xc_debug_dump() error: uninitialized
symbol 'lock_status'.
drivers/media/tuners/xc5000.c:665 xc_debug_dump() error: uninitialized
symbol 'frame_lines'.
drivers/media/tuners/xc5000.c:668 xc_debug_dump() error: uninitialized
symbol 'quality'.
drivers/media/tuners/xc5000.c:671 xc_debug_dump() error: uninitialized
symbol 'snr'.
drivers/media/tuners/xc5000.c:674 xc_debug_dump() error: uninitialized
symbol 'totalgain'.

Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[hverkuil: dropped ' = 0' from rc in ir-kbd-i2c.c, not needed]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- ir-kbd-i2c: Prevents real uninitialized use. Before this change,
  `ir_key_poll()` used three stack locals without defaults and then
  passed them to `rc_keydown()` when the low-level `get_key()` returned
  >0. See `drivers/media/i2c/ir-kbd-i2c.c:322` (pre-change) and the new
  initializations at `drivers/media/i2c/ir-kbd-i2c.c:324` where
  `protocol`, `scancode`, and `toggle` are now set to 0. This is not
  just a cosmetic fix: one `get_key()` implementation explicitly returns
  success without writing the outputs on a “repeat” indication:
  - In `get_key_knc1()`, the code does “keep old data” and returns 1
    without touching the out parameters when it reads 0xfe from the
    device, see `drivers/media/i2c/ir-kbd-i2c.c:232`. With
    `ir_key_poll()`’s locals previously uninitialized, this led to
    undefined behavior (garbage protocol/scancode/toggle) being used and
    logged, and passed into `rc_keydown()`.
  - Initializing `protocol=0` is semantically safe since
    `RC_PROTO_UNKNOWN` is 0 (`include/uapi/linux/lirc.h:206`).
    Initializing `scancode=0` and `toggle=0` likewise makes the fallback
    deterministic if a buggy `get_key()` path fails to set them while
    still returning success.
  - The call to `rc_keydown()` remains gated on `rc > 0` (same logic as
    before), but now will never consume uninitialized data; see the call
    at `drivers/media/i2c/ir-kbd-i2c.c:337`. `rc_keydown()` handles
    unknown/invalid scancodes gracefully by mapping via the keymap, see
    `drivers/media/rc/rc-main.c:848` and the surrounding logic.

- xc4000/xc5000: Debug-only safety. In both tuner drivers,
  `xc_debug_dump()` prints various measurements after calling
  `xc_get_*()` helpers. If any of those helpers fail to write their out
  parameters (e.g., due to transient I2C problems), the previous code
  could print uninitialized stack contents. The commit zero-initializes
  these locals (e.g., `adc_envelope`, `lock_status`, `frame_lines`,
  `quality`, etc.), see:
  - `drivers/media/tuners/xc4000.c:1102-1127` (variables now initialized
    to 0)
  - `drivers/media/tuners/xc5000.c:645-674` (same pattern)
  These dumps are gated behind debugging paths (e.g., `if (debug)
xc_debug_dump(priv);` in `drivers/media/tuners/xc5000.c:723`), so this
is a low‑risk safety improvement for diagnostics.

- Scope and risk assessment:
  - Fix type: Bugfix for uninitialized variable use (ir input path) and
    diagnostic robustness (tuners). No new features or behavior changes
    beyond removing undefined behavior.
  - Size and containment: Small, localized initializations in three
    driver files.
  - Criticality: Media subsystem drivers only; no core kernel or major
    architectural changes.
  - Semantics: Using 0 defaults aligns with established meanings (e.g.,
    `RC_PROTO_UNKNOWN=0`) and avoids UB. In the specific “keep old data”
    repeat case in `get_key_knc1()`, the previous behavior already
    relied on undefined state; this change makes it deterministic and
    safer for rc-core to handle.

Given it fixes a real potential runtime issue (use of uninitialized
values reaching `rc_keydown()` when certain device returns indicate
“keep old data”) with a minimal, low-risk change, this is a good
candidate for stable backport.

 drivers/media/i2c/ir-kbd-i2c.c |  6 +++---
 drivers/media/tuners/xc4000.c  |  8 ++++----
 drivers/media/tuners/xc5000.c  | 12 ++++++------
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index c84e1e0e6109a..5588cdd7ec20d 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -321,9 +321,9 @@ static int get_key_avermedia_cardbus(struct IR_i2c *ir, enum rc_proto *protocol,
 
 static int ir_key_poll(struct IR_i2c *ir)
 {
-	enum rc_proto protocol;
-	u32 scancode;
-	u8 toggle;
+	enum rc_proto protocol = 0;
+	u32 scancode = 0;
+	u8 toggle = 0;
 	int rc;
 
 	dev_dbg(&ir->rc->dev, "%s\n", __func__);
diff --git a/drivers/media/tuners/xc4000.c b/drivers/media/tuners/xc4000.c
index 3cf54d776d36c..b44c97e4e5ec6 100644
--- a/drivers/media/tuners/xc4000.c
+++ b/drivers/media/tuners/xc4000.c
@@ -1087,12 +1087,12 @@ static int check_firmware(struct dvb_frontend *fe, unsigned int type,
 
 static void xc_debug_dump(struct xc4000_priv *priv)
 {
-	u16	adc_envelope;
+	u16	adc_envelope = 0;
 	u32	freq_error_hz = 0;
-	u16	lock_status;
+	u16	lock_status = 0;
 	u32	hsync_freq_hz = 0;
-	u16	frame_lines;
-	u16	quality;
+	u16	frame_lines = 0;
+	u16	quality = 0;
 	u16	signal = 0;
 	u16	noise = 0;
 	u8	hw_majorversion = 0, hw_minorversion = 0;
diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index ec9a3cd4784e1..a28481edd22ed 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -622,14 +622,14 @@ static int xc5000_fwupload(struct dvb_frontend *fe,
 
 static void xc_debug_dump(struct xc5000_priv *priv)
 {
-	u16 adc_envelope;
+	u16 adc_envelope = 0;
 	u32 freq_error_hz = 0;
-	u16 lock_status;
+	u16 lock_status = 0;
 	u32 hsync_freq_hz = 0;
-	u16 frame_lines;
-	u16 quality;
-	u16 snr;
-	u16 totalgain;
+	u16 frame_lines = 0;
+	u16 quality = 0;
+	u16 snr = 0;
+	u16 totalgain = 0;
 	u8 hw_majorversion = 0, hw_minorversion = 0;
 	u8 fw_majorversion = 0, fw_minorversion = 0;
 	u16 fw_buildversion = 0;
-- 
2.51.0

