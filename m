Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4395E144619;
	Tue, 23 Jan 2024 00:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969537; cv=none; b=M3cesS37jMCFeZ/C9gZz+26dS5/fn8mLPtYewwoblk4lSOGN9Xze2wqOT4C/Y+cxZVnrsU08ZuqucxuOgKSm/bqkWMIHROEZ/1ujWDnn604wCbh7F9ADWBM0IAt1f2aYuJ5lOSV3+0imp5lAvGeCSVO0WFT8V9dEvDpxWigHUr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969537; c=relaxed/simple;
	bh=WQcxf3E+PdErRYbEzj/6G8qQ537ZdjxzOB38OBdbDp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoTvdZOk7IBuocTAzoysJZQUPNITsx8+IRQbB1Vt/zPwk+yc5ShA6rKAd0YafJZIFEbLG3Z0HmAjKisLLcwYyaLhUTybvkumSkE9n63BhD0Cuuo7ge1YhoO1YRkg2nqLPNoagdLkQY3R+X+KuKcOmzVGXkgl2yA3sCKC0MzXTGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y3lARn6p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y3lARn6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A7DC43390;
	Tue, 23 Jan 2024 00:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969536;
	bh=WQcxf3E+PdErRYbEzj/6G8qQ537ZdjxzOB38OBdbDp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y3lARn6pS0nC7I5mBGdCfWHQeEDVSWk91aBbTuD/5YN1TvqxW2hBylP1SeTr22/lZ
	 WKucT0Y/qFo7/bMNp1swVisUn2QGOG7ca5VAqBpWZI8M7jnKXgS9/iGJ5/2c+Xn4x5
	 KhCKJQv9PVR/6/cVmHpUwvZgSLlalRtOY9aCOYgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommaso Merciai <tomm.merciai@gmail.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 311/641] media: rkisp1: Fix memory leaks in rkisp1_isp_unregister()
Date: Mon, 22 Jan 2024 15:53:35 -0800
Message-ID: <20240122235827.638086946@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 688f3af3c354adc19b78d352c8c7b2006f993f2d ]

Add missing call to v4l2_subdev_cleanup() to fix memory leak.

Link: https://lore.kernel.org/r/20231122-rkisp-fixes-v2-2-78bfb63cdcf8@ideasonboard.com

Fixes: 2cce0a369dbd ("media: rkisp1: isp: Use V4L2 subdev active state")
Reviewed-by: Tommaso Merciai <tomm.merciai@gmail.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rkisp1/rkisp1-isp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/rockchip/rkisp1/rkisp1-isp.c b/drivers/media/platform/rockchip/rkisp1/rkisp1-isp.c
index 88ca8b2283b7..45d1ab96fc6e 100644
--- a/drivers/media/platform/rockchip/rkisp1/rkisp1-isp.c
+++ b/drivers/media/platform/rockchip/rkisp1/rkisp1-isp.c
@@ -933,6 +933,7 @@ void rkisp1_isp_unregister(struct rkisp1_device *rkisp1)
 		return;
 
 	v4l2_device_unregister_subdev(&isp->sd);
+	v4l2_subdev_cleanup(&isp->sd);
 	media_entity_cleanup(&isp->sd.entity);
 }
 
-- 
2.43.0



