Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CA6DF71;
	Mon,  6 Jan 2025 15:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177575; cv=none; b=Fg1bqvrkeGLoTrLx4z39hkpWVsbJo9dDoNNatD2oXwZbhKzhd70SRcfdxdMlltGbznDR7ky8j6EMMVJEZXFPRsxep24BU7N3P6kF4+a6x5WpjW7+MxBaqdqhfn16TAW0yfr2jZg607STN7gEcYHLPMoN9CIkvjZp+Q2I28VBHck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177575; c=relaxed/simple;
	bh=VLeKeYUiuMVW7bzfJGKDj5tqGE8QYVXbxlUiIXvoa4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSZm42z1O223jntCn1NeyUvuMOcvdamHD7qgXpWiBMptfaF9ZfPOO1SeV6p7zS9Rl94kDnx+wj3TMZdDAuGMwGfSZy4d4/aBZYcbNPj048zeX/zAZWtu6rTaaJg77n2321pn5zv9WYuGdRsQ+4Q+CSSGSH8LA1PUzfKx992rHEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WRTJOj+i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WRTJOj+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01093C4CED2;
	Mon,  6 Jan 2025 15:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177575;
	bh=VLeKeYUiuMVW7bzfJGKDj5tqGE8QYVXbxlUiIXvoa4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WRTJOj+ii0CeAwIykx1w1pnaI5zHnM1C/Bv7+/nO+l9tIMI1/CHEs7pDLpVP/45BM
	 oze6rPUv1D2mBKRwhV+yElggUGAHIkOI5R+Pi7de6/OAp8PZmPoYMeXzOjgwp2/W6H
	 U1fZZmwPvzFmgpCFBuAh9mTOMl+hgyK0l+Mktc0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hien Huynh <hien.huynh.px@renesas.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Adam Ford <aford173@gmail.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.6 209/222] drm: adv7511: Drop dsi single lane support
Date: Mon,  6 Jan 2025 16:16:53 +0100
Message-ID: <20250106151158.676143713@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

commit 79d67c499c3f886202a40c5cb27e747e4fa4d738 upstream.

As per [1] and [2], ADV7535/7533 supports only 2-, 3-, or 4-lane. Drop
unsupported 1-lane.

[1] https://www.analog.com/media/en/technical-documentation/data-sheets/ADV7535.pdf
[2] https://www.analog.com/media/en/technical-documentation/data-sheets/ADV7533.pdf

Fixes: 1e4d58cd7f88 ("drm/bridge: adv7533: Create a MIPI DSI device")
Reported-by: Hien Huynh <hien.huynh.px@renesas.com>
Cc: stable@vger.kernel.org
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241119192040.152657-4-biju.das.jz@bp.renesas.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7533.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/bridge/adv7511/adv7533.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7533.c
@@ -175,7 +175,7 @@ int adv7533_parse_dt(struct device_node
 
 	of_property_read_u32(np, "adi,dsi-lanes", &num_lanes);
 
-	if (num_lanes < 1 || num_lanes > 4)
+	if (num_lanes < 2 || num_lanes > 4)
 		return -EINVAL;
 
 	adv->num_dsi_lanes = num_lanes;


