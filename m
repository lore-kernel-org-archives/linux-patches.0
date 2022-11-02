Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175D8629
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE1AC433B5;
	Wed,  2 Nov 2022 03:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667359392;
	bh=1UYgwGfq+Sg4JU7j31xB8gqjf3oSnCS+t7QqOZiETL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tws+pQQgq+OIlgeMH4a+bQLIG9ptBniw2eXHhoi4T1h+MFemkiBtt1mwJ+812Kv8h
	 3vsomVIaKfp79K6vGkCjewHAwhUFTrWiI5ppSqSvFcarrdz39O7w/UaVx7CQgrPPPx
	 iZfWSN7mJh7Y4lpKi+M3KXulQeY9kkuNXm0ulJo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 31/64] media: v4l2: Fix v4l2_i2c_subdev_set_name function documentation
Date: Wed,  2 Nov 2022 03:33:57 +0100
Message-Id: <20221102022052.822894703@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.821538553@linuxfoundation.org>
References: <20221102022051.821538553@linuxfoundation.org>
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
index c070d8ae11e5..c2e9660c4d75 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -174,7 +174,8 @@ struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
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



