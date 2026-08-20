Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD1D47DD54;
	Thu, 20 Aug 2026 16:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244425; cv=none; b=SShrZqB9kvh05bDmKB/X0CY+gUVFIqYVRLYe5VU5xHCNtpeL3LYrEhXCPT+IexMHkX9pLFuSnNMTBWwvYZvyPMUKnJ3odXv6Mc7esqRJ1RuZxp9qhCjh3eJC6UbW768ylbWuHPvZO79vZdFVc8Htwm/4Z0GECNwwyWpSRLOUJaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244425; c=relaxed/simple;
	bh=3nzNTJKuHMqWPeYXihNsVgosiOVkDkTAQIlYM7XbWms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKepGsHHgheJS8xJlHmIOAoV2a97F2ACkJt2AXZEjvYkV5vlLedLJ6OC3OFnJqB/HBSy+WyFZLoE95s8h3ejre/XMVnc9KcbTaRD+EkMhkBfCdq/VJ4tlgLNekAXB5M2Ix6xvHpJjN5Erry76/QhgJnwoioyw4U7+enuFiB4ptE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yqyc0Qyl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yqyc0Qyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E937B1F00A3F;
	Thu, 20 Aug 2026 16:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244424;
	bh=ekNeVOD/x9uwGOwycOUSMvXAYfUATwcdq9kX9mfiGq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yqyc0QylT8Mnt4sONYI+7CIDaw35NwEAwh5JjeemoxQ7ZJG6Qok7L5fGreO3dSt74
	 +grFSvB+2u7ux2mIM9fMzjiJ+RhHkTORd44wSK2j3IuoR7MNpUlpGWWp5DaQuY0P/b
	 zWJ1ASIzgNjEEHspfD/q4ItF585hLTCP7JKtO1nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 164/235] media: v4l: async: Set owner for async sub-devices
Date: Thu, 20 Aug 2026 16:56:40 +0200
Message-ID: <20260820145221.465648902@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 8a718752f5c339137c5b05e54f116cd26d5a4143 ]

Set the owner field of the async sub-devices by making
v4l2_async_register_subdev() a macro and obtaining THIS_MODULE that way.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Stable-dep-of: 06cb687a5132 ("media: v4l2-fwnode: Fix subdev owner overwritten in v4l2_async_register_subdev_sensor()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-async.c |    8 ++++++--
 include/media/v4l2-async.h           |    4 +++-
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -747,7 +747,7 @@ v4l2_async_notifier_add_devname_subdev(s
 }
 EXPORT_SYMBOL_GPL(v4l2_async_notifier_add_devname_subdev);
 
-int v4l2_async_register_subdev(struct v4l2_subdev *sd)
+int __v4l2_async_register_subdev(struct v4l2_subdev *sd, struct module *module)
 {
 	struct v4l2_async_notifier *subdev_notifier;
 	struct v4l2_async_notifier *notifier;
@@ -761,6 +761,8 @@ int v4l2_async_register_subdev(struct v4
 	if (!sd->fwnode && sd->dev)
 		sd->fwnode = dev_fwnode(sd->dev);
 
+	sd->owner = module;
+
 	mutex_lock(&list_lock);
 
 	INIT_LIST_HEAD(&sd->async_list);
@@ -811,9 +813,11 @@ err_unbind:
 
 	mutex_unlock(&list_lock);
 
+	sd->owner = NULL;
+
 	return ret;
 }
-EXPORT_SYMBOL(v4l2_async_register_subdev);
+EXPORT_SYMBOL(__v4l2_async_register_subdev);
 
 void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
 {
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -298,7 +298,9 @@ void v4l2_async_notifier_cleanup(struct
  *
  * @sd: pointer to &struct v4l2_subdev
  */
-int v4l2_async_register_subdev(struct v4l2_subdev *sd);
+#define v4l2_async_register_subdev(sd) \
+	__v4l2_async_register_subdev(sd, THIS_MODULE)
+int __v4l2_async_register_subdev(struct v4l2_subdev *sd, struct module *module);
 
 /**
  * v4l2_async_register_subdev_sensor_common - registers a sensor sub-device to


