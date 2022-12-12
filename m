Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302B428ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:40:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164EAC433EF;
	Mon, 12 Dec 2022 13:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852452;
	bh=phyVVwqYGtrMlvC2QC2/H841CprUmcWBHMOGjywHE+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nu95tjgYxCk563YNKcVsjcKVgLtIrUxN/tcdP9BWZ7czUbisb9fssAJi4HOi7PEKl
	 +MvrI7CLs4ko+99Ca0TVESjBlLamDsh5p4T1+w5XQnygR6r+i39ln/dqinfU+XBHxG
	 u6cAlVD8kjVlqYie07Q5fO48+l3IY/KTCzBIacLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rudolf Polzer <rpolzer@google.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 6.0 083/157] HID: ite: Enable QUIRK_TOUCHPAD_ON_OFF_REPORT on Acer Aspire Switch V 10
Date: Mon, 12 Dec 2022 14:17:11 +0100
Message-Id: <20221212130938.121804019@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

commit 9ad6645a9dce4d0e42daca6ebf32a154401c59d3 upstream.

The Acer Aspire Switch V 10 (SW5-017)'s keyboard-dock uses the same
ITE controller setup as other Acer Switch 2-in-1's.

This needs special handling for the wifi on/off toggle hotkey as well as
to properly report touchpad on/off keypresses.

Add the USB-ids for the SW5-017's keyboard-dock with a quirk setting of
QUIRK_TOUCHPAD_ON_OFF_REPORT to fix both issues.

Cc: Rudolf Polzer <rpolzer@google.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h |    1 +
 drivers/hid/hid-ite.c |    5 +++++
 2 files changed, 6 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1217,6 +1217,7 @@
 #define USB_DEVICE_ID_SYNAPTICS_DELL_K15A	0x6e21
 #define USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1002	0x73f4
 #define USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1003	0x73f5
+#define USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_017	0x73f6
 #define USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5	0x81a7
 
 #define USB_VENDOR_ID_TEXAS_INSTRUMENTS	0x2047
--- a/drivers/hid/hid-ite.c
+++ b/drivers/hid/hid-ite.c
@@ -121,6 +121,11 @@ static const struct hid_device_id ite_de
 		     USB_VENDOR_ID_SYNAPTICS,
 		     USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1003),
 	  .driver_data = QUIRK_TOUCHPAD_ON_OFF_REPORT },
+	/* ITE8910 USB kbd ctlr, with Synaptics touchpad connected to it. */
+	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
+		     USB_VENDOR_ID_SYNAPTICS,
+		     USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_017),
+	  .driver_data = QUIRK_TOUCHPAD_ON_OFF_REPORT },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, ite_devices);


