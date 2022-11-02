Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDD97E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE31C433C1;
	Wed,  2 Nov 2022 03:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358909;
	bh=8oX0g3YoDc7wDK/WlxZIoSBRGagOGPLHWCpGOsx+otE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBgO15l7aEIQAUKz4MFpniHRoZMtR2qmn4dArvL+GrB47b5DYNwlv06LrqrNNBu31
	 BFoBfAc1p4ed4HoEBGnacanLOcCqVBh4847hb3u34e64bOne/gmMxmqPwKiBCF9Z9m
	 0ylVgIDfUWCFy3tUQK4lBHWnrN376751EPPvL5zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 37/91] media: v4l2: Fix v4l2_i2c_subdev_set_name function documentation
Date: Wed,  2 Nov 2022 03:33:20 +0100
Message-Id: <20221102022056.089772251@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit bb9ea2c31fa11b789ade4c3abcdda3c5370a76ab ]

The doc says the I²C device's name is used if devname is NULL, but
actually the I²C device driver's name is used.

Fixes: 0658293012af ("media: v4l: subdev: Add a function to set an I²C sub-device's name")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/media/v4l2-common.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index a3083529b698..2e53ee1c8db4 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -175,7 +175,8 @@ struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
  *
  * @sd: pointer to &struct v4l2_subdev
  * @client: pointer to struct i2c_client
- * @devname: the name of the device; if NULL, the I²C device's name will be used
+ * @devname: the name of the device; if NULL, the I²C device drivers's name
+ *           will be used
  * @postfix: sub-device specific string to put right after the I²C device name;
  *	     may be NULL
  */
-- 
2.35.1



