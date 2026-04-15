Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F1B37DEAF
	for <patches@lists.linux.dev>; Wed, 15 Apr 2026 17:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776274669; cv=none; b=bSLvzoa0qAzi1ydV2zIhA5XDczE6x67plMnFGhLjXzbZHEsM3C1cq2HD47c7ywgB7xSX4RwdEiIF6DoBrr4EAlceW6sUXhXZT+BITawX58Mq97YrJq4KMsFMQWQ8ixmkuMiAbSK/y1lKVBVaBSW/On0bfTiRsAoz6QkmLsxNJD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776274669; c=relaxed/simple;
	bh=zNcbkm/hUwKQh49O5J89Rxu2VqQ1cTYgzsuxxYEGH38=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QX/P5LZvlIkJuGJiYw0nN+yS77cIeNx1ozG/KJ7IEWsog+fl5S06StUDebRFl2vh7mBINxpLpkNt3FAApmTui101QiPwFLlpRERAXvcBvUG/Iis73oziSJA1aDyGS+11dhAqUJZrJyd4jdbAygDqqW2C1W+eq3PRN0axWC6hDQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bdsFW0s8; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bdsFW0s8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776274668; x=1807810668;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zNcbkm/hUwKQh49O5J89Rxu2VqQ1cTYgzsuxxYEGH38=;
  b=bdsFW0s8pP4fNFQV05qK3oG1XTZhKBNRiDQSzxynLxzVUDLgxoid4Wqo
   INYTHMUHnNX3pMwuBM26JHA84EAsEpwwCu/4lBzNDqDYeM9/E2/rroZkg
   /COPxnLnkp1q58v77iGUYQgDw5IBtepg7mBt6UkPxfhBpSChKeraVyt89
   Dx4lhIe4TcdflVixn6qxe1jsQjZZK/y56YlXGjBQfVjFmlD7kWAjK5KNp
   GagADkhLvapW8ITPiOfkxvwaAeTFHOXvFavGTwqiovli+w6u/C5+zauKS
   a+yH71wXzqqJ5d5Y16wDBKApDFK5q1/yfp4pIy4lXoJ/R0AN9k3KUJb7D
   A==;
X-CSE-ConnectionGUID: 8wOyf7FYTK6JHVV079g4RQ==
X-CSE-MsgGUID: vUlZVhYbQR2f+QrUVsDbKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11760"; a="88344106"
X-IronPort-AV: E=Sophos;i="6.23,179,1770624000"; 
   d="scan'208";a="88344106"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2026 10:37:47 -0700
X-CSE-ConnectionGUID: /QG5vpw3TjuK05VDLRsEAg==
X-CSE-MsgGUID: rcXTsBHhRxKBl69fq+LKNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,179,1770624000"; 
   d="scan'208";a="225785571"
Received: from vverma7-desk1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.158])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2026 10:37:47 -0700
From: Tony Luck <tony.luck@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Herman Li <herman.li@intel.com>,
	Zaid Alali <zaidal@os.amperecomputing.com>,
	Jiaqi Yan <jiaqiyan@google.com>,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2] ACPI: APEI: EINJ: Fix EINJv2 memory injection
Date: Wed, 15 Apr 2026 10:37:35 -0700
Message-ID: <20260415173735.24437-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

EINJ trigger actions for memory error injection often include access to
the target injection address. This address does not need to special
mapping.

The code to drop the target address from the resource list only checked
for V1 injection signature.

Add a test for the EINJ V2 memory injection signature.

Fixes: b47610296d17 ("ACPI: APEI: EINJ: Enable EINJv2 error injections")
Reported-by: Herman Li <herman.li@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---

V2: Add "Fixes:" tag

 drivers/acpi/apei/einj-core.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/apei/einj-core.c b/drivers/acpi/apei/einj-core.c
index a9248af078f6..ba0ce71b7adb 100644
--- a/drivers/acpi/apei/einj-core.c
+++ b/drivers/acpi/apei/einj-core.c
@@ -401,6 +401,17 @@ static struct acpi_generic_address *einj_get_trigger_parameter_region(
 
 	return NULL;
 }
+
+static bool is_memory_injection(u32 type, u64 param2)
+{
+	if (is_v2)
+		return type & BIT(1);
+	else if (param_extension || acpi5)
+		return (type & MEM_ERROR_MASK) && param2;
+
+	return false;
+}
+
 /* Execute instructions in trigger error action table */
 static int __einj_error_trigger(u64 trigger_paddr, u32 type,
 				u64 param1, u64 param2)
@@ -480,7 +491,7 @@ static int __einj_error_trigger(u64 trigger_paddr, u32 type,
 	 * This will cause resource conflict with regular memory.  So
 	 * remove it from trigger table resources.
 	 */
-	if ((param_extension || acpi5) && (type & MEM_ERROR_MASK) && param2) {
+	if (is_memory_injection(type, param2)) {
 		struct apei_resources addr_resources;
 
 		apei_resources_init(&addr_resources);
-- 
2.53.0

