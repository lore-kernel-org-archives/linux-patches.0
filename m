Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2E615DBBA;
	Thu, 13 Feb 2025 15:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460797; cv=none; b=smZx8IKEgBKx79Opni+kb7mPW40HSuHLwxgHRGgIbkFAamzQqZYUKlnelHI8/vIN1Jla7UGYmUfGAL/58SY+lhMSyPtx4ef8sgcdKZZ/testOjHZs5m4gXfVWXvPAKjiRIgznFAcC/8h1kb32aohxZ916A0sxS2+0SQ5DSIatQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460797; c=relaxed/simple;
	bh=XyySg7NfhdZMGmTmU4uP0v1F64fpjEhXK8l1PvQ86ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KoXKwJxVAPTKVsuMeHtxWVYQCMVj4hlmPH3aLV7qab+UzfaEbp5m16XTiHBSewTltLPFLNzbwmxXc6eU9fLCyrgLgv/4Wnj734sOgo05EUqVy5wsMbrC4j25OLtD+9Pi93Oo3MlY9Rl04oz96tbe9GUxF/S4Y7vHHAwhgCAOX8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vncpfNxl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vncpfNxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76845C4CED1;
	Thu, 13 Feb 2025 15:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460797;
	bh=XyySg7NfhdZMGmTmU4uP0v1F64fpjEhXK8l1PvQ86ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vncpfNxlfx09+2YdaeBOm30VkMjS7ong3fEK51jNDqUKOIUiW2GHIHuBAd3Fj58WY
	 knkttqW6x/wWMh1CfQeBeAmU0yoibBVk+cen1eIYuW2NFa49NoeENGIaOHQmy2M0Ry
	 ibu1w8J1nWR0k0veXUAQpF+xlu6rpVBhXmod7JXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.6 216/273] media: uvcvideo: Remove redundant NULL assignment
Date: Thu, 13 Feb 2025 15:29:48 +0100
Message-ID: <20250213142415.846814237@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1593,10 +1593,8 @@ bool uvc_ctrl_status_event_async(struct
 	struct uvc_device *dev = chain->dev;
 	struct uvc_ctrl_work *w = &dev->async_ctrl;
 
-	if (list_empty(&ctrl->info.mappings)) {
-		ctrl->handle = NULL;
+	if (list_empty(&ctrl->info.mappings))
 		return false;
-	}
 
 	w->data = data;
 	w->urb = urb;


