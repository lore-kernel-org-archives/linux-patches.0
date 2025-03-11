Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60BF1C3BEB;
	Tue, 11 Mar 2025 15:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705819; cv=none; b=cRE6RCRC4vd1CP8r99RRbPrHNafZLVhW8DETQhqHa+WYwCOL59mKmUoZzvyMKVhDIsItb5BbzGXEX6UomA8crFTgDxXRQxMRbkr9DcGS8S4oGfEVSqVZ7W4BLalDe1AA60lHLw2B6+SNiYjWh8gNr1v8lb6R5hqaPKcqe+gJIsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705819; c=relaxed/simple;
	bh=kXrhC85VwMPPVZqtbiPKoHRQQW1Ks/2aRgyLzwZvgxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cb7CU1wut9kFJM0ZpMFet8rvYQQjGOqQDPvt+NG6sho3B0EPF8MyeCTkqOqdtQCEg0j4uPltYngwP8cRfSWpGCTUiThwRxfeU87UVh6XWV0tUKCXa0g1IVKxhjEyNH+U7nFcmjHQWcKuSuoimQi9rZVR2nxWRofeEcF/nSlrA+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Em5PH8aC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Em5PH8aC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DE2C4CEEA;
	Tue, 11 Mar 2025 15:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705819;
	bh=kXrhC85VwMPPVZqtbiPKoHRQQW1Ks/2aRgyLzwZvgxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Em5PH8aCASoZa5qeGzkynjEBCdQexJyyE4c7uiyNQYIsYjnrW/zrhq1pbKIXBoS9+
	 G8kJCCZneByOKZ9tguLNlgKkhJP1yDRRdN5YniWObClfQgjrsls0R0eImxh/NYc+Lp
	 S+3cmePNMUGAFEFhH8V4oiWPIF/HIFI66glgxcqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 147/328] media: uvcvideo: Remove redundant NULL assignment
Date: Tue, 11 Mar 2025 15:58:37 +0100
Message-ID: <20250311145720.748844734@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

commit 04d3398f66d2d31c4b8caea88f051a4257b7a161 upstream.

ctrl->handle will only be different than NULL for controls that have
mappings. This is because that assignment is only done inside
uvc_ctrl_set() for mapped controls.

Cc: stable@vger.kernel.org
Fixes: e5225c820c05 ("media: uvcvideo: Send a control event when a Control Change interrupt arrives")
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://lore.kernel.org/r/20241203-uvc-fix-async-v6-2-26c867231118@chromium.org
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1367,10 +1367,8 @@ bool uvc_ctrl_status_event_async(struct
 	struct uvc_device *dev = chain->dev;
 	struct uvc_ctrl_work *w = &dev->async_ctrl;
 
-	if (list_empty(&ctrl->info.mappings)) {
-		ctrl->handle = NULL;
+	if (list_empty(&ctrl->info.mappings))
 		return false;
-	}
 
 	w->data = data;
 	w->urb = urb;


