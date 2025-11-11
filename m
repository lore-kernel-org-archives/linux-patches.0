Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDB12DC32A;
	Tue, 11 Nov 2025 01:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823692; cv=none; b=sgGv4UKx9mqHeaUH8bWe2Tx7bqO4Zu6evYXI80Pfaj1qngvs275VyjEMW+RoSLGnUREn6vrRfrzHNX6CnOouWvBrS9PzhJl9VpgztpeMOrF/qRq0lTIbVAKzUQjpIqSxd6khGP9DnuLWzfAmyN6Z8xQ7JUFfuUsBdf22YBiSsN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823692; c=relaxed/simple;
	bh=SQhxxNuL6Gho6dBEM47zCY0jxXOaX0N5xbrR/xqrPgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDUh6L+HzSaSbybkCeNdna4Hsuqk/nNsdlu77Oa9p7B1xpemHS23Kf0E9E9O+nI4btUe75f4wZRdov16+D1TC+UdH+k7Dn6tKhXjGqciijT/iZGoTmMJYMFWTazGXE3aBlQUE6DEe4A8+FYLke4POrcLCdaCZqARu2hk54QtK8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hT+upXi2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hT+upXi2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6772BC4CEFB;
	Tue, 11 Nov 2025 01:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823692;
	bh=SQhxxNuL6Gho6dBEM47zCY0jxXOaX0N5xbrR/xqrPgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hT+upXi2I+PUMqxBBzdFfvjlSvp05Tt9p+p+/glmaRuQt8lYJS0taUOVs7gFQBzmj
	 Sknxu5HtsjTmNNDVYxzXW6jLcBLDvk2B4Nfy1fx8OHwgHkwU1dtRE6yoTJxRnkYi9X
	 g7K8pp1De6tSL56a46m/aIQP9pPKSVsx2bs6R+tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Hari Nagalla <hnagalla@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 351/849] rpmsg: char: Export alias for RPMSG ID rpmsg-raw from table
Date: Tue, 11 Nov 2025 09:38:41 +0900
Message-ID: <20251111004544.905683877@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Davis <afd@ti.com>

[ Upstream commit 6e29c30d8ddea6109ea7e0b9f17e7841df0794ea ]

Module aliases are used by userspace to identify the correct module to
load for a detected hardware. The currently supported RPMSG device IDs for
this module include "rpmsg-raw", but the module alias is "rpmsg_chrdev".

Use the helper macro MODULE_DEVICE_TABLE(rpmsg) to export the correct
supported IDs. And while here, to keep backwards compatibility we also add
the other ID "rpmsg_chrdev" so that it is also still exported as an alias.

This has the side benefit of adding support for some legacy firmware
which still uses the original "rpmsg_chrdev" ID. This was the ID used for
this driver before it was upstreamed (as reflected by the module alias).

Signed-off-by: Andrew Davis <afd@ti.com>
Acked-by: Hari Nagalla <hnagalla@ti.com>
Tested-by: Hari Nagalla <hnagalla@ti.com>
Link: https://lore.kernel.org/r/20250619205722.133827-1-afd@ti.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/rpmsg_char.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/rpmsg/rpmsg_char.c b/drivers/rpmsg/rpmsg_char.c
index eec7642d26863..96fcdd2d7093c 100644
--- a/drivers/rpmsg/rpmsg_char.c
+++ b/drivers/rpmsg/rpmsg_char.c
@@ -522,8 +522,10 @@ static void rpmsg_chrdev_remove(struct rpmsg_device *rpdev)
 
 static struct rpmsg_device_id rpmsg_chrdev_id_table[] = {
 	{ .name	= "rpmsg-raw" },
+	{ .name	= "rpmsg_chrdev" },
 	{ },
 };
+MODULE_DEVICE_TABLE(rpmsg, rpmsg_chrdev_id_table);
 
 static struct rpmsg_driver rpmsg_chrdev_driver = {
 	.probe = rpmsg_chrdev_probe,
@@ -565,6 +567,5 @@ static void rpmsg_chrdev_exit(void)
 }
 module_exit(rpmsg_chrdev_exit);
 
-MODULE_ALIAS("rpmsg:rpmsg_chrdev");
 MODULE_DESCRIPTION("RPMSG device interface");
 MODULE_LICENSE("GPL v2");
-- 
2.51.0



