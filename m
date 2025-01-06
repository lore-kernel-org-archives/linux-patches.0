Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6C0157E82;
	Mon,  6 Jan 2025 15:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178010; cv=none; b=L6vC4MTFye1L2PDpr5xt72DwDRDWZwG6fQC9j2SwvsDZQPknmJSO5iFEs1MS8PO0viipGgobkJuZqh6hD+Nzwyc7UuVpM9k4ABRk9PVluMjCrC3MNnxtVzc79N2D6UDkbAqGqtoW/Cp1ph3A79lOIx9BV5okgub2/AoDK1O9suo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178010; c=relaxed/simple;
	bh=SwTW9BYDPMSacZtJVTNCWmJhT4mHBqUZjeAm/nfqiCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sl2li5d31avJLs6RCtZhsi2lp6IXPEnM/zho3rfDHVN5iVyiRwbci0nw2KZVoMwF+P8yD6d+1JgouLGgNB+ZGEee43j7SWfz+up1T6UYn6RRiZm3KcWVqcQbdE6N4MP/r5VMuGoavwIECbCOf/eghns8dQBuq2f4eKgSwxGOQ4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qh9ugpO/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qh9ugpO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC46AC4CED2;
	Mon,  6 Jan 2025 15:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178010;
	bh=SwTW9BYDPMSacZtJVTNCWmJhT4mHBqUZjeAm/nfqiCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qh9ugpO/j3XmCgiqo6FLV8z3Dxfze8ziFCvCd49qJpHDAd0GECX1fu8xzBReQBUOY
	 ZwCxyEa0TqPzoP7Fikw3wtGMz6vnTOsp5++pU6sOYbVIF8J9LaEHWXpI4h05CJsQ8w
	 5/XzwRmMEa5fSzi7eFhcnR50Jv7wDJf6kUkUY5sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hien Huynh <hien.huynh.px@renesas.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Adam Ford <aford173@gmail.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.12 132/156] drm: adv7511: Drop dsi single lane support
Date: Mon,  6 Jan 2025 16:16:58 +0100
Message-ID: <20250106151146.704017162@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -172,7 +172,7 @@ int adv7533_parse_dt(struct device_node
 
 	of_property_read_u32(np, "adi,dsi-lanes", &num_lanes);
 
-	if (num_lanes < 1 || num_lanes > 4)
+	if (num_lanes < 2 || num_lanes > 4)
 		return -EINVAL;
 
 	adv->num_dsi_lanes = num_lanes;


