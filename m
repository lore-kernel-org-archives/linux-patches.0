Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8492D8494
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 12:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CFEC433EF;
	Thu,  5 Jan 2023 12:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672923543;
	bh=EGmdB4g2cEOZLiw58ca6TqDCNhi2sZ8EVu6/aQ25duU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rqOJcviFoaeraXdCfHHdSIesBmWBqhi3SpTiaAAGc3RcssDFkeaaoVJXrxRHwaoqx
	 vjuo3yKeRmKj02O0ecbXHUOO0csQ/5CAocD6cHU4+C/TPmLko8KrMLKi+e9j6Nf21X
	 fKiQj35GKSu6qrdToIqFdlsDTKQleKzLZ7AhiGl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 053/251] media: i2c: ad5820: Fix error path
Date: Thu,  5 Jan 2023 13:53:10 +0100
Message-Id: <20230105125337.218749403@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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
index beab2f381b81..84e378cbc726 100644
--- a/drivers/media/i2c/ad5820.c
+++ b/drivers/media/i2c/ad5820.c
@@ -320,18 +320,18 @@ static int ad5820_probe(struct i2c_client *client,
 
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



