Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064734;
	b=uYcE98V1AF9wYlSDubfSJyR/b5Ub1Ww03M2gn0PtyWUYiMjptynwSY+auKRami+BV7iC
	 EOuea1lzFtwO6whFFMObFLlR8C0dJOO5a6THvifzn5+JGNTwIzhbSEMh8sBJPceKOQNZy
	 3hsXFgKVMR9JBIl/SiixtFjSMg1UmngtSMKCHOpEw/37Ob9yXr0vNLUdcQegGqjbaKM6c
	 bYVmsJnfzSLmkB027CRn/N8Z5mDn8MIHhd6im+zwgh8Hd9ijJCo++szaCIO8uwrf1SVAi
	 ttSXLC9p3JdcPvOsghC4qlhR4AhFaeJi04zrCBezzw0i9vhDotlLy2VkTzccOJkh1sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064734;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=iSSgXx91Q1/7psrPYr9y8uhtCSFz7msUHgWCn9iPR6g=;
	b=jt4fHNCbWqnqbP5N3+a7lJld1vmJ+kByE+QwgIYT9l49qYLdAc+M98djMArSbMl4f99v
	 VuXg7ZBD2KNtuaTllKQnx5oVTZsXdl0n2D5j3ylMf63yGO2E8YxLibiKqd8d/qj5FPr4c
	 Cyj51LK3KrKKArmHw11K3juTgDS2cV7KMO3VguDciNfavSrRanpOEA5tw5odYlPpTdbUD
	 8RabZ7PG0fo6c7+cf9O5+lCNExXlR676o3wiOR0JcZg18mmV5qINI/26HjQheTfB905AE
	 CztH8x4zI/f/yV18OKDWj6dEI3Cbzt0TXWo6yOPk1UPz34nkedHEX4NnFDpCWwP/tSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kSB4n1Is;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5362606A9C9;
	Sat,  7 Nov 2026 15:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kSB4n1Is
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641CE1F0089F;
	Sat,  7 Nov 2026 15:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064733;
	bh=iSSgXx91Q1/7psrPYr9y8uhtCSFz7msUHgWCn9iPR6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kSB4n1Isfb2lW0noY+Z2fidnJGdLRXmaQqFSsZg8YKdQWYOCQgx6R0VnmwDtM5sK6
	 8hQP+B7MqL5khhtvThF6JUpFl4uFzW2K19kgDdgJkskoodMz7zb3ESgQqoZFAASLj1
	 TvLII5SdRuV127j9u3VFUm8l6PH324YGRnXQ71Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Baigue <hugobaigue2004@gmail.com>,
	Denis Benato <denis.benato@linux.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0671/1257] platform/x86: asus-wmi: fix screenpad power state detection
Date: Sat,  7 Nov 2026 08:49:27 -0500
Message-ID: <20261107134957.791913486@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Benato <denis.benato@linux.dev>

[ Upstream commit f9a1cd14b392a82fdc73474894bf8b198757dfb2 ]

On some models, e.g. the UX5400EA, the screenpad power state cannot be
read back: DSTS(ASUS_WMI_DEVID_SCREENPAD_POWER) never sets
ASUS_WMI_DSTS_STATUS_BIT, so asus_wmi_get_devstate_simple() reports the
panel as powered off regardless of its real state.

The DSDT shows DSTS 0x00050031 (POWER) and DSTS 0x00050032 (LIGHT)
both read the same two-byte EC register, each returning a different
byte: byte 0 is a raw EC status byte, which is 0xa0 when the panel is
powered and 0x00 when it is off, and byte 1 is the brightness. Read
the power state from the low byte instead of
ASUS_WMI_DSTS_STATUS_BIT: firmware reporting the power through the
status bit is covered too, since ASUS_WMI_DSTS_STATUS_BIT lies inside
ASUS_WMI_DSTS_BRIGHTNESS_MASK.

Reuse read_screenpad_backlight_power() in asus_screenpad_init() in
place of the raw devstate read. This makes the brightness read
reachable on models like the UX5400EA, so mask the SCREENPAD_LIGHT
value with ASUS_WMI_DSTS_BRIGHTNESS_MASK before storing it: the
unmasked devstate (0x0001ffa0 when the panel is on) would otherwise be
exposed to userspace as an out-of-range brightness (max_brightness is
255) which systemd-backlight then persists.

While at it, pass asus_wmi_get_devstate() the u32 it expects.

Fixes: 130d29c5627c ("platform/x86: asus-wmi: adjust screenpad power/brightness handling")
Reported-by: Hugo Baigue <hugobaigue2004@gmail.com>
Closes: https://lore.kernel.org/all/CAO84+x+P2_xyHP89+nGVSMV6bL+dy0P9=vyEEfZGnFhv0hBNWw@mail.gmail.com/
Suggested-by: Hugo Baigue <hugobaigue2004@gmail.com>
Tested-by: Hugo Baigue <hugobaigue2004@gmail.com>
Cc: stable@vger.kernel.org
Assisted-by: zcode:glm-5.3-flash
Signed-off-by: Denis Benato <denis.benato@linux.dev>
Link: https://patch.msgid.link/20260916143838.170950-3-denis.benato@linux.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 10c8fcb075b2d..3cc0b96baeb34 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -4498,13 +4498,20 @@ static int is_display_toggle(int code)
 
 static int read_screenpad_backlight_power(struct asus_wmi *asus)
 {
-	int ret;
+	int ret, retval;
 
-	ret = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_SCREENPAD_POWER);
+	ret = asus_wmi_get_devstate(asus, ASUS_WMI_DEVID_SCREENPAD_POWER, &retval);
 	if (ret < 0)
 		return ret;
-	/* 1 == powered */
-	return ret ? BACKLIGHT_POWER_ON : BACKLIGHT_POWER_OFF;
+
+	/*
+	 * The firmware reports the panel power in the low byte of the
+	 * devstate as a raw EC status byte that is non-zero when the
+	 * panel is powered; other models report it through
+	 * ASUS_WMI_DSTS_STATUS_BIT, which lies inside the same mask.
+	 */
+	return (retval & ASUS_WMI_DSTS_BRIGHTNESS_MASK) ?
+		BACKLIGHT_POWER_ON : BACKLIGHT_POWER_OFF;
 }
 
 static int read_screenpad_brightness(struct backlight_device *bd)
@@ -4568,16 +4575,17 @@ static int asus_screenpad_init(struct asus_wmi *asus)
 	struct backlight_device *bd;
 	struct backlight_properties props;
 	int err, power;
-	int brightness = 0;
+	u32 brightness = 0;
 
-	power = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_SCREENPAD_POWER);
+	power = read_screenpad_backlight_power(asus);
 	if (power < 0)
 		return power;
 
-	if (power) {
+	if (power == BACKLIGHT_POWER_ON) {
 		err = asus_wmi_get_devstate(asus, ASUS_WMI_DEVID_SCREENPAD_LIGHT, &brightness);
 		if (err < 0)
 			return err;
+		brightness &= ASUS_WMI_DSTS_BRIGHTNESS_MASK;
 	}
 
 	memset(&props, 0, sizeof(struct backlight_properties));
-- 
2.53.0



