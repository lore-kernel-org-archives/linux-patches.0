Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA05029B228
	for <patches@lists.linux.dev>; Wed,  4 Mar 2026 00:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772583587; cv=none; b=bTyMljqNaXqh4OWBvKB1zvZ+f2zuFfhQ+gD3M84w3Di4n82+57ye74jCGbZlQgEtMWuvmGTXskZWnHQGVo6ZOokHHov44Zsc3AdFh18IwyU9+OcF7L0wMH4nV7cXWWyn5GoRdA00S3GNC3J2MTZYJJWbwt58+haUL8WNLQ2Wt+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772583587; c=relaxed/simple;
	bh=3ef+JIZyk1BCpaoxZjYIa2McjH4xu833l3yMdDsAq/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GwnxYVnsa64xMpVdBRFxYa1AYcINOElog66KARlO96lsreWhofKv7QTlMG5NQqruAKvQDzhYnl8Uz7SmMEOJFSRbXTqCHgcFQbdq/nfR+6XnvktichBkq46sFva+RhwzjQ9Nojrf2eFHgS7vkYgYRJMA5THSFuUmOI/X9BVCws4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MPI5eD9o; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MPI5eD9o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772583586; x=1804119586;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3ef+JIZyk1BCpaoxZjYIa2McjH4xu833l3yMdDsAq/Y=;
  b=MPI5eD9oxrLe/lPE742Dz70z3UScow7FeuBDpmeXeCFIEoZ9zSKyB4w9
   L+kqJkxc/kOlXSCCadoBsCdfw2P2P5VNxy51WIqlp/qG80tRp0IVWUACG
   3TqjJWNcj5ne8Qzy9iYMJ/lo23BPrkgCbHNm8QsbblYucfoqxNdodVDXF
   LGIarggYTDxcR07wXkNGtuSJNdLNanuGGW950Rw5Cua1H4e/4JwNGP/Cn
   ExzmI6EOVG8hoVmErHOPM415LUvI0FYeTx7E5jGaHaWUEuj+Mfza+d2jX
   qYY9SLPnPgfzrU0jJVqmLuyLv+TUjNMM28y0oAjkoln2z/ooR8VaLXark
   Q==;
X-CSE-ConnectionGUID: dANZMZzZS4m9U4cE6OgXuw==
X-CSE-MsgGUID: RKxc7MWvTCyqwStQcF7TSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="73545003"
X-IronPort-AV: E=Sophos;i="6.21,323,1763452800"; 
   d="scan'208";a="73545003"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 16:19:44 -0800
X-CSE-ConnectionGUID: 1HPPM9HURTireiDLvZw4HQ==
X-CSE-MsgGUID: hUlGkldzSNSc/cMQEGww1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,323,1763452800"; 
   d="scan'208";a="218120388"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 16:19:45 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: shuah@kernel.org,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	tony.luck@intel.com,
	babu.moger@amd.com,
	ilpo.jarvinen@linux.intel.com
Cc: fenghuay@nvidia.com,
	peternewman@google.com,
	zide.chen@intel.com,
	dapeng1.mi@linux.intel.com,
	ben.horgan@arm.com,
	yu.c.chen@intel.com,
	reinette.chatre@intel.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v2 2/9] selftests/resctrl: Do not store iMC counter value in counter config structure
Date: Tue,  3 Mar 2026 16:19:31 -0800
Message-ID: <aaaeaa9b1dfe0694a1c6659193ab5b736aceb090.1772582958.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1772582958.git.reinette.chatre@intel.com>
References: <cover.1772582958.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The MBM and MBA tests compare MBM memory bandwidth measurements against
the memory bandwidth event values obtained from each memory controller's
PMU. The memory bandwidth event settings are discovered from the memory
controller details found in /sys/bus/event_source/devices/uncore_imc_N and
stored in struct imc_counter_config.

In addition to event settings struct imc_counter_config contains
imc_counter_config::return_value in which the associated event value is
stored on every read.

The event value is consumed and immediately recorded at regular intervals.
The stored value is never consumed afterwards, making its storage as part
of event configuration unnecessary.

Remove the return_value member from struct imc_counter_config. Instead
just use a local variable for use during event reading.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 tools/testing/selftests/resctrl/resctrl_val.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/resctrl/resctrl_val.c b/tools/testing/selftests/resctrl/resctrl_val.c
index a5a8badb83d4..2cc22f61a1f8 100644
--- a/tools/testing/selftests/resctrl/resctrl_val.c
+++ b/tools/testing/selftests/resctrl/resctrl_val.c
@@ -32,7 +32,6 @@ struct imc_counter_config {
 	__u64 event;
 	__u64 umask;
 	struct perf_event_attr pe;
-	struct membw_read_format return_value;
 	int fd;
 };
 
@@ -312,23 +311,23 @@ static int get_read_mem_bw_imc(float *bw_imc)
 	 * Take overflow into consideration before calculating total bandwidth.
 	 */
 	for (imc = 0; imc < imcs; imc++) {
+		struct membw_read_format return_value;
 		struct imc_counter_config *r =
 			&imc_counters_config[imc];
 
-		if (read(r->fd, &r->return_value,
-			 sizeof(struct membw_read_format)) == -1) {
+		if (read(r->fd, &return_value, sizeof(return_value)) == -1) {
 			ksft_perror("Couldn't get read bandwidth through iMC");
 			return -1;
 		}
 
-		__u64 r_time_enabled = r->return_value.time_enabled;
-		__u64 r_time_running = r->return_value.time_running;
+		__u64 r_time_enabled = return_value.time_enabled;
+		__u64 r_time_running = return_value.time_running;
 
 		if (r_time_enabled != r_time_running)
 			of_mul_read = (float)r_time_enabled /
 					(float)r_time_running;
 
-		reads += r->return_value.value * of_mul_read * SCALE;
+		reads += return_value.value * of_mul_read * SCALE;
 	}
 
 	*bw_imc = reads;
-- 
2.50.1

