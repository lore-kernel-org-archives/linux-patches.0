Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597C317730
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:05:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B052DC4339B;
	Mon, 15 May 2023 18:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173934;
	bh=B7tV84oscsb2bWeMieYBYBgMZVw1d95Rty4xFOFqe2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=luzfl0hUdqITZxQAwZGMQEEi/eFJHVAlEqn699b4ESnWFqbQfr4xRGcO2tqEU3ydI
	 b1jz+xoYJMNW/3oKso7UZrHsM6F2gQB9f/ocgVui9A1PsGv0Jh7bbwBzjemo5In0MB
	 Vl4c27+MlbIh/+UU1ZaNXXUQgiqQuTtvkynhVvkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Cowgill <james.cowgill@blaize.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 5.4 253/282] drm/panel: otm8009a: Set backlight parent to panel device
Date: Mon, 15 May 2023 18:30:31 +0200
Message-Id: <20230515161729.867725600@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: James Cowgill <james.cowgill@blaize.com>

commit ab4f869fba6119997f7630d600049762a2b014fa upstream.

This is the logical place to put the backlight device, and it also
fixes a kernel crash if the MIPI host is removed. Previously the
backlight device would be unregistered twice when this happened - once
as a child of the MIPI host through `mipi_dsi_host_unregister`, and
once when the panel device is destroyed.

Fixes: 12a6cbd4f3f1 ("drm/panel: otm8009a: Use new backlight API")
Signed-off-by: James Cowgill <james.cowgill@blaize.com>
Cc: stable@vger.kernel.org
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230412173450.199592-1-james.cowgill@blaize.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panel/panel-orisetech-otm8009a.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/panel/panel-orisetech-otm8009a.c
+++ b/drivers/gpu/drm/panel/panel-orisetech-otm8009a.c
@@ -460,7 +460,7 @@ static int otm8009a_probe(struct mipi_ds
 	ctx->panel.funcs = &otm8009a_drm_funcs;
 
 	ctx->bl_dev = devm_backlight_device_register(dev, dev_name(dev),
-						     dsi->host->dev, ctx,
+						     dev, ctx,
 						     &otm8009a_backlight_ops,
 						     NULL);
 	if (IS_ERR(ctx->bl_dev)) {


