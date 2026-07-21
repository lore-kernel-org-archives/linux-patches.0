Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9B6476CFB;
	Tue, 21 Jul 2026 21:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667828; cv=none; b=b1y7svw25FSSQpszFnRG3B6NchhnDEQQlrpWHbE/1PaYh5P5E5fbAk+MbVRGVgZ5xBhe4xxmz+C6rx8UsAaMDvhEUUnWyDgV7d/srmuQdVbFjwYgR80LP/aeZar4XcIOhj6r9PRcwdaRmWPnNtaovmTHEiT6tL8HcnbKZIyzxTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667828; c=relaxed/simple;
	bh=f8QbRovcdCEvPa5GKa3DZeJppbc8kQOb21IMxKvc7Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWfaWZJYE5eek80285MDUi9sdoX8HjMzE6lwiOBnKauMX+XE+AAT7m0Z9coziT7TYdt7X3z8021pe5ne+xoUUdSeJkR8UsxTMTorcsjhbJqVIVfISQeoTsMGt5qrNvN1Y/Ck0V2LaXa3nUl02RElXUxcJJ9COJVK5fg4VOv7E7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VlKddFmy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VlKddFmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49961F000E9;
	Tue, 21 Jul 2026 21:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667824;
	bh=8WjZdqXSOMFGr76GZSU3tb3zLMfE5saVrb7+h353ocg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VlKddFmyVHIFrWH3rBcK4C0MqrNvD5TOmxvieGVwryxLbKt9ICyQ5btv/NQ/ne4N7
	 3R62jUpl4DVf/ISDad0xyIq70jBp+38kCJSsWYH1wA41b3NfUep+vIr+1b91McFasB
	 T3R4g2yww4lVhQyK+cLwzxTwhT72TB8A+mSei7tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Angela Czubak <aczubak@google.com>,
	Jonathan Denose <jdenose@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1208/1266] HID: add haptics page defines
Date: Tue, 21 Jul 2026 17:27:25 +0200
Message-ID: <20260721152508.833722708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Angela Czubak <aczubak@google.com>

[ Upstream commit 5e0ae59159e3a07391a35865bb79ff335473fa79 ]

Introduce haptic usages as defined in HID Usage Tables specification.
Add HID units for newton and gram.

Signed-off-by: Angela Czubak <aczubak@google.com>
Co-developed-by: Jonathan Denose <jdenose@google.com>
Signed-off-by: Jonathan Denose <jdenose@google.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Stable-dep-of: 8813b0612275 ("HID: multitouch: fix out-of-bounds bit access on mt_io_flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hid.h |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -154,6 +154,7 @@ struct hid_item {
 #define HID_UP_TELEPHONY	0x000b0000
 #define HID_UP_CONSUMER		0x000c0000
 #define HID_UP_DIGITIZER	0x000d0000
+#define HID_UP_HAPTIC		0x000e0000
 #define HID_UP_PID		0x000f0000
 #define HID_UP_BATTERY		0x00850000
 #define HID_UP_CAMERA		0x00900000
@@ -314,6 +315,28 @@ struct hid_item {
 #define HID_DG_TOOLSERIALNUMBER	0x000d005b
 #define HID_DG_LATENCYMODE	0x000d0060
 
+#define HID_HP_SIMPLECONTROLLER	0x000e0001
+#define HID_HP_WAVEFORMLIST	0x000e0010
+#define HID_HP_DURATIONLIST	0x000e0011
+#define HID_HP_AUTOTRIGGER	0x000e0020
+#define HID_HP_MANUALTRIGGER	0x000e0021
+#define HID_HP_AUTOTRIGGERASSOCIATEDCONTROL 0x000e0022
+#define HID_HP_INTENSITY	0x000e0023
+#define HID_HP_REPEATCOUNT	0x000e0024
+#define HID_HP_RETRIGGERPERIOD	0x000e0025
+#define HID_HP_WAVEFORMVENDORPAGE	0x000e0026
+#define HID_HP_WAVEFORMVENDORID	0x000e0027
+#define HID_HP_WAVEFORMCUTOFFTIME	0x000e0028
+#define HID_HP_WAVEFORMNONE	0x000e1001
+#define HID_HP_WAVEFORMSTOP	0x000e1002
+#define HID_HP_WAVEFORMCLICK	0x000e1003
+#define HID_HP_WAVEFORMBUZZCONTINUOUS	0x000e1004
+#define HID_HP_WAVEFORMRUMBLECONTINUOUS	0x000e1005
+#define HID_HP_WAVEFORMPRESS	0x000e1006
+#define HID_HP_WAVEFORMRELEASE	0x000e1007
+#define HID_HP_VENDORWAVEFORMMIN	0x000e2001
+#define HID_HP_VENDORWAVEFORMMAX	0x000e2fff
+
 #define HID_BAT_ABSOLUTESTATEOFCHARGE	0x00850065
 #define HID_BAT_CHARGING		0x00850044
 
@@ -420,6 +443,12 @@ struct hid_item {
 #define HID_BOOT_PROTOCOL	0
 
 /*
+ * HID units
+ */
+#define HID_UNIT_GRAM		0x0101
+#define HID_UNIT_NEWTON		0xe111
+
+/*
  * This is the global environment of the parser. This information is
  * persistent for main-items. The global environment can be saved and
  * restored with PUSH/POP statements.


