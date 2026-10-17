Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD1B3B8BC1;
	Sat, 17 Oct 2026 17:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256483; cv=none; b=FpCJ02WPpxduYN/m3UNGtbMjJuZhUQMXekv1fXtBdsQAAP7BoQgyp3TSA6HW7epouYPYywcj9fQKZJ7R8PHq4xpOAJGPX1liMxeeS86Hq/YMCwBMUk0t3fd6fc5JxwK+5cahSpV+xKUFb+ws0Lkcg/9qYXP1TkBBXPN76Q0G/kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256483; c=relaxed/simple;
	bh=c80OhskIoerVXn4FBSaEpTAJKg/uVmvnx6Mgf12ZvGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+nxPk/NUL0bIdoaLXJSCN0yGyW3P98lR5gOgBq40mqjH0oAEaEK9MN9fS9vtihIMX+J+49XagfMZNqoKeYMAuofmKZ5aecoTuDaVEOzWvnxGpYOpONqkhbuVrW0MN2VoEnIsoZ27ad5yBywZejw0BTRG+LvyrybOsWd+vdVpoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hkafVoH8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hkafVoH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85EA1F000C4;
	Sat, 17 Oct 2026 17:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256482;
	bh=ZRhb8Elzo/ZfKVqzETdYjvS+l0yN20uDysMPpYV+SHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hkafVoH8GHqmod8JXs3IkyvEKpZmm8Qb1EXjIGQxLK3lSRQ1Y6BBu08iox8gvJZPs
	 DJGcO/syEoLUpO7ZwWjnpqWc5MywO6kqvZCvmbwH70pfomG5t+WcUV4e6/8pafjZZ9
	 Cx1y1c/aZm5PCZziotaW8tkuj1wRej9WsySzylIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Brey <cico0815@gmx.de>,
	Lovekesh Solanki <lovekeshsolanki00@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 0249/1674] Input: i8042 - add nomux quirk for Fujitsu LIFEBOOK U7410
Date: Sat, 17 Oct 2026 17:42:01 +0200
Message-ID: <20261017160437.518056647@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Lovekesh Solanki <lovekeshsolanki00@gmail.com>

commit 495cd7f858b45d2ffa9b685bba3a8c23c1ca4dd3 upstream.

On the Fujitsu LIFEBOOK U7410 the internal keyboard and touchpad die
shortly after boot if i8042 multiplexing controller is probed and
switched to muxed mode. These multiplexing setup commands disturb the EC
emulated keyboard and atkbd reports "Spurious ACK" and "Unknown key
pressed" warnings, after which both keyboard and touchpad stop
delivering events. Both touchpad and keyboard work in BIOS and GRUB.

Disabling multiplexer using i8042.nomux=1 makes both devices work on
warm/cold boot.

Add a DMI quirk to force nomux mode for this model.

Reported-by: Heiko Brey <cico0815@gmx.de>
Link: https://lore.kernel.org/all/89f36f3f5e4c2d07b9ff72bc0b355875c336e498.camel@gmx.de/
Signed-off-by: Lovekesh Solanki <lovekeshsolanki00@gmail.com>
Link: https://patch.msgid.link/20260920113541.1484808-1-lovekeshsolanki00@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -671,6 +671,15 @@ static const struct dmi_system_id i8042_
 		.driver_data = (void *)(SERIO_QUIRK_NOAUX)
 	},
 	{
+		/* Fujitsu LIFEBOOK U7410 */
+		/* Mux mode also disturbs the EC keyboard, causing spurious ACKs */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU CLIENT COMPUTING LIMITED"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK U7410"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
+	},
+	{
 		/* Gigabyte M912 */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),


