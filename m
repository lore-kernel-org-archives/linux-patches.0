Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E31F849C
	for <patches@lists.linux.dev>; Fri, 29 Sep 2023 20:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696020320; x=1727556320;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c8ofPZQg6aJ0kE1jG7f82ai6elYHrz7FK0oJN2MLVaE=;
  b=Z1OZNUf4Q5gLyolPQGfL6QFVyRTzRWLZQpKgLaIf4I4YM/zPMV0OhRAH
   9IYxrBdG31AMWY8CSop/8qhgrEC8ARUqY4t2waztggnP07rqkEcSbKppA
   S9asLaZB2CwtZZcFiXEI6wy+YkSwT+86fK338VxtVLveDBhFGCwBGGxjv
   faKLU9p4dG71yDeqbZg5QRoAXPIcRC63MGGnVoNrmVi7E3m6G0lGYHA2I
   XcUI28hezEBiOHyFjsN7ow6wLvwpb2wk3RIjv+Q1Zj4woPzqVuNAQVdKo
   dl31jQJCZNooSKvGGy07gYM2AXrm7Y4aAOotPvLt3wsntzak/HoZyVn7R
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10848"; a="468654481"
X-IronPort-AV: E=Sophos;i="6.03,188,1694761200"; 
   d="scan'208";a="468654481"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2023 13:28:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10848"; a="893539262"
X-IronPort-AV: E=Sophos;i="6.03,188,1694761200"; 
   d="scan'208";a="893539262"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2023 13:27:30 -0700
From: Jithu Joseph <jithu.joseph@intel.com>
To: hdegoede@redhat.com,
	markgross@kernel.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rostedt@goodmis.org,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com,
	pengfei.xu@intel.com,
	ilpo.jarvinen@linux.intel.com
Subject: [PATCH v3 8/9] platform/x86/intel/ifs: Add new error code
Date: Fri, 29 Sep 2023 13:24:35 -0700
Message-Id: <20230929202436.2850388-9-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230929202436.2850388-1-jithu.joseph@intel.com>
References: <20230922232606.1928026-1-jithu.joseph@intel.com>
 <20230929202436.2850388-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Make driver aware of a newly added error code so that it can provide a
more appropriate error message.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
---
 drivers/platform/x86/intel/ifs/runtest.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index 925c30c79011..4fe544d79946 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -40,6 +40,8 @@ enum ifs_status_err_code {
 	IFS_UNASSIGNED_ERROR_CODE		= 7,
 	IFS_EXCEED_NUMBER_OF_THREADS_CONCURRENT	= 8,
 	IFS_INTERRUPTED_DURING_EXECUTION	= 9,
+	IFS_UNASSIGNED_ERROR_CODE_0xA		= 0xA,
+	IFS_CORRUPTED_CHUNK		= 0xB,
 };
 
 static const char * const scan_test_status[] = {
@@ -55,6 +57,8 @@ static const char * const scan_test_status[] = {
 	[IFS_EXCEED_NUMBER_OF_THREADS_CONCURRENT] =
 	"Exceeded number of Logical Processors (LP) allowed to run Scan-At-Field concurrently",
 	[IFS_INTERRUPTED_DURING_EXECUTION] = "Interrupt occurred prior to SCAN start",
+	[IFS_UNASSIGNED_ERROR_CODE_0xA] = "Unassigned error code 0xA",
+	[IFS_CORRUPTED_CHUNK] = "Scan operation aborted due to corrupted image. Try reloading",
 };
 
 static void message_not_tested(struct device *dev, int cpu, union ifs_status status)
@@ -123,6 +127,8 @@ static bool can_restart(union ifs_status status)
 	case IFS_MISMATCH_ARGUMENTS_BETWEEN_THREADS:
 	case IFS_CORE_NOT_CAPABLE_CURRENTLY:
 	case IFS_UNASSIGNED_ERROR_CODE:
+	case IFS_UNASSIGNED_ERROR_CODE_0xA:
+	case IFS_CORRUPTED_CHUNK:
 		break;
 	}
 	return false;
-- 
2.25.1

