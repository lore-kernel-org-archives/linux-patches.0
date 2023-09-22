Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD6548E8B
	for <patches@lists.linux.dev>; Fri, 22 Sep 2023 23:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695425419; x=1726961419;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=psQXW7/lcmfS9QTLfrs9wDsLw5q6RjkAEKo07iKppi4=;
  b=OAKMs6abPpKp9xtW9D+2/EBLerCDBilTyHZML4ReJnpyvpQW5qTBhLiR
   oJVaBlxr+Lc6UpBBz1H1dZ2hh9uHp9m78/WCCvTJOXs7+mVBklJLkzYGX
   YpjxBoxt2pjoKX4OyWqgTZMlEiA4smSRH7S86egG6DtFJdwE4EFTuJlGS
   mGO9sqVfPEoajXwv890IoKJtH68sOM6to+MXBFRuoJHXTdbgTAJOyQo1u
   uoyxeitMI/PPq3+h3lFg0Mtmuy55pl0VSJtGsxfAmhSd0IB1F3/9z0DY2
   IhmltM+jk8DXtIaa2FAR/wtehpEJbk3amAweHqO1x+rkTUgbztrguv7x9
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="411896987"
X-IronPort-AV: E=Sophos;i="6.03,169,1694761200"; 
   d="scan'208";a="411896987"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2023 16:30:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="921350850"
X-IronPort-AV: E=Sophos;i="6.03,169,1694761200"; 
   d="scan'208";a="921350850"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2023 16:30:13 -0700
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
Subject: [PATCH v2 8/9] platform/x86/intel/ifs: Add new error code
Date: Fri, 22 Sep 2023 16:26:05 -0700
Message-Id: <20230922232606.1928026-9-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230922232606.1928026-1-jithu.joseph@intel.com>
References: <20230913183348.1349409-1-jithu.joseph@intel.com>
 <20230922232606.1928026-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make driver aware of a newly added error code so that it can provide a
more appropriate error message.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
---
 drivers/platform/x86/intel/ifs/runtest.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index 94d486e5d263..a29f7b8fa48e 100644
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

