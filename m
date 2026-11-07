Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064329;
	b=Ng3HudChqwvOsAtABIM5I7AP9+1WllQ2ZGGK/QKvwrh0jml8C8oivgJ7gF+XaUVX8xkj
	 FPHO3AqlI2f43dGY9OXs4FnHSS8VVBQEx24cJTLjDQVVJv8fOYdjET6EQS4XvMDvh0JrO
	 ZSMYNVa+ThU/JWeoigEGgSHZEVsfS/3s/NuJKrOLk0hzEYE7WtFQQxSFtTwlduRO6Ald7
	 ImacVukg/WfGnAf0lxBu3CWhzOoua73NkCynZTHolhyYvmznxNmNEfBpPyFBi/LWDSVe4
	 5w/gAv6mzZ7yuOc5R030HFYSaC3eIkGTqHTtbGkOd2/5VBLEHw6pjI7KqjBnwMwppUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=12iOKMwQWpI4XjnxgqqhwuXvdFGbiCyYFrwUsIOv0AI=;
	b=ftm7mIIXpFq0OvFOPkm99ckGpywVRPrZtnkQKfn6lJ3+KA/bkf+H17TXnoPFd47YyO/r
	 H+zu1GPG0bRLuAI9UVnks2ARk35lRelx0t3hxKn49nZFTTDzLs01oG+mOXXU2WP+qo8YM
	 81GiYIZLgCCCDW11iWqIG//lF7RlIM2X4mnRGYxk/Dz94GIi43OKVzlot9Ju74qQunFy1
	 xHuGkWiGULLjxzLsKT7okdZPOMh97IyM7QBvltMyesuZtJR+alcSqcdFNCc8ZM2ECahRD
	 JZaAdAjXsb9xhL0UE74KBjJx+AspH53OaKpdhku/aqhHPgDTDzWwnionlHYRXEee/KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oEycfLJe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1537D606A336;
	Sat,  7 Nov 2026 15:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oEycfLJe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C6F1F0089F;
	Sat,  7 Nov 2026 15:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064328;
	bh=12iOKMwQWpI4XjnxgqqhwuXvdFGbiCyYFrwUsIOv0AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oEycfLJeAy3Bt+OKBGCpY4irPJIjgG8jsbYLFWCz43VUVVGvnqNbs00Ki7ME2uSWu
	 K2UvmaCRuI0pvHCJPY90MqFMpqxMUWaE9ZT4N2MtvTqDii13ahK/PiWrtqctw624nO
	 eLMZELO8ZgqWhSKWzBExB94/y1haGKW+6HiQRlME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Snowhill <chris@kode54.net>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0415/1257] media: em28xx: fix inverted tuner capability check for VBI device
Date: Sat,  7 Nov 2026 08:45:11 -0500
Message-ID: <20261107134950.975180011@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Snowhill <chris@kode54.net>

[ Upstream commit a8296bfabd1112e690aad9acc7de3c431f39d0e6 ]

Commit 8e53399c63c3 ("media: em28xx: Add support for Empia em2828X
bridge") changed the condition for setting V4L2_CAP_TUNER on the VBI
device from "dev->tuner_type != TUNER_ABSENT" to a check of the video
device's capabilities, but inverted it: the VBI node now advertises a
tuner only when the video node does not have one.

On boards without a tuner (e.g. the MyGica iGrabber, card=105) the VBI
device's device_caps therefore contain V4L2_CAP_TUNER, while the shared
vidioc_querycap() correctly omits it from cap->capabilities. This trips
the sanity check in v4l_querycap() whenever the VBI node is queried,
for example by udev's v4l_id on every hotplug:

  WARNING: drivers/media/v4l2-core/v4l2-ioctl.c:1119 at v4l_querycap+0xff/0x110 [videodev]
  (cap->capabilities & (vfd->device_caps | V4L2_CAP_DEVICE_CAPS)) != (vfd->device_caps | V4L2_CAP_DEVICE_CAPS)

It also leaves the tuner ioctls enabled on the VBI node of tuner-less
boards and disables them on boards that do have a tuner.

Restore the intended logic so the VBI device has V4L2_CAP_TUNER exactly
when the video device does.

Fixes: 8e53399c63c3 ("media: em28xx: Add support for Empia em2828X bridge")
Assisted-by: LLM
Signed-off-by: Christopher Snowhill <chris@kode54.net>
Cc: stable@vger.kernel.org
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 79af154767c17..e441f221dbb7a 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -3001,7 +3001,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		v4l2->vbi_dev.queue->lock = &v4l2->vb_vbi_queue_lock;
 		v4l2->vbi_dev.device_caps = V4L2_CAP_STREAMING |
 			V4L2_CAP_READWRITE | V4L2_CAP_VBI_CAPTURE;
-		if ((v4l2->vdev.device_caps & V4L2_CAP_TUNER) == 0)
+		if (v4l2->vdev.device_caps & V4L2_CAP_TUNER)
 			v4l2->vbi_dev.device_caps |= V4L2_CAP_TUNER;
 
 		/* disable inapplicable ioctls */
-- 
2.53.0



