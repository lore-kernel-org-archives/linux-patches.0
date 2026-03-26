Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668562D9EDB
	for <patches@lists.linux.dev>; Thu, 26 Mar 2026 12:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774529105; cv=none; b=dlvyS/mMGB+6jEcQoNdv8jwbifKQwsToKcd7MCzfSr7/oqEbBx5ETCKVReTGH+QFYJCTFctHaZx2tQ8E9F+DjU+blNDBYhazYIu7J2YuGi19OTauRcPm8QSdY/aJJ7Z2HrsZ89ZOeHImG6ZgwbX50f9dv284Wfsia31oCoWwYGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774529105; c=relaxed/simple;
	bh=SO6TFPSKJMDkACDMt+JwPXadw7yzJu+DZzwq18e6r5Q=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=gxYhB4nT4qWRQh5I9Tpyj++GMQqWpwNY/qwzOJCkrl4n/U3lcAuBG4ImQK6HXV763VSHvOcaw2RjL6S5uXkb7nIFShLafsIM4G4hC8X9b7vqNKmtOuPktF2Agj7PYJp6WG/vpWPRtnm71yFCGS/QlnxVUoEouFCgdx6HKU1iDxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jRzYojkh; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jRzYojkh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774529103; x=1806065103;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=SO6TFPSKJMDkACDMt+JwPXadw7yzJu+DZzwq18e6r5Q=;
  b=jRzYojkhMSpyeaDZXcPPKJgi01MiI6qZV6KgzJP8NoxCF5J5KJ7P2Noy
   C9LwO8f/zZm9zuOlbWQ/jgvpLMsqcPt9CZer1tdGlSEYCXxb4ooaRJkxB
   ak39itThyFnfXQNCiZm9vDElt7BwI/gtTrrjFnIRkK1KjqwqWIeNY45fW
   KuPyxv3ELYotKwGPwpYfe4SOvhEEudV4QN3zSG4XQ97PLuR5MQjDGuZUi
   Fi+Sk0h5h/faInlEw6/WmTww19RBUYRDoT5WReCHRU9cNd351obFemPU4
   lAF/d2yl0DWsZT/Gh/x8/WK+ElJUicPBVSPrp5bE4e2PiMZ9BW8auWy54
   A==;
X-CSE-ConnectionGUID: 9RFvIrSmQBuYO1Rwl7WKlw==
X-CSE-MsgGUID: 7xQP8JrMRlCMoCvUtiKprg==
X-IronPort-AV: E=McAfee;i="6800,10657,11740"; a="101040611"
X-IronPort-AV: E=Sophos;i="6.23,142,1770624000"; 
   d="scan'208";a="101040611"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 05:45:03 -0700
X-CSE-ConnectionGUID: wyLT6F8pRIimXjMJpO/zMA==
X-CSE-MsgGUID: 1I1kRnM9RgKFv5NOqD0PcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,142,1770624000"; 
   d="scan'208";a="229063184"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.32])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 05:44:56 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Thu, 26 Mar 2026 14:44:52 +0200 (EET)
To: Reinette Chatre <reinette.chatre@intel.com>
cc: shuah@kernel.org, Dave.Martin@arm.com, james.morse@arm.com, 
    tony.luck@intel.com, babu.moger@amd.com, fenghuay@nvidia.com, 
    peternewman@google.com, zide.chen@intel.com, dapeng1.mi@linux.intel.com, 
    ben.horgan@arm.com, yu.c.chen@intel.com, jason.zeng@intel.com, 
    linux-kselftest@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, 
    patches@lists.linux.dev
Subject: Re: [PATCH v3 01/10] selftests/resctrl: Improve accuracy of cache
 occupancy test
In-Reply-To: <b632cf0bad98f501079748346cb2e1dae120237d.1773432891.git.reinette.chatre@intel.com>
Message-ID: <7c10d8a4-cf81-aeea-4573-5d22ea39624c@linux.intel.com>
References: <cover.1773432891.git.reinette.chatre@intel.com> <b632cf0bad98f501079748346cb2e1dae120237d.1773432891.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1626447140-1774529092=:986"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1626447140-1774529092=:986
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 13 Mar 2026, Reinette Chatre wrote:

> Dave Martin reported inconsistent CMT test failures. In one experiment
> the first run of the CMT test failed because of too large (24%) differenc=
e
> between measured and achievable cache occupancy while the second run pass=
ed
> with an acceptable 4% difference.
>=20
> The CMT test is susceptible to interference from the rest of the system.
> This can be demonstrated with a utility like stress-ng by running the CMT
> test while introducing cache misses using:
>=20
>    stress-ng --matrix-3d 0 --matrix-3d-zyx
>=20
> Below shows an example of the CMT test failing because of a significant
> difference between measured and achievable cache occupancy when run with
> interference:
>     # Starting CMT test ...
>     # Mounting resctrl to "/sys/fs/resctrl"
>     # Cache size :335544320
>     # Writing benchmark parameters to resctrl FS
>     # Benchmark PID: 7011
>     # Checking for pass/fail
>     # Fail: Check cache miss rate within 15%
>     # Percent diff=3D99
>     # Number of bits: 5
>     # Average LLC val: 235929
>     # Cache span (bytes): 83886080
>     not ok 1 CMT: test
>=20
> The CMT test creates a new control group that is also capable of monitori=
ng
> and assigns the workload to it. The workload allocates a buffer that by
> default fills a portion of the L3 and keeps reading from the buffer,
> measuring the L3 occupancy at intervals. The test passes if the workload'=
s
> L3 occupancy is within 15% of the buffer size.
>=20
> By not adjusting any capacity bitmasks the workload shares the cache with
> the rest of the system. Any other task that may be running could evict
> the workload's data from the cache causing it to have low cache occupancy=
=2E
>=20
> Reduce interference from the rest of the system by ensuring that the
> workload's control group uses the capacity bitmask found in the user
> parameters for L3 and that the rest of the system can only allocate into
> the inverse of the workload's L3 cache portion. Other tasks can thus no
> longer evict the workload's data from L3.
>=20
> With the above adjustments the CMT test is more consistent. Repeating the
> CMT test while generating interference with stress-ng on a sample
> system after applying the fixes show significant improvement in test
> accuracy:
>=20
>     # Starting CMT test ...
>     # Mounting resctrl to "/sys/fs/resctrl"
>     # Cache size :335544320
>     # Writing benchmark parameters to resctrl FS
>     # Write schema "L3:0=3Dfffe0" to resctrl FS
>     # Write schema "L3:0=3D1f" to resctrl FS
>     # Benchmark PID: 7089
>     # Checking for pass/fail
>     # Pass: Check cache miss rate within 15%
>     # Percent diff=3D12
>     # Number of bits: 5
>     # Average LLC val: 73269248
>     # Cache span (bytes): 83886080
>     ok 1 CMT: test
>=20
> Reported-by: Dave Martin <Dave.Martin@arm.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Tested-by: Chen Yu <yu.c.chen@intel.com>
> Link: https://lore.kernel.org/lkml/aO+7MeSMV29VdbQs@e133380.arm.com/
> ---
> Changes since v1:
> - Fix typo in changelog: "data my be in L2" -> "data may be in L2".
>=20
> Changes since v2:
> - Split patch to separate changes impacting L3 and L2 resource. (Ilpo)
> - Re-run tests after patch split to ensure test impact match patch
>   and update changelog with refreshed data.
> - Since fix is now split across two patches: "Closes:" -> "Link:"
> - Rename "long_mask" to "full_mask". (Ilpo)
> - Add Chen Yu's tag.
> ---
>  tools/testing/selftests/resctrl/cmt_test.c    | 26 +++++++++++++++++--
>  tools/testing/selftests/resctrl/mba_test.c    |  4 ++-
>  tools/testing/selftests/resctrl/mbm_test.c    |  4 ++-
>  tools/testing/selftests/resctrl/resctrl.h     |  4 ++-
>  tools/testing/selftests/resctrl/resctrl_val.c |  2 +-
>  5 files changed, 34 insertions(+), 6 deletions(-)
>=20
> diff --git a/tools/testing/selftests/resctrl/cmt_test.c b/tools/testing/s=
elftests/resctrl/cmt_test.c
> index d09e693dc739..7bc6cf49c1c5 100644
> --- a/tools/testing/selftests/resctrl/cmt_test.c
> +++ b/tools/testing/selftests/resctrl/cmt_test.c
> @@ -19,12 +19,34 @@
>  #define CON_MON_LCC_OCCUP_PATH=09=09\
>  =09"%s/%s/mon_data/mon_L3_%02d/llc_occupancy"
> =20
> -static int cmt_init(const struct resctrl_val_param *param, int domain_id=
)
> +/*
> + * Initialize capacity bitmasks (CBMs) of:
> + * - control group being tested per test parameters,
> + * - default resource group as inverse of control group being tested to =
prevent
> + *   other tasks from interfering with test.
> + */
> +static int cmt_init(const struct resctrl_test *test,
> +=09=09    const struct user_params *uparams,
> +=09=09    const struct resctrl_val_param *param, int domain_id)
>  {
> +=09unsigned long full_mask;
> +=09char schemata[64];
> +=09int ret;
> +
>  =09sprintf(llc_occup_path, CON_MON_LCC_OCCUP_PATH, RESCTRL_PATH,
>  =09=09param->ctrlgrp, domain_id);
> =20
> -=09return 0;
> +=09ret =3D get_full_cbm(test->resource, &full_mask);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09snprintf(schemata, sizeof(schemata), "%lx", ~param->mask & full_mask)=
;
> +=09ret =3D write_schemata("", schemata, uparams->cpu, test->resource);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09snprintf(schemata, sizeof(schemata), "%lx", param->mask);
> +=09return write_schemata(param->ctrlgrp, schemata, uparams->cpu, test->r=
esource);
>  }
> =20
>  static int cmt_setup(const struct resctrl_test *test,
> diff --git a/tools/testing/selftests/resctrl/mba_test.c b/tools/testing/s=
elftests/resctrl/mba_test.c
> index c7e9adc0368f..cd4c715b7ffd 100644
> --- a/tools/testing/selftests/resctrl/mba_test.c
> +++ b/tools/testing/selftests/resctrl/mba_test.c
> @@ -17,7 +17,9 @@
>  #define ALLOCATION_MIN=09=0910
>  #define ALLOCATION_STEP=09=0910
> =20
> -static int mba_init(const struct resctrl_val_param *param, int domain_id=
)
> +static int mba_init(const struct resctrl_test *test,
> +=09=09    const struct user_params *uparams,
> +=09=09    const struct resctrl_val_param *param, int domain_id)
>  {
>  =09int ret;
> =20
> diff --git a/tools/testing/selftests/resctrl/mbm_test.c b/tools/testing/s=
elftests/resctrl/mbm_test.c
> index 84d8bc250539..58201f844740 100644
> --- a/tools/testing/selftests/resctrl/mbm_test.c
> +++ b/tools/testing/selftests/resctrl/mbm_test.c
> @@ -83,7 +83,9 @@ static int check_results(size_t span)
>  =09return ret;
>  }
> =20
> -static int mbm_init(const struct resctrl_val_param *param, int domain_id=
)
> +static int mbm_init(const struct resctrl_test *test,
> +=09=09    const struct user_params *uparams,
> +=09=09    const struct resctrl_val_param *param, int domain_id)
>  {
>  =09int ret;
> =20
> diff --git a/tools/testing/selftests/resctrl/resctrl.h b/tools/testing/se=
lftests/resctrl/resctrl.h
> index afe635b6e48d..c72045c74ac4 100644
> --- a/tools/testing/selftests/resctrl/resctrl.h
> +++ b/tools/testing/selftests/resctrl/resctrl.h
> @@ -135,7 +135,9 @@ struct resctrl_val_param {
>  =09char=09=09=09filename[64];
>  =09unsigned long=09=09mask;
>  =09int=09=09=09num_of_runs;
> -=09int=09=09=09(*init)(const struct resctrl_val_param *param,
> +=09int=09=09=09(*init)(const struct resctrl_test *test,
> +=09=09=09=09=09const struct user_params *uparams,
> +=09=09=09=09=09const struct resctrl_val_param *param,
>  =09=09=09=09=09int domain_id);
>  =09int=09=09=09(*setup)(const struct resctrl_test *test,
>  =09=09=09=09=09 const struct user_params *uparams,
> diff --git a/tools/testing/selftests/resctrl/resctrl_val.c b/tools/testin=
g/selftests/resctrl/resctrl_val.c
> index 7c08e936572d..a5a8badb83d4 100644
> --- a/tools/testing/selftests/resctrl/resctrl_val.c
> +++ b/tools/testing/selftests/resctrl/resctrl_val.c
> @@ -569,7 +569,7 @@ int resctrl_val(const struct resctrl_test *test,
>  =09=09goto reset_affinity;
> =20
>  =09if (param->init) {
> -=09=09ret =3D param->init(param, domain_id);
> +=09=09ret =3D param->init(test, uparams, param, domain_id);
>  =09=09if (ret)
>  =09=09=09goto reset_affinity;
>  =09}
>=20

Reviewed-by: Ilpo J=E4rvinen <ilpo.jarvinen@linux.intel.com>

--=20
 i.

--8323328-1626447140-1774529092=:986--
