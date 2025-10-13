Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA6130BBB0;
	Mon, 13 Oct 2025 15:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369594; cv=none; b=X2BVUO1BJFecFg9/D+V0TAimIjs9v1E3a9xRBqLBKsPIzkPMLeuNvQIQ5y963ht99hqoY79c6RjGt36TWIRt4EFZf0E/U4bmgzyVdTagNKFpQnbQLBbazoFkzUMPN72MDFXlNo7k1GrkafMJfog0mC1TiYmUwW+Cgque3HowjuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369594; c=relaxed/simple;
	bh=07+xVmOzu5QDDog69xuJ9tZwBAdJY5m0QZ1vBTzL3Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sH3FdVJ1L9K7aRkEZ0HBNm150HijkENfgGgaQe0x1Jp9cXVge20O9bgdHB6xXqyVkLhSt5Iox6/WaU2zdd3J7j4LnwjDOabKN4pkcmbf0WVQoW81KGs31MM8+xLbYpmHZYXBD8pqeoV/cpda5FR9TyA+125IpJ7nDU8I7PT/z4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qyYgnslP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qyYgnslP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A012C4CEE7;
	Mon, 13 Oct 2025 15:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369594;
	bh=07+xVmOzu5QDDog69xuJ9tZwBAdJY5m0QZ1vBTzL3Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qyYgnslPmkAhGk2tc6GyYpvQ1vpaONDWYMoX7Tv6aJ5szjdlVfPoSZXOwJB4cUu5G
	 0OXtRjTMLepm9uFccPZ13TOfpbSZFcHNeXh6Iqans0fqkEDQAV+bGgBfqFxhdQHspj
	 HtaqnyIRZlTUNwznzme+wY719hyairceRhyCj/dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 300/563] coresight: Fix missing include for FIELD_GET
Date: Mon, 13 Oct 2025 16:42:41 +0200
Message-ID: <20251013144422.136348609@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: James Clark <james.clark@linaro.org>

[ Upstream commit 08d24e076d0fb9f90522ef69bf6cdae06e0919de ]

Include the header for FIELD_GET which is only sometimes transitively
included on some configs and kernel releases.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Closes: https://lists.linaro.org/archives/list/lkft-triage@lists.linaro.org/thread/6GKMK52PPRJVEYMEUHJP6BXF4CJAXOFL/
Fixes: a4e65842e114 ("coresight: Only check bottom two claim bits")
Signed-off-by: James Clark <james.clark@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250707-james-coresight-bitfield-include-v1-1-aa0f4220ecfd@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-core.c        | 1 +
 drivers/hwtracing/coresight/coresight-etm4x-core.c  | 1 +
 drivers/hwtracing/coresight/coresight-etm4x-sysfs.c | 1 +
 drivers/hwtracing/coresight/ultrasoc-smb.h          | 1 +
 4 files changed, 4 insertions(+)

diff --git a/drivers/hwtracing/coresight/coresight-core.c b/drivers/hwtracing/coresight/coresight-core.c
index fa758cc218275..c2db94f2ab237 100644
--- a/drivers/hwtracing/coresight/coresight-core.c
+++ b/drivers/hwtracing/coresight/coresight-core.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2012, The Linux Foundation. All rights reserved.
  */
 
+#include <linux/bitfield.h>
 #include <linux/build_bug.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 42e5d37403add..cbea200489c8f 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/acpi.h>
+#include <linux/bitfield.h>
 #include <linux/bitops.h>
 #include <linux/kernel.h>
 #include <linux/kvm_host.h>
diff --git a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
index ab251865b893d..e9eeea6240d55 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
@@ -4,6 +4,7 @@
  * Author: Mathieu Poirier <mathieu.poirier@linaro.org>
  */
 
+#include <linux/bitfield.h>
 #include <linux/coresight.h>
 #include <linux/pid_namespace.h>
 #include <linux/pm_runtime.h>
diff --git a/drivers/hwtracing/coresight/ultrasoc-smb.h b/drivers/hwtracing/coresight/ultrasoc-smb.h
index c4c111275627b..323f0ccb6878c 100644
--- a/drivers/hwtracing/coresight/ultrasoc-smb.h
+++ b/drivers/hwtracing/coresight/ultrasoc-smb.h
@@ -7,6 +7,7 @@
 #ifndef _ULTRASOC_SMB_H
 #define _ULTRASOC_SMB_H
 
+#include <linux/bitfield.h>
 #include <linux/miscdevice.h>
 #include <linux/spinlock.h>
 
-- 
2.51.0



