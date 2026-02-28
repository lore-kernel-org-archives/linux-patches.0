Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497004B8DE7;
	Sat, 28 Feb 2026 17:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301332; cv=none; b=Vf4X2H2dm2iRdOIpKnHwwbJgJssR7GmiOD3FoXAA7FwztYP5XlVoDMqTvf/ymxusdGLBJ1IZK5yK5gsI8GONjjUBjhR9exTdnKVpzHNINi+px9GnvlsCVS+0410I9YNzGzg1jt1Utm7G77hCbf+Z4E7JSLZO8w1gHhfouAJLp/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301332; c=relaxed/simple;
	bh=9XiW3GpYli+WyXCsoXLNbi7jTatj6HD3MPaVz1E9SBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZopKEW0ykMA1x+Lk5/BbWvc4fo7JA3AkiReB3RL9ix4oZ+UbU4+zfQPqTy7pWngferxtgNFu1wisZJ2JhwsTLwRkqoWDTM+AsKsws9orS6v6OEh0p4KrKlyX/cZFpQLiwYLe0jYOZG0zNbC8d1suipwgZFESOOldrt5TbU7dzrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b7Nwjv0l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b7Nwjv0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D3DC19423;
	Sat, 28 Feb 2026 17:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301332;
	bh=9XiW3GpYli+WyXCsoXLNbi7jTatj6HD3MPaVz1E9SBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7Nwjv0llh3c1Wh5zj4UuqiYTTszFZjIE64p499vNhA10gvvG4RciwoQVnd6rDD/L
	 jiA5RJFfTHTc0Ehou7Xqpn1LHioeuL884G8LSCXAnNVTIZfQGEN7mNtW3lulcm1u+z
	 zJtB8E18+iyUgLlkHY5QA5pExZcCRWjOyT31O9XDpzFkwZxR3qux4jR+YFngtsLctw
	 Ftqzvy3VDde8hbsW4rOnk3oLq5hWsxc25QdXpEV/dOXnvZ0zve1jyMIMpqhqQwNAcb
	 I3qB5IQC2H1TVisgCOjj4yk+zxUo3TczCysD7bnsCjzQUW6543cABGGuylPAOT+h80
	 dK6UeOqLO9row==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hans de Goede <hansg@kernel.org>,
	stable@vger.kernel.org,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 519/752] media: i2c: ov01a10: Add missing v4l2_subdev_cleanup() calls
Date: Sat, 28 Feb 2026 12:43:50 -0500
Message-ID: <20260228174750.1542406-519-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit 0dfec6e30c334364145d0acb38bb8c216b9a7a78 ]

Add missing v4l2_subdev_cleanup() calls to cleanup after
v4l2_subdev_init_finalize().

Fixes: 0827b58dabff ("media: i2c: add ov01a10 image sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hansg@kernel.org>
Tested-by: Mehdi Djait <mehdi.djait@linux.intel.com> # Dell XPS 9315
Reviewed-by: Mehdi Djait <mehdi.djait@linux.intel.com>
Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov01a10.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/ov01a10.c b/drivers/media/i2c/ov01a10.c
index 834ca46acb75f..1e22df12989ae 100644
--- a/drivers/media/i2c/ov01a10.c
+++ b/drivers/media/i2c/ov01a10.c
@@ -864,6 +864,7 @@ static void ov01a10_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	v4l2_async_unregister_subdev(sd);
+	v4l2_subdev_cleanup(sd);
 	media_entity_cleanup(&sd->entity);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 
@@ -934,6 +935,7 @@ static int ov01a10_probe(struct i2c_client *client)
 err_pm_disable:
 	pm_runtime_disable(dev);
 	pm_runtime_set_suspended(&client->dev);
+	v4l2_subdev_cleanup(&ov01a10->sd);
 
 err_media_entity_cleanup:
 	media_entity_cleanup(&ov01a10->sd.entity);
-- 
2.51.0

