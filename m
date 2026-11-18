Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058866;
	b=aQgqzvDCibpW5ir0x4+TFBo4s7KyB0dlmqSk6tzcjuq3mmqopGUvQofGRMH9715GLSs/
	 mCx11ltsANATiaNug+IixPYXS9yMh7+nTPEsWykBheajqJKwSEMNxPO5wXvGBJOGro4EM
	 JHkaFSCSwPx91xDsm5SFaespu2XO/xAZSMQimggsMVWvsUPcgXrO7IsD1DKTTVQMj7U5x
	 sHSdCkk61/TZOwLHlzrNwt7wRlpyrpDGFnrbFWkeEDFBQyM8MGvqYE3Aq09x/3wMnq7wr
	 Rw/GIFuMTzpZGzvH+Ab6PNJy/HifkNtUiHeYzF6dSLRjzGP+87ivISU3jPmRct2xOxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058866;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zL0vL0W4TbQy1ddDzEjyCKFGqyWHrH4QA61+sUwmL2o=;
	b=0mPckOZYb0W+9lp80FlhraBlFZzVLzveFgmWsphMicBkjx+Y07vDDuJ4N+QHlvuE4iMG
	 OaTk/xoihh8/SpiKqTEqV4gfxOci9jjIpDQG9lt9HSSF4vqLRre+axm7o4V6StBvf8JMC
	 Tniq2Ci66B59G9Iqy175O2470IqQCM4zjDEL64rNlv4i0PLJJC4krsk18prQLi6nr5vt+
	 BUtv0IXE5iMt0YJmGqoSOoHrfPn6wEs5aPhqeUH7uBJEYp42Srt0oZ1L16FYbXqAXGcaz
	 T7TCSWeHTlA9cgXbdlXFps6woapJ3ng3NBSWo1H18Xu6RS/hxC1ZEx5Xz4mXUxKpEww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2lEfRv6d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1E8606A326;
	Thu, 19 Nov 2026 03:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2lEfRv6d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2660C1F000C4;
	Thu, 19 Nov 2026 03:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058866;
	bh=zL0vL0W4TbQy1ddDzEjyCKFGqyWHrH4QA61+sUwmL2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2lEfRv6dwEyqRvHJsFHmDEhJyyZfsrWDNVsIeUf1ArAF2PjdI0Mx7qQ142ePXpYNp
	 AWrNA5V5+GbRNJF7wDfWlfFXSu0MlJ+7FwraPkPEW3/NFb4Qc7tN1BXGVQ/Ggy7WNh
	 davVwQKsN55ejKjTCpavihor4QtYCYEVzCRmFz+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0639/1848] HID: hid-prodikeys: remove struct pk_device
Date: Wed, 18 Nov 2026 15:44:37 +0100
Message-ID: <20261118145942.495078029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit 16d0e1d469cc16aefa8ef745e926eda473a9b221 ]

First, quirks was unused in struct pk_device.

And I see no reason for this additional level of indirection. struct
pcmidi_snd is far enough for the driver. Unless I am missing something?

So drop struct pk_device and convert all the users to use struct
pcmidi_snd directly. No need for doubled kmalloc+kfrees now.

Found by https://github.com/jirislaby/clang-struct.

Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: 0ff37294c41b ("HID: prodikeys: validate fixed-format MIDI reports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-prodikeys.c | 113 +++++++++++++-----------------------
 1 file changed, 40 insertions(+), 73 deletions(-)

diff --git a/drivers/hid/hid-prodikeys.c b/drivers/hid/hid-prodikeys.c
index f20d29566b4da..b53b0c02675a4 100644
--- a/drivers/hid/hid-prodikeys.c
+++ b/drivers/hid/hid-prodikeys.c
@@ -32,13 +32,6 @@
 
 struct pcmidi_snd;
 
-struct pk_device {
-	unsigned long		quirks;
-
-	struct hid_device	*hdev;
-	struct pcmidi_snd	*pm; /* pcmidi device context */
-};
-
 struct pcmidi_sustain {
 	unsigned long		in_use;
 	struct pcmidi_snd	*pm;
@@ -50,7 +43,7 @@ struct pcmidi_sustain {
 
 #define PCMIDI_SUSTAINED_MAX	32
 struct pcmidi_snd {
-	struct pk_device		*pk;
+	struct hid_device		*hdev;
 	unsigned short			ifnum;
 	struct hid_report		*pcmidi_report6;
 	struct input_dev		*input_ep82;
@@ -100,11 +93,11 @@ static ssize_t show_channel(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
 	struct hid_device *hdev = to_hid_device(dev);
-	struct pk_device *pk = hid_get_drvdata(hdev);
+	struct pcmidi_snd *pm = hid_get_drvdata(hdev);
 
-	dbg_hid("pcmidi sysfs read channel=%u\n", pk->pm->midi_channel);
+	dbg_hid("pcmidi sysfs read channel=%u\n", pm->midi_channel);
 
-	return sprintf(buf, "%u (min:%u, max:%u)\n", pk->pm->midi_channel,
+	return sprintf(buf, "%u (min:%u, max:%u)\n", pm->midi_channel,
 		PCMIDI_CHANNEL_MIN, PCMIDI_CHANNEL_MAX);
 }
 
@@ -113,13 +106,13 @@ static ssize_t store_channel(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct hid_device *hdev = to_hid_device(dev);
-	struct pk_device *pk = hid_get_drvdata(hdev);
+	struct pcmidi_snd *pm = hid_get_drvdata(hdev);
 
 	unsigned channel = 0;
 
 	if (sscanf(buf, "%u", &channel) > 0 && channel <= PCMIDI_CHANNEL_MAX) {
 		dbg_hid("pcmidi sysfs write channel=%u\n", channel);
-		pk->pm->midi_channel = channel;
+		pm->midi_channel = channel;
 		return strlen(buf);
 	}
 	return -EINVAL;
@@ -137,11 +130,11 @@ static ssize_t show_sustain(struct device *dev,
  struct device_attribute *attr, char *buf)
 {
 	struct hid_device *hdev = to_hid_device(dev);
-	struct pk_device *pk = hid_get_drvdata(hdev);
+	struct pcmidi_snd *pm = hid_get_drvdata(hdev);
 
-	dbg_hid("pcmidi sysfs read sustain=%u\n", pk->pm->midi_sustain);
+	dbg_hid("pcmidi sysfs read sustain=%u\n", pm->midi_sustain);
 
-	return sprintf(buf, "%u (off:%u, max:%u (ms))\n", pk->pm->midi_sustain,
+	return sprintf(buf, "%u (off:%u, max:%u (ms))\n", pm->midi_sustain,
 		PCMIDI_SUSTAIN_MIN, PCMIDI_SUSTAIN_MAX);
 }
 
@@ -150,15 +143,14 @@ static ssize_t store_sustain(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct hid_device *hdev = to_hid_device(dev);
-	struct pk_device *pk = hid_get_drvdata(hdev);
+	struct pcmidi_snd *pm = hid_get_drvdata(hdev);
 
 	unsigned sustain = 0;
 
 	if (sscanf(buf, "%u", &sustain) > 0 && sustain <= PCMIDI_SUSTAIN_MAX) {
 		dbg_hid("pcmidi sysfs write sustain=%u\n", sustain);
-		pk->pm->midi_sustain = sustain;
-		pk->pm->midi_sustain_mode =
-			(0 == sustain || !pk->pm->midi_mode) ? 0 : 1;
+		pm->midi_sustain = sustain;
+		pm->midi_sustain_mode = (0 == sustain || !pm->midi_mode) ? 0 : 1;
 		return strlen(buf);
 	}
 	return -EINVAL;
@@ -176,11 +168,11 @@ static ssize_t show_octave(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
 	struct hid_device *hdev = to_hid_device(dev);
-	struct pk_device *pk = hid_get_drvdata(hdev);
+	struct pcmidi_snd *pm = hid_get_drvdata(hdev);
 
-	dbg_hid("pcmidi sysfs read octave=%d\n", pk->pm->midi_octave);
+	dbg_hid("pcmidi sysfs read octave=%d\n", pm->midi_octave);
 
-	return sprintf(buf, "%d (min:%d, max:%d)\n", pk->pm->midi_octave,
+	return sprintf(buf, "%d (min:%d, max:%d)\n", pm->midi_octave,
 		PCMIDI_OCTAVE_MIN, PCMIDI_OCTAVE_MAX);
 }
 
@@ -189,14 +181,14 @@ static ssize_t store_octave(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct hid_device *hdev = to_hid_device(dev);
-	struct pk_device *pk = hid_get_drvdata(hdev);
+	struct pcmidi_snd *pm = hid_get_drvdata(hdev);
 
 	int octave = 0;
 
 	if (sscanf(buf, "%d", &octave) > 0 &&
 		octave >= PCMIDI_OCTAVE_MIN && octave <= PCMIDI_OCTAVE_MAX) {
 		dbg_hid("pcmidi sysfs write octave=%d\n", octave);
-		pk->pm->midi_octave = octave;
+		pm->midi_octave = octave;
 		return strlen(buf);
 	}
 	return -EINVAL;
@@ -270,7 +262,7 @@ static void stop_sustain_timers(struct pcmidi_snd *pm)
 
 static int pcmidi_get_output_report(struct pcmidi_snd *pm)
 {
-	struct hid_device *hdev = pm->pk->hdev;
+	struct hid_device *hdev = pm->hdev;
 	struct hid_report *report;
 
 	list_for_each_entry(report,
@@ -295,7 +287,7 @@ static int pcmidi_get_output_report(struct pcmidi_snd *pm)
 
 static void pcmidi_submit_output_report(struct pcmidi_snd *pm, int state)
 {
-	struct hid_device *hdev = pm->pk->hdev;
+	struct hid_device *hdev = pm->hdev;
 	struct hid_report *report = pm->pcmidi_report6;
 	report->field[0]->value[0] = 0x01;
 	report->field[0]->value[1] = state;
@@ -626,7 +618,7 @@ static int pcmidi_snd_initialise(struct pcmidi_snd *pm)
 
 	/* Setup sound card */
 
-	err = snd_card_new(&pm->pk->hdev->dev, index[dev], id[dev],
+	err = snd_card_new(&pm->hdev->dev, index[dev], id[dev],
 			   THIS_MODULE, 0, &card);
 	if (err < 0) {
 		pk_error("failed to create pc-midi sound card\n");
@@ -664,7 +656,7 @@ static int pcmidi_snd_initialise(struct pcmidi_snd *pm)
 		&pcmidi_in_ops);
 
 	/* create sysfs variables */
-	err = device_create_file(&pm->pk->hdev->dev,
+	err = device_create_file(&pm->hdev->dev,
 				 sysfs_device_attr_channel);
 	if (err < 0) {
 		pk_error("failed to create sysfs attribute channel: error %d\n",
@@ -672,7 +664,7 @@ static int pcmidi_snd_initialise(struct pcmidi_snd *pm)
 		goto fail;
 	}
 
-	err = device_create_file(&pm->pk->hdev->dev,
+	err = device_create_file(&pm->hdev->dev,
 				sysfs_device_attr_sustain);
 	if (err < 0) {
 		pk_error("failed to create sysfs attribute sustain: error %d\n",
@@ -680,7 +672,7 @@ static int pcmidi_snd_initialise(struct pcmidi_snd *pm)
 		goto fail_attr_sustain;
 	}
 
-	err = device_create_file(&pm->pk->hdev->dev,
+	err = device_create_file(&pm->hdev->dev,
 			 sysfs_device_attr_octave);
 	if (err < 0) {
 		pk_error("failed to create sysfs attribute octave: error %d\n",
@@ -710,11 +702,11 @@ static int pcmidi_snd_initialise(struct pcmidi_snd *pm)
 
 fail_register:
 	stop_sustain_timers(pm);
-	device_remove_file(&pm->pk->hdev->dev, sysfs_device_attr_octave);
+	device_remove_file(&pm->hdev->dev, sysfs_device_attr_octave);
 fail_attr_octave:
-	device_remove_file(&pm->pk->hdev->dev, sysfs_device_attr_sustain);
+	device_remove_file(&pm->hdev->dev, sysfs_device_attr_sustain);
 fail_attr_sustain:
-	device_remove_file(&pm->pk->hdev->dev, sysfs_device_attr_channel);
+	device_remove_file(&pm->hdev->dev, sysfs_device_attr_channel);
 fail:
 	if (pm->card) {
 		snd_card_free(pm->card);
@@ -728,12 +720,9 @@ static int pcmidi_snd_terminate(struct pcmidi_snd *pm)
 	if (pm->card) {
 		stop_sustain_timers(pm);
 
-		device_remove_file(&pm->pk->hdev->dev,
-			sysfs_device_attr_channel);
-		device_remove_file(&pm->pk->hdev->dev,
-			sysfs_device_attr_sustain);
-		device_remove_file(&pm->pk->hdev->dev,
-			sysfs_device_attr_octave);
+		device_remove_file(&pm->hdev->dev, sysfs_device_attr_channel);
+		device_remove_file(&pm->hdev->dev, sysfs_device_attr_sustain);
+		device_remove_file(&pm->hdev->dev, sysfs_device_attr_octave);
 
 		snd_card_disconnect(pm->card);
 		snd_card_free_when_closed(pm->card);
@@ -763,10 +752,7 @@ static int pk_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
-	struct pk_device *pk = hid_get_drvdata(hdev);
-	struct pcmidi_snd *pm;
-
-	pm = pk->pm;
+	struct pcmidi_snd *pm = hid_get_drvdata(hdev);
 
 	if (HID_UP_MSVENDOR == (usage->hid & HID_USAGE_PAGE) &&
 		1 == pm->ifnum) {
@@ -781,16 +767,16 @@ static int pk_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 static int pk_raw_event(struct hid_device *hdev, struct hid_report *report,
 	u8 *data, int size)
 {
-	struct pk_device *pk = hid_get_drvdata(hdev);
+	struct pcmidi_snd *pm = hid_get_drvdata(hdev);
 	int ret = 0;
 
-	if (1 == pk->pm->ifnum) {
+	if (1 == pm->ifnum) {
 		if (report->id == data[0])
 			switch (report->id) {
 			case 0x01: /* midi keys (qwerty)*/
 			case 0x03: /* midi keyboard (musical)*/
 			case 0x04: /* extra/midi keys (qwerty)*/
-				ret = pcmidi_handle_report(pk->pm,
+				ret = pcmidi_handle_report(pm,
 						report->id, data, size);
 				break;
 			}
@@ -805,8 +791,7 @@ static int pk_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	struct usb_interface *intf;
 	unsigned short ifnum;
 	unsigned long quirks = id->driver_data;
-	struct pk_device *pk;
-	struct pcmidi_snd *pm = NULL;
+	struct pcmidi_snd *pm;
 
 	if (!hid_is_usb(hdev))
 		return -EINVAL;
@@ -814,26 +799,16 @@ static int pk_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	intf = to_usb_interface(hdev->dev.parent);
 	ifnum = intf->cur_altsetting->desc.bInterfaceNumber;
 
-	pk = kzalloc(sizeof(*pk), GFP_KERNEL);
-	if (pk == NULL) {
-		hid_err(hdev, "can't alloc descriptor\n");
-		return -ENOMEM;
-	}
-
-	pk->hdev = hdev;
-
 	pm = kzalloc(sizeof(*pm), GFP_KERNEL);
 	if (pm == NULL) {
 		hid_err(hdev, "can't alloc descriptor\n");
-		ret = -ENOMEM;
-		goto err_free_pk;
+		return -ENOMEM;
 	}
 
-	pm->pk = pk;
-	pk->pm = pm;
+	pm->hdev = hdev;
 	pm->ifnum = ifnum;
 
-	hid_set_drvdata(hdev, pk);
+	hid_set_drvdata(hdev, pm);
 
 	ret = hid_parse(hdev);
 	if (ret) {
@@ -860,26 +835,18 @@ static int pk_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	hid_hw_stop(hdev);
 err_free:
 	kfree(pm);
-err_free_pk:
-	kfree(pk);
 
 	return ret;
 }
 
 static void pk_remove(struct hid_device *hdev)
 {
-	struct pk_device *pk = hid_get_drvdata(hdev);
-	struct pcmidi_snd *pm;
-
-	pm = pk->pm;
-	if (pm) {
-		pcmidi_snd_terminate(pm);
-		kfree(pm);
-	}
+	struct pcmidi_snd *pm = hid_get_drvdata(hdev);
 
+	pcmidi_snd_terminate(pm);
 	hid_hw_stop(hdev);
 
-	kfree(pk);
+	kfree(pm);
 }
 
 static const struct hid_device_id pk_devices[] = {
-- 
2.53.0



