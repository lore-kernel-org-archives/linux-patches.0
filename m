Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D069E32B116;
	Thu, 30 Jul 2026 15:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424444; cv=none; b=qYO3Ice4jUo89OYTtfCQ3bYvLx7EWDVDSkif1mZiatGAXH2gKwIdax7zDft84fX9tP0Bul4gBQGkzbjyT1DLpQOFFV+cs1FSP8bsPINGn5SGNAjYBjVIASYCrTyS+Xc6LfpUR8EQxmSG2SoZ83I6ClEV3EXsi1RT8CbNRniWhz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424444; c=relaxed/simple;
	bh=JJsSKrSrJHl5ivmU3ujDgKCnG0ch1SrR+1bQIpPiBkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1axMMLO41GsbKqfxhwzYrG2scoeLMTkj/3pMLxoW2FKAsFuOjV/KyiJwNxyvvv+BwxEFzjxQp8t8b8plfDqGBQ+GxMy3nbk32XCzBGGCxrzW8DMStP4WHGjq2Gii1YCH4zIFA8M8t9fGVX/MrrylQglegY7rFcegEFURjJElMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hl+iDUih; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hl+iDUih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624B81F000E9;
	Thu, 30 Jul 2026 15:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424443;
	bh=crmYUkUYTE58MXfNfnANOJnli8oUjIOnHhvULmSi6vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hl+iDUihGPn3Y1vpsY1ODXn2l+REbQ8Hsxq9PNaC1lOgRyuM/QOJ+xeBrNgjpxxDc
	 dimc5KT8yQN6Rotd+UHkMurVXXIPFGLQ173z2jRsYnG1/mXCRNC/x3IVp2dPzLM9eg
	 HSNYh2Z8RIfOHoXmFf+RKOxihzbMbpHMd2Au4RxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Keke Li <keke.li@amlogic.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 395/675] media: amlogic-c3: Add validations for ae and awb config
Date: Thu, 30 Jul 2026 16:12:05 +0200
Message-ID: <20260730141453.528514805@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

commit 9724164f71974a2a44a5e026614fbcc05bab6d91 upstream.

Avoid invalid memory access if the zones_num is bigger than
zone_weight.

This patch fixes the following smatch errors:
drivers/media/platform/amlogic/c3/isp/c3-isp-params.c:111 c3_isp_params_awb_wt() error: buffer overflow 'cfg->zone_weight' 768 <= u32max
drivers/media/platform/amlogic/c3/isp/c3-isp-params.c:111 c3_isp_params_awb_wt() error: buffer overflow 'cfg->zone_weight' 768 <= u32max
drivers/media/platform/amlogic/c3/isp/c3-isp-params.c:227 c3_isp_params_ae_wt() error: buffer overflow 'cfg->zone_weight' 255 <= u32max
drivers/media/platform/amlogic/c3/isp/c3-isp-params.c:227 c3_isp_params_ae_wt() error: buffer overflow 'cfg->zone_weight' 255 <= u32max

Cc: stable@vger.kernel.org
Fixes: fb2e135208f3 ("media: platform: Add C3 ISP driver")
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Keke Li <keke.li@amlogic.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/amlogic/c3/isp/c3-isp-params.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/media/platform/amlogic/c3/isp/c3-isp-params.c
+++ b/drivers/media/platform/amlogic/c3/isp/c3-isp-params.c
@@ -107,6 +107,8 @@ static void c3_isp_params_awb_wt(struct
 	c3_isp_write(isp, ISP_AWB_BLK_WT_ADDR, 0);
 
 	zones_num = cfg->horiz_zones_num * cfg->vert_zones_num;
+	if (zones_num > C3_ISP_AWB_MAX_ZONES)
+		zones_num = C3_ISP_AWB_MAX_ZONES;
 
 	/* Need to write 8 weights at once */
 	for (i = 0; i < zones_num / 8; i++) {
@@ -223,6 +225,8 @@ static void c3_isp_params_ae_wt(struct c
 	c3_isp_write(isp, ISP_AE_BLK_WT_ADDR, 0);
 
 	zones_num = cfg->horiz_zones_num * cfg->vert_zones_num;
+	if (zones_num > C3_ISP_AE_MAX_ZONES)
+		zones_num = C3_ISP_AE_MAX_ZONES;
 
 	/* Need to write 8 weights at once */
 	for (i = 0; i < zones_num / 8; i++) {


