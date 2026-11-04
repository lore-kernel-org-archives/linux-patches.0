Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829208;
	b=yx7eWcMfFNAU1vgfXUettRUOZcQsk4RPRJ/j6rW7Q5Lfqdw7/IheVJfQNa6dZcFeb5cS
	 ncdZoOTGoBQNiN+1RoSGxoFkR/t+Qg+osIsBQPSEq2iSRSpAaFxZ0S12Uq9napgXcJq+u
	 NQuYZGHj7Rz+qFwgv4BDwpSMwPsiDU0n1i5e+wEEdHz4tMmJ7RwZtaSuun+7q1WMflvN8
	 O+qD09Vfq1WmreN0x6oHFWYcDhFWciowvKIL0ENNkqZJ2vfv5CZt0ip16Q7+LQ0L0K0da
	 y1qyYcfgYv/I+RpvJGTE7DnEzsVmG4MKvOG446/d66QHX2yNQe7VgCii0AtUBxfTw6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829208;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jqIwsioYBGtuM9qh36zxjinb6qNden3f/SjNtHROcEg=;
	b=R+YcPV0fag3zb0rV8lIREsOZvYJZyxxm5E40L+3FuAO4Gvo2YbZOUBCTTw9yZ4d8aIrX
	 l2x3Cf9LrsVk5xOQ/MZlDHFJ2zRnDOXy0Law0GT7n30OAoLV5V/+nrp16zLjM+G7e83vU
	 u2+tFl8gWD0C9Q3QlSlpBqzKyS0fGzX1yIvKRXQmlBKmvJ3sCEL2AC0yG5w9g2sczYNyv
	 Dw83ih9W8RR7lQL3HBwoI/vhylrF4pKsKLFID9HOB/woaLKsAS1OvtBpZWSRhFbWEnflK
	 TS1tCwJctQuvQD337FOHOhqsal+R6WczDYGor6/UDDZMcuzxfyUpy2RL5Em1J3VnWfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hw+LP8Pi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A726072F9A;
	Wed,  4 Nov 2026 21:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hw+LP8Pi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E8A1F000C1;
	Wed,  4 Nov 2026 21:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829207;
	bh=jqIwsioYBGtuM9qh36zxjinb6qNden3f/SjNtHROcEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hw+LP8PifQyydN2zu8hYpycC/AgsEH7/edDLMiq/VMuRLpgFyig41uPHuAvgWneaG
	 K+pHBteBnLNdVVU2JCqCb/Ti6JvXRy/pvMfeWbQqKDRBYi0tSAF+X7gKBJh05EralG
	 auLM0RcY49ikkkmgUy8YQh660CmLHmV2yp61oWlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Derek J. Clark" <derekjohn.clark@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 513/547] HID: hid-lenovo-go-s: Reorganize and rename hid_gos_cfg
Date: Wed,  4 Nov 2026 16:11:37 -0500
Message-ID: <20261104211052.966848659@linuxfoundation.org>
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

From: Derek J. Clark <derekjohn.clark@gmail.com>

commit 186323f048317e033819291e5d70ad19ded53768 upstream.

Renames hid_gos_cfg struct to gos_cfg_drvdata in preparation for later
fixes.

This is a prerequisite for later fixes. No functional change intended.

Fixes: a23f3497bf208c59ad ("HID: hid-lenovo-go-s: Add Lenovo Legion Go S Series HID Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Derek J. Clark <derekjohn.clark@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-lenovo-go-s.c | 43 +++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/hid/hid-lenovo-go-s.c b/drivers/hid/hid-lenovo-go-s.c
index f1a0bcfcdb71..e5c4104a3adb 100644
--- a/drivers/hid/hid-lenovo-go-s.c
+++ b/drivers/hid/hid-lenovo-go-s.c
@@ -32,36 +32,41 @@
 #define GO_S_CFG_INTF_IN	0x84
 #define GO_S_PACKET_SIZE	64
 
-static struct hid_gos_cfg {
-	struct delayed_work gos_cfg_setup;
+static struct gos_cfg_drvdata {
+	/* MCU General Variables */
 	struct completion send_cmd_complete;
-	struct led_classdev *led_cdev;
+	struct delayed_work gos_cfg_setup;
 	struct hid_device *hdev;
 	bool orphan_ack_pending;
 	struct mutex cfg_mutex; /*ensure single synchronous output report*/
-	bool gp_registered;
-	bool rgb_registered;
 	int cmd_status;
+
+	/* Gamepad Variables */
 	u8 gp_auto_sleep_time;
-	u8 gp_dpad_mode;
-	u8 gp_mode;
-	u8 gp_poll_rate;
-	u8 imu_bypass_en;
 	u8 imu_manufacturer;
+	bool gp_registered;
+	u8 tp_windows_mode;
+	u8 tp_manufacturer;
+	u8 tp_linux_mode;
+	u8 imu_bypass_en;
 	u8 imu_sensor_en;
+	u8 gp_dpad_mode;
+	u8 gp_poll_rate;
 	u8 mcu_id[12];
 	u8 mouse_step;
-	u8 os_mode;
-	u8 rgb_effect;
-	u8 rgb_en;
-	u8 rgb_mode;
-	u8 rgb_profile;
-	u8 rgb_speed;
-	u8 tp_en;
-	u8 tp_linux_mode;
-	u8 tp_windows_mode;
 	u8 tp_version;
-	u8 tp_manufacturer;
+	u8 gp_mode;
+	u8 os_mode;
+	u8 tp_en;
+
+	/* RGB Variables */
+	struct led_classdev *led_cdev;
+	bool rgb_registered;
+	u8 rgb_profile;
+	u8 rgb_effect;
+	u8 rgb_speed;
+	u8 rgb_mode;
+	u8 rgb_en;
 } drvdata;
 
 struct gos_cfg_attr {
-- 
2.56.0



