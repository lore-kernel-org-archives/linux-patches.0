Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BE8248861
	for <patches@lists.linux.dev>; Thu, 26 Mar 2026 12:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774529788; cv=none; b=WKzMrDf+uxCUV3Qoqb9WoRaG3wZJARV4Y3ApwoqdDKXKIIcqC9mAwoBGD7PRa+MyYWEyypytOcSOAYJHjYbACJrl1W7blg/A7TVK9opQyKW9X2xf1yn6cW+tRY9climBOBiErS8Bn/dZ30fqDSgYYKKvJKGrLM8UiPdKjw5Nhcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774529788; c=relaxed/simple;
	bh=Tl33Yt/j+n6SMPnVz+COO3bxyNqqhjepX86GV2+tLyg=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=PyAydatnLSBcJHi6DnZKQs923fz50KAgfye8MW9mwKSWQVstGkNXIO8PZlDEYlc4ZklIIcRSI7swQdZB8Ca9/xfwzzO05DeT7YsSzcMnTY6nSDgACEWJ9MkhzEyKCA0wBrkS8bZGjCLOPvi7LLln2eMv1xMWooFKoKdMyR3jsVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O77BZhD6; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O77BZhD6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774529787; x=1806065787;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=Tl33Yt/j+n6SMPnVz+COO3bxyNqqhjepX86GV2+tLyg=;
  b=O77BZhD6nQvy6qSb22BrAu6bQtyMat43d11+OYHHIc31DaMbJ9oKjMgl
   CeR5MszrCOgrtmhUNqXijcQzS7ZT4aqqlsHu9B1Lb+0zk7v3ap7F97nfS
   +7SpJIEH3zxCirv3hHKMj3zS5Irf/E/BQQgOJXBAdrc+j0/MTZhNewHS2
   gBduHsLjmAnI65mCc89HsbYKBUyPFe7dwZ/MvmUADeUpz0Q+2LTZnGbA6
   QV8f2vWGXKShdOT18bMjQzCglf8tB8vTvcIj8KZzgQ2EB3BfPAsHEaiyv
   CuQzpMoqzQEaenbdXifv/kbys86t/EbbR8q+Oxk5Ri+U6y4anNQRCdnVj
   w==;
X-CSE-ConnectionGUID: hZaS5+w6RTqVniIMWcL3YQ==
X-CSE-MsgGUID: qRkYY8pmSbW3uIUqB47dDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11740"; a="75468228"
X-IronPort-AV: E=Sophos;i="6.23,142,1770624000"; 
   d="scan'208";a="75468228"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 05:56:26 -0700
X-CSE-ConnectionGUID: xrKg9aeuQ0KSlcJnqVc0og==
X-CSE-MsgGUID: fLp8ie9hS3ylN6UPq5KjQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,142,1770624000"; 
   d="scan'208";a="221688098"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.32])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 05:56:21 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Thu, 26 Mar 2026 14:56:18 +0200 (EET)
To: Reinette Chatre <reinette.chatre@intel.com>
cc: shuah@kernel.org, Dave.Martin@arm.com, james.morse@arm.com, 
    tony.luck@intel.com, babu.moger@amd.com, fenghuay@nvidia.com, 
    peternewman@google.com, zide.chen@intel.com, dapeng1.mi@linux.intel.com, 
    ben.horgan@arm.com, yu.c.chen@intel.com, jason.zeng@intel.com, 
    linux-kselftest@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, 
    patches@lists.linux.dev
Subject: Re: [PATCH v3 02/10] selftests/resctrl: Reduce interference from L2
 occupancy during cache occupancy test
In-Reply-To: <5a23acd72af3ea0513f730d7773108586f68c430.1773432891.git.reinette.chatre@intel.com>
Message-ID: <579d8a41-d6ec-8d9f-93b1-6a6f6312099e@linux.intel.com>
References: <cover.1773432891.git.reinette.chatre@intel.com> <5a23acd72af3ea0513f730d7773108586f68c430.1773432891.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-2032665295-1774529778=:986"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2032665295-1774529778=:986
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 13 Mar 2026, Reinette Chatre wrote:

> The CMT test creates a new control group that is also capable of monitori=
ng
> and assigns the workload to it. The workload allocates a buffer that by
> default fills a portion of the L3 and keeps reading from the buffer,
> measuring the L3 occupancy at intervals. The test passes if the workload'=
s
> L3 occupancy is within 15% of the buffer size.
>=20
> The CMT test does not take into account that some of the workload's data
> may land in L2/L1. Matching L3 occupancy to the size of the buffer while
> a portion of the buffer can be allocated into L2 is not accurate.
>=20
> Take the L2 cache into account to improve test accuracy:
>  - Reduce the workload's L2 cache allocation to the minimum on systems th=
at
>    support L2 cache allocation. Do so with a new utility in preparation f=
or
>    all L3 cache allocation tests needing the same capability.
>  - Increase the buffer size to accommodate data that may be allocated int=
o
>    the L2 cache. Use a buffer size double the L3 portion to keep using th=
e
>    L3 portion size as goal for L3 occupancy while taking into account tha=
t
>    some of the data may be in L2.
>=20
> Running the CMT test on a sample system while introducing significant
> cache misses using "stress-ng --matrix-3d 0 --matrix-3d-zyx" shows
> significant improvement in L3 cache occupancy:
>=20
> Before:
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
> After:
>     # Starting CMT test ...
>     # Mounting resctrl to "/sys/fs/resctrl"
>     # Cache size :335544320
>     # Writing benchmark parameters to resctrl FS
>     # Write schema "L3:0=3Dfffe0" to resctrl FS
>     # Write schema "L3:0=3D1f" to resctrl FS
>     # Write schema "L2:1=3D0x1" to resctrl FS
>     # Benchmark PID: 7171
>     # Checking for pass/fail
>     # Pass: Check cache miss rate within 15%
>     # Percent diff=3D0
>     # Number of bits: 5
>     # Average LLC val: 83755008
>     # Cache span (bytes): 83886080
>     ok 1 CMT: test
>=20
> Reported-by: Dave Martin <Dave.Martin@arm.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Tested-by: Chen Yu <yu.c.chen@intel.com>
> Link: https://lore.kernel.org/lkml/aO+7MeSMV29VdbQs@e133380.arm.com/
> ---
> Changes since v2:
> - New patch split from v1's "selftests/resctrl: Improve accuracy of cache
>   occupancy test". (Ilpo)
> - Reword changelog. (Ilpo)
> - Update data used in changelog to match code after patch split.
> - Introduce utility to reduce L2 cache allocation. (Ilpo)
> - Add Chen Yu's tag.
> ---
>  tools/testing/selftests/resctrl/cache.c    | 13 +++++++++++++
>  tools/testing/selftests/resctrl/cmt_test.c | 14 ++++++++++----
>  tools/testing/selftests/resctrl/resctrl.h  |  3 +++
>  3 files changed, 26 insertions(+), 4 deletions(-)
>=20
> diff --git a/tools/testing/selftests/resctrl/cache.c b/tools/testing/self=
tests/resctrl/cache.c
> index 1ff1104e6575..bef71b6feacc 100644
> --- a/tools/testing/selftests/resctrl/cache.c
> +++ b/tools/testing/selftests/resctrl/cache.c
> @@ -173,6 +173,19 @@ int measure_llc_resctrl(const char *filename, pid_t =
bm_pid)
>  =09return print_results_cache(filename, bm_pid, llc_occu_resc);
>  }
> =20
> +/*
> + * Reduce L2 allocation to minimum when testing L3 cache allocation.
> + */
> +int minimize_l2_occupancy(const struct resctrl_test *test,
> +=09=09=09  const struct user_params *uparams,
> +=09=09=09  const struct resctrl_val_param *param)
> +{
> +=09if (!strcmp(test->resource, "L3") && resctrl_resource_exists("L2"))
> +=09=09return write_schemata(param->ctrlgrp, "0x1", uparams->cpu, "L2");
> +
> +=09return 0;
> +}
> +
>  /*
>   * show_cache_info - Show generic cache test information
>   * @no_of_bits:=09=09Number of bits
> diff --git a/tools/testing/selftests/resctrl/cmt_test.c b/tools/testing/s=
elftests/resctrl/cmt_test.c
> index 7bc6cf49c1c5..ccb6fe881a94 100644
> --- a/tools/testing/selftests/resctrl/cmt_test.c
> +++ b/tools/testing/selftests/resctrl/cmt_test.c
> @@ -23,7 +23,9 @@
>   * Initialize capacity bitmasks (CBMs) of:
>   * - control group being tested per test parameters,
>   * - default resource group as inverse of control group being tested to =
prevent
> - *   other tasks from interfering with test.
> + *   other tasks from interfering with test,
> + * - L2 resource of control group being tested to minimize allocations i=
nto
> + *   L2 if possible to better predict L3 occupancy.
>   */
>  static int cmt_init(const struct resctrl_test *test,
>  =09=09    const struct user_params *uparams,
> @@ -46,7 +48,11 @@ static int cmt_init(const struct resctrl_test *test,
>  =09=09return ret;
> =20
>  =09snprintf(schemata, sizeof(schemata), "%lx", param->mask);
> -=09return write_schemata(param->ctrlgrp, schemata, uparams->cpu, test->r=
esource);
> +=09ret =3D write_schemata(param->ctrlgrp, schemata, uparams->cpu, test->=
resource);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09return minimize_l2_occupancy(test, uparams, param);
>  }
> =20
>  static int cmt_setup(const struct resctrl_test *test,
> @@ -175,11 +181,11 @@ static int cmt_run_test(const struct resctrl_test *=
test, const struct user_param
>  =09span =3D cache_portion_size(cache_total_size, param.mask, long_mask);
> =20
>  =09if (uparams->fill_buf) {
> -=09=09fill_buf.buf_size =3D span;
> +=09=09fill_buf.buf_size =3D span * 2;
>  =09=09fill_buf.memflush =3D uparams->fill_buf->memflush;
>  =09=09param.fill_buf =3D &fill_buf;
>  =09} else if (!uparams->benchmark_cmd[0]) {
> -=09=09fill_buf.buf_size =3D span;
> +=09=09fill_buf.buf_size =3D span * 2;
>  =09=09fill_buf.memflush =3D true;
>  =09=09param.fill_buf =3D &fill_buf;
>  =09}
> diff --git a/tools/testing/selftests/resctrl/resctrl.h b/tools/testing/se=
lftests/resctrl/resctrl.h
> index c72045c74ac4..7f2ab28be857 100644
> --- a/tools/testing/selftests/resctrl/resctrl.h
> +++ b/tools/testing/selftests/resctrl/resctrl.h
> @@ -216,6 +216,9 @@ int perf_event_reset_enable(int pe_fd);
>  int perf_event_measure(int pe_fd, struct perf_event_read *pe_read,
>  =09=09       const char *filename, pid_t bm_pid);
>  int measure_llc_resctrl(const char *filename, pid_t bm_pid);
> +int minimize_l2_occupancy(const struct resctrl_test *test,
> +=09=09=09  const struct user_params *uparams,
> +=09=09=09  const struct resctrl_val_param *param);
>  void show_cache_info(int no_of_bits, __u64 avg_llc_val, size_t cache_spa=
n, bool lines);
> =20
>  /*
>=20

Reviewed-by: Ilpo J=E4rvinen <ilpo.jarvinen@linux.intel.com>

--=20
 i.

--8323328-2032665295-1774529778=:986--
