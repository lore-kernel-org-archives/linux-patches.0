Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B589C2222B2;
	Mon, 23 Jun 2025 22:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717350; cv=none; b=QYGjorikhPHRj2oauu5lgwvs8osyGsgQp1wBuS/KEC1SK8OSurvaQ1LqR57T+sCwl/8uRhWolkXOpUrQ1ZqiV2IbwzryuVVUbe9gTO7uHkeDjm38+nYfvLJNAuZOg9pvQawrx7I0z/Xiw+Gdr5NQH9F0naue1oo/bJhb6MTZ72U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717350; c=relaxed/simple;
	bh=m54C/IO5by1M4vBNOb0jLH1Ndact6q94lVfRKouMSXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KG/pZBAKWAJzJpSc4qd6XC7lPVn8qW0BxgSp0TZGjJCRo0wkP5CBUSrqIcESnhcYTjcObzi+1xUeN8VrVdFQSOvKkuUxS17GrpI41c6YdS5U6sVEraW8kAhqsAQOSQvq2FWrM4wnwTD/rMWDpgx8q8xMqwiTTOgXPf9pM1u9POI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JT6PQSz5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JT6PQSz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDE4C4CEEA;
	Mon, 23 Jun 2025 22:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717350;
	bh=m54C/IO5by1M4vBNOb0jLH1Ndact6q94lVfRKouMSXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JT6PQSz5pG8a/Up9l7P0RF57q/wh+tw3OQ1gRyRhObRLWXG5MjXEiwhuzERvS/NVd
	 aVkbZr/9Sx0wD1Fe/UtKe8o9a9qoUzPuhnAy4IR4J4YDwRKw5cvnQGUUUjOfKZX2Qn
	 Gvm8374D9OrVOSQ4Gg991JZhnNksWCrjtzKeWWSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 357/414] drm/ssd130x: fix ssd132x_clear_screen() columns
Date: Mon, 23 Jun 2025 15:08:14 +0200
Message-ID: <20250623130650.892883331@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: John Keeping <jkeeping@inmusicbrands.com>

[ Upstream commit e479da4054875c4cc53a7fb956ebff03d2dac939 ]

The number of columns relates to the width, not the height.  Use the
correct variable.

Signed-off-by: John Keeping <jkeeping@inmusicbrands.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Fixes: fdd591e00a9c ("drm/ssd130x: Add support for the SSD132x OLED controller family")
Link: https://lore.kernel.org/r/20250611111307.1814876-1-jkeeping@inmusicbrands.com
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/solomon/ssd130x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/solomon/ssd130x.c b/drivers/gpu/drm/solomon/ssd130x.c
index 06f5057690bd8..e0fc12d514d76 100644
--- a/drivers/gpu/drm/solomon/ssd130x.c
+++ b/drivers/gpu/drm/solomon/ssd130x.c
@@ -974,7 +974,7 @@ static void ssd130x_clear_screen(struct ssd130x_device *ssd130x, u8 *data_array)
 
 static void ssd132x_clear_screen(struct ssd130x_device *ssd130x, u8 *data_array)
 {
-	unsigned int columns = DIV_ROUND_UP(ssd130x->height, SSD132X_SEGMENT_WIDTH);
+	unsigned int columns = DIV_ROUND_UP(ssd130x->width, SSD132X_SEGMENT_WIDTH);
 	unsigned int height = ssd130x->height;
 
 	memset(data_array, 0, columns * height);
-- 
2.39.5



