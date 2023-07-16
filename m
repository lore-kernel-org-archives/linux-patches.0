Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F528F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF8AC433C8;
	Sun, 16 Jul 2023 20:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540652;
	bh=lC0vgdu+RR9Fgb2u7+nRwnWXVmhCFRi3N5AXzIwjtpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kkGTsmr6wySVUHTZAnKN/UyAZPRJ6630+QjB/NlEfLXXAZYJ+M6xoyOKta0yNcQod
	 CawPp8fcxuy3F6yvewKTvZP5smG7/GP0kK4kg+6n//W/xtrIbXlKutaug3S8aqo+f1
	 FvS2BEHUI2bnzbh0ROQxJRt0VPJfvS6U7kgNbrFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Daniel Scally <djrscally@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Miaoqian Lin <linmq006@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 440/591] device property: Fix documentation for fwnode_get_next_parent()
Date: Sun, 16 Jul 2023 21:49:39 +0200
Message-ID: <20230716194935.294360634@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit f18caf261398a7f2de4fa3f600deb87072fe7b8d ]

Use fwnode_handle_put() on the node pointer to release the refcount.
Change fwnode_handle_node() to fwnode_handle_put().

Fixes: 233872585de1 ("device property: Add fwnode_get_next_parent()")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Daniel Scally <djrscally@gmail.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20221207112219.2652411-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 39d422555e43 ("drivers: fwnode: fix fwnode_irq_get[_byname]()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/property.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index 7f338cb4fb7b8..f2f7829ad36b9 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -601,7 +601,7 @@ EXPORT_SYMBOL_GPL(fwnode_get_parent);
  * node's parents.
  *
  * Returns a node pointer with refcount incremented, use
- * fwnode_handle_node() on it when done.
+ * fwnode_handle_put() on it when done.
  */
 struct fwnode_handle *fwnode_get_next_parent(struct fwnode_handle *fwnode)
 {
-- 
2.39.2



