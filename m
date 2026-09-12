Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C4E28B4FA;
	Sat, 12 Sep 2026 08:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202880; cv=none; b=p50GjQLQBc4s1ntGC5WSH1mTFBsZxARvuQuD/31E2hYJky1Vfo+f0dstPxiQu9ivqXrbjtgU4pupaHgc4UYi/j/wy31azoGfwlEzisanPKhdH2Fj+Jd+QmceSofNLYMYKojRREaHoHSXOGIyVTrUW8EDJrlos9NKuTbsg0Dbdhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202880; c=relaxed/simple;
	bh=vPVWsmUU84d8ywg5KM81WY6S+M6Qcm05/OWoLV6PVU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIm9mjCIhHkOPEvaQn6n3RN01N7Iwb8vGUEyruAICH5EVgHwcVJmo6b8pqIEptPoSCUvhIxfD5fOd54oRYTegnPBmK4uSXbT5kC9AFkWfbzjhhOY0Xs4jVu2Zu3UXUvXttsBgWrlWpBvE2n3nhJnMaVYqVOu5Rn/z82iD80GAGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BDB2BG2x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BDB2BG2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A491F000FF;
	Sat, 12 Sep 2026 08:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202878;
	bh=8es95EbcGkPvn38d3gDVfiu0VysK/wDCZu0htKdMvSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BDB2BG2xzwogeY2hO7okgOfbfdXQNDW/nWPHNSzH1hn4MgPSrWrD47GCyTNYqtEXW
	 32uvkNDJZLLKhvOC8dTEpZUBSFlyj+xcq40skG7G0tIA/Hge0wT28hhQ8R1cax6HMy
	 cLq7eB/RNB4QHe6S+4iw4tthSdDooS0gL0SgQIdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1295/1815] crypto: qat - use 2-arg strscpy where destination size is known
Date: Sat, 12 Sep 2026 08:50:45 +0200
Message-ID: <20260912065719.416139646@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 4525ac14115d07c3e4c57a8cd5c154916e9d1172 ]

To simplify the code, drop explicit and hard-coded size arguments from
strscpy() where the destination buffer has a fixed size and strscpy()
can automatically determine it using sizeof().

Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 61135c1597af ("crypto: qat - remove dead ADF_HEX code")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_cfg.c             | 7 ++++---
 drivers/crypto/intel/qat/qat_common/adf_cfg_services.c    | 2 +-
 drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c      | 3 ++-
 drivers/crypto/intel/qat/qat_common/adf_transport_debug.c | 3 ++-
 drivers/crypto/intel/qat/qat_common/qat_compression.c     | 3 ++-
 5 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg.c b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
index ea5d72d5090c0..d97ee10000452 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2014 - 2020 Intel Corporation */
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/list.h>
 #include <linux/seq_file.h>
 #include "adf_accel_devices.h"
@@ -284,13 +285,13 @@ int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&key_val->list);
-	strscpy(key_val->key, key, sizeof(key_val->key));
+	strscpy(key_val->key, key);
 
 	if (type == ADF_DEC) {
 		snprintf(key_val->val, ADF_CFG_MAX_VAL_LEN_IN_BYTES,
 			 "%ld", (*((long *)val)));
 	} else if (type == ADF_STR) {
-		strscpy(key_val->val, (char *)val, sizeof(key_val->val));
+		strscpy(key_val->val, (char *)val);
 	} else if (type == ADF_HEX) {
 		snprintf(key_val->val, ADF_CFG_MAX_VAL_LEN_IN_BYTES,
 			 "0x%lx", (unsigned long)val);
@@ -350,7 +351,7 @@ int adf_cfg_section_add(struct adf_accel_dev *accel_dev, const char *name)
 	if (!sec)
 		return -ENOMEM;
 
-	strscpy(sec->name, name, sizeof(sec->name));
+	strscpy(sec->name, name);
 	INIT_LIST_HEAD(&sec->param_head);
 	down_write(&cfg->lock);
 	list_add_tail(&sec->list, &cfg->sec_list);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
index 1af6da8b263fb..0cb6cb63e9950 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
@@ -60,7 +60,7 @@ static int adf_service_string_to_mask(struct adf_accel_dev *accel_dev, const cha
 	if (len > ADF_CFG_MAX_VAL_LEN_IN_BYTES - 1)
 		return -EINVAL;
 
-	strscpy(services, buf, ADF_CFG_MAX_VAL_LEN_IN_BYTES);
+	strscpy(services, buf);
 	substr = services;
 
 	while ((token = strsep(&substr, ADF_SERVICES_DELIMITER))) {
diff --git a/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c b/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
index f9017e03ec0f2..32aeb795cc036 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2024 Intel Corporation */
 
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/types.h>
 #include "adf_mstate_mgr.h"
 
@@ -158,7 +159,7 @@ static struct adf_mstate_sect_h *adf_mstate_sect_add_header(struct adf_mstate_mg
 		return NULL;
 	}
 
-	strscpy(sect->id, id, sizeof(sect->id));
+	strscpy(sect->id, id);
 	sect->size = 0;
 	sect->sub_sects = 0;
 	mgr->state += sizeof(*sect);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c b/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
index a8f853516a3f9..fc5d88a2bb172 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2014 - 2020 Intel Corporation */
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/seq_file.h>
 #include "adf_accel_devices.h"
 #include "adf_transport_internal.h"
@@ -103,7 +104,7 @@ int adf_ring_debugfs_add(struct adf_etr_ring_data *ring, const char *name)
 	if (!ring_debug)
 		return -ENOMEM;
 
-	strscpy(ring_debug->ring_name, name, sizeof(ring_debug->ring_name));
+	strscpy(ring_debug->ring_name, name);
 	snprintf(entry_name, sizeof(entry_name), "ring_%02d",
 		 ring->ring_number);
 
diff --git a/drivers/crypto/intel/qat/qat_common/qat_compression.c b/drivers/crypto/intel/qat/qat_common/qat_compression.c
index 1424d7a9bcd36..8129ad0c32d84 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_compression.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_compression.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2022 Intel Corporation */
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
 #include "adf_transport.h"
@@ -144,7 +145,7 @@ static int qat_compression_create_instances(struct adf_accel_dev *accel_dev)
 	int i;
 
 	INIT_LIST_HEAD(&accel_dev->compression_list);
-	strscpy(key, ADF_NUM_DC, sizeof(key));
+	strscpy(key, ADF_NUM_DC);
 	ret = adf_cfg_get_param_value(accel_dev, SEC, key, val);
 	if (ret)
 		return ret;
-- 
2.53.0



