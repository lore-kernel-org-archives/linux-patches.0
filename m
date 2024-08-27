Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8761C6F48;
	Tue, 27 Aug 2024 15:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770805; cv=none; b=JolsUOWHCPOD7gaeJzQKq7dTnHW36lptMBIfgGvxBZ29fmsBB9kUiRt4iDPbMdgo9leAHklNuiZJog5jUKb6tQbN0qoncRoP+c9byzZuO3t1sju0pJfwkbjOPgduWADJdQwkg3rYJTS2+XvlHclaJL79UnClaAU+ihO0lB3THRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770805; c=relaxed/simple;
	bh=Qkk1L3XdNyJvkwEV/ft6Hlj2ZYYHFMO4hyYYBIB/cFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XumEPteI1cn9TW/yu+VWzQNFJlDrO+4wVWpvhOjXjNYQw5vp0TLCXP9RaBqdqsrFcd6EmTww+xgGNLo4IsmPCpRqOr9m4D98dbPZID9DYS8rTCBBlwjI+5nlIIPOsktfBoXHbDnbZDV+2W752ALWeq3Aoqj1Fytv5RlY3KGmYo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q4Y7O/nC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q4Y7O/nC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160C1C4AF63;
	Tue, 27 Aug 2024 15:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770805;
	bh=Qkk1L3XdNyJvkwEV/ft6Hlj2ZYYHFMO4hyYYBIB/cFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q4Y7O/nCS06D20M9NMzpc2vl3/EAFGs4HvvKLXp0XPymAv+2zwwRacqinaqAubyms
	 bK6jCXY9KhwsvDLg1rVZqProUDe1CpzWsfLVjB2xPV4qR+VqlLkC11urn3TM3NHY01
	 vho8mjgsd0MhVRuMQwc0jbuelXxUtwZWZxoiQ5V0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH 6.6 322/341] Revert "usb: gadget: uvc: cleanup request when not in correct state"
Date: Tue, 27 Aug 2024 16:39:13 +0200
Message-ID: <20240827143855.646919840@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit dddc00f255415b826190cfbaa5d6dbc87cd9ded1 upstream.

This reverts commit 52a39f2cf62bb5430ad1f54cd522dbfdab1d71ba.

Based on review comments, it was applied too soon and needs more work.

Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20231005081716.GA13853@pendragon.ideasonboard.com
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/uvc_video.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -259,12 +259,6 @@ uvc_video_complete(struct usb_ep *ep, st
 	struct uvc_device *uvc = video->uvc;
 	unsigned long flags;
 
-	if (uvc->state == UVC_STATE_CONNECTED) {
-		usb_ep_free_request(video->ep, ureq->req);
-		ureq->req = NULL;
-		return;
-	}
-
 	switch (req->status) {
 	case 0:
 		break;


