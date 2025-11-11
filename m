Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E9B248883;
	Tue, 11 Nov 2025 01:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823442; cv=none; b=VTa4Tp//FEwFO49Oia0lmvNOozfXif4wsO/cNGhTp8qT25MEdNyCn6zUu8ilDaIYWJR7PDS5lv3hTMe9LN+s5xNFKQoXHaKszWqiEpOgPFHKHed8+LyQg31omo2Ln1pa1zTTjWRYFk9hir3+GR/U3nPiGtdjOXvZ7uaOPqZGA5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823442; c=relaxed/simple;
	bh=Kis806pFvHWgcIf2hxDtRYBvo/L2BOfIEK1E6qiMDcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etpdtquGjt0BZayINFUA7FtG2nqv7a/DDmOE7rZfPtCsDXbcppY/5NwiRXEiwZuq7RHV2c1BC62TojXUG/6esZtl9ggz88g+AfzmiAXX5fZNB9WcP2sOGFbWF4F+D4GAVw5FoYMHCK7q02lFx6o38ovow3zkmFDe5kmGLY3rWGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1o7XYafs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1o7XYafs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCBCC4CEFB;
	Tue, 11 Nov 2025 01:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823442;
	bh=Kis806pFvHWgcIf2hxDtRYBvo/L2BOfIEK1E6qiMDcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1o7XYafsNu3e/nQb+O2bxqVZu7Nv1dDxieqn/EPyH2PpDxEk//R2QB/B9faReNXTe
	 0nQGm1BjnTcX7hNT8El3dHISEpQmoOb/IlrQYzpeFaEzyXpN8oyWCFW+qrncCng+G4
	 +kSUV0yFk5imj9ST3YOkgXmYBfP64fIH5NfCPUN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Hari Nagalla <hnagalla@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 247/565] rpmsg: char: Export alias for RPMSG ID rpmsg-raw from table
Date: Tue, 11 Nov 2025 09:41:43 +0900
Message-ID: <20251111004532.466068192@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



