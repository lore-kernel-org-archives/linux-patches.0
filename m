Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26C71170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454E4C433C8;
	Mon, 11 Sep 2023 14:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441799;
	bh=JswTmcR34La5xIBLJ6jbD9mB19/oOR6n/couNv3CBqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GXs3mVo56j2qFIzv7Go/lQk8nLMxwW7eotutSPkTvQjPyimte6iJVTBeusPh0biaF
	 bJp3kfFrC1rQF22bNY8Lcs0DRaFq36YaSi0B3c3mkph2iUP2ZbP/F8tInJBioXt3Jz
	 xRCo7d3cHz0Bp244upXr/x5AESXTMaW3lCL/C83s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 540/739] media: Documentation: Fix [GS]_ROUTING documentation
Date: Mon, 11 Sep 2023 15:45:39 +0200
Message-ID: <20230911134706.180850915@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 997a6b01cd97b74684728d5af6511c333f25957d ]

Add mention that successful VIDIOC_SUBDEV_G_ROUTING call will update
'num_routes' and remove mention about non-existing streams, which is
incorrect.

Fixes: ea73eda50813 ("media: Documentation: Add GS_ROUTING documentation")
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../userspace-api/media/v4l/vidioc-subdev-g-routing.rst    | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/userspace-api/media/v4l/vidioc-subdev-g-routing.rst b/Documentation/userspace-api/media/v4l/vidioc-subdev-g-routing.rst
index 2d6e3bbdd0404..72677a280cd64 100644
--- a/Documentation/userspace-api/media/v4l/vidioc-subdev-g-routing.rst
+++ b/Documentation/userspace-api/media/v4l/vidioc-subdev-g-routing.rst
@@ -58,6 +58,9 @@ the subdevice exposes, drivers return the ENOSPC error code and adjust the
 value of the ``num_routes`` field. Application should then reserve enough memory
 for all the route entries and call ``VIDIOC_SUBDEV_G_ROUTING`` again.
 
+On a successful ``VIDIOC_SUBDEV_G_ROUTING`` call the driver updates the
+``num_routes`` field to reflect the actual number of routes returned.
+
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
 .. c:type:: v4l2_subdev_routing
@@ -138,9 +141,7 @@ ENOSPC
 
 EINVAL
    The sink or source pad identifiers reference a non-existing pad, or reference
-   pads of different types (ie. the sink_pad identifiers refers to a source pad)
-   or the sink or source stream identifiers reference a non-existing stream on
-   the sink or source pad.
+   pads of different types (ie. the sink_pad identifiers refers to a source pad).
 
 E2BIG
    The application provided ``num_routes`` for ``VIDIOC_SUBDEV_S_ROUTING`` is
-- 
2.40.1



