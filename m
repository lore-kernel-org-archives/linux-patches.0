Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C02D4E36D6;
	Fri,  9 Oct 2026 14:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556537; cv=none; b=JVAY55EfpMi+GSs4eTr0SePY/h6RFBkD2lHCtMPr8/bCa/o8RaO3DVQ9h+BnTQwk0g3ZwwWuNHHBYU8sV/IRYpwct4G9Mb43beO1PN4lL2YAc0VcTItAogMdTOXDuACPh7StUt0U+PTl6+neI9sjjg8IIWwfcJrktEg5wKeaB60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556537; c=relaxed/simple;
	bh=A7fhNIonJF3tx1m5QV6hhfnr6o+TLNag/WKDg080x/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCC2Ll27vM5a1RcrDYZeld6/Lg/vUaiJfDqvu2rDj35i2HPGxTXyvAOJPTiXg8K+bpMfPGk65pFDbAOmLrMcRgLgrnXz0EAACI1zfrIi9p946QCdNg53peuR2ISPZZ/3zeMlp2HPI9uYU2MRNNoJbNJnlTQ/5P2zh0oTP+cHiqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kgjdkV+a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kgjdkV+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6EC91F000FF;
	Fri,  9 Oct 2026 14:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556536;
	bh=v1GfxrI5kxYUdIovAUxXACHRC3cI6neEjSZAhlDpbSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kgjdkV+a1WPIiYtIYIyT7ujEfRSue0FP7LAPmOYzS0eTWZIzOMSI0R+bkOEErVxHL
	 dKjQbPAYyo9/lfLebdawJk4j9dz0om8e0t3IMWzCO2xn+0UZDrTpCOOuFt1sIVlirx
	 Z/0XbFeDzJmQd2PDsSBW1xvAohp+yD0DHjAo6nrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Brey <cico0815@gmx.de>,
	Lovekesh Solanki <lovekeshsolanki00@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.2 197/428] Input: i8042 - add nomux quirk for Fujitsu LIFEBOOK U7410
Date: Fri,  9 Oct 2026 16:08:54 +0200
Message-ID: <20261009140950.464482982@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


