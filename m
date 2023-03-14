Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626D4180
	for <patches@lists.linux.dev>; Tue, 14 Mar 2023 00:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678754783; x=1710290783;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rcsTvBwbU1YioDRpvQCRJ7zAZ7Wtr8ikLHy99aBB36c=;
  b=aA1fp+NhAtcNuYutsqIlix7jS0COuzUNl0M6JeetZs9n56sXbhVCotvF
   DMid3LzyvLbYQO5gHVcFzs/LnnPF3+QEoHLSznG5w1+v0oVL/FLFOhoJt
   dBjLT0eFW18tvJo5Gs+MXHBwamzUCa8VupUopZWhtWNqAolLw2wcyau4V
   dFokJTA29QF8b0H25T5fW2fJTLnS07UQg0HMjLXZplUGVr6mwfMOfwhiG
   HjYD2T1fqwGdGXuFkLrQlvOrBkfupO0ywR0JfSw+4ZF3Y/Tl/bxeemR7j
   VoIIoYsn4YSO8APDIz0jP/WezmLMAIYRYxKOnHBcp+lp/n9x90W1vxF6h
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="337321668"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="337321668"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 17:46:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="672119601"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="672119601"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 17:46:22 -0700
From: Tony Luck <tony.luck@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	linux-acpi@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] ACPI: APEI: EINJ: Add CXL error types
Date: Mon, 13 Mar 2023 17:46:11 -0700
Message-Id: <20230314004611.48583-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ACPI 6.5 added six new error types for CXL. See chapter 18
table 18.30.

Add strings for the new types so that Linux will list them in the
/sys/kernel/debug/apei/einj/available_error_types file.

It seems no other changes are needed. Linux already accepts
the CXL codes (on a BIOS that advertises them).

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/acpi/apei/einj.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
index b4373e575660..39bee5a067cc 100644
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -584,6 +584,12 @@ static const char * const einj_error_type_string[] = {
 	"0x00000200\tPlatform Correctable\n",
 	"0x00000400\tPlatform Uncorrectable non-fatal\n",
 	"0x00000800\tPlatform Uncorrectable fatal\n",
+	"0x00001000\tCXL.cache Protocol Correctable\n",
+	"0x00002000\tCXL.cache Protocol Uncorrectable non-fatal\n",
+	"0x00004000\tCXL.cache Protocol Uncorrectable fatal\n",
+	"0x00008000\tCXL.mem Protocol Correctable\n",
+	"0x00010000\tCXL.mem Protocol Uncorrectable non-fatal\n",
+	"0x00020000\tCXL.mem Protocol Uncorrectable fatal\n",
 };
 
 static int available_error_type_show(struct seq_file *m, void *v)
-- 
2.39.2

