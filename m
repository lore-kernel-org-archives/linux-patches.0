Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057604;
	b=ISQ9Yu0lc6YFxA6L/L8F8BRZfwvaLdq1jRIFwrKpisgA5Qhs3jeAa76AhLzMN2uyGNXS
	 yp6LrihlX7MBWQqVctp0XsWSMbMu6fuUb+MhLjSG1IOtoHjUUVjzhVHFivXrg9C3wxkEW
	 i7+rTYYiST5QRx619tdSOMJhUlCjJEL227Rb9iH80IBjeInlIvSHnEPdruH+AWxIUmYMg
	 /Zo2MwziUeaHLOXw5OqlQOCdEr18PFpO0lsgn7MgOC+DVy8H4jBgAgfC0+cZRSFWXmCWX
	 KY/D+9r7AOsUd6JPZnGzAvSQyfEYbvt/Iu8aFOWYWse/lILzZtNtTD9Vl2scx4d8ZcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=I+13VTJTkbBcEayq4/isOyFGvdGkmKBzCMha+arf6cU=;
	b=wXS43QessOrUKiDF/DnpmOzDeW+sBIoQlXFYVs70ICQqb76dFB1SHMULwu5+or9/LO3X
	 xzk6vdAZyfD9j/ah+JRm5ofydDbLli7NC7dg6nTqJM5XqKHtZrPrhDNQ/QSsFUwpiqq/v
	 R1FC3NjtcwWGKnbya8voliWqyl4KLCqiwbxL0lPNdGlNpdSOdXLg5Wury2kn7tid4Sn3J
	 uu2WKod9aUKTCgY6myMbzVDpWR3VJtsVmeYob2vJ1cmgCZQaipsbddTIQgxd6Bu9S5xVR
	 p49oMQgR9ZpSfqPzoV3PalWNsuDtVsxWyolAb3XKIzcWBXO2wAnhIcAm/xI5Kl8Rfvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JFt9HWHL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA9360A2604;
	Thu, 19 Nov 2026 03:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JFt9HWHL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD3E1F000C9;
	Thu, 19 Nov 2026 03:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057604;
	bh=I+13VTJTkbBcEayq4/isOyFGvdGkmKBzCMha+arf6cU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JFt9HWHLZaXmm6dAjqmi4N/d5l7Zk024xK2o0UgoLd18iPhIydUJK380ON3qIGpXV
	 Av7H5MGPvO39YXyi6t9qTUCDo93VfX49auag+EYpK8/l1ZBAYu5XpKKY+gqzZrCU53
	 9Ham7XqN3omtT9klaOqg9yGbEDVRu7+Sf195IguA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Carey <carvsdriver@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0190/1848] HID: multitouch: Fix stale MT slots when contact count drops to zero
Date: Wed, 18 Nov 2026 15:37:08 +0100
Message-ID: <20261118145919.657756549@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e4b91c0866bb9..0e8507f617d0f 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1174,21 +1174,18 @@ static void mt_touch_report(struct hid_device *hid,
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



