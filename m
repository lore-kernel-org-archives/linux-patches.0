Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061156;
	b=gJ3fIX+Yp487qYqAWLa+KwTRw0euO0nhiju5BM9m2r/mO4c584Jrxk6gdZN97iUKKWcF
	 prVtmqbENTfdav1rgC462XYyhPH0PYn76t9l3LM6K7Ob3j4dICIC06006aHhzuTR0ZJjM
	 CvFIDf+eJTqYqsA7FnnEceR91v+QK1Tl8WJ8K142q9hjHhlip4u3IWI6aA0RhovOU/oY9
	 5W2i5w8ZOy12Bg2BpnVmk4Z96mdAA3OncW9dPFfT/RTa2uhxKoxLApQ/k4Y1QnvIfwK3a
	 4G/t0IGZJtt42hOItaGJ5Vz62Rim7qef33B5v+k/pW7rai45XqY+rJC0mYT8cRNRdww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061156;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=k6RGLOt5V2AXgQUmK/ULqrIaQdIaspXsg5rWHwPNx6Q=;
	b=asFB10QpJy4VrR588bvGakANcSa67zB1bFfg64NGCDSsMJmgg85dn7h5mnEkUt0g7oML
	 dGWA3J4iwixAGjP+7iaPlHOBeUjxV9h6uFLPC+YjRDN1u90jAcrfeeLcJMU2UBrNTa8eZ
	 /FXiRIk9kJopJn+FLrIbdyULSHn47ooS9auy9xwYh5ANm1vuLZNJbE1HMmYdFtMkzfJkB
	 N3H0zeqI/tDS7ObMzqBq4GCTh3JLyE5XiY0sOwsu/ayse1I/2uKZfKWeIQGIXW0qbVDsh
	 vjafkKlOBcjeHN16JORmCFveGrEEhV5Pkuz3Cg41bm4lTIhNCO4VsqfeFJI1IghOaCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="o22C/4oI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BAB606EE9C;
	Sat,  7 Nov 2026 14:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o22C/4oI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A070A1F0089F;
	Sat,  7 Nov 2026 14:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061155;
	bh=k6RGLOt5V2AXgQUmK/ULqrIaQdIaspXsg5rWHwPNx6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o22C/4oIZgAlPFoJDR6Okc2T+j5x/o9hKmiXpPhZS+IqCajvmX2Te+DBW06/3wDhv
	 01/41hR0flkjNKQ3TLi/eIztmnhnKrnN3YZN+nztJjpaym30irtxoeCG0VpLxBijZe
	 OAK+ApX0weSDkpDxNg1j/0pPsWJR+Lxf+2i561F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jose=20Villase=C3=B1or=20Montfort?= <pepemontfort@gmail.com>,
	Alec Hall <signshop.alec@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0463/1536] HID: input: read battery capacity from its actual report offset
Date: Sat,  7 Nov 2026 08:41:19 -0500
Message-ID: <20261107135010.525908830@linuxfoundation.org>
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

From: Jose Villaseñor Montfort <pepemontfort@gmail.com>

[ Upstream commit d07644524b6511b622ee7b0e2e68c9ee43d522a4 ]

hidinput_query_battery_capacity() assumes the state-of-charge value is
the first byte following the report ID (buf[1]) and ignores where the
battery field actually sits within the report.

An Apple Magic Trackpad 2 precedes the AbsoluteStateOfCharge byte with a
byte of status flags in its battery reports, so this query returns the
flags byte instead of the charge level.

The device happens to make that easy to observe, because it exposes the
same cell twice: its report descriptor declares AbsoluteStateOfCharge in
two reports (0x90 and 0x9b), so hidinput_setup_battery() registers two
power supplies. Only the first one is refreshed by hid-magicmouse -- it
uses hid_get_battery(), which returns the first battery of the list --
and that refresh goes through the report event path, which parses the
field correctly. Nothing ever reports the second one, so every read of
its capacity takes the query path above. On a USB-C Magic Trackpad over
USB, on an unpatched 7.1.5:

  hid-<serial>-battery-144 = 100%  (Charging)      <- report event path
  hid-<serial>-battery-155 =   3%  (Discharging)   <- query path

Both are the same physical battery. A raw HIDIOCGINPUT of the two
reports at that same moment:

  report 0x90 -> [90 03 64]
  report 0x9b -> [9b 03 64 64 00 00 10 00 00 00 00 00 00 00]
                     ^flags ^SoC = 0x64 = 100%

The device answers correctly in both cases; only the offset the kernel
reads the capacity from is wrong. 0x03 is the flags byte (present,
charging), reported as "3%".

Bluetooth takes the same query path for its capacity, where the trackpad
reported a bogus near-constant ~4% -- 0b100, the FullyCharged flag --
regardless of the real charge.

Store the battery field's offset within the report at setup time and use
it when querying, so the capacity is read from its real position. The
report event path already parses the field correctly through the HID
core; only the explicit GET_REPORT query was wrong.

Devices whose capacity field is the first field in the report have a
report_offset of 0 and are unaffected (buf[1 + 0] == buf[1]).

Fixes: 581c4484769e ("HID: input: map digitizer battery usage")
Cc: stable@vger.kernel.org
Signed-off-by: Jose Villaseñor Montfort <pepemontfort@gmail.com>
Reviewed-by: Alec Hall <signshop.alec@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
[ sashal: Adapted to the older HID layout by storing the battery report offset as a flat battery_report_offset field in struct hid_device instead of struct hid_battery, and keeping manual kfree() instead of __free(kfree). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-input.c | 17 +++++++++++++----
 include/linux/hid.h     |  1 +
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 8f5e5cb88d37d..e65236326b559 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -424,19 +424,27 @@ static int hidinput_query_battery_capacity(struct hid_device *dev)
 {
 	u8 *buf;
 	int ret;
+	/*
+	 * The capacity field may not be the first field in the report: some
+	 * devices (e.g. the Apple Magic Trackpad 2 over Bluetooth) precede it
+	 * with status flags. Read it from its actual byte offset in the report
+	 * (report_offset is in bits; the leading byte is the report id).
+	 */
+	int offset = 1 + dev->battery_report_offset / 8;
+	int len = offset + 1;
 
-	buf = kmalloc(4, GFP_KERNEL);
+	buf = kmalloc(max(len, 4), GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
-	ret = hid_hw_raw_request(dev, dev->battery_report_id, buf, 4,
+	ret = hid_hw_raw_request(dev, dev->battery_report_id, buf, max(len, 4),
 				 dev->battery_report_type, HID_REQ_GET_REPORT);
-	if (ret < 2) {
+	if (ret < len) {
 		kfree(buf);
 		return -ENODATA;
 	}
 
-	ret = hidinput_scale_battery_capacity(dev, buf[1]);
+	ret = hidinput_scale_battery_capacity(dev, buf[offset]);
 	kfree(buf);
 	return ret;
 }
@@ -554,6 +562,7 @@ static int hidinput_setup_battery(struct hid_device *dev, unsigned report_type,
 	dev->battery_max = max;
 	dev->battery_report_type = report_type;
 	dev->battery_report_id = field->report->id;
+	dev->battery_report_offset = field->report_offset;
 	dev->battery_charge_status = POWER_SUPPLY_STATUS_DISCHARGING;
 
 	/*
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 2edaa8cbdd4a9..9abbafd9d1b35 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -673,6 +673,7 @@ struct hid_device {							/* device report descriptor */
 	__s32 battery_max;
 	__s32 battery_report_type;
 	__s32 battery_report_id;
+	__s32 battery_report_offset;
 	__s32 battery_charge_status;
 	enum hid_battery_status battery_status;
 	bool battery_avoid_query;
-- 
2.53.0



