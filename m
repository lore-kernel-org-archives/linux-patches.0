Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF554171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B71AC433EF;
	Mon, 22 May 2023 19:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783297;
	bh=/IcPLkMLoxgWR6lmxVgTkE++8SzaFk0gYWdzxDgnWME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lj/NHK8H2CvZU9XrLZp+8Jf3m6+m2Z1pasnh/ZOCs2QAKHRU6mByAzG/7MAu7u+Rm
	 9D3fJHTiVcJeQMjxFrd9/8f9wjuMUJDi69zVA2QENnh2xh+LAq0yAJRvABTs1s9DS8
	 SveX/yKwXWY5X7pHax3cNKNqf/lIETr05pshWDcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Ping Cheng <pinglinux@gmail.com>
Subject: [PATCH 5.15 202/203] HID: wacom: Add new Intuos Pro Small (PTH-460) device IDs
Date: Mon, 22 May 2023 20:10:26 +0100
Message-Id: <20230522190400.642010589@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ping Cheng <pinglinux@gmail.com>

commit 0627f3df95e1609693f89e7ceb4156ac5db6e358 upstream.

Add the new PIDs to wacom_wac.c to support the new model in the Intuos Pro series.

Signed-off-by: Ping Cheng <ping.cheng@wacom.com>
Tested-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Ping Cheng <pinglinux@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -4871,6 +4871,10 @@ static const struct wacom_features wacom
 static const struct wacom_features wacom_features_0x3c8 =
 	{ "Wacom Intuos BT M", 21600, 13500, 4095, 63,
 	  INTUOSHT3_BT, WACOM_INTUOS_RES, WACOM_INTUOS_RES, 4 };
+static const struct wacom_features wacom_features_0x3dd =
+	{ "Wacom Intuos Pro S", 31920, 19950, 8191, 63,
+	  INTUOSP2S_BT, WACOM_INTUOS3_RES, WACOM_INTUOS3_RES, 7,
+	  .touch_max = 10 };
 
 static const struct wacom_features wacom_features_HID_ANY_ID =
 	{ "Wacom HID", .type = HID_GENERIC, .oVid = HID_ANY_ID, .oPid = HID_ANY_ID };
@@ -5050,6 +5054,7 @@ const struct hid_device_id wacom_ids[] =
 	{ BT_DEVICE_WACOM(0x393) },
 	{ BT_DEVICE_WACOM(0x3c6) },
 	{ BT_DEVICE_WACOM(0x3c8) },
+	{ BT_DEVICE_WACOM(0x3dd) },
 	{ USB_DEVICE_WACOM(0x4001) },
 	{ USB_DEVICE_WACOM(0x4004) },
 	{ USB_DEVICE_WACOM(0x5000) },


