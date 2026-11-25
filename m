Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620620;
	b=K9Do/uF6Lvk2fwGjKxl4zvWLNwofa6e+JTzZDe5eURCTfYIROjJR3j6SGqH9dI7yIT3g
	 RP23WaYQo48ZedaBZtIJrrm8UPAUzfaOydLBhkfRGgKrGMELG0elzAHIiwmGUlCpL+yQe
	 EFjRQAvNbtBz4+2KUt+pw4Bw9mLew3GRC+NEUwyeRIMAnJtHbhsfVpXCfaQqS0+Fr8Uz2
	 HOTctoCZliVfG/mivGkPFT39CCOq6L1Udov1BDfXhsUvMH9Ie3k2PNIYByyDB04m4t2Bk
	 PszLq9H1Whl7Q53dP2RulOzfzFUnmnin6rP3HDgjzY+pgeDkn+Qs+nLAT5bQCcJ97TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lZEPBVgOsl9f6avuUeW1HaDkaIWuGdfMD28dUkkYhFs=;
	b=F7SjhjGKDr9SfASnfyAPKVaZcTxVnXRbzDfkTwvCf6du/e4YBGnMqY9yfBWBuFJ0wb5f
	 0m0d0zrVcQ9b3ECNymSySY9vEx4V5aHbHlVTBm5H/n3JkMTGmqXkBrTbbxOuRnXZUB5L4
	 EGEngY6ZagykoLA0dYqJqAcWBv0L2RK5DvDLanqpvrIU+3ZaFtlSXK46IzTLRK9AqjvyY
	 QYAIYQk4aNiZc9bmSPB0HPgtdR9Ye6cnDILviNZlOpy0nlXZFnO+rZIlVyxEYmwBlrdyl
	 zwczhB2pgOowiI0qwSO2fijgHHeHYJafchi9Vqhu+fhUoBKjHvQCOuH05wFVuKxDW9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=geZ+rSn2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB50606A333;
	Wed, 25 Nov 2026 15:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=geZ+rSn2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B681F000C6;
	Wed, 25 Nov 2026 15:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620619;
	bh=lZEPBVgOsl9f6avuUeW1HaDkaIWuGdfMD28dUkkYhFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=geZ+rSn2/yl1KHFRtVwIZsrQJWZulPXQvmW6qwiu0JqFr9RU74unqF+ncKSROdNVx
	 A9U/JN7OllFY9bLWZp9FJJI4nSl22QCt/A3SZN7tbOezAfvXlJBOOLdHjDBePf7Xlz
	 kHsLXY2MgWmYeoJlZpThhwyAesdekaXbxk4ltXbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Hoover <ch@murgatroid.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0976/1005] iio: humidity: hid-sensor-humidity: Use per-instance callbacks
Date: Wed, 25 Nov 2026 15:38:34 +0100
Message-ID: <20261125143844.526915859@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Christopher Hoover <ch@murgatroid.com>

commit bbe4f3f668babc9443fc1f075695e43e17ca7976 upstream.

hid-sensor-humidity keeps a single static struct
hid_sensor_hub_callbacks for all instances and overwrites its pdev in
every probe, so with two humidity sensors, input reports for one are
delivered with the other's platform device, and a NULL dereference
follows once that device is removed.  The same bug was found in
hid-sensor-temperature, which shares this code.

Keep the callbacks in struct hid_humidity_state, as the other HID
sensor drivers (accel, gyro, als, ...) do.

Fixes: d7ed89d5aadf ("iio: hid: Add humidity sensor support")
Cc: stable@vger.kernel.org
Signed-off-by: Christopher Hoover <ch@murgatroid.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/humidity/hid-sensor-humidity.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/iio/humidity/hid-sensor-humidity.c
+++ b/drivers/iio/humidity/hid-sensor-humidity.c
@@ -15,6 +15,7 @@
 struct hid_humidity_state {
 	struct hid_sensor_common common_attributes;
 	struct hid_sensor_hub_attribute_info humidity_attr;
+	struct hid_sensor_hub_callbacks callbacks;
 	struct {
 		s32 humidity_data;
 		aligned_s64 timestamp;
@@ -184,11 +185,6 @@ static int humidity_parse_report(struct
 	return ret;
 }
 
-static struct hid_sensor_hub_callbacks humidity_callbacks = {
-	.send_event = &humidity_proc_event,
-	.capture_sample = &humidity_capture_sample,
-};
-
 /* Function to initialize the processing for usage id */
 static int hid_humidity_probe(struct platform_device *pdev)
 {
@@ -240,9 +236,13 @@ static int hid_humidity_probe(struct pla
 
 	platform_set_drvdata(pdev, indio_dev);
 
-	humidity_callbacks.pdev = pdev;
+	humid_st->callbacks = (struct hid_sensor_hub_callbacks) {
+		.send_event = humidity_proc_event,
+		.capture_sample = humidity_capture_sample,
+		.pdev = pdev,
+	};
 	ret = sensor_hub_register_callback(hsdev, HID_USAGE_SENSOR_HUMIDITY,
-					   &humidity_callbacks);
+					   &humid_st->callbacks);
 	if (ret)
 		goto error_remove_trigger;
 


