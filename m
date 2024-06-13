Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6977513C69C;
	Thu, 13 Jun 2024 12:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281222; cv=none; b=GgfhiLQcdg7e4bV/OM4dyNeO+3o4x9XcpJ56TnIubWPXx3/lN8YmEWebU72FmR4aUkzCFzPl59l4C3EmDCygo+TPE720PGO5C0jDUiN+OMgTdwENcMnmfr9ikybRLA6B0Hq5KANDCfA9mm+0ErIy70/Jl2sICPd4vGIjOG3gS7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281222; c=relaxed/simple;
	bh=uVLtSSTaxrNZQy3jzBgkBul08AZh5YKW6LyVU2qB29E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZxPJXnh1bTWRDFbtaimT6PPoSoqKhL7YBI6lG0Za/Nnkq/VuIfKeKteq8xJ1qgsJbsS57ofGwS0nXvxRlx8BbJllx7V1Sf85bdWco/OZDbeQH31n/eK6ESMGg8eF6I3/cBGFFk3V7BXms2Oc3uL6Wx5i0lFepf31rsxuUqnoeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fWtiDQMt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fWtiDQMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFA5C2BBFC;
	Thu, 13 Jun 2024 12:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281222;
	bh=uVLtSSTaxrNZQy3jzBgkBul08AZh5YKW6LyVU2qB29E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fWtiDQMtqWB3nhwOfpdvzOIznlJb3FKuVycVJNWypNTC5rlHkbURqQFYzToOsV5Cb
	 aH7d9UtCrCZozijjmN1lpvIAPnDds16toN0JdxjWiJvhNWw/eEisX1/IcGmgAB5fND
	 +wKKVvmRyf6yobrpSVLPAQnQ/eS0fCGIxLEu+k00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Russ Weight <russell.h.weight@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Moritz Fischer <mdf@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 164/317] fpga: region: Rename dev to parent for parent device
Date: Thu, 13 Jun 2024 13:33:02 +0200
Message-ID: <20240613113253.908802547@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russ Weight <russell.h.weight@intel.com>

[ Upstream commit 5e77886d0aa9a882424f6a4ccb3eca4dca43b4a0 ]

Rename variable "dev" to "parent" in cases where it represents the parent
device.

Signed-off-by: Russ Weight <russell.h.weight@intel.com>
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Moritz Fischer <mdf@kernel.org>
Link: https://lore.kernel.org/r/20210614170909.232415-6-mdf@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: b7c0e1ecee40 ("fpga: region: add owner module and take its refcount")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/fpga-region.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/fpga/fpga-region.c b/drivers/fpga/fpga-region.c
index c5c55d2f20b92..a4838715221ff 100644
--- a/drivers/fpga/fpga-region.c
+++ b/drivers/fpga/fpga-region.c
@@ -181,7 +181,7 @@ ATTRIBUTE_GROUPS(fpga_region);
 
 /**
  * fpga_region_create - alloc and init a struct fpga_region
- * @dev: device parent
+ * @parent: device parent
  * @mgr: manager that programs this region
  * @get_bridges: optional function to get bridges to a list
  *
@@ -192,7 +192,7 @@ ATTRIBUTE_GROUPS(fpga_region);
  * Return: struct fpga_region or NULL
  */
 struct fpga_region
-*fpga_region_create(struct device *dev,
+*fpga_region_create(struct device *parent,
 		    struct fpga_manager *mgr,
 		    int (*get_bridges)(struct fpga_region *))
 {
@@ -214,8 +214,8 @@ struct fpga_region
 
 	device_initialize(&region->dev);
 	region->dev.class = fpga_region_class;
-	region->dev.parent = dev;
-	region->dev.of_node = dev->of_node;
+	region->dev.parent = parent;
+	region->dev.of_node = parent->of_node;
 	region->dev.id = id;
 
 	ret = dev_set_name(&region->dev, "region%d", id);
@@ -253,7 +253,7 @@ static void devm_fpga_region_release(struct device *dev, void *res)
 
 /**
  * devm_fpga_region_create - create and initialize a managed FPGA region struct
- * @dev: device parent
+ * @parent: device parent
  * @mgr: manager that programs this region
  * @get_bridges: optional function to get bridges to a list
  *
@@ -268,7 +268,7 @@ static void devm_fpga_region_release(struct device *dev, void *res)
  * Return: struct fpga_region or NULL
  */
 struct fpga_region
-*devm_fpga_region_create(struct device *dev,
+*devm_fpga_region_create(struct device *parent,
 			 struct fpga_manager *mgr,
 			 int (*get_bridges)(struct fpga_region *))
 {
@@ -278,12 +278,12 @@ struct fpga_region
 	if (!ptr)
 		return NULL;
 
-	region = fpga_region_create(dev, mgr, get_bridges);
+	region = fpga_region_create(parent, mgr, get_bridges);
 	if (!region) {
 		devres_free(ptr);
 	} else {
 		*ptr = region;
-		devres_add(dev, ptr);
+		devres_add(parent, ptr);
 	}
 
 	return region;
-- 
2.43.0



