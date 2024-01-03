Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA63C1BDF1;
	Wed,  3 Jan 2024 17:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8AlOfKu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAEE8C433C7;
	Wed,  3 Jan 2024 17:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301631;
	bh=2a8TVNo+Ut3WU2vKIasQYO1PtISEJoJEsyzJK1CnU3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r8AlOfKugtoKENBKdPMUctY7q1B5d5/iK9qhorPh0dID6kWULnceGQzcdqnSPnC8C
	 dAZnhNEYhLclQKn8hPOkT7Yo4w1PFfVY6cGTD83KAIebO6gaAc5y965g8wOze6Kf/N
	 fHLs+A7IlumpW8aB3jMvuOrkFasiAokdAhyrwSQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 80/95] device property: Add const qualifier to device_get_match_data() parameter
Date: Wed,  3 Jan 2024 17:55:28 +0100
Message-ID: <20240103164906.070101915@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>
References: <20240103164853.921194838@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit aade55c86033bee868a93e4bf3843c9c99e84526 ]

Add const qualifier to the device_get_match_data() parameter.
Some of the future users may utilize this function without
forcing the type.

All the same, dev_fwnode() may be used with a const qualifier.

Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220922135410.49694-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/property.c  | 4 ++--
 include/linux/property.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index 17a648d643566..2ed844650328c 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -18,7 +18,7 @@
 #include <linux/etherdevice.h>
 #include <linux/phy.h>
 
-struct fwnode_handle *dev_fwnode(struct device *dev)
+struct fwnode_handle *dev_fwnode(const struct device *dev)
 {
 	return IS_ENABLED(CONFIG_OF) && dev->of_node ?
 		of_fwnode_handle(dev->of_node) : dev->fwnode;
@@ -1281,7 +1281,7 @@ int fwnode_graph_parse_endpoint(const struct fwnode_handle *fwnode,
 }
 EXPORT_SYMBOL(fwnode_graph_parse_endpoint);
 
-const void *device_get_match_data(struct device *dev)
+const void *device_get_match_data(const struct device *dev)
 {
 	return fwnode_call_ptr_op(dev_fwnode(dev), device_get_match_data, dev);
 }
diff --git a/include/linux/property.h b/include/linux/property.h
index 357513a977e5d..1bd1e4ada7e3a 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -31,7 +31,7 @@ enum dev_dma_attr {
 	DEV_DMA_COHERENT,
 };
 
-struct fwnode_handle *dev_fwnode(struct device *dev);
+struct fwnode_handle *dev_fwnode(const struct device *dev);
 
 bool device_property_present(struct device *dev, const char *propname);
 int device_property_read_u8_array(struct device *dev, const char *propname,
@@ -385,7 +385,7 @@ bool device_dma_supported(struct device *dev);
 
 enum dev_dma_attr device_get_dma_attr(struct device *dev);
 
-const void *device_get_match_data(struct device *dev);
+const void *device_get_match_data(const struct device *dev);
 
 int device_get_phy_mode(struct device *dev);
 
-- 
2.43.0



