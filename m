Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACFF25B67F;
	Tue, 11 Mar 2025 15:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706907; cv=none; b=IwuRb2xCuxH9BA5v1uWRfUFnqId2KhjbfvRXGwJZYsN9fNFbZs/YqBpV5m/z3vyHxDfLVmurjgdlssksuQ3aI3QozH9zMnLQBrCC7bTXWSjwUtkryzaSwmNHWa5q32uEkwUbfxGPjZf8UZ+uIa1vjjnEMM35dJQInVeA168qPEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706907; c=relaxed/simple;
	bh=Q9E/Oq1tEDZMosAzYcQXFOCQiLmICpyZctkn1aM6ilY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jr+0KhAcievur61ZlwBCO4tdC9/630chl65MQ/uFh3ACYwzRLAbYVfAoWumwMzZuOZVJ6dsTr4Xxw+Qs0vyE7I/8MDjGwE1kp4Lrqw763Gqcdi8OF0RyEAePN6r+dkDtel8J6AkP981g0CnFi40N9sogcBrCjnANlyf1Ned00HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HASTV6WK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HASTV6WK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F2DC4CEE9;
	Tue, 11 Mar 2025 15:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706906;
	bh=Q9E/Oq1tEDZMosAzYcQXFOCQiLmICpyZctkn1aM6ilY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HASTV6WKfxN5jvhQkcuI+sAR8JINj+FkcpdBmMIXNgJsprD5BiZDNdRWh3Xy4EzcA
	 +Up0uUS33sWIFa93NiwW2Q21sRIjXdIcybCq8WDGTt+lp13RCI90pYXMFi7QxHewwx
	 JfbT1O5x9i75P55E2sasSsGs+U7gZ/t5V7VnfYT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 207/462] media: uvcvideo: Remove redundant NULL assignment
Date: Tue, 11 Mar 2025 15:57:53 +0100
Message-ID: <20250311145806.539271838@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


