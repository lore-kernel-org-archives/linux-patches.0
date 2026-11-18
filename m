Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057250;
	b=Odaur38S6cnM89cBMF0nvhvIudnbO1otNWcqDP3lfDOX0Y4usMUjJ9Ih6Z0v+db370q7
	 QmTfYbID/hxlZpXWx2X7oN8T+9PvdUrIVZPWXd64pqUMEVDOeYcRgmDH/0yRFF+Q3QDfK
	 JacxLY6e39om23dFfj1US0k9XaFer+Yc/eDAqLAGo6UmtZdXrs/HKfFDpikWrMYe2/3Ah
	 JAB9ku4aMlOTKB+u7S+yjzZUGMYHHI1YExwvExpVj8XFIYQu4VBlYghsynQNfGZdEWCHR
	 YzJVNy85rWgpZp8nBbzaEpu+Vtsf30ZbetEeyLzOYkz5T+XYrfgOkDdz6kpj9iV1Ktw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hCTkdH9rqGwvaP3Xx3pndGI5ofywFebkja2BNqI/btQ=;
	b=3lcQWS77/2xYmv4DF4vc6HRJKl+erK0nYoSSbfJ+cGeileLPW194bPb2jd02gEV6pun8
	 HImF84RDzdFJDsdzg2i+IoP7A7lbxRB1SVrEITcje7ISsJ1AFfN1fb8FV1mvEZ0wCwlBm
	 6U7k5hJPDVSyOYNP+7kNe1XXxZOV3742qyfeKO+Vqlh/WD3fCJaI164uEKw+C6vOlo31s
	 y527d2uVFAslZCSmYCHUCbFFV3U1KBemHmj0Oo1hP4zfc3/4CLgAkk2gNcMzUGP64r+tq
	 LfBhiIf0hM89Ut1pArGLs0d5dEUK1UPJ3a+cosy/RUT9muIPVejZuPeJjhfbrbpuByg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mwcNaBOT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B1A60A2609;
	Thu, 19 Nov 2026 03:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mwcNaBOT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260531F000C5;
	Thu, 19 Nov 2026 03:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057250;
	bh=hCTkdH9rqGwvaP3Xx3pndGI5ofywFebkja2BNqI/btQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mwcNaBOTyZ+eB2ZlxD1k3cUC165nEmX4cINrAMyzi9wQrVeSVguroK/KtEDGjRxtS
	 gbDLwiHSj8f/8nE17J3Wzj9KANFqF8YFIW+vxHLqZEmvfVIsqxN/0DwQdfJ/SYtZ6i
	 gp57MLz5Wjul50QtPRDBOOeTi21rZdll4vWSEZP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0065/1848] media: em28xx: use vb2_video_unregister_device
Date: Wed, 18 Nov 2026 15:35:03 +0100
Message-ID: <20261118145913.871328626@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil+cisco@kernel.org>

[ Upstream commit 7c8bf63b79371f5b57da1bd1401bd420180ac6e6 ]

Use vb2_video_unregister_device instead of video_unregister_device
to ensure any streaming is correctly stopped at unregister time.

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Tested-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-video.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 15f90c25fab2b..a2cdde3bfe900 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2253,17 +2253,17 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 	if (video_is_registered(&v4l2->radio_dev)) {
 		dev_info(&dev->intf->dev, "V4L2 device %s deregistered\n",
 			 video_device_node_name(&v4l2->radio_dev));
-		video_unregister_device(&v4l2->radio_dev);
+		vb2_video_unregister_device(&v4l2->radio_dev);
 	}
 	if (video_is_registered(&v4l2->vbi_dev)) {
 		dev_info(&dev->intf->dev, "V4L2 device %s deregistered\n",
 			 video_device_node_name(&v4l2->vbi_dev));
-		video_unregister_device(&v4l2->vbi_dev);
+		vb2_video_unregister_device(&v4l2->vbi_dev);
 	}
 	if (video_is_registered(&v4l2->vdev)) {
 		dev_info(&dev->intf->dev, "V4L2 device %s deregistered\n",
 			 video_device_node_name(&v4l2->vdev));
-		video_unregister_device(&v4l2->vdev);
+		vb2_video_unregister_device(&v4l2->vdev);
 	}
 
 	v4l2_ctrl_handler_free(&v4l2->ctrl_handler);
@@ -2911,19 +2911,19 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		dev_info(&dev->intf->dev,
 			 "V4L2 device %s deregistered\n",
 			 video_device_node_name(&v4l2->radio_dev));
-		video_unregister_device(&v4l2->radio_dev);
+		vb2_video_unregister_device(&v4l2->radio_dev);
 	}
 	if (video_is_registered(&v4l2->vbi_dev)) {
 		dev_info(&dev->intf->dev,
 			 "V4L2 device %s deregistered\n",
 			 video_device_node_name(&v4l2->vbi_dev));
-		video_unregister_device(&v4l2->vbi_dev);
+		vb2_video_unregister_device(&v4l2->vbi_dev);
 	}
 	if (video_is_registered(&v4l2->vdev)) {
 		dev_info(&dev->intf->dev,
 			 "V4L2 device %s deregistered\n",
 			 video_device_node_name(&v4l2->vdev));
-		video_unregister_device(&v4l2->vdev);
+		vb2_video_unregister_device(&v4l2->vdev);
 	}
 
 	v4l2_ctrl_handler_free(&v4l2->ctrl_handler);
-- 
2.53.0



