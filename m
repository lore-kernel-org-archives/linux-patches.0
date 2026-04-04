Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A27D2BD0B
	for <patches@lists.linux.dev>; Sat,  4 Apr 2026 01:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775267808; cv=none; b=bBDuXtaZNS3SsZ/wG1MrwTTjGDSimux2ZyoNvNRViIjeD3CaLsMCMlXA3/0cswLjFsxPFAEUUcxWgOlISL5d/fqDBV8Kauad3Z71QJGeEY+s0EQYllaSK0eZNf+zZb/awoszHo9IDhajaE1s6fGxNy/+e98G3xDHVrtUJGaKVKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775267808; c=relaxed/simple;
	bh=5Qmoh1Ru8vMO1Nfg8X9L40uIhnik+WL6a07fapKwUMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QAug6+R8HR3rXKz9cCj3hEIef/XRUucJ5ufp4Lmm5XiAe0eF/puo8HbcdRM73Mv7miSjhczrelRHGyk0YC6rEZOMcD7ucfGmUwkRJawnkAQPl8zAXY3GBHufgo/jsA74zkjJW59yuwHYU+BU7B44hI22NWHXxzkP5GhWIB6wJ/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VPTb707X; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VPTb707X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775267806; x=1806803806;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5Qmoh1Ru8vMO1Nfg8X9L40uIhnik+WL6a07fapKwUMA=;
  b=VPTb707XCzf6aFEn1UgQjt9FFNS1Yo+8h2Qa83R2jFZOxzcXSgUEBeOO
   2KXQ3KDbGSOlHCyvjg1X21WUlZ1KdP74UWwNOESAgVjg8jAUWe4mbqtJp
   d8BBxjK8nX9iNokhlM6Ihz2Odhj4BwdM9QDcie9QSBEKxscGg0qwQivbu
   mXRNDHlDUeLapZSe51997hRVi8AGOCAj0QMA46cbu0SrakdeUa/8W79ht
   jJTU+crVSDYRxh2Lu8U+NHo9rYDnnBceZstMTNElV5KIQHAdpDvraXAWY
   NorpMw2e9pbF/WfrtwWXtltApETH+a3gYfiy6BuCr67DzPQXx9/URBIzx
   w==;
X-CSE-ConnectionGUID: 6T0BBTnnST6aCMwLBBtthQ==
X-CSE-MsgGUID: ne3i5E1iQamQXjkt1QOXHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11748"; a="76219361"
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="76219361"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 18:56:43 -0700
X-CSE-ConnectionGUID: GcyMdMu6S9K1URP1/S6AFA==
X-CSE-MsgGUID: Dikir7wlQBqP0Z41ZUEHuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="224121502"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 18:56:17 -0700
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
	jason.zeng@intel.com,
	reinette.chatre@intel.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v4 03/10] selftests/resctrl: Do not store iMC counter value in counter config structure
Date: Fri,  3 Apr 2026 18:56:02 -0700
Message-ID: <e0b6ad2755e2fd802f54b0bc07eeb90247baca19.1775266384.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1775266384.git.reinette.chatre@intel.com>
References: <cover.1775266384.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
just use a more aptly named "measurement" local variable for use during
event reading.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---
Changes since v2:
- Rename "return_value" -> "measurement". (Ilpo)
- Add Ilpo's Rb tag.
- Add Chen Yu's tag.
---
 tools/testing/selftests/resctrl/resctrl_val.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/resctrl/resctrl_val.c b/tools/testing/selftests/resctrl/resctrl_val.c
index a5a8badb83d4..71d6f88cc1f7 100644
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
+		struct membw_read_format measurement;
 		struct imc_counter_config *r =
 			&imc_counters_config[imc];
 
-		if (read(r->fd, &r->return_value,
-			 sizeof(struct membw_read_format)) == -1) {
+		if (read(r->fd, &measurement, sizeof(measurement)) == -1) {
 			ksft_perror("Couldn't get read bandwidth through iMC");
 			return -1;
 		}
 
-		__u64 r_time_enabled = r->return_value.time_enabled;
-		__u64 r_time_running = r->return_value.time_running;
+		__u64 r_time_enabled = measurement.time_enabled;
+		__u64 r_time_running = measurement.time_running;
 
 		if (r_time_enabled != r_time_running)
 			of_mul_read = (float)r_time_enabled /
 					(float)r_time_running;
 
-		reads += r->return_value.value * of_mul_read * SCALE;
+		reads += measurement.value * of_mul_read * SCALE;
 	}
 
 	*bw_imc = reads;
-- 
2.50.1

