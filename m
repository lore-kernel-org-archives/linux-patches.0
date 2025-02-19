Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441D71E102E;
	Wed, 19 Feb 2025 09:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957124; cv=none; b=jKTg/Ck8kcW5ikPWz3AUQEecLrGIpxFIR27cUz979d5e7iorktBly15fnggvVKX9aCVoMkrXdp260A9Prqc0wLzsFoBpKrSmZqO4ihkWskSKbolUU3NRxkghbOon8v69KZHhbowOVP+b+AK9cJLR0I+Ez1WSCPPp4mxumwvugkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957124; c=relaxed/simple;
	bh=e53JNnSl41JNYrc2zMjIADYLsmlm8NzpcybzG6L0FQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e81MIvNWCN+EueaqKXzPNcsEskO7ridrZsGcdJBxQcVA5IOarxzbO8aeHTT9FeZel+a4S+emmPxdydkYr1MX021xAq10mBfBKYRfwd4/+sKuI61XXf4I5T1AxgBrAfedDg23oHNclOyAhY8aZUfPUFDM8al5RHos2JTzRq4uixU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQlF4Sw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQlF4Sw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4195CC4CED1;
	Wed, 19 Feb 2025 09:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957123;
	bh=e53JNnSl41JNYrc2zMjIADYLsmlm8NzpcybzG6L0FQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQlF4Sw1KP7lUnnxFdiA/Y53Dji3dFwNzuI4rEGj6+/bOvb7XwwFMDJtKLtkCkaIb
	 Xnxayc0FfiIR9c5Fb0o1AB8zgy8awgJuhKDELRR5fv8Fa5Galicwdb23zVJsEOf7cY
	 t/2ASBdzuZop8BqihbQrqSOqoU3SJRhq48NXc+tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.1 415/578] media: uvcvideo: Remove redundant NULL assignment
Date: Wed, 19 Feb 2025 09:26:59 +0100
Message-ID: <20250219082709.344403241@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1531,10 +1531,8 @@ bool uvc_ctrl_status_event_async(struct
 	struct uvc_device *dev = chain->dev;
 	struct uvc_ctrl_work *w = &dev->async_ctrl;
 
-	if (list_empty(&ctrl->info.mappings)) {
-		ctrl->handle = NULL;
+	if (list_empty(&ctrl->info.mappings))
 		return false;
-	}
 
 	w->data = data;
 	w->urb = urb;


