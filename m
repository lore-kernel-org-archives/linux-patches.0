Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06D826B0A5;
	Thu, 13 Feb 2025 15:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459964; cv=none; b=LaVIgwl4xo3D/sYLt3BvGmekeGGuqZ+MUMoD9An6oOOzZOcG1ryloUKH0ytTlVuyNuRZz0PeXgdqqFlSnctXlaETlfOUoUHJVP/Mimg3hVTLZwvnYaLUn6HUKv+WHT+/n+QCmpaVc6m9AqVBBphXCNMBT6sGa9ok5r94PcPUXGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459964; c=relaxed/simple;
	bh=7vDHnEg8513hXWp+JhDxl6L2c4Xo7IqB/e9dtJcU3Rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDucJFxR51iwJoxMcLO8HDmOTeuwgP0zJs4kqDNqcmFucht1/8t7lWYj1OwmofW9jFFDa0JNxMjpodK6NVRbN1Mkw+rIyNZef9UocDqntOtqrhd/GaG3qfDQRnWKo+5Gpqy+jwhW4i/pZ5k/RIZDt9YKG1Z4vnYyoG2Jyvcs+eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ogt2SHYw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogt2SHYw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB53C4CED1;
	Thu, 13 Feb 2025 15:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459964;
	bh=7vDHnEg8513hXWp+JhDxl6L2c4Xo7IqB/e9dtJcU3Rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ogt2SHYwLpJGFGs9wJGD49Ybc8PcSZ9rJguffBnzt9jiaIrW12jIN+VtSDU7hr3aM
	 +gEPAYLT4x5RhNPdczK8KwwcnDH9/mVWgIl3g62YkuZ00Ldrnc3PtJe8FfOYgLb1nL
	 FlFEvRyzQtrmCVvlXhl0Qb0G+3L7jKQopxW2aQkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.13 375/443] media: uvcvideo: Remove redundant NULL assignment
Date: Thu, 13 Feb 2025 15:29:00 +0100
Message-ID: <20250213142455.079339140@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1640,10 +1640,8 @@ bool uvc_ctrl_status_event_async(struct
 	struct uvc_device *dev = chain->dev;
 	struct uvc_ctrl_work *w = &dev->async_ctrl;
 
-	if (list_empty(&ctrl->info.mappings)) {
-		ctrl->handle = NULL;
+	if (list_empty(&ctrl->info.mappings))
 		return false;
-	}
 
 	w->data = data;
 	w->urb = urb;


