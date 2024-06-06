Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4E019753E;
	Thu,  6 Jun 2024 14:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682978; cv=none; b=JzqmUfURU5jYZLidZMOqRp58lI4oXoSxHxFtXTIcdosKgDm0pwJEBKcQ+LO2Z6BkFZcJow0WzKaVzwxvBqSWna2sw6AuztCy4IA047DDn3LFIFulSCs4PPmxnGWR4lbOO4nTj1N1JRnP++1tq1iXR+KtRvtw0pfN9d6CkTixnLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682978; c=relaxed/simple;
	bh=Jk/pjefwXmnQ/sdbHcEbcpSPoJqY1ME1oUr0psUc7xM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+OPuNMzud6MIu5HBQcOH0V1M5zvXGZnZh2xvUEuQzL3X9SkWZuC3SFR6Sg4AyBiJks5wVuj0mSZ/nvd00XF88lzd9l0dsW6eb/cBS+7x853Z3S/rXHYUkaEhXTrI5yKMY03QOZqfTdDQT0aMi+3G1HpCaN+32fKlpMsXcncB18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lnIiHlYg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lnIiHlYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DEC4C2BD10;
	Thu,  6 Jun 2024 14:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682978;
	bh=Jk/pjefwXmnQ/sdbHcEbcpSPoJqY1ME1oUr0psUc7xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lnIiHlYgHGRkoT/pifxPHWPa3nhQid+B9dJuwoRI/Bp3lbHLV7Smkx6l1d6BY6Z7G
	 KdXS9O10y2PEneaB1R/Mo+9FAte0BZW4j7p3veAp/RsNS0e0aW1YK5XHGzJ36lk2EH
	 OBhbGhpUV3iPcUq8VOdk/Ey+1ledt6ig1Jc6hqEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Umang Jain <umang.jain@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 158/374] media: v4l: Dont turn on privacy LED if streamon fails
Date: Thu,  6 Jun 2024 16:02:17 +0200
Message-ID: <20240606131657.206455254@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit f2bf6cd8f44781349620e30a0af8987fe9af008f ]

Turn on the privacy LED only if streamon succeeds. This can be done after
enabling streaming on the sensor.

Fixes: b6e10ff6c23d ("media: v4l2-core: Make the v4l2-core code enable/disable the privacy LED if present")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Reviewed-by: Umang Jain <umang.jain@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 45836f0a2b0a7..19d20871afefa 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -412,15 +412,6 @@ static int call_s_stream(struct v4l2_subdev *sd, int enable)
 	if (WARN_ON(!!sd->enabled_streams == !!enable))
 		return 0;
 
-#if IS_REACHABLE(CONFIG_LEDS_CLASS)
-	if (!IS_ERR_OR_NULL(sd->privacy_led)) {
-		if (enable)
-			led_set_brightness(sd->privacy_led,
-					   sd->privacy_led->max_brightness);
-		else
-			led_set_brightness(sd->privacy_led, 0);
-	}
-#endif
 	ret = sd->ops->video->s_stream(sd, enable);
 
 	if (!enable && ret < 0) {
@@ -428,9 +419,20 @@ static int call_s_stream(struct v4l2_subdev *sd, int enable)
 		ret = 0;
 	}
 
-	if (!ret)
+	if (!ret) {
 		sd->enabled_streams = enable ? BIT(0) : 0;
 
+#if IS_REACHABLE(CONFIG_LEDS_CLASS)
+		if (!IS_ERR_OR_NULL(sd->privacy_led)) {
+			if (enable)
+				led_set_brightness(sd->privacy_led,
+						   sd->privacy_led->max_brightness);
+			else
+				led_set_brightness(sd->privacy_led, 0);
+		}
+#endif
+	}
+
 	return ret;
 }
 
-- 
2.43.0



