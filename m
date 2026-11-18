Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051511;
	b=zMz0krx5wJYo14r8neaS7KuWYAtWVdgAmmgiLOrBaeKlIAmjbRF9bKlhbliy1xS+4mHh
	 YxSANMTlyeGoZYfOrTbgwQJbrrQ2MpkH8vHC4JBU32ARHHmm0t0Zv6SHundysccMXNH3n
	 K+cdc575zS/RLFrwDkXoSon7jbC6N+FDnfu1WTIACp16Slmfw4LxCqkfNaLe//+xoGmZA
	 2gLt2/y+P2o1GtBsmNEbST+D40rVzCnpxpztV0Kawl4DUBEYj7IZ13My7agjFmVWMlNPV
	 MbAu3ovo/a9Q9GC/BGmX0k5xuzbUdaq5rhLz/MvX0+DBjQtH629CMLJmirP6dz6uPzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=7SS6UdF3o8TY1kOwF8FXWmEjB+adJkDyaMzB0/+4cvA=;
	b=iiql0mRQn8IpqYdJq+V4lgdDaMrW1g8eEiMfIPLXenS/YfGj+YP9ckxYiGYlpB+G7Xhb
	 coXAjq0qf3Kuv4zMI5U+ZaOnw/T6qJkgg7bh4pmhIo47q333f89slyhtpewBLuGFjI538
	 69ZrA9o4CLUaDqafCH89hPqg1zfCRyMtxisHJzqyAe1phPb9J4pSsFZiJL7azfgrkvmzq
	 8rQHPWfOE1Q2hlAN8HmbgRKA/ucGgz6L8X5gRekbEC0Ykued44aCZewg4l2nieo5AtxRX
	 4TncAgPq3zRIV8ZiOzpzhfLInouWY0PybkSk/ub1Z1WeFGJ7yt3F7ZMpNhDKwp604Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0P5n8JsQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BE2606A31C;
	Thu, 19 Nov 2026 01:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0P5n8JsQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC4C1F000C4;
	Thu, 19 Nov 2026 01:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051511;
	bh=7SS6UdF3o8TY1kOwF8FXWmEjB+adJkDyaMzB0/+4cvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0P5n8JsQ+p9OTSgZ67TjHwbbw4mWEls9S9TI0ojDKj9yXvM4OFzWZlpDDFvE6XbNC
	 hk9x8fxnjwEzZm+ohds6SSHjcCnfySvQlnaA8gwHuiUMKYNCm8cT4rBbIx5M2cV5Fy
	 EoVV5+qFfjGjtewnwcSyBqZIb8ZDdXwwXFl/1IhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Carey <carvsdriver@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0234/2214] HID: multitouch: Fix stale MT slots when contact count drops to zero
Date: Wed, 18 Nov 2026 15:31:50 +0100
Message-ID: <20261118150019.575861567@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Carey <carvsdriver@gmail.com>

[ Upstream commit e8e60b6439eed340a611e9d7a5b9bcbd0ef62725 ]

The INGENIC 17EF:6161 touchscreen (Lenovo Yoga Book 9 14IAH10) reports
HID_DG_CONTACTCOUNT=0 in the frame immediately following the last finger
lift rather than omitting the frame entirely.  In mt_touch_report() the
existing code only updates num_expected when contact_count is non-zero,
so a zero contact count on the first packet of a new frame leaves
num_expected at its previous value (e.g. 2 for a two-finger gesture).
The sync check "num_received >= num_expected" then evaluates "0 >= 2"
and never fires, preventing INPUT_MT_DROP_UNUSED from releasing the
stale slots.  Those slots remain active in the kernel MT layer until the
next touch, at which point they are released in a batch alongside the
new contact — causing the userspace event consumer to miss the
intervening finger-up sequence and corrupt its gesture session state.

Fix by resetting num_expected to 0 when contact_count is zero and
num_received is still 0 (i.e., this is the first and only packet of the
frame, not a continuation packet in a multi-packet sequence).  With
num_expected=0 the sync check "0 >= 0" fires immediately, calling
input_mt_sync_frame() which drops the stale slots via
INPUT_MT_DROP_UNUSED.

The num_received==0 guard is critical: continuation packets in a
multi-packet frame arrive after at least one contact has already been
processed (num_received>0), so they are correctly excluded from this
path and the existing multi-packet logic is unaffected.

Signed-off-by: Dave Carey <carvsdriver@gmail.com>
Tested-by: Dave Carey <carvsdriver@gmail.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index a7871c2b2d8f7..13e679c465916 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1227,21 +1227,18 @@ static void mt_touch_report(struct hid_device *hid,
 	 * Includes multi-packet support where subsequent
 	 * packets are sent with zero contactcount.
 	 */
-	if (contact_count >= 0) {
+	if (contact_count > 0)
+		app->num_expected = contact_count;
+	else if (app->num_received == 0 && app->prev_scantime != scantime) {
 		/*
+		 * New multi-report frame:
+		 *
 		 * For Win8 PTPs the first packet (td->num_received == 0) may
 		 * have a contactcount of 0 if there only is a button event.
-		 * We double check that this is not a continuation packet
-		 * of a possible multi-packet frame be checking that the
-		 * timestamp has changed.
+		 *
+		 * Some other devices use a sentinel frame with 0 to release all contacts
 		 */
-		if ((app->quirks & MT_QUIRK_WIN8_PTP_BUTTONS) &&
-		    app->num_received == 0 &&
-		    app->prev_scantime != scantime)
-			app->num_expected = contact_count;
-		/* A non 0 contact count always indicates a first packet */
-		else if (contact_count)
-			app->num_expected = contact_count;
+		app->num_expected = 0;
 	}
 	app->prev_scantime = scantime;
 
-- 
2.53.0



