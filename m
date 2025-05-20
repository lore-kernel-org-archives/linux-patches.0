Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373BD24886F;
	Tue, 20 May 2025 14:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750378; cv=none; b=iXIS1i3rvHvr8hG3xIBKFmd1zhJH8R/PAAqmOVetc2oneNPNganzABvA8xDKHt16D0RHF0q+S6jyvHC7WnOjOayBULpmAB4Kyo5Vq0mM7QeMhZsgocibGz4G/YcrOERF24us3H3Fkx9af8eKVzpOiFbKALn97bk2NH5tu3ambiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750378; c=relaxed/simple;
	bh=vIR1nKHv0vcV/V33dOUf5gidGuJgny/hgGCRD4LWPkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PqiJLi8tO6A4i3Rjicq1PnMES2IPSpJfwHk1ntnV5qHolkzUzfSDLjiqPoXPpTEPamnYuFLrAchuPkt7Oip1e6yVyhocO7f0Q+4h2JBxLUqnOO+d0x/OmHntVMrKh8Bx4BTcVNudUnkhZIqZ1RS97mD4dQkNnt6HtlqYu3Lxuco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lTEkKeeu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lTEkKeeu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55C8C4CEE9;
	Tue, 20 May 2025 14:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750378;
	bh=vIR1nKHv0vcV/V33dOUf5gidGuJgny/hgGCRD4LWPkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lTEkKeeujtb0qFZwvHsbL3um1e4YKOoqggvo9h0fjn4L9f9dUfWCE49D/exhParhF
	 Ia/qPP+cY6UW995/kTJKT3M+VS+zk1pVOR02rj5xHOaoh65Mtgy4c/IQSQhGDkq7Ao
	 4a7w8ZKY6cJsyhXI61kOqmOvJ8LaFiPNr0AGkYwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.12 132/143] accel/ivpu: Rename ivpu_log_level to fw_log_level
Date: Tue, 20 May 2025 15:51:27 +0200
Message-ID: <20250520125815.208930067@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

commit 3a3fb8110c65d361cd9d750c9e16520f740c93f2 upstream.

Rename module param ivpu_log_level to fw_log_level, so it is clear
what log level is actually changed.

Reviewed-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240930195322.461209-3-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_fw.c     |    4 ++--
 drivers/accel/ivpu/ivpu_fw_log.c |   12 ++++++------
 drivers/accel/ivpu/ivpu_fw_log.h |    6 +++---
 3 files changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/accel/ivpu/ivpu_fw.c
+++ b/drivers/accel/ivpu/ivpu_fw.c
@@ -218,7 +218,7 @@ static int ivpu_fw_parse(struct ivpu_dev
 	fw->cold_boot_entry_point = fw_hdr->entry_point;
 	fw->entry_point = fw->cold_boot_entry_point;
 
-	fw->trace_level = min_t(u32, ivpu_log_level, IVPU_FW_LOG_FATAL);
+	fw->trace_level = min_t(u32, ivpu_fw_log_level, IVPU_FW_LOG_FATAL);
 	fw->trace_destination_mask = VPU_TRACE_DESTINATION_VERBOSE_TRACING;
 	fw->trace_hw_component_mask = -1;
 
@@ -323,7 +323,7 @@ static int ivpu_fw_mem_init(struct ivpu_
 		goto err_free_fw_mem;
 	}
 
-	if (ivpu_log_level <= IVPU_FW_LOG_INFO)
+	if (ivpu_fw_log_level <= IVPU_FW_LOG_INFO)
 		log_verb_size = IVPU_FW_VERBOSE_BUFFER_LARGE_SIZE;
 	else
 		log_verb_size = IVPU_FW_VERBOSE_BUFFER_SMALL_SIZE;
--- a/drivers/accel/ivpu/ivpu_fw_log.c
+++ b/drivers/accel/ivpu/ivpu_fw_log.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (C) 2020-2023 Intel Corporation
+ * Copyright (C) 2020-2024 Intel Corporation
  */
 
 #include <linux/ctype.h>
@@ -15,12 +15,12 @@
 #include "ivpu_fw_log.h"
 #include "ivpu_gem.h"
 
-#define IVPU_FW_LOG_LINE_LENGTH	  256
+#define IVPU_FW_LOG_LINE_LENGTH	256
 
-unsigned int ivpu_log_level = IVPU_FW_LOG_ERROR;
-module_param(ivpu_log_level, uint, 0444);
-MODULE_PARM_DESC(ivpu_log_level,
-		 "NPU firmware default trace level: debug=" __stringify(IVPU_FW_LOG_DEBUG)
+unsigned int ivpu_fw_log_level = IVPU_FW_LOG_ERROR;
+module_param_named(fw_log_level, ivpu_fw_log_level, uint, 0444);
+MODULE_PARM_DESC(fw_log_level,
+		 "NPU firmware default log level: debug=" __stringify(IVPU_FW_LOG_DEBUG)
 		 " info=" __stringify(IVPU_FW_LOG_INFO)
 		 " warn=" __stringify(IVPU_FW_LOG_WARN)
 		 " error=" __stringify(IVPU_FW_LOG_ERROR)
--- a/drivers/accel/ivpu/ivpu_fw_log.h
+++ b/drivers/accel/ivpu/ivpu_fw_log.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * Copyright (C) 2020-2023 Intel Corporation
+ * Copyright (C) 2020-2024 Intel Corporation
  */
 
 #ifndef __IVPU_FW_LOG_H__
@@ -17,12 +17,12 @@
 #define IVPU_FW_LOG_ERROR   4
 #define IVPU_FW_LOG_FATAL   5
 
-extern unsigned int ivpu_log_level;
-
 #define IVPU_FW_VERBOSE_BUFFER_SMALL_SIZE	SZ_1M
 #define IVPU_FW_VERBOSE_BUFFER_LARGE_SIZE	SZ_8M
 #define IVPU_FW_CRITICAL_BUFFER_SIZE		SZ_512K
 
+extern unsigned int ivpu_fw_log_level;
+
 void ivpu_fw_log_print(struct ivpu_device *vdev, bool only_new_msgs, struct drm_printer *p);
 void ivpu_fw_log_clear(struct ivpu_device *vdev);
 


