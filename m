Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C108C1F953
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:23:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBDBC433C8;
	Fri, 21 Jul 2023 16:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956595;
	bh=TN9B1Kq8sKyuFVxcG7RH3dVeJ3Ai06TJhNlu5Xfefdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1g4h2YNMGlGX/ypmK37f/UCktO4YxGoPWvvDpOSeCJ/ez3z81cafFhhU4YBl3y6SR
	 2VnLgdYzzmtSHfkdCoS4rFySNdIbrY4QdN//KAsUWSSgMl488diIMHPUlrOKwKNLvX
	 bYWY9U7socjcfU6wpb40OOy+6EG21sPNcpYJwZTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.4 232/292] media: uapi: Fix [GS]_ROUTING ACTIVE flag value
Date: Fri, 21 Jul 2023 18:05:41 +0200
Message-ID: <20230721160538.829293015@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 950e9a295b984b011bcbfb90af167e4e20a077f3 upstream.

The value of the V4L2_SUBDEV_ROUTE_FL_ACTIVE is 1, not 0. Use hexadecimal
numbers as is done elsewhere in the documentation.

Cc: stable@vger.kernel.org # for >= v6.3
Fixes: ea73eda50813 ("media: Documentation: Add GS_ROUTING documentation")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../userspace-api/media/v4l/vidioc-subdev-g-routing.rst         | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/userspace-api/media/v4l/vidioc-subdev-g-routing.rst b/Documentation/userspace-api/media/v4l/vidioc-subdev-g-routing.rst
index 68ca343c3b44..2d6e3bbdd040 100644
--- a/Documentation/userspace-api/media/v4l/vidioc-subdev-g-routing.rst
+++ b/Documentation/userspace-api/media/v4l/vidioc-subdev-g-routing.rst
@@ -122,7 +122,7 @@ for all the route entries and call ``VIDIOC_SUBDEV_G_ROUTING`` again.
     :widths:       3 1 4
 
     * - V4L2_SUBDEV_ROUTE_FL_ACTIVE
-      - 0
+      - 0x0001
       - The route is enabled. Set by applications.
 
 Return Value
-- 
2.41.0



