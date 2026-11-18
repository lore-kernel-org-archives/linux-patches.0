Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043078;
	b=rtfARQ4oS6xV+RW/D3fZV/dGPrae88fMGrEEqeZutiZvM2BscsB4qieAEQ7XsRZlnvRT
	 MQO6kh3NHIZA5ejVL7TQ7quEH5zxp5STbOfx0MkCVcH+hePAj7vtPRybkC6w4IG8seAwK
	 qDBn0oHc3vaYYQZzdZNL0AHzLfrV7MrdaQb2oFaEiMNVesrTDpMOq13i3wnuPCwH9Uqv3
	 l5Y98qbBma3KhyuS+GE4zkTvh4nlviVEFM9u/PMrlNx2Dj+21uyFhyC/r6Ww3I3Ff3wNn
	 iPuhRd+ZW96WJPSV+obczTZsaxyHZP/E9JamDZu7czOWWNPxGDKvpL8SLsqK64nnyLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043078;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0fOKfym/DS77LoJnOFnFw/vjOTh6tF4/dY9vp1ia4d4=;
	b=igetcsBxvCSL/re9vVFImgjhpcna83TtLvV/l8/v0sNQNiwvS8o03qYaeiBNhok331xd
	 bSlAVrKTmOBDlgLQh9fIAR4JVlAFum9Y4va3zJGPhVk16/V48PRYe6Y8MuBfrQ+bq9GF8
	 HfFGDQ9K0LBvo1LhyqJhkZi/l96WGks/38me+hdImnW1/psHAWc0bubmgr2ZepQFsb/cb
	 5qQrwucrLP2H9tZ/7+CUhIiRQT7dR04nFMpVYqxqd3ZgHJ5cqG3y87WCGzWmI1TH9ktmH
	 gzXRFnw5bzy1bstHNUFKGBxy8ZBZNbNA+LtpFqelEAhnEfRB1UJkL2nEp38qo1efEDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UZCiwnq2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DBB606A320;
	Wed, 18 Nov 2026 23:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UZCiwnq2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73EBF1F000C4;
	Wed, 18 Nov 2026 23:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043078;
	bh=0fOKfym/DS77LoJnOFnFw/vjOTh6tF4/dY9vp1ia4d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UZCiwnq2Tl17LSnE57JoaOIq24K2wi6nm26BMjW/ZPVW2Nn1LyNKokIa22UFMIK/Y
	 H6KK+ijIAKoOXu03nyba7tTxGZv134snRaPc5r4UyWcfJ8PHpNgKATlN1pHmlgeeZF
	 z8MQZywdMwFPqk0oYrkLfIv3aJp9zaSJuOx+q1So=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0082/2857] media: em28xx: use vb2_video_unregister_device
Date: Wed, 18 Nov 2026 15:18:36 +0100
Message-ID: <20261118150204.241130683@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6ac9ad5aa25f6..acc2fbadc609c 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2243,17 +2243,17 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
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
@@ -2901,19 +2901,19 @@ static int em28xx_v4l2_init(struct em28xx *dev)
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



