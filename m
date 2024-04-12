Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7B514EC72
	for <patches@lists.linux.dev>; Fri, 12 Apr 2024 17:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712943049; cv=none; b=lnitdOMjCzxDhHXGbb1PkzBrArs1NImCMita5meTlN76iGmaCPs+xVoXaAHd+uYJl05nH6aSPIpC4MHquC7jebfgy6JQFtpROVDrPCEE6Yjv6gHrGGj7EAAM6PnFDza2LflbuG7ZZ0Czr/WdZIqleIeMzGrAKxgKyRqJpzgtOeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712943049; c=relaxed/simple;
	bh=53VPmLYStvI4gEILOZdjzTXxl1Rvmbkp0Ro+tl8CTdM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DE50RVn2h7kxaSqnOa8sbZojnwlxV2mpCizrWDrmvAUrjCkJY3WvY8qTTLRV3G+4UlIaXMQoUqxL8TtSlJivC018FXoyBy+h24wzacKPcLvxqazh4A7e0kNBzmciXPgzLkEtuVypUSoQYmeYZ37Z/eBAVWnVz8SSnjLrvbxJM7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H1NG5SPd; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H1NG5SPd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712943047; x=1744479047;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=53VPmLYStvI4gEILOZdjzTXxl1Rvmbkp0Ro+tl8CTdM=;
  b=H1NG5SPdvGw5OikyOl6Xtz1MZSbFhCDlr1GNbcK33CRiDApgEvKdO7bb
   aQwmRH0dnG3zcA+rtX8sw7qBymKkLYI1pio9O7/BLWtRHpfrCkeC0vdhI
   wCNALystGcV/L3gAfwyhd0SLGdwGAVH2nnCL5C6gZHT2O1w8rwWsNuCvE
   DJVM4h9sOTe8DmmTETvyoFLC/F1CKqvv8AiFT2eSi6RPvIBU3FrhrRy8P
   iScRj7Gt+KYW8IsWAS5kmXdZhIUrn9B8dO5ExAW5/xnfLxwcoDbhBPFjf
   tipQFNBmsOzY7U2TUNcKBeIP1Yz7gp6w/D9HLqtYuNm2kHbZDAEBBiVTy
   w==;
X-CSE-ConnectionGUID: zDKxtvenRZWaq/uH0HF8Vg==
X-CSE-MsgGUID: SMrRTpSBQoGyzHMnLnhcdg==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="11365690"
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="11365690"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 10:30:43 -0700
X-CSE-ConnectionGUID: BId4IbBrRS2kytb9eccrjQ==
X-CSE-MsgGUID: movp/L6LQHq5WdRBvF4hNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="21780775"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 10:30:42 -0700
From: Jithu Joseph <jithu.joseph@intel.com>
To: ilpo.jarvinen@linux.intel.com,
	hdegoede@redhat.com,
	markgross@kernel.org
Cc: linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	rostedt@goodmis.org,
	sathyanarayanan.kuppuswamy@intel.com,
	ravi.v.shankar@intel.com,
	patches@lists.linux.dev
Subject: [PATCH 2/3] platform/x86/intel/ifs: trace: display batch num in hex
Date: Fri, 12 Apr 2024 10:23:48 -0700
Message-Id: <20240412172349.544064-3-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240412172349.544064-1-jithu.joseph@intel.com>
References: <20240412172349.544064-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In Field Scan test image files are named in ff-mm-ss-<batch02x>.scan
format. Current trace output, prints the batch number in decimal format.

Make it easier to correlate the trace line to a test image file by
showing the batch number also in hex format.

Add 0x prefix to all fields in the trace line to make the type explicit.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Ashok Raj <ashok.raj@intel.com>
---
 include/trace/events/intel_ifs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/intel_ifs.h b/include/trace/events/intel_ifs.h
index 8ce2de120f2d..0d88ebf2c980 100644
--- a/include/trace/events/intel_ifs.h
+++ b/include/trace/events/intel_ifs.h
@@ -28,7 +28,7 @@ TRACE_EVENT(ifs_status,
 		__entry->status	= status;
 	),
 
-	TP_printk("batch: %.2d, start: %.4x, stop: %.4x, status: %.16llx",
+	TP_printk("batch: 0x%.2x, start: 0x%.4x, stop: 0x%.4x, status: 0x%.16llx",
 		__entry->batch,
 		__entry->start,
 		__entry->stop,
-- 
2.25.1

