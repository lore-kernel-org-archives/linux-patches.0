Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46BF219303;
	Sat, 30 May 2026 18:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165510; cv=none; b=BuCG2blyiy6ZrkLjBk5ER0OIPt3q7ySbbJLzMa8P4nekTHMBcWY3duFBdfGG6Dw05Go7RT/PJH/6nrOQUcyqOywHyqblpEaq1yRLTIHjfTCZZ0BcLysp1KfdEnn9/czrDxJaO2mZP8uM3IKybU1Q7kTz6/aOrv8DLcUvYXZhEjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165510; c=relaxed/simple;
	bh=U9M10CgxLXFNQt8OwS3vEVXEao/rMSzLzSttFxkO0qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLfYIipwbE7qP4LBmOaQNROQntSLS8mWmlWdipvNt+5ZnKqk9YFhRTRntr0so9eJG3Z0zaNvZFOoqsR9nncqrupTTdoTqvs8vOe8FjeqT6b1esdiNqRiCauHsXTj4H5e4m8E/NDjwCX6BaD1Vy+Kaj2dK3kyKEJz3KK/ThM+7kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jicpeT/U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jicpeT/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5EB1F00893;
	Sat, 30 May 2026 18:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165509;
	bh=MvEuSA4/4UEYDYVDOXEPzvCKTPH4zOM7n+4zEu6yYKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jicpeT/U4D8cOJ9Zb3HcKQQhREj0yXI4D5TGHbB8aEX6mmrpQ0QpVQgN31Xlz/re/
	 YpWsCI1/xmgaIAkmLO2+ioXe5WsRQennsOUtx48l+f9x29uZ/YvbN5kV8oyQGyEUx0
	 OW6+WrrKiHczUq61f54HTFjL2ure/uvbDdoQ5skA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/589] media: uvcvideo: Allow extra entities
Date: Sat, 30 May 2026 17:59:11 +0200
Message-ID: <20260530160226.441673934@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit cae79e50d1222010fde8c522410c315f74d35c40 ]

Increase the size of the id, to avoid collisions with entities
implemented by the driver that are not part of the UVC device.

Entities exposed by the UVC device use IDs 0-255, extra entities
implemented by the driver (such as the GPIO entity) use IDs 256 and
up.

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 2 +-
 drivers/media/usb/uvc/uvcvideo.h   | 7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 419fbdbb7a3b8..c2adc6854c540 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1032,7 +1032,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 	return ret;
 }
 
-static struct uvc_entity *uvc_alloc_entity(u16 type, u8 id,
+static struct uvc_entity *uvc_alloc_entity(u16 type, u16 id,
 		unsigned int num_pads, unsigned int extra_size)
 {
 	struct uvc_entity *entity;
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 60a8749c97a9d..a83995276170b 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -302,7 +302,12 @@ struct uvc_entity {
 					 * chain. */
 	unsigned int flags;
 
-	u8 id;
+	/*
+	 * Entities exposed by the UVC device use IDs 0-255, extra entities
+	 * implemented by the driver (such as the GPIO entity) use IDs 256 and
+	 * up.
+	 */
+	u16 id;
 	u16 type;
 	char name[64];
 
-- 
2.53.0



