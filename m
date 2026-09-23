Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006573F23C5;
	Wed, 23 Sep 2026 14:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175309; cv=none; b=Y7ZE6RKboemAqOfvNdDAtMHJSwDGKPbG1GiyVOpgTOO54Lk2jvjfkIzkyQE6GUsnjU3TAFDoGD8yXm/CGksV50DuslexGZcmm5mALjv6XFiHQjZ4JZWtA1dTx/REsOJTVjZZoe83sM9PPuAOdgwgqjKKhW1TrTwJy4JofUVuxpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175309; c=relaxed/simple;
	bh=FC39eltdg9vgCpPkMa9kqvRSsSSiRi9eflALk9jXC6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OW1MbGL1VSLjH9mV90OiN9uMCABDFfmSD3GxG47IonYW3em+V4TQIO1+qB4TmwH0e1PbWqYS320wQkseUZi/UFCZ5+XsA+OMML1oEmu2kHi/VQNmDG7wgKA4K8pAKWwGx/vTIMToruY56rwN6uIV9+asx41W+mcmk7ObOGOMgI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=muDIpDkp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="muDIpDkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0241F000FF;
	Wed, 23 Sep 2026 14:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175307;
	bh=pnqwzdWiry5OEBXE36DL17Ao+AA1q8eERjh3LMJqEGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=muDIpDkp06jW+tQXX9oLONaO+bUFoJhulQsjFNzJ8C1f3N4PawcEYiar/FXZgsH/3
	 4dZTxLU0vDo/9j5kuFNOXy7hEUxpdkhkAJ2LxYoknxcyfBFOC5olPpiQ5S02n63DyC
	 a5F/+RZHe71djzzvmxO+4ozcNwPHEJNNZPVwVwrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Denis Benato <benato.denis96@gmail.com>,
	Antheas Kapenekakis <lkml@antheas.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 357/398] HID: asus: fortify keyboard handshake
Date: Wed, 23 Sep 2026 16:07:11 +0200
Message-ID: <20260923140652.681665538@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit e82ae34af29e910c96d33c8b3a90c60e27f1625e ]

Handshaking with an Asus device involves sending it a feature report
with the string "ASUS Tech.Inc." and then reading it back to verify the
handshake was successful, under the feature ID the interaction will
take place.

Currently, the driver only does the first part. Add the readback to
verify the handshake was successful. As this could cause breakages,
allow the verification to fail with a dmesg error until we verify
all devices work with it (they seem to).

Since the response is more than 16 bytes, increase the buffer size
to 64 as well to avoid overflow errors. In addition, add the report
ID to prints, to help identify failed handshakes.

Reviewed-by: Benjamin Tissoires <bentiss@kernel.org>
Reviewed-by: Denis Benato <benato.denis96@gmail.com>
Acked-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://patch.msgid.link/20260122075044.5070-5-lkml@antheas.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c |   34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -48,7 +48,7 @@ MODULE_DESCRIPTION("Asus HID Keyboard an
 #define FEATURE_REPORT_ID 0x0d
 #define INPUT_REPORT_ID 0x5d
 #define FEATURE_KBD_REPORT_ID 0x5a
-#define FEATURE_KBD_REPORT_SIZE 16
+#define FEATURE_KBD_REPORT_SIZE 64
 #define FEATURE_KBD_LED_REPORT_ID1 0x5d
 #define FEATURE_KBD_LED_REPORT_ID2 0x5e
 
@@ -393,15 +393,41 @@ static int asus_kbd_set_report(struct hi
 
 static int asus_kbd_init(struct hid_device *hdev, u8 report_id)
 {
+	/*
+	 * The handshake is first sent as a set_report, then retrieved
+	 * from a get_report. They should be equal.
+	 */
 	const u8 buf[] = { report_id, 0x41, 0x53, 0x55, 0x53, 0x20, 0x54,
 		     0x65, 0x63, 0x68, 0x2e, 0x49, 0x6e, 0x63, 0x2e, 0x00 };
 	int ret;
 
 	ret = asus_kbd_set_report(hdev, buf, sizeof(buf));
-	if (ret < 0)
-		hid_err(hdev, "Asus failed to send init command: %d\n", ret);
+	if (ret < 0) {
+		hid_err(hdev, "Asus handshake %02x failed to send: %d\n",
+			report_id, ret);
+		return ret;
+	}
 
-	return ret;
+	u8 *readbuf __free(kfree) = kzalloc(FEATURE_KBD_REPORT_SIZE, GFP_KERNEL);
+	if (!readbuf)
+		return -ENOMEM;
+
+	ret = hid_hw_raw_request(hdev, report_id, readbuf,
+				 FEATURE_KBD_REPORT_SIZE, HID_FEATURE_REPORT,
+				 HID_REQ_GET_REPORT);
+	if (ret < 0) {
+		hid_warn(hdev, "Asus handshake %02x failed to receive ack: %d\n",
+			 report_id, ret);
+	} else if (memcmp(readbuf, buf, sizeof(buf)) != 0) {
+		hid_warn(hdev, "Asus handshake %02x returned invalid response: %*ph\n",
+			 report_id, FEATURE_KBD_REPORT_SIZE, readbuf);
+	}
+
+	/*
+	 * Do not return error if handshake is wrong until this is
+	 * verified to work for all devices.
+	 */
+	return 0;
 }
 
 static int asus_kbd_get_functions(struct hid_device *hdev,


