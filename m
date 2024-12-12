Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F137022C345;
	Thu, 12 Dec 2024 16:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020863; cv=none; b=QdvnJXKwHn9f76/CZOUb/krpqrbPr2vllpqA/r4/szQRAKF0jAewaUkgGDx00bIdzl7CRNAKDxsV96rizFnCiGdArXjwyrdcDSISEkD6HTWNbBC334ONt4fJCr9u212Ey0Rq/lAlyfsANbhZ/us9X5BnIQa+tTGbgFDipLvSXjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020863; c=relaxed/simple;
	bh=8G6KZgHxm3CzuiOf0M41AaisrUo0fySfMfIaOmox44w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2gnm1tuL7p21ni6w0jEvCxTVVsKMXjiI2+LAlFrCQ4nkRPVnnSFUoseqZJeMvAXnUpZfs654TieMTE3P6irQysz4SZ4Rqs0TXOKgi9WEu1+fd9OhbH79ZJJLiB7GOTxtX25jwFN3REZC3kIG1tfyCPLyJrrqvXWsMM6OGu8Izk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVeyUg+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVeyUg+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606C1C4CECE;
	Thu, 12 Dec 2024 16:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020862;
	bh=8G6KZgHxm3CzuiOf0M41AaisrUo0fySfMfIaOmox44w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NVeyUg+BfpirIFB+rWFmRVc2K1ry+bWV5KMKS/0fkYXh+hDJyIoBR0GnnmUQXy+js
	 BjLp6HHqXWveXF8alspj0mFvp2oCxLG1v7aGaedMiDVGENhAQK9zzl3oxFDd89n205
	 t2Wll1o0Hs+D7klj3ub911ijc5wJTU+rVX7MejXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 579/772] device property: Constify device child node APIs
Date: Thu, 12 Dec 2024 15:58:44 +0100
Message-ID: <20241212144413.871298499@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 7952cd2b8213f20a1752634c25dfd215da537722 ]

The device parameter is not altered in the device child node APIs,
constify them.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://lore.kernel.org/r/20221004092129.19412-5-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 73b03b27736e ("leds: flash: mt6360: Fix device_for_each_child_node() refcounting in error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/property.c  |  6 +++---
 include/linux/property.h | 12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index eb9b01c2ff1d9..ba612087a278f 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -790,7 +790,7 @@ EXPORT_SYMBOL_GPL(fwnode_get_next_available_child_node);
  * fwnode pointer. Note that this function also puts a reference to @child
  * unconditionally.
  */
-struct fwnode_handle *device_get_next_child_node(struct device *dev,
+struct fwnode_handle *device_get_next_child_node(const struct device *dev,
 						 struct fwnode_handle *child)
 {
 	const struct fwnode_handle *fwnode = dev_fwnode(dev);
@@ -833,7 +833,7 @@ EXPORT_SYMBOL_GPL(fwnode_get_named_child_node);
  * The caller is responsible for calling fwnode_handle_put() on the returned
  * fwnode pointer.
  */
-struct fwnode_handle *device_get_named_child_node(struct device *dev,
+struct fwnode_handle *device_get_named_child_node(const struct device *dev,
 						  const char *childname)
 {
 	return fwnode_get_named_child_node(dev_fwnode(dev), childname);
@@ -899,7 +899,7 @@ EXPORT_SYMBOL_GPL(fwnode_device_is_available);
  *
  * Return: the number of child nodes for a given device.
  */
-unsigned int device_get_child_node_count(struct device *dev)
+unsigned int device_get_child_node_count(const struct device *dev)
 {
 	struct fwnode_handle *child;
 	unsigned int count = 0;
diff --git a/include/linux/property.h b/include/linux/property.h
index 587b5b666b5bb..ec3490591f934 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -114,16 +114,16 @@ struct fwnode_handle *fwnode_get_next_available_child_node(
 	for (child = fwnode_get_next_available_child_node(fwnode, NULL); child;\
 	     child = fwnode_get_next_available_child_node(fwnode, child))
 
-struct fwnode_handle *device_get_next_child_node(
-	struct device *dev, struct fwnode_handle *child);
+struct fwnode_handle *device_get_next_child_node(const struct device *dev,
+						 struct fwnode_handle *child);
 
 #define device_for_each_child_node(dev, child)				\
 	for (child = device_get_next_child_node(dev, NULL); child;	\
 	     child = device_get_next_child_node(dev, child))
 
-struct fwnode_handle *fwnode_get_named_child_node(
-	const struct fwnode_handle *fwnode, const char *childname);
-struct fwnode_handle *device_get_named_child_node(struct device *dev,
+struct fwnode_handle *fwnode_get_named_child_node(const struct fwnode_handle *fwnode,
+						  const char *childname);
+struct fwnode_handle *device_get_named_child_node(const struct device *dev,
 						  const char *childname);
 
 struct fwnode_handle *fwnode_handle_get(struct fwnode_handle *fwnode);
@@ -132,7 +132,7 @@ void fwnode_handle_put(struct fwnode_handle *fwnode);
 int fwnode_irq_get(const struct fwnode_handle *fwnode, unsigned int index);
 int fwnode_irq_get_byname(const struct fwnode_handle *fwnode, const char *name);
 
-unsigned int device_get_child_node_count(struct device *dev);
+unsigned int device_get_child_node_count(const struct device *dev);
 
 static inline bool device_property_read_bool(struct device *dev,
 					     const char *propname)
-- 
2.43.0



