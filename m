Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062313;
	b=5cQRm/SBIDiAws3Uy03avGPZdF+bSxwtDk7QJnBRCRNsgEnqHvcmjLVxC4+MGtGKQ76h
	 4b1taqTO3hwIMgWzsJxym5sVulAHHUdXx64q0k6vwZFgYTdMp5fpQ6hSwPAXC3mnUXOr2
	 ATm5D+1XsJY1rwFgt42+lxg8JJgfoVo6q+pZzinmaf9gbf4nTj3c119rDAoXQTKPnjkkH
	 7294fCgQf31NOorFPwmvhGMJ9CEm1wz+ClZAM2CSlnwFc6XqWpz4+qCNqBq8l02Qx/a57
	 1tHSUin+UvDyonRGjDrvi/wZQei04/ax6GVyAS2MejsdunbjThakDTWaTAWCseLorPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062313;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Cx0WaoFMVYuRk/yYQePuN7UwFeme5whUOFMBlRxABPQ=;
	b=D/+F5Y4qX3Uexigk0bKKFXD2swJEWqZqBGXEHrmQiFCXC+cTvkL1bzcPuL155s15UI7d
	 5Fxgl8fk0Pn7js9pSV32yrrmjo+iHOV7tJf8GNYOlABogZ+F019VAjsUYJKRUMyWMo0Jf
	 UP6KedpCgfu/Y8XW8+xdaJfqd8cRH77Q6vWrKnh19apHkc5LnKSaFh16yzFA1ehqZ6mA8
	 lTHlgK9OVeKr2Sy5sfSMRCd4CTt+hTQzz6okTu2JuOBjWFfU4u5fZHbj2QCT0Yo4891AM
	 i/V7PKZNhA8OnqcQOXk0WgrzARh7MWDlOGE+vRhjBE7NYvTmfaQQT1ZI8bPpF6r+lVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XKExHFjh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50230606A648;
	Sat,  7 Nov 2026 14:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XKExHFjh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F290D1F0089F;
	Sat,  7 Nov 2026 14:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062313;
	bh=Cx0WaoFMVYuRk/yYQePuN7UwFeme5whUOFMBlRxABPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XKExHFjhLhshoJ7Lj6yOcTES3Kwf9g1h0j671eRGevjbzsJz+0qYb5XwgZZGkab6t
	 8U4krJfU0ZfCw7hxaB1+vBU7DQwOsUVF/vPGeXbYh5BcL52mUOcDK+tDr+Kebn9EOq
	 pY1v8myYBjJ3mFqjv9j6XmuQb0Y6Ce8fcKifjgCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Baigue <hugobaigue2004@gmail.com>,
	Denis Benato <denis.benato@linux.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1248/1536] platform/x86: asus-wmi: fix screenpad power state detection
Date: Sat,  7 Nov 2026 08:54:24 -0500
Message-ID: <20261107135032.822483600@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 07d14fa33c034..af9505b2455ae 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -4098,13 +4098,20 @@ static int is_display_toggle(int code)
 
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
@@ -4168,16 +4175,17 @@ static int asus_screenpad_init(struct asus_wmi *asus)
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



