Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829159;
	b=L+AEnfsIbLfIjxyc7IQOCmtoIVjPIay+Ru3qz4u+GrvOzxWRoMIR5Y5prpAJkFsC7aW5
	 u0Yr4GttSkGkit/I7fEjRSD+EkNq7bp8CgsgodQ45GdcYqMeEtLbCE8hll3h+HXV/CLXI
	 X7AWZzmRh9I/KkQXTpE4zwDxLqOpqU11P9fyj9MRq4XehyJrHxsJZXqAiFROS2IcvsU/D
	 BgLlNcgf/DO6ejab+I46LLahskWTHVBH5nUk6bmchS96UrrC/rShUYtJCW1ph4Z7f3tHC
	 TlkZEo/fikoHaSgXKSmXdcxELZzbVp/11Zj5m3mSA1/Djs1EXpBQP1n7Q8Xi1SJZJ+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829159;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lS64HSa1R1o7hZGs+sp1ii4YOLZioOreSXqxmz7DdDA=;
	b=WrC5zupYuM6Mhsn2r03Wae1Io+Dz9eMbNsVvQPaSu95xx+A/jSndy4valu1TODNXvlAO
	 mL5waabAV5A+20GJmtYwAEU98yXCqLwpmT6IvMr+CckwyE6x70Ztz91ZiigAIRaozSigE
	 sKBX8ldactvea+yI+hCUa5Jmsv4pEaqatpNZcde5gK5OpWPWmoML5bUGMsgxvNOkrpR+h
	 YOWv9VfIl0Qp83yI2lccuepbKIWsRNpQp9qR0Ex+8tcU3Lh0HmZcYSvf+PXN9nvjtXDg1
	 MchuyY64uBVOfhwOpTvSx2fDxxu0CgN0SgCAKYBWDRHZxg3UgDwmLEdKTX16L6Ad/NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VEm4k1uP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2996607031A;
	Wed,  4 Nov 2026 21:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VEm4k1uP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F7C1F000C1;
	Wed,  4 Nov 2026 21:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829158;
	bh=lS64HSa1R1o7hZGs+sp1ii4YOLZioOreSXqxmz7DdDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VEm4k1uPultmfflIG3She2gXhjFqyuXu1k6X2+YSzORxFUpjtU4JBt0nJqIbivqHh
	 8oBJ8BR/OnGc4SeviwahMaPsNl1v8OGiCqwLJcNW5hRDGJ57tcIcNBAJdNEJdUPibx
	 Y82RfvzFQNvLZXzVtIJi2MyWZdrgSuN1nZf1c9kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kerim Kabirov <the.privat33r+linux@pm.me>,
	GameBurrow <gameburrow@pm.me>,
	Ahmed Yaseen <yaseen@ghoul.dev>,
	Denis Benato <denis.benato@linux.dev>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 483/547] HID: usbhid: skip interrupt IN polling for devices with no input reports
Date: Wed,  4 Nov 2026 16:11:07 -0500
Message-ID: <20261104211052.101535673@linuxfoundation.org>
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

From: Ahmed Yaseen <yaseen@ghoul.dev>

commit 4563e596bd913fb2d5b10b2ef306c754cf97ced2 upstream.

usbhid starts polling a device's interrupt IN endpoint on open
(usbhid_open() -> hid_start_in()). If the report descriptor declares no
input reports there is nothing to read there, so the poll is useless,
and on some composite devices it is also harmful.

The ASUS ROG N-Key keyboards expose a second, input-less interface used
only for RGB control via feature reports. Opening its hidraw node (any
hidraw reader does, including SDL/Steam Input or a plain cat) starts the
pointless IN poll and keypress reports on the keyboard interface get
dropped for as long as the node stays open: a lost key-down drops a
letter, a lost key-up leaves the key stuck. usbmon shows the dropped
reports never reach the URB layer.

The useless poll itself is long-standing; commit 4ac74ea68f64 ("HID:
asus: early return for ROG devices") is what exposes it on these
devices by keeping the input-less interface alive instead of ejecting
it, so its hidraw node can be opened and the poll started.

Skip the poll in usbhid_open() when the device has no input reports.
Feature reports and hidraw output keep working over the control and OUT
endpoints, so the interface is otherwise unaffected.

Fixes: 4ac74ea68f64 ("HID: asus: early return for ROG devices")
Link: https://discuss.cachyos.org/t/keyboard-input-issues-on-asus-rog-strix-16-2025-with-cachyos-during-gaming/30823
Link: https://github.com/ublue-os/bazzite/issues/4590
Cc: stable@vger.kernel.org
Tested-by: Kerim Kabirov <the.privat33r+linux@pm.me>
Tested-by: GameBurrow <gameburrow@pm.me>
Signed-off-by: Ahmed Yaseen <yaseen@ghoul.dev>
Reviewed-by: Denis Benato <denis.benato@linux.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/usbhid/hid-core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 96b0181cf819..d7cf2b56e117 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -688,7 +688,14 @@ static int usbhid_open(struct hid_device *hid)
 
 	set_bit(HID_OPENED, &usbhid->iofl);
 
-	if (hid->quirks & HID_QUIRK_ALWAYS_POLL) {
+	/*
+	 * ALWAYS_POLL devices are already polled from usbhid_start(), and a
+	 * device with no input reports has nothing to send on the interrupt
+	 * IN endpoint. In some cases polling is harmful: on the ASUS ROG
+	 * N-Key keyboards it makes the sibling interface drop keypresses.
+	 */
+	if ((hid->quirks & HID_QUIRK_ALWAYS_POLL) ||
+	    list_empty(&hid->report_enum[HID_INPUT_REPORT].report_list)) {
 		res = 0;
 		goto Done;
 	}
-- 
2.56.0



