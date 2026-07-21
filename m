Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F5E2D7DF1;
	Tue, 21 Jul 2026 22:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674728; cv=none; b=VEOM6uyvJjU27l5qMPDGJpV736yUIH0b0UZDSusWC43CiWP7j9QQNsXL3dvKUkB4spUjR5raI4Yh6zGW5Ql7vhv47X95lctYKvcCPC4t6tGmHbAPe7Mk9PeP8nEJPegy41OYTxjMuo1g33IvrigA773HY2al+QCuTiuAWuDf9qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674728; c=relaxed/simple;
	bh=TIddahY6yor67W6Jq9H06uktEF1iZCmxyHCWccdJAok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXNMCYpqK7jJDWLXp0yoLPzqo82BGBNMiSzyFt/I8GQcpqerKktSZkoc/4WxBKjaIzmlexRUgDCjhTepsvHE1gD6/z+75VpRtP4R7eJRFrnmMNQ8HKtBM8cPvI0RUN38LWviFwNNcwDXuLiUeeBTBm16n8bhWSoZgxBwKCtWua8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2dcr1zI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2dcr1zI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B5A1F000E9;
	Tue, 21 Jul 2026 22:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674727;
	bh=pMMaNxxXkoDHz+gsSG+4Xj6VF0kE0fiQBXm4GTXkjRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W2dcr1zInh4CKVUN9XrZJf/WC45aIm1ZO8vp8q4YELalK9BEOYWXMOyo0F0pkaDIn
	 zpKfSXiHJx+s6pbepi1vUS9dij6X6FIp2sO8/S+mtfu7cvaO6UXs7hzd+jWuPMP++m
	 KiQ/oVAfnJRLhT3ep/U03TcXKo7bDDut9uQTj6GA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Angela Czubak <aczubak@google.com>,
	Jonathan Denose <jdenose@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 651/699] HID: add haptics page defines
Date: Tue, 21 Jul 2026 17:26:50 +0200
Message-ID: <20260721152410.441776950@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -152,6 +152,7 @@ struct hid_item {
 #define HID_UP_TELEPHONY	0x000b0000
 #define HID_UP_CONSUMER		0x000c0000
 #define HID_UP_DIGITIZER	0x000d0000
+#define HID_UP_HAPTIC		0x000e0000
 #define HID_UP_PID		0x000f0000
 #define HID_UP_HPVENDOR         0xff7f0000
 #define HID_UP_HPVENDOR2        0xff010000
@@ -299,6 +300,28 @@ struct hid_item {
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
 #define HID_VD_ASUS_CUSTOM_MEDIA_KEYS	0xff310076
 /*
  * HID report types --- Ouch! HID spec says 1 2 3!
@@ -385,6 +408,12 @@ struct hid_item {
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


