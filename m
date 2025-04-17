Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4112561D9;
	Thu, 17 Apr 2025 18:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915576; cv=none; b=TEICYElIRSNYE3SlA4Ghtev8DUGUjtEWDCXE+fHsfFtiw4V1EjpN+axbrWhHXPZvjDoK0xNpNCsjFu1U1S6hOPJADdhgdHHdxfjd4uzJGKp/wXnOaYGPR6Xksb7RecFM4U7mWGB2bVEaCBWVzmZmxlqqbtiiGzBdZ7jyOsqhGbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915576; c=relaxed/simple;
	bh=LtkL16jemO5+lOxcVu28w/NzDX17ZhuxlQEzq2PKucM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZHDW49mvaKpzrxCyHtJj3s9Q01r8+SDaiVJmhC5pr1z4fxlj4Jyz9e9DmQHTz1EqZg2uVrWRnDwldERtNv/DiWk6PyDEhrQ/ppR/duHOL7aPiSp/5fRa0gW37GGar0d0jlZEMhpfxI+yWixt/a1ZuNPDPXtZShkueVcE+fYsEWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A58EsrNi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A58EsrNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16522C4CEE4;
	Thu, 17 Apr 2025 18:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915576;
	bh=LtkL16jemO5+lOxcVu28w/NzDX17ZhuxlQEzq2PKucM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A58EsrNipcfKGSAhKUp+TJzqFUqkYOo1fxDnLZL2PsLl2L5IZIAKiYM10VSg6zoMS
	 JpmZBNWddmCom6Mv1IfCzFTNvyxxpTHfg0IY7eCg+D6a9iCohI/eSkzfEuWm+WHF1Q
	 dBIGSu7k2yPJCWHoNCun8Ze2qKN63aZ6cmSy7FcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal@nozomi.space>,
	Paul Dino Jones <paul@spacefreak18.xyz>,
	=?UTF-8?q?Crist=C3=B3ferson=20Bueno?= <cbueno81@gmail.com>,
	Pablo Cisneros <patchkez@protonmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 172/393] HID: pidff: Factor out code for setting gain
Date: Thu, 17 Apr 2025 19:49:41 +0200
Message-ID: <20250417175114.517011344@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit f7ebf0b11b9e04bf59c438ad14f0115b12aa2f44 ]

Makes it possible to easily set gain from inside hid-pidff.c

Changes in v7:
- Check if device gain field exists before setting device gain

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Reviewed-by: Michał Kopeć <michal@nozomi.space>
Reviewed-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Cristóferson Bueno <cbueno81@gmail.com>
Tested-by: Pablo Cisneros <patchkez@protonmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-pidff.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index 180b2cf66e4c7..ac6f940abd901 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -539,6 +539,19 @@ static int pidff_needs_set_ramp(struct ff_effect *effect, struct ff_effect *old)
 	       effect->u.ramp.end_level != old->u.ramp.end_level;
 }
 
+/*
+ * Set device gain
+ */
+static void pidff_set_gain_report(struct pidff_device *pidff, u16 gain)
+{
+	if (!pidff->device_gain[PID_DEVICE_GAIN_FIELD].field)
+		return;
+
+	pidff_set(&pidff->device_gain[PID_DEVICE_GAIN_FIELD], gain);
+	hid_hw_request(pidff->hid, pidff->reports[PID_DEVICE_GAIN],
+			HID_REQ_SET_REPORT);
+}
+
 /*
  * Clear device control report
  */
@@ -865,11 +878,7 @@ static int pidff_upload_effect(struct input_dev *dev, struct ff_effect *effect,
  */
 static void pidff_set_gain(struct input_dev *dev, u16 gain)
 {
-	struct pidff_device *pidff = dev->ff->private;
-
-	pidff_set(&pidff->device_gain[PID_DEVICE_GAIN_FIELD], gain);
-	hid_hw_request(pidff->hid, pidff->reports[PID_DEVICE_GAIN],
-			HID_REQ_SET_REPORT);
+	pidff_set_gain_report(dev->ff->private, gain);
 }
 
 static void pidff_autocenter(struct pidff_device *pidff, u16 magnitude)
@@ -1414,12 +1423,7 @@ int hid_pidff_init_with_quirks(struct hid_device *hid, __u32 initial_quirks)
 	if (error)
 		goto fail;
 
-	if (test_bit(FF_GAIN, dev->ffbit)) {
-		pidff_set(&pidff->device_gain[PID_DEVICE_GAIN_FIELD], 0xffff);
-		hid_hw_request(hid, pidff->reports[PID_DEVICE_GAIN],
-				     HID_REQ_SET_REPORT);
-	}
-
+	pidff_set_gain_report(pidff, 0xffff);
 	error = pidff_check_autocenter(pidff, dev);
 	if (error)
 		goto fail;
-- 
2.39.5



