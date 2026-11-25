Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620658;
	b=YieSFz0WJWPhy08Pu5VsFIhUTqizgrSjDl7OcYomxxPneFXSdkgYVewKCKzfWm53mmi+
	 ZL5g94D8sOfr9dC2yashlN11/Lrir8uAdbcGvn3t8zSs3OcmX0YOCNChjHHejW/J91N43
	 5xLJL5aNBSZf9R0uTAa+jMKUhZ2/i5LzHJeR6Sn0ZE9hoKQpn1RkLE7IoYbBPEzPHePnG
	 0RvOc5IhvXy0FdY1s+OHBdPj85Bia7iUjiO3PbBP1h9gLwDZupfxGZdtjfE1iXflhU9Dn
	 i/brvS3lhfBrnXICZC2rosxvfh19zY7IqT1TPBTZorhcKFaGw/ym/CZpARzCGaMkekQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/hlC4LVKJV6hPG50OaXCP1rRxNY2v8bM+KDV4gPEaEo=;
	b=QNY53lNXQ3OmLjB0vn0QLG+P3edTplRdVhzZddylyPO4X+b+P47vI+8E4URZS+kgZfRG
	 PHd5MMYnAGVEVpLm0qoWGAtOM8++8vA074c9OPQykOj9qlPtwyLSeR8/wowrUEVjyuAnr
	 Q2V6QjXMTtTUAz0C+98XsgQPSajXJkYD9GofkHGJ25eMscO9tFr0xOGJTZJT/4d6C/5at
	 MAVaV/FH4/AZKJMAPcqkVRuFf0CSqTZgNupmQ+B4Bm0HEFmBMkGoXJzDgBnTMIbJFiaNN
	 FerbV1NDtdNWNEHKw/HW7tY+ZWx0DhXnMbXm+QZY0ymYOOICvxjuCGe/rVOhTwJ06UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oIVZIG5H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA09606A31E;
	Wed, 25 Nov 2026 15:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oIVZIG5H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39E61F000C4;
	Wed, 25 Nov 2026 15:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620658;
	bh=/hlC4LVKJV6hPG50OaXCP1rRxNY2v8bM+KDV4gPEaEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oIVZIG5HSHQkefr/U93UGy7EWgTczWH3CHzOAsXw7IXs9ejonhGmo9WsJm+lDHd0Z
	 Gyi/4K0t9GDgAnz2MFJuPxAN3A5Chfq9VSrguV2VvtYK+uldBq+96ptWxky9GIcEve
	 yQoo+aQfntZululOH5yYSZZi5RF2QdPzW3OW/YH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Hoover <ch@murgatroid.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0992/1005] iio: temperature: hid-sensor-temperature: Use per-instance callbacks
Date: Wed, 25 Nov 2026 15:38:50 +0100
Message-ID: <20261125143844.893241999@linuxfoundation.org>
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

commit 36eeb26031e90eeb81bbac3d3acad61d23fcbdf3 upstream.

hid-sensor-temperature keeps a single static struct
hid_sensor_hub_callbacks for all instances and overwrites its pdev in
every probe.  With two temperature sensors, input reports for one are
delivered with the other's platform device; once that device is
removed, platform_get_drvdata() returns NULL and
temperature_capture_sample() dereferences it:

  BUG: kernel NULL pointer dereference, address: 00000000000003a8
  RIP: 0010:temperature_capture_sample+0xd/0x50 [hid_sensor_temperature]

The oops happens in sensor_hub_raw_event() with the hub's spinlock
held, so the hub's removal then hangs.  It reproduces with two uhid
devices that each declare a temperature sensor, one destroyed while
the other still sends input reports.

Keep the callbacks in struct temperature_state, as the other HID
sensor drivers (accel, gyro, als, ...) do.

Fixes: 59d0f2da3569 ("iio: hid: Add temperature sensor support")
Cc: stable@vger.kernel.org
Signed-off-by: Christopher Hoover <ch@murgatroid.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/temperature/hid-sensor-temperature.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/iio/temperature/hid-sensor-temperature.c
+++ b/drivers/iio/temperature/hid-sensor-temperature.c
@@ -15,6 +15,7 @@
 struct temperature_state {
 	struct hid_sensor_common common_attributes;
 	struct hid_sensor_hub_attribute_info temperature_attr;
+	struct hid_sensor_hub_callbacks callbacks;
 	struct {
 		s32 temperature_data;
 		aligned_s64 timestamp;
@@ -181,11 +182,6 @@ static int temperature_parse_report(stru
 	return ret;
 }
 
-static struct hid_sensor_hub_callbacks temperature_callbacks = {
-	.send_event = &temperature_proc_event,
-	.capture_sample = &temperature_capture_sample,
-};
-
 /* Function to initialize the processing for usage id */
 static int hid_temperature_probe(struct platform_device *pdev)
 {
@@ -237,9 +233,13 @@ static int hid_temperature_probe(struct
 
 	platform_set_drvdata(pdev, indio_dev);
 
-	temperature_callbacks.pdev = pdev;
+	temp_st->callbacks = (struct hid_sensor_hub_callbacks) {
+		.send_event = temperature_proc_event,
+		.capture_sample = temperature_capture_sample,
+		.pdev = pdev,
+	};
 	ret = sensor_hub_register_callback(hsdev, HID_USAGE_SENSOR_TEMPERATURE,
-					   &temperature_callbacks);
+					   &temp_st->callbacks);
 	if (ret)
 		goto error_remove_trigger;
 


