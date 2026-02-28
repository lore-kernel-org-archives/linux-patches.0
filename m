Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5572328B71;
	Sat, 28 Feb 2026 17:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301339; cv=none; b=NtGZ7/qCv7fIZuX6dhfGx20J1sDjyfOzHfO5n7RDd6kgCFF37dK2togKyv2pmQKCW1iCABw22I6zDZ7QxWdySGkpm2XNc2wztxgHNu6fEK3niIR9eZ50miKX6LLz2wW2Xm3cY2L8NjpewpBkb9+UDJPzaYgrvQ8mcHt3gEUH/cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301339; c=relaxed/simple;
	bh=CwyC21AyPKHvJlpZKOz1p2h18WZw4vJoC4Wy5bvfxR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L03siaFAYC8OaWi3QQjsyl4hroOGkaxhsIcu+LE4QnfXtTg0W5HecgrAzIBXf5500ybDNbFaMQen7oSEtF3Nb4MlaqERmSQZGv5Q6cqxszfWGeMEjKqlMzx5t06XEDI/s3MJnGnRAnypwnl+2IzzX8Wt/5CH9tDh1MYBTxOF9us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lee4BUdH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lee4BUdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A9AC19423;
	Sat, 28 Feb 2026 17:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301339;
	bh=CwyC21AyPKHvJlpZKOz1p2h18WZw4vJoC4Wy5bvfxR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lee4BUdHlqvQNnxpYHVs9GTzDQ2EcPnOpwc7LXGwU9wh9+BnDF6vWp3/NJ7KuIGP9
	 +X3XMy5juJJFYtfTP1IGb9W5KWE+XNhZMncLG56wNCe7Nvb4NYxPZ1I7oSFQ53H7L+
	 an7LDcjx6JNJKIJUWz1SCcM8q38ixr/mTMtPgY4k2/+Xop8IhNFzKmaAlsLITCjMNk
	 O5EshlsYVVyMhRJfrrjta84oxCtRWPTK0JNinzGDflAqXWqHeEl8Aqz1cqGqg0OSfa
	 KVXdDDbV85zG3OrjJ9V6uYFLc0AUDrrcobYJ2fmubXZv/1EV8vxFiQpGKreCF7QHXA
	 sR6T3GPPdX5cg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: David Plowman <david.plowman@raspberrypi.com>,
	stable@vger.kernel.org,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 526/752] media: i2c: ov5647: Correct minimum VBLANK value
Date: Sat, 28 Feb 2026 12:43:57 -0500
Message-ID: <20260228174750.1542406-526-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: David Plowman <david.plowman@raspberrypi.com>

[ Upstream commit 1438248c5a82c86b4e1f0311c3bb827af747a8cf ]

Trial and error reveals that the minimum vblank value appears to be 24
(the OV5647 data sheet does not give any clues). This fixes streaming
lock-ups in full resolution mode.

Fixes: 2512c06441e3 ("media: ov5647: Support V4L2_CID_VBLANK control")
Cc: stable@vger.kernel.org
Signed-off-by: David Plowman <david.plowman@raspberrypi.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5647.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5647.c b/drivers/media/i2c/ov5647.c
index d9e300406f58e..191954497e3db 100644
--- a/drivers/media/i2c/ov5647.c
+++ b/drivers/media/i2c/ov5647.c
@@ -73,7 +73,7 @@
 #define OV5647_PIXEL_ARRAY_WIDTH	2592U
 #define OV5647_PIXEL_ARRAY_HEIGHT	1944U
 
-#define OV5647_VBLANK_MIN		4
+#define OV5647_VBLANK_MIN		24
 #define OV5647_VTS_MAX			32767
 
 #define OV5647_EXPOSURE_MIN		4
-- 
2.51.0

