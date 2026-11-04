Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829164;
	b=m4WtPoaOCntIn3xPgkvGr16tCuLZ5WrD9i1NyAs8rsc7e9JiLtd2Y2/aNxzGz4riWvy9
	 dyLbCf7gaYO55YbNT9gKWeS3XKKs7RGBE1bjw5pFqH2JWy8zAcENwYugeSjoBApfSCS0i
	 UZeNZxrvc6txUFuDr19kuUshZwWHLDO0Y9/YoH39hiQ5oumuT6Gt2zOh2qYcRtKRurtSt
	 K7B/kmFk0lwrAwKTVmrCmmbSlrBVRTpw3bM8v8pbxL74RWeIgxbEHb+fJ5CIXQCvYhiTh
	 ww4eAodeuTrKoPxph5Oniv/lKK6b+j7w8JVUIvX+KoxZd+b5lXGy+CUYV1D00346SMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829164;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hng6rj5RsHRtt+ax796bUpXGm5+f4PAkfUMdsrfSzr8=;
	b=0BParW+dRJJZOsEcmWu58P933xUV6wnxv047BOhfimmNstrP167Fub3LhQZxELP9k9SU
	 AvsXncd2j9Bbw7JxBRaBoO0ImI/Wgj+JdpNkXYhwm8bVgNj1vODX/3BV29AWfOVlIP2xq
	 TC14toCnBcMCT0oF4bSjmQSwO5zOp3E3DNaOH+3Rv+9dCDBRrQJN4akria/byTDJNUeY5
	 CMLpkeZ4EWM2nBX2ALhJa4jJMDqO53hcteuwKywEfrQeES0WczXvNDanq21Txz1OmDqPx
	 l8y+fGz+BjQfQ8mSGa0aszRy7gYdko9VjmEVevu+sfCkd41JbUwJW1leZdROuOT1xag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I539CqF1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC8D607031A;
	Wed,  4 Nov 2026 21:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I539CqF1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F83D1F00919;
	Wed,  4 Nov 2026 21:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829164;
	bh=Hng6rj5RsHRtt+ax796bUpXGm5+f4PAkfUMdsrfSzr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I539CqF1TB88dCAbhwhAiLgCE5KANtO9Y6Kp83cXRsLVKfmSnbSYUqOs3kXYWWCJ4
	 3nLI8qeyw8PG2tpDJccW8sYLIIjz8oCq12GV5+XjtoHeuQm910x8Yc2uIQVDaz9nhF
	 W3gNeCs98x0VjPocIVeXHJrWQSbxatGG+Mo89G/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Panz Dev <panz.development@gmail.com>,
	Denis Benato <denis.benato@linux.dev>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 487/547] HID: asus: do not send keyboard init reports to touchpads
Date: Wed,  4 Nov 2026 16:11:11 -0500
Message-ID: <20261104211052.213460130@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Panz Dev <panz.development@gmail.com>

commit 8099f9da59f1c338bf88e25b7aa2a7fdf840879c upstream.

Commit 0919db9f3583 ("HID: asus: always fully initialize devices") added a
loop during asus_probe() to send keyboard feature report initializations
(asus_kbd_init) to all ASUS HID devices.

On ASUS laptops with I2C/HID touchpads (such as the ASUS E200HA), sending
keyboard feature reports (FEATURE_KBD_REPORT_ID) to touchpad endpoints
sends invalid feature requests to touchpad hardware, corrupting probe
state and causing the touchpad to become unresponsive.

Wrap the asus_report_id_init loop in an `if (!drvdata->tp)` check so
keyboard feature initialization only runs for actual keyboards.

Tested on ASUS E200HA (where touchpad functionality is fully restored)
and ASUS VivoBook Flip 14 TP401MA (confirming zero regressions).

Fixes: 0919db9f3583 ("HID: asus: always fully initialize devices")
Cc: stable@vger.kernel.org
Signed-off-by: Panz Dev <panz.development@gmail.com>
Reviewed-by: Denis Benato <denis.benato@linux.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-asus.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index ec966fc0a411..bd46aba6622a 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -1493,12 +1493,14 @@ static int asus_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		return ret;
 	}
 
-	for (int r = 0; r < ARRAY_SIZE(asus_report_id_init); r++) {
-		if (asus_has_report_id(hdev, asus_report_id_init[r])) {
-			ret = asus_kbd_init(hdev, asus_report_id_init[r]);
-			if (ret < 0)
-				hid_warn(hdev, "Failed to initialize 0x%x: %d.\n",
-					 asus_report_id_init[r], ret);
+	if (!drvdata->tp) {
+		for (int r = 0; r < ARRAY_SIZE(asus_report_id_init); r++) {
+			if (asus_has_report_id(hdev, asus_report_id_init[r])) {
+				ret = asus_kbd_init(hdev, asus_report_id_init[r]);
+				if (ret < 0)
+					hid_warn(hdev, "Failed to initialize 0x%x: %d.\n",
+						 asus_report_id_init[r], ret);
+			}
 		}
 	}
 
-- 
2.56.0



