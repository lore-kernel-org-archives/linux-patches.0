Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9BF34752E;
	Sat, 12 Sep 2026 10:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210632; cv=none; b=P+c34wk30lFBTtucExu4bVeN2tpcNI/QufMtQtKbpoCZAgh2Mdt2CRX2Mf39BnfUqYaAGmBahrcuGRoHz55LnAH3cXKRsNBHCAFRWf3JtVH22wvP8CIMq0utNyemF7zoZcG1Z25XEMWyizPc037pjHHaTcd1oTHDaI07TiiJvbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210632; c=relaxed/simple;
	bh=vn9JX7MeCyP+5f/n1tGrInjs8gHWlctA3a3V0ejZqRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCQOODW4AJZ7z555MuLR59AcUin85getw2tbDv14uWhHKWuK2LrieoKgdz62acPRRgNXQwloJ1Y6/fT04LldkPjg91wGMXZW8pcXAE947Pa4+RrP0NNWP2KacDEuhOKnRfq/B+Wm8yAHxPb16F3y5rLtdTVI2H+K3VvQ9SN/VS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PObAaRBR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PObAaRBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471621F000FF;
	Sat, 12 Sep 2026 10:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210631;
	bh=PcDGTrghV1DDAR42M1o3dsWeoqLUarzfhtAUGyxDByo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PObAaRBRvDA3l+6bSPebRG8jI00ihDl9UNaKTBRkLjIBP9Jz2NQCou14NvQronyDu
	 8XEtRdN0VlaGrJZeGWiZ5qNu09+CwW2JGY6CXIHjZOa3Zj+fdWz9J3CizUNuddsm2V
	 1ELizjbuweOYKYppYN7/AQeC+9tPwI1Ti6AWLN08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1067/1518] crypto: qat - use 2-arg strscpy where destination size is known
Date: Sat, 12 Sep 2026 08:53:56 +0200
Message-ID: <20260912065647.585800962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 97273da40b438..3b42e29047bcc 100644
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
index 7d00bcb41ce70..11cba347d12d1 100644
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
index 41cc763a74aa2..df4600ab72d6b 100644
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
index 6c22bc9b28e47..ad45ca7e8eb86 100644
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
index 53a4db5507ec2..69db4178a419c 100644
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
@@ -123,7 +124,7 @@ static int qat_compression_create_instances(struct adf_accel_dev *accel_dev)
 	int i;
 
 	INIT_LIST_HEAD(&accel_dev->compression_list);
-	strscpy(key, ADF_NUM_DC, sizeof(key));
+	strscpy(key, ADF_NUM_DC);
 	ret = adf_cfg_get_param_value(accel_dev, SEC, key, val);
 	if (ret)
 		return ret;
-- 
2.53.0



