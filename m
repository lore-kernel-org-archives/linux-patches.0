Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D332C21EC
	for <patches@lists.linux.dev>; Sat,  4 Apr 2026 01:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775267808; cv=none; b=kyIvwthnotZEUgW3VHzo8dH8SexDJliaMDK26S4ot0pam1ZNjDQiA4aA8Zqin3kYASXJ+hAkddbWYT0TkjOeLej+xDSC9Nix3/AD8iTKDtFEMZRA1UHPeptgCMI66iL97df516XRLY4AJ1K0SEiCMERaVNtDKgK1Jh75zI3mb1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775267808; c=relaxed/simple;
	bh=fK5XQeBQzWMAEfkpexHViEcwK3WoZrQhjXaLzGSiMDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z4b7YkcXjC96iu+ivk4vvqF3gwUuv4OTiBkL8Q0a6BqIyk+3KzOOcSa8qm/zcwY8zt/VeGeSL69vuZXLw35g0Qt/0he0J98bQRIrwpklPzz16WIjbrAKAuaZBCOY2T9cKep9TkYxJynarQYKlmmUJpYrfywajm0hK5dRR1cUwpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nh/+1wal; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nh/+1wal"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775267806; x=1806803806;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fK5XQeBQzWMAEfkpexHViEcwK3WoZrQhjXaLzGSiMDA=;
  b=nh/+1walg23ir+9qpqbiZ4Xc25NTtTIF8bV4YX+m/f1z8jtFF70dlcn4
   UYfxJ57tFqMLbmJsy0wg3O7CDY+WFN8NIsiIn/+aOHHxAN5HMiD4ML6Hj
   edm+Z3/nRO4L3sOO7+WR72ApdI1wfObGmXMhRzMktdYQn8UEvdr8AP/2U
   FoE9BTLgiVDRrYvF26vNMP0A1ZSlxoQbrxOqA/i6M5DWHzGPio5y4PfQ/
   MkjF7nom7OCAQrb5EDpZI+299MGV97Rd8643sBoTDfQokOZvnNNoKXkWw
   rh/V4i8Qb22M7/8E4bQVCF8rZrwAQO9Dv7zJB8/oF9WtgEzhPNXq0D9/3
   Q==;
X-CSE-ConnectionGUID: WAUwXGGNSFWRBPgP82m20A==
X-CSE-MsgGUID: ChizVYsYTNutusjZ/0w0Hw==
X-IronPort-AV: E=McAfee;i="6800,10657,11748"; a="76219360"
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="76219360"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 18:56:43 -0700
X-CSE-ConnectionGUID: Lxh12dmoT/enq5S79zXJlQ==
X-CSE-MsgGUID: fjY+0pJ6Szywgp6MS4Ev2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="224121495"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 18:56:16 -0700
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
Subject: [PATCH v4 01/10] selftests/resctrl: Improve accuracy of cache occupancy test
Date: Fri,  3 Apr 2026 18:56:00 -0700
Message-ID: <b160592179f88069cdc679563e152007998a0d76.1775266384.git.reinette.chatre@intel.com>
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

Dave Martin reported inconsistent CMT test failures. In one experiment
the first run of the CMT test failed because of too large (24%) difference
between measured and achievable cache occupancy while the second run passed
with an acceptable 4% difference.

The CMT test is susceptible to interference from the rest of the system.
This can be demonstrated with a utility like stress-ng by running the CMT
test while introducing cache misses using:

   stress-ng --matrix-3d 0 --matrix-3d-zyx

Below shows an example of the CMT test failing because of a significant
difference between measured and achievable cache occupancy when run with
interference:
    # Starting CMT test ...
    # Mounting resctrl to "/sys/fs/resctrl"
    # Cache size :335544320
    # Writing benchmark parameters to resctrl FS
    # Benchmark PID: 7011
    # Checking for pass/fail
    # Fail: Check cache miss rate within 15%
    # Percent diff=99
    # Number of bits: 5
    # Average LLC val: 235929
    # Cache span (bytes): 83886080
    not ok 1 CMT: test

The CMT test creates a new control group that is also capable of monitoring
and assigns the workload to it. The workload allocates a buffer that by
default fills a portion of the L3 and keeps reading from the buffer,
measuring the L3 occupancy at intervals. The test passes if the workload's
L3 occupancy is within 15% of the buffer size.

By not adjusting any capacity bitmasks the workload shares the cache with
the rest of the system. Any other task that may be running could evict
the workload's data from the cache causing it to have low cache occupancy.

Reduce interference from the rest of the system by ensuring that the
workload's control group uses the capacity bitmask found in the user
parameters for L3 and that the rest of the system can only allocate into
the inverse of the workload's L3 cache portion. Other tasks can thus no
longer evict the workload's data from L3.

With the above adjustments the CMT test is more consistent. Repeating the
CMT test while generating interference with stress-ng on a sample
system after applying the fixes show significant improvement in test
accuracy:

    # Starting CMT test ...
    # Mounting resctrl to "/sys/fs/resctrl"
    # Cache size :335544320
    # Writing benchmark parameters to resctrl FS
    # Write schema "L3:0=fffe0" to resctrl FS
    # Write schema "L3:0=1f" to resctrl FS
    # Benchmark PID: 7089
    # Checking for pass/fail
    # Pass: Check cache miss rate within 15%
    # Percent diff=12
    # Number of bits: 5
    # Average LLC val: 73269248
    # Cache span (bytes): 83886080
    ok 1 CMT: test

Reported-by: Dave Martin <Dave.Martin@arm.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/lkml/aO+7MeSMV29VdbQs@e133380.arm.com/
---
Changes since v1:
- Fix typo in changelog: "data my be in L2" -> "data may be in L2".

Changes since v2:
- Split patch to separate changes impacting L3 and L2 resource. (Ilpo)
- Re-run tests after patch split to ensure test impact match patch
  and update changelog with refreshed data.
- Since fix is now split across two patches: "Closes:" -> "Link:"
- Rename "long_mask" to "full_mask". (Ilpo)
- Add Chen Yu's tag.

Changes since v3:
- Add Ilpo's RB tag.
---
 tools/testing/selftests/resctrl/cmt_test.c    | 26 +++++++++++++++++--
 tools/testing/selftests/resctrl/mba_test.c    |  4 ++-
 tools/testing/selftests/resctrl/mbm_test.c    |  4 ++-
 tools/testing/selftests/resctrl/resctrl.h     |  4 ++-
 tools/testing/selftests/resctrl/resctrl_val.c |  2 +-
 5 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/resctrl/cmt_test.c b/tools/testing/selftests/resctrl/cmt_test.c
index d09e693dc739..7bc6cf49c1c5 100644
--- a/tools/testing/selftests/resctrl/cmt_test.c
+++ b/tools/testing/selftests/resctrl/cmt_test.c
@@ -19,12 +19,34 @@
 #define CON_MON_LCC_OCCUP_PATH		\
 	"%s/%s/mon_data/mon_L3_%02d/llc_occupancy"
 
-static int cmt_init(const struct resctrl_val_param *param, int domain_id)
+/*
+ * Initialize capacity bitmasks (CBMs) of:
+ * - control group being tested per test parameters,
+ * - default resource group as inverse of control group being tested to prevent
+ *   other tasks from interfering with test.
+ */
+static int cmt_init(const struct resctrl_test *test,
+		    const struct user_params *uparams,
+		    const struct resctrl_val_param *param, int domain_id)
 {
+	unsigned long full_mask;
+	char schemata[64];
+	int ret;
+
 	sprintf(llc_occup_path, CON_MON_LCC_OCCUP_PATH, RESCTRL_PATH,
 		param->ctrlgrp, domain_id);
 
-	return 0;
+	ret = get_full_cbm(test->resource, &full_mask);
+	if (ret)
+		return ret;
+
+	snprintf(schemata, sizeof(schemata), "%lx", ~param->mask & full_mask);
+	ret = write_schemata("", schemata, uparams->cpu, test->resource);
+	if (ret)
+		return ret;
+
+	snprintf(schemata, sizeof(schemata), "%lx", param->mask);
+	return write_schemata(param->ctrlgrp, schemata, uparams->cpu, test->resource);
 }
 
 static int cmt_setup(const struct resctrl_test *test,
diff --git a/tools/testing/selftests/resctrl/mba_test.c b/tools/testing/selftests/resctrl/mba_test.c
index c7e9adc0368f..cd4c715b7ffd 100644
--- a/tools/testing/selftests/resctrl/mba_test.c
+++ b/tools/testing/selftests/resctrl/mba_test.c
@@ -17,7 +17,9 @@
 #define ALLOCATION_MIN		10
 #define ALLOCATION_STEP		10
 
-static int mba_init(const struct resctrl_val_param *param, int domain_id)
+static int mba_init(const struct resctrl_test *test,
+		    const struct user_params *uparams,
+		    const struct resctrl_val_param *param, int domain_id)
 {
 	int ret;
 
diff --git a/tools/testing/selftests/resctrl/mbm_test.c b/tools/testing/selftests/resctrl/mbm_test.c
index 84d8bc250539..58201f844740 100644
--- a/tools/testing/selftests/resctrl/mbm_test.c
+++ b/tools/testing/selftests/resctrl/mbm_test.c
@@ -83,7 +83,9 @@ static int check_results(size_t span)
 	return ret;
 }
 
-static int mbm_init(const struct resctrl_val_param *param, int domain_id)
+static int mbm_init(const struct resctrl_test *test,
+		    const struct user_params *uparams,
+		    const struct resctrl_val_param *param, int domain_id)
 {
 	int ret;
 
diff --git a/tools/testing/selftests/resctrl/resctrl.h b/tools/testing/selftests/resctrl/resctrl.h
index afe635b6e48d..c72045c74ac4 100644
--- a/tools/testing/selftests/resctrl/resctrl.h
+++ b/tools/testing/selftests/resctrl/resctrl.h
@@ -135,7 +135,9 @@ struct resctrl_val_param {
 	char			filename[64];
 	unsigned long		mask;
 	int			num_of_runs;
-	int			(*init)(const struct resctrl_val_param *param,
+	int			(*init)(const struct resctrl_test *test,
+					const struct user_params *uparams,
+					const struct resctrl_val_param *param,
 					int domain_id);
 	int			(*setup)(const struct resctrl_test *test,
 					 const struct user_params *uparams,
diff --git a/tools/testing/selftests/resctrl/resctrl_val.c b/tools/testing/selftests/resctrl/resctrl_val.c
index 7c08e936572d..a5a8badb83d4 100644
--- a/tools/testing/selftests/resctrl/resctrl_val.c
+++ b/tools/testing/selftests/resctrl/resctrl_val.c
@@ -569,7 +569,7 @@ int resctrl_val(const struct resctrl_test *test,
 		goto reset_affinity;
 
 	if (param->init) {
-		ret = param->init(param, domain_id);
+		ret = param->init(test, uparams, param, domain_id);
 		if (ret)
 			goto reset_affinity;
 	}
-- 
2.50.1

