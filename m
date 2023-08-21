Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150CE1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:09:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B8CC433C9;
	Mon, 21 Aug 2023 20:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648544;
	bh=3Kd24lTvXcNQq6I8eFfN8B3jBvCJApVg1Qrw2F8/VPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PlOOY1MTYQBjZg6DQexvPzQUVXMQ+4sG8SK4cAWVfS9r1A3gSD1G6xl4aSY2ys5Ue
	 3YrYRSd0HID+vBZPlT7SQz6PZ10Lf+RDsQ555AzaXb/ErE1/3e6Yg7XSf0PdBEP0Bi
	 TUgvnxHOoMP2RflE7q6aInjpj1Ga1y5LSduP2Toc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Poncho <poncho@spahan.ch>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 6.4 213/234] media: uvcvideo: Fix menu count handling for userspace XU mappings
Date: Mon, 21 Aug 2023 21:42:56 +0200
Message-ID: <20230821194138.284912090@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit 6d00f4ec1205a01a6aac1fe3ce04d53a6b2ede59 upstream.

When commit 716c330433e3 ("media: uvcvideo: Use standard names for
menus") reworked the handling of menu controls, it inadvertently
replaced a GENMASK(n - 1, 0) with a BIT_MASK(n). The latter isn't
equivalent to the former, which broke adding XU mappings from userspace.
Fix it.

Link: https://lore.kernel.org/linux-media/468a36ec-c3ac-cb47-e12f-5906239ae3cd@spahan.ch/

Cc: stable@vger.kernel.org
Reported-by: Poncho <poncho@spahan.ch>
Fixes: 716c330433e3 ("media: uvcvideo: Use standard names for menus")
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_v4l2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 5ac2a424b13d..f4988f03640a 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -45,7 +45,7 @@ static int uvc_control_add_xu_mapping(struct uvc_video_chain *chain,
 	map->menu_names = NULL;
 	map->menu_mapping = NULL;
 
-	map->menu_mask = BIT_MASK(xmap->menu_count);
+	map->menu_mask = GENMASK(xmap->menu_count - 1, 0);
 
 	size = xmap->menu_count * sizeof(*map->menu_mapping);
 	map->menu_mapping = kzalloc(size, GFP_KERNEL);
-- 
2.41.0



