Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E6186332;
	Mon,  6 Jan 2025 15:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179016; cv=none; b=d91ChmgeGBjBPAPYEHwMtbLDjKJmPAfQ6l+y45SVLjOJrarRYfEKZemKfInZ4MRsT32Vj8VlIW03RKWnXYgQmd/BWi/VNCZhoxuRBmymkJl7h2rrrpq0eVNdCg8S/0yHJqXSlbIrjJ887n/hKAf+B9sxda21U3+SfjGh9/rVnl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179016; c=relaxed/simple;
	bh=a25PYmCIzROFAoi28Yza/me38NTqk8jlDit9tWvR6vA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KwOB2RXK4G0peKiJJF3ZkHWyZv7XyozH7WrRV+HpRV4+KteOEUMAyoY7Mz+qdJV3TqO+Cy4p4tDeSR+KYjaXPOjqxrtY2QQPw28p4S+CZ7Vq5isC0UwKFcuYDplhaCZmkvkXMwTKY1QKQ8d2wqtoGXNnkOZnKzedhbpDyeqDp4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zX6bNwks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zX6bNwks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F897C4CED2;
	Mon,  6 Jan 2025 15:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179015;
	bh=a25PYmCIzROFAoi28Yza/me38NTqk8jlDit9tWvR6vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zX6bNwksUEUDmvc8cWah52qwZD0JGOvi2XEEeGlJfWlPM81zOV27eCFoiO7AWdbnR
	 HOgg88/2oVhabYWTzkC1rvsiW18XmPrL2AHFFz8QANub3IQPKJjGy0balTENlqP5SK
	 dbczMfbavm4IIZeXW5iYBl4FmFXxZrt+98twRWwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hien Huynh <hien.huynh.px@renesas.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Adam Ford <aford173@gmail.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 5.15 166/168] drm: adv7511: Drop dsi single lane support
Date: Mon,  6 Jan 2025 16:17:54 +0100
Message-ID: <20250106151144.696927503@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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
@@ -191,7 +191,7 @@ int adv7533_parse_dt(struct device_node
 
 	of_property_read_u32(np, "adi,dsi-lanes", &num_lanes);
 
-	if (num_lanes < 1 || num_lanes > 4)
+	if (num_lanes < 2 || num_lanes > 4)
 		return -EINVAL;
 
 	adv->num_dsi_lanes = num_lanes;


