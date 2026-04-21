Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917303D9047
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 15:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776783750; cv=none; b=hNCMMuS3mLEm+aCUg5LJGoRjyM2ScErFZsGsppRy8Xg9KBAWCrhAo749pcdi/E7Y4dDdc/21ph+CllYE22RxpGAluKI/zvUDrbGpkCpzTHEUoIVFljRdstF/ZAumKWkACD7Qc7Bq2YwygGdpPhV0QpChljvrE+ZAhH+QwxTqaww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776783750; c=relaxed/simple;
	bh=JQ2bYN63fgfn9ocjvZHJv2SwjpU35WUbJTTi+e2QUzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/cnzlF8XiNhIywSQqqXE0cX0r9XzHfaEcHlnHTolfa6dCexhMAMr5pUmitHugJ864MwcCzo4437ZVNRUyl7/Ro7JTkechRjG6Atj3NgKGvaaVe577ol8BwXuAqv00uyX/AHP9i6zsUD3CA+JR12Fwgvh6PjrLuBHQHh80BUyjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QzFjC8PR; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QzFjC8PR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776783750; x=1808319750;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JQ2bYN63fgfn9ocjvZHJv2SwjpU35WUbJTTi+e2QUzM=;
  b=QzFjC8PRsolt1smsGtrVAbjPN9m/gS9ZJ59foRJAII6hi8PyvU9Ii2l0
   HkxWi3AbUVIMYU26L8xCuHsT0ZN/vCUHPSadSsdF70o0KMSvRVkUOhgof
   B0XaCIrcUiSqv37l7VAdq7ESCBSgaNZL/7iPpYYga8XILoXiDrf3ELxin
   gjtaGfVVxk4vsVfbek7OBbVLo3tcJropmGXCnAMFUKG3kTNis9iBkvU0z
   d/7LWVDKyoJeyq006ZPcY5BaaNT2d8TxPzTHz5gP5XwxVhA3qjCHeU/sx
   oAiWcqka5QSHa/OyN6lmEMZuvB+G29+DQw2nM0gAMDIywsv+GDk+QCo+o
   A==;
X-CSE-ConnectionGUID: J+JoJybGSbO6NGpppA9Xtg==
X-CSE-MsgGUID: Y/S9OOviTFSOqQhUOOazTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11763"; a="100376001"
X-IronPort-AV: E=Sophos;i="6.23,191,1770624000"; 
   d="scan'208";a="100376001"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2026 08:02:27 -0700
X-CSE-ConnectionGUID: lDRT3IckTQuVwX52KvGtUg==
X-CSE-MsgGUID: ecE/nRcyTzqn1O29iz+9wA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,191,1770624000"; 
   d="scan'208";a="227731226"
Received: from inaky-mobl1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.220])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2026 08:02:26 -0700
From: Tony Luck <tony.luck@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Herman Li <herman.li@intel.com>,
	"Lai, Yi1" <yi1.lai@intel.com>,
	Zaid Alali <zaidal@os.amperecomputing.com>,
	Jiaqi Yan <jiaqiyan@google.com>,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 1/2] ACPICA: Provide #defines for EINJV2 error types
Date: Tue, 21 Apr 2026 08:02:15 -0700
Message-ID: <20260421150216.11666-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260421150216.11666-1-tony.luck@intel.com>
References: <20260421150216.11666-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

EINJV2 defined new error types by moving the severity (correctable,
uncorrectable non-fatal, uncorrectable fatal) out of the "type".

ACPI 6.5 introduced EINJV2 and defined a vendor defined error type using
bit 31. This was dropped in ACPI 6.6.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---
Already applied to https://github.com/acpica/acpica.git as
commit e82d2d2fd145 ("Provide #defines for EINJV2 error types")


 include/acpi/actbl1.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
index 4e15583e0d25..f72e00517eb3 100644
--- a/include/acpi/actbl1.h
+++ b/include/acpi/actbl1.h
@@ -1386,6 +1386,12 @@ enum acpi_einj_command_status {
 #define ACPI_EINJ_CXL_MEM_FATAL             (1<<17)
 #define ACPI_EINJ_VENDOR_DEFINED            (1<<31)
 
+/* EINJV2 error types from EINJV2_GET_ERROR_TYPE (ACPI 6.6) */
+
+#define ACPI_EINJV2_PROCESSOR               (1)
+#define ACPI_EINJV2_MEMORY                  (1<<1)
+#define ACPI_EINJV2_PCIE                    (1<<2)
+
 /*******************************************************************************
  *
  * ERST - Error Record Serialization Table (ACPI 4.0)
-- 
2.53.0

