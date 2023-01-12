Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E16749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:04:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06D8C433F0;
	Thu, 12 Jan 2023 14:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532283;
	bh=BTAg/nCpFIffMDG03h+efaSYsv5OSaE6QIl5RxYs44Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qU7LktSe3GBy8vFKnpQRc/ljatzvqW7N/6qVzMfeBTclLK2GpRZN8nrL+SFAmt40r
	 2xS9AV0gsMV40wVbLOFdcZgvBqT8GUwPvtBGZhGo6mS003pnreo5hnWZwfYUaw9BCV
	 fvtpgWLN2F0gUOoqijeivr79Fubs7OBAIsmLutBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/783] media: i2c: ad5820: Fix error path
Date: Thu, 12 Jan 2023 14:47:07 +0100
Message-Id: <20230112135529.350626930@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 9fce241660f37d9e95e93c0ae6fba8cfefa5797b ]

Error path seems to be swaped. Fix the order and provide some meaningful
names.

Fixes: bee3d5115611 ("[media] ad5820: Add driver for auto-focus coil")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ad5820.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
index 19c74db0649f..f55322eebf6d 100644
--- a/drivers/media/i2c/ad5820.c
+++ b/drivers/media/i2c/ad5820.c
@@ -329,18 +329,18 @@ static int ad5820_probe(struct i2c_client *client,
 
 	ret = media_entity_pads_init(&coil->subdev.entity, 0, NULL);
 	if (ret < 0)
-		goto cleanup2;
+		goto clean_mutex;
 
 	ret = v4l2_async_register_subdev(&coil->subdev);
 	if (ret < 0)
-		goto cleanup;
+		goto clean_entity;
 
 	return ret;
 
-cleanup2:
-	mutex_destroy(&coil->power_lock);
-cleanup:
+clean_entity:
 	media_entity_cleanup(&coil->subdev.entity);
+clean_mutex:
+	mutex_destroy(&coil->power_lock);
 	return ret;
 }
 
-- 
2.35.1



