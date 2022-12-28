Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825A21C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06916C433EF;
	Wed, 28 Dec 2022 16:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243600;
	bh=mlSQAw8rAge/PTnJ2+GOdF6ePheixqxhMkCwFWIKhRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w7Bg+NVz9sh0iUvudhMVTCe/UldmCl6AqsbwuoISsWn/9JCXDvNf7CdkJhHBmW5iw
	 MdFaPBwOoslMLTYZJZ01udTU07RQKxfnbIjr3IAJhsyB6is/SpavrR7IWnjw7hOV9z
	 gV4n8K5JNQeB7d67foNwLOMq3s3dguRqGmvOVsfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0519/1146] media: staging: stkwebcam: Restore MEDIA_{USB,CAMERA}_SUPPORT dependencies
Date: Wed, 28 Dec 2022 15:34:18 +0100
Message-Id: <20221228144344.272934426@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit faaf901727eddcfbe889fe172ec9cdb5e63c8236 ]

By moving support for the USB Syntek DC1125 Camera to staging, the
dependencies on MEDIA_USB_SUPPORT and MEDIA_CAMERA_SUPPORT were lost.

Fixes: 56280c64ecac ("media: stkwebcam: deprecate driver, move to staging")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/deprecated/stkwebcam/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/deprecated/stkwebcam/Kconfig b/drivers/staging/media/deprecated/stkwebcam/Kconfig
index 4450403dff41..7234498e634a 100644
--- a/drivers/staging/media/deprecated/stkwebcam/Kconfig
+++ b/drivers/staging/media/deprecated/stkwebcam/Kconfig
@@ -2,7 +2,7 @@
 config VIDEO_STKWEBCAM
 	tristate "USB Syntek DC1125 Camera support (DEPRECATED)"
 	depends on VIDEO_DEV
-	depends on USB
+	depends on MEDIA_USB_SUPPORT && MEDIA_CAMERA_SUPPORT
 	help
 	  Say Y here if you want to use this type of camera.
 	  Supported devices are typically found in some Asus laptops,
-- 
2.35.1



