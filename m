Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FE0233724;
	Mon, 10 Mar 2025 17:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629493; cv=none; b=gfxmj4ahVT1kY9e963iJCFuu1kJMwAFV81kASZMw7plkwl3ndcztbCHHJUnv/ENkwdNnTaUULcszp9GbqhECafiiW1tM5AA7IDxedMDUjLF0Bgn3p9td8l7wR4b6jGGggVizuk4kk6gCMkKGcG83cXxpjOWp95ifB7UN0xDBhoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629493; c=relaxed/simple;
	bh=fvzXiyiOIY3MHPrjmCfPjXEQMH4uAQ3BneyuClQoko8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwsoWZl8DPbJ+PmnPPYaykFvrQtFokp6RtM6HnBsXoLRoaZlvg23/wss1hmdPFkRqRy4MeXwUt63cNmP0icfhj5tDwOHC4aNLEI3NPGbO5WZPzxV9a9mUT0/qXdteeKUTAggRwQxbV1vSyCgjprkTZUJewN+GXBODtxO7E4Urqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZajyLSZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZajyLSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51BDC4CEE5;
	Mon, 10 Mar 2025 17:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629493;
	bh=fvzXiyiOIY3MHPrjmCfPjXEQMH4uAQ3BneyuClQoko8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZajyLSZVWOogfqAZeRRbNra65xgBhMbAw71PT8goPDeJGkWO0pPxD1lL2cAKuP+1
	 kmBEb61k+xYjt41ayU9XFsr8TQB8GF0y3Zw/8ZlePEmR7f0nORT7GoGzxNat6+TN4P
	 aOz1PC2IwxzVuUCusSoH7k90yyEQOsKgYnaicKGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 312/620] media: uvcvideo: Remove redundant NULL assignment
Date: Mon, 10 Mar 2025 18:02:38 +0100
Message-ID: <20250310170557.932892703@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1478,10 +1478,8 @@ bool uvc_ctrl_status_event_async(struct
 	struct uvc_device *dev = chain->dev;
 	struct uvc_ctrl_work *w = &dev->async_ctrl;
 
-	if (list_empty(&ctrl->info.mappings)) {
-		ctrl->handle = NULL;
+	if (list_empty(&ctrl->info.mappings))
 		return false;
-	}
 
 	w->data = data;
 	w->urb = urb;


