Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653711F4615;
	Sat, 14 Feb 2026 01:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031129; cv=none; b=Oichnn0tQ0In1FdgKIu6+XPqZYyRcuWeEf8QreWQ4zhMaqPJDXp/cFppi46tbDIHrvzoyxq9GW/NvS1KtKuCdyA2CfVBOv39ZwviKLYBbwF2Dh0eOgey2o1vPCbjvYakOeobDSDqbaDTCxWuJt7bfY2TFZ7JJIXtol4nbowgwlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031129; c=relaxed/simple;
	bh=lAK1Rv2ji/05aw3D1Er4DgRpI5rSRRMJeig6pVLTcq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rt0t0YMANDpnNW+arUwio0Gny/8WKF2e03iLXiCGt+7RgjQAT+kyuFU1LAMWV2l0L6BYO+Nbooa1IymTCm+TbKeFob9kLhMMX6t8UATO+MD6+Yy94YsgK9/fq8dAaNJ2mZm8bGa0Y8RG20MWj7uW3U6IyNFegYx5SpSFh2zylqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k21GDKDN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k21GDKDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78889C19423;
	Sat, 14 Feb 2026 01:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031129;
	bh=lAK1Rv2ji/05aw3D1Er4DgRpI5rSRRMJeig6pVLTcq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k21GDKDNt3XkBJRV6UEhY53Ec62YFOu3tDcPHHIDn0jHHnLiVbMm/a8R9uhzdaMw6
	 KzAhNigfcFZR4Xm9+Id25nMhyju1LHhp1qeKqQ3sdJiO4DMfsB+YV2Qn+Fp0AH28Cr
	 mLEfWgTleQIyAbjP5k9KepnJH8UdrylBnk0HthaU1DfIGfxuRhfI5+7XLo6WLbhP9m
	 m/xjr3XLL0kWMVEAFbv6RnbGKEN5cQazX6soFyYjWhRLOH+khspZEvGEGiufk3qUw/
	 ViZQGXjGvcsqu4fqegdhfXnxMg5tLfqOWjsYJ129Ri0NjPAZgTJAHSQCUo5HAJ/xa9
	 Nv09g03+rrMxQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: fenugrec <fenugrec@mail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	roy.vegard.ovesen@gmail.com,
	neil.armstrong@linaro.org,
	yelangyan@huaqin.corp-partner.google.com
Subject: [PATCH AUTOSEL 6.19-6.18] ALSA: usb-audio: presonus s18xx uses little-endian
Date: Fri, 13 Feb 2026 19:59:13 -0500
Message-ID: <20260214010245.3671907-73-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: fenugrec <fenugrec@mail.com>

[ Upstream commit 3ce03297baff0ba116769044e4594fb324d4a551 ]

Use __le32 types for USB control transfers

Signed-off-by: fenugrec <fenugrec@mail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260111-preso_clean1-v2-1-44b4e5129a75@mail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of ALSA: usb-audio: presonus s18xx uses little-endian

### Commit Message Analysis

The commit converts USB control transfer packet structures from native
`u32` types to `__le32` (little-endian 32-bit) types in the PreSonus
S1810c/S1824c USB audio mixer driver. This is an endianness correctness
fix.

### Code Change Analysis

The changes are in `sound/usb/mixer_s1810c.c` and consist of:

1. **Structure type changes**: `struct s1810c_ctl_packet` and `struct
   s1810c_state_packet` fields changed from `u32` to `__le32`
2. **Write path**: All assignments to packet fields now use
   `__cpu_to_le32()` to convert from CPU-native to little-endian before
   sending to the USB device
3. **Read path**: The value read back from the device is converted using
   `__le32_to_cpu()` before being stored in a native `u32`

### Bug Classification: Endianness Bug

This is a classic endianness/type correctness fix. USB is a little-
endian bus protocol. When these `u32` fields are sent via
`snd_usb_ctl_msg()` (which wraps `usb_control_msg()`), they're
transmitted as raw bytes. On **little-endian architectures** (x86),
`u32` and `__le32` have the same byte representation, so this bug is
invisible. However, on **big-endian architectures** (PowerPC, s390, some
ARM configurations, MIPS), the bytes would be in the wrong order,
causing:

- The device would receive garbled control values
- The driver would read back garbled state values
- The mixer controls (volume, mute, 48V phantom power, line switches)
  would be completely non-functional
- The device would be unusable on big-endian systems

### Severity Assessment

- **On little-endian (x86)**: No visible effect - the fix is a no-op in
  practice
- **On big-endian**: This fixes a complete driver malfunction. The
  PreSonus S1810c/S1824c audio interface would not function correctly at
  all - mixer controls would send wrong values to hardware

This is a **real bug fix**, not a cleanup or style change. The sparse
annotation change (`u32` -> `__le32`) isn't just about satisfying the
checker - the `__cpu_to_le32()` / `__le32_to_cpu()` conversions actually
perform byte swaps on big-endian systems.

### Scope and Risk

- **Files changed**: 1 file (`sound/usb/mixer_s1810c.c`)
- **Nature of changes**: Purely mechanical type conversions - every
  change follows the exact same pattern
- **Risk**: Very low. On little-endian systems, the byte-swap macros
  compile to no-ops, so behavior is identical. On big-endian systems,
  this fixes broken behavior.
- **No new features**: This is purely a correctness fix
- **Self-contained**: No dependencies on other commits
- **Small and surgical**: The changes are straightforward and mechanical

### Stable Kernel Criteria

1. **Obviously correct and tested**: Yes - standard endianness
   conversion pattern used throughout the kernel
2. **Fixes a real bug**: Yes - driver is broken on big-endian
   architectures
3. **Important issue**: The device is completely non-functional on big-
   endian systems
4. **Small and contained**: Yes - single file, mechanical changes
5. **No new features**: Correct - pure bug fix
6. **Applies cleanly**: Should apply cleanly as this driver code hasn't
   changed significantly

### Concerns

- The commit message is terse and doesn't explicitly mention the
  endianness bug or affected architectures
- No Fixes: tag or Cc: stable tag (expected for commits in this review
  pipeline)
- Impact is limited to big-endian users of this specific USB audio
  device (a relatively niche intersection)

### Verdict

This is a legitimate endianness bug fix in a USB audio driver. While the
affected user population (big-endian + PreSonus S1810c/S1824c) is small,
the fix is trivially correct, zero-risk on the dominant x86 platform,
and fixes a complete driver malfunction on affected platforms. It meets
all stable kernel criteria: small, surgical, obviously correct, fixes a
real bug, and introduces no new features.

**YES**

 sound/usb/mixer_s1810c.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/sound/usb/mixer_s1810c.c b/sound/usb/mixer_s1810c.c
index 6e09e074c0e7f..93510aa0dc5ef 100644
--- a/sound/usb/mixer_s1810c.c
+++ b/sound/usb/mixer_s1810c.c
@@ -82,13 +82,13 @@
  * mixer and output but a different set for device.
  */
 struct s1810c_ctl_packet {
-	u32 a;
-	u32 b;
-	u32 fixed1;
-	u32 fixed2;
-	u32 c;
-	u32 d;
-	u32 e;
+	__le32 a;
+	__le32 b;
+	__le32 fixed1;
+	__le32 fixed2;
+	__le32 c;
+	__le32 d;
+	__le32 e;
 };
 
 #define SC1810C_CTL_LINE_SW	0
@@ -118,7 +118,7 @@ struct s1810c_ctl_packet {
  * being zero and different f1/f2.
  */
 struct s1810c_state_packet {
-	u32 fields[63];
+	__le32 fields[63];
 };
 
 #define SC1810C_STATE_48V_SW	58
@@ -140,14 +140,14 @@ snd_s1810c_send_ctl_packet(struct usb_device *dev, u32 a,
 	struct s1810c_ctl_packet pkt = { 0 };
 	int ret = 0;
 
-	pkt.fixed1 = SC1810C_CMD_F1;
-	pkt.fixed2 = SC1810C_CMD_F2;
+	pkt.fixed1 = __cpu_to_le32(SC1810C_CMD_F1);
+	pkt.fixed2 = __cpu_to_le32(SC1810C_CMD_F2);
 
-	pkt.a = a;
-	pkt.b = b;
-	pkt.c = c;
-	pkt.d = d;
-	pkt.e = e;
+	pkt.a = __cpu_to_le32(a);
+	pkt.b = __cpu_to_le32(b);
+	pkt.c = __cpu_to_le32(c);
+	pkt.d = __cpu_to_le32(d);
+	pkt.e = __cpu_to_le32(e);
 
 	ret = snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
 			      SC1810C_CMD_REQ,
@@ -176,8 +176,8 @@ snd_sc1810c_get_status_field(struct usb_device *dev,
 	struct s1810c_state_packet pkt_in = { { 0 } };
 	int ret = 0;
 
-	pkt_out.fields[SC1810C_STATE_F1_IDX] = SC1810C_SET_STATE_F1;
-	pkt_out.fields[SC1810C_STATE_F2_IDX] = SC1810C_SET_STATE_F2;
+	pkt_out.fields[SC1810C_STATE_F1_IDX] = __cpu_to_le32(SC1810C_SET_STATE_F1);
+	pkt_out.fields[SC1810C_STATE_F2_IDX] = __cpu_to_le32(SC1810C_SET_STATE_F2);
 	ret = snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
 			      SC1810C_SET_STATE_REQ,
 			      SC1810C_SET_STATE_REQTYPE,
@@ -197,7 +197,7 @@ snd_sc1810c_get_status_field(struct usb_device *dev,
 		return ret;
 	}
 
-	(*field) = pkt_in.fields[field_idx];
+	(*field) = __le32_to_cpu(pkt_in.fields[field_idx]);
 	(*seqnum)++;
 	return 0;
 }
-- 
2.51.0

