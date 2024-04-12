Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A770914F119
	for <patches@lists.linux.dev>; Fri, 12 Apr 2024 17:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712943050; cv=none; b=VNk29avIQPELf0yJ5uIlpn1XGcAVuYzufFjVjZzQd6jwk7PDRvzQSsNBYVIsvk7Ar67/xROE8xA6GRSfkN1OMlL3UNZbi2acqP1RvFJLnPrCHGcXny4q0AbAMcpoY0IpHrg/nQH3BaO2hwGSXwGMy5bXGnvpOdQTf4OY4BVLbbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712943050; c=relaxed/simple;
	bh=0q/n4BB5A4qfKK7WTII1e9HuGi84JwM3B21N0UMYoMo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bSsXE7NY+KuETa3vpM3+PyAlQ39L0CboEMPLC1h2luZSQe/JwVwboXTj6OXdSxvQONU3F/KmDOExxvk9bPOqr6CXnnVSznqBtd+Njj6rpjT+3+V6oOIKotTtcRQwru3RGGwQkgjPK9DHdZmBj1r3NVmux3tpd8EbeUCieeFoyq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LpomL4Cl; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LpomL4Cl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712943049; x=1744479049;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0q/n4BB5A4qfKK7WTII1e9HuGi84JwM3B21N0UMYoMo=;
  b=LpomL4ClkznmNfpvrpx0N+tFOpUVNWOS17jjL6XfWFE4WCk2fwjgyHKB
   HM0OGCgJS4hcqYSYVAOyF9ltIjvlQ8ri7+V6vRIeoyOFrMDc7JKWdUWRM
   tN0H38ldDKwF7rj+Yzx0+9k6IaFYB4KAJHtu22kk/czJSd4KhtBlKnsGE
   S2pJbt2YRBbHX+sJIt5ATiDiJ5CQyc3gdiKjk/q/vV8IAoN34hkhrodbo
   /kXT/KjBLNiPfPG91VqAuQgGCfSf8nn2/UUOLsB0AVVDawxXxX779R9K3
   TXJ5RYbvq3R0o1XJDfojTxknwcN27JyweGGohEu9Aqe7UezhSRVLUwFYM
   g==;
X-CSE-ConnectionGUID: c+W8AttRSTStukcbgqRhfg==
X-CSE-MsgGUID: rT2lxRurSCGkCPBKQUpZ4Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="11365695"
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="11365695"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 10:30:43 -0700
X-CSE-ConnectionGUID: zPCuEzLMT5miAOxrOYdj0Q==
X-CSE-MsgGUID: OFOLKwADSD+tETiNBK/HVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="21780778"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 10:30:43 -0700
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
Subject: [PATCH 3/3] platform/x86/intel/ifs: Disable irq during one load stage
Date: Fri, 12 Apr 2024 10:23:49 -0700
Message-Id: <20240412172349.544064-4-jithu.joseph@intel.com>
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

One of the stages in IFS image loading process involves loading individual
chunks (test patterns) from test image file to secure memory.

Driver issues a WRMSR(MSR_AUTHENTICATE_AND_COPY_CHUNK) operation to do
this. This operation can take up to 5 msec, and if an interrupt occurs
in between, the AUTH_AND_COPY_CHUNK u-code implementation aborts the
operation.

Interrupt sources such as NMI or SMI are handled by retrying. Regular
interrupts may occur frequently enough to prevent this operation from ever
completing. Disable irq on local cpu around the aforementioned WRMSR to
allow the operation to complete.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Ashok Raj <ashok.raj@intel.com>
---
 drivers/platform/x86/intel/ifs/load.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
index 584c44387e10..39f19cb51749 100644
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -233,7 +233,9 @@ static int copy_hashes_authenticate_chunks_gen2(struct device *dev)
 		chunk_table[0] = starting_chunk_nr + i;
 		chunk_table[1] = linear_addr;
 		do {
+			local_irq_disable();
 			wrmsrl(MSR_AUTHENTICATE_AND_COPY_CHUNK, (u64)chunk_table);
+			local_irq_enable();
 			rdmsrl(MSR_CHUNKS_AUTHENTICATION_STATUS, chunk_status.data);
 			err_code = chunk_status.error_code;
 		} while (err_code == AUTH_INTERRUPTED_ERROR && --retry_count);
-- 
2.25.1

