Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9A630CDB0
	for <patches@lists.linux.dev>; Tue, 10 Feb 2026 16:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770741390; cv=none; b=XduniZX7x333vczx2uYHBQFQro+y5zBgAWtYzwoS0E9MPFQsgBsl6BmrG2hgNsFDquzrRB4nvyJ6b6PDSg+7s9fnaFj1zCOUijuXLw79yJk2RgPtcc0DsTt/6j+LqfB9n00wjS0rgs0r4bHoThIJ6rkpYv0qAzj4Bweiwcw2mKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770741390; c=relaxed/simple;
	bh=3ef+JIZyk1BCpaoxZjYIa2McjH4xu833l3yMdDsAq/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRs7S9p8TjlETw0d/cfe2WcwlWU0YvdxnrVF9gSy6PpqpxgczZTbJSwCvZQz5TBqRbeaO3Azi7LpkwZeAclKqeuJM3PHTweKOhiM82YHHsbStu/KHpkW6a0TEGIHCsz+WP8hfr/dJeYoUHMwQQSAj8nheFD3ej8mQeJ1IJYJlYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=elfAysvT; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="elfAysvT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770741389; x=1802277389;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3ef+JIZyk1BCpaoxZjYIa2McjH4xu833l3yMdDsAq/Y=;
  b=elfAysvTStnZBuL/pO06nz5ux1rWrs0CmksgG0L6TISAYB8H9dcln3zC
   fRiIrDyjin1RzrhX5mE1j6+hliDY/ih54FbcgsStRAfe6BScWtox6iIfZ
   j8Psqk/uQt0mPjxpEXlvNlv0bSitGliusElwTgKjlfsJvbN26oB4NeEYz
   ixKqQYxxuMq5i7e5Bv0pxrzs3TEFrAltFJna9t3Ed/b36ev0NRRQGz3gA
   0NIcY6VvVO8oxSFt1vXnAwy2NkJJgT3fxxHX8bq5JfyPNIdJ4iW1D+1kZ
   aMGUOBUnsAS+5AFc4jsaXt5xWlCdUWDMyVaqqNLQ3st+WZcqWiQDg+LRg
   g==;
X-CSE-ConnectionGUID: seEm/m8DSA2xwfDGkVqI5g==
X-CSE-MsgGUID: hbfRL8kBQ5+hpraqiWVS6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="74476820"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="74476820"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 08:36:27 -0800
X-CSE-ConnectionGUID: YMCSJ/bjSEeqsKMHZ8nHqg==
X-CSE-MsgGUID: cavmhqYVSBW8yQyiAUPhgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="212003454"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 08:36:26 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: shuah@kernel.org,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	tony.luck@intel.com,
	peternewman@google.com,
	babu.moger@amd.com,
	ilpo.jarvinen@linux.intel.com
Cc: zide.chen@intel.com,
	dapeng1.mi@linux.intel.com,
	fenghuay@nvidia.com,
	reinette.chatre@intel.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 1/8] selftests/resctrl: Do not store iMC counter value in counter config structure
Date: Tue, 10 Feb 2026 08:50:40 -0800
Message-ID: <c7d581bad963f20ac0d3738939874050d4dcc924.1770406608.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1770406608.git.reinette.chatre@intel.com>
References: <cover.1770406608.git.reinette.chatre@intel.com>
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

