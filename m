Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C0437757A
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 05:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774589229; cv=none; b=ichYcXtII9RQzzojAMWOur362QQmDa/fhhsxXopEtG3jAwt1IySiMfT9TZmoUsz8w1QnoNLGjdXPSN+iTtAkUguwcyYYd/2IrYr0rYXJvioAhjKbFoT5MS7AROE6EdD26ffkGK6vSUZQcrb0OnCeRPY2Gvc7F0SSRja+5dokrn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774589229; c=relaxed/simple;
	bh=pKsndxUTDR6tmzClXFnQ5VeIMo4WQkELIJrD0j42Bnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z5W5uAyzAiZ9jpfDvKQBAQT3SiNIQF6CRrV3Kgh1FrkH6YWvh2dxaWkvwNEXcBlEXOLi1R2keyJQ/4a8uwqmKPQCXttd7WcQOQV6WY/knlpcpg/uBUggYA7c5bA6tm15Pp25vWXA928ohgzLAmdsMLmnGh4dXDsR21IeuiAlWBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HR1ONxjb; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HR1ONxjb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774589228; x=1806125228;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pKsndxUTDR6tmzClXFnQ5VeIMo4WQkELIJrD0j42Bnc=;
  b=HR1ONxjb6/VtmPwXKNreImKsINQoSBqybQnlKTGKd2PUBsFuAqUhawAB
   dzVj5c65wbaWzKJ6lxXFYgVVEgE1DwU0ye0E4xChmmeWYg9xAlPhhGNvy
   +YWr+S8xj37aiYYAWsT8NJ7MDd9DmcCgS3joNL3U18YWHfMUwTlCW5PC4
   IbvKKmlfz2cG5ITXVJPB9bxKb5FfAtpgySzIGSnoVLt+fX29vvovSEXuP
   w/Ln7KH9iszxov2B2k43e/0Rky2LqJ6Uul9hMnn3F70yDhGH6hHMd5PLT
   /8ZuAyT66uijEdFS86RYFyfF8kvBVHnJE0MEZJ91ik+qMrJq1UQIv58vU
   A==;
X-CSE-ConnectionGUID: UaeVFjBiRdOFn4ZvoprTHg==
X-CSE-MsgGUID: FcP0RPAXS/CLhn7QJ5+dTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11741"; a="101117952"
X-IronPort-AV: E=Sophos;i="6.23,143,1770624000"; 
   d="scan'208";a="101117952"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 22:27:06 -0700
X-CSE-ConnectionGUID: 9QRPH7n4RWeB1mMhxnRxdg==
X-CSE-MsgGUID: 2e01m4sUSnCKNOVnc35E5A==
X-ExtLoop1: 1
Received: from dwillia2-desk.jf.intel.com ([10.88.27.145])
  by fmviesa003.fm.intel.com with ESMTP; 26 Mar 2026 22:27:05 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: dave.jiang@intel.com
Cc: patches@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com
Subject: [PATCH 4/9] cxl/region: Constify cxl_region_resource_contains()
Date: Thu, 26 Mar 2026 22:28:16 -0700
Message-ID: <20260327052821.440749-5-dan.j.williams@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327052821.440749-1-dan.j.williams@intel.com>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The call to cxl_region_resource_contains() in hmem_register_cxl_device()
need not cast away 'const'. The problem is the usage of the
bus_for_each_dev() API which does not mark its @data parameter as 'const'.
Switch to bus_find_device() which does take 'const' @data, fixup
cxl_region_resource_contains() and its caller.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/cxl.h         |  4 ++--
 drivers/cxl/core/region.c | 11 ++++++-----
 drivers/dax/hmem/hmem.c   |  2 +-
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 84ad04a02bde..340bdc9fcacc 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -941,7 +941,7 @@ struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
 int cxl_add_to_region(struct cxl_endpoint_decoder *cxled);
 struct cxl_dax_region *to_cxl_dax_region(struct device *dev);
 u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint, u64 spa);
-bool cxl_region_contains_resource(struct resource *res);
+bool cxl_region_contains_resource(const struct resource *res);
 #else
 static inline bool is_cxl_pmem_region(struct device *dev)
 {
@@ -964,7 +964,7 @@ static inline u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint,
 {
 	return 0;
 }
-static inline bool cxl_region_contains_resource(struct resource *res)
+static inline bool cxl_region_contains_resource(const struct resource *res)
 {
 	return false;
 }
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 12a9572f34d5..a8b183f2d9c5 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -4225,9 +4225,9 @@ static int cxl_region_setup_poison(struct cxl_region *cxlr)
 	return devm_add_action_or_reset(dev, remove_debugfs, dentry);
 }
 
-static int region_contains_resource(struct device *dev, void *data)
+static int region_contains_resource(struct device *dev, const void *data)
 {
-	struct resource *res = data;
+	const struct resource *res = data;
 	struct cxl_region *cxlr;
 	struct cxl_region_params *p;
 
@@ -4246,11 +4246,12 @@ static int region_contains_resource(struct device *dev, void *data)
 	return resource_contains(p->res, res) ? 1 : 0;
 }
 
-bool cxl_region_contains_resource(struct resource *res)
+bool cxl_region_contains_resource(const struct resource *res)
 {
 	guard(rwsem_read)(&cxl_rwsem.region);
-	return bus_for_each_dev(&cxl_bus_type, NULL, res,
-				region_contains_resource) != 0;
+	struct device *dev __free(put_device) = bus_find_device(
+		&cxl_bus_type, NULL, res, region_contains_resource);
+	return !!dev;
 }
 EXPORT_SYMBOL_FOR_MODULES(cxl_region_contains_resource, "dax_hmem");
 
diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
index 0051e553c33f..b2ab1292fa81 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -159,7 +159,7 @@ static int hmem_register_cxl_device(struct device *host, int target_nid,
 			      IORES_DESC_CXL) == REGION_DISJOINT)
 		return 0;
 
-	if (cxl_region_contains_resource((struct resource *)res)) {
+	if (cxl_region_contains_resource(res)) {
 		dev_dbg(host, "CXL claims resource, dropping: %pr\n", res);
 		return 0;
 	}
-- 
2.53.0

