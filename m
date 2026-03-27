Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48872BEC2A
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 17:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632910; cv=none; b=atAGxGq+sfk8VK2n0RowfB0kT3M3Hmljl5/6jN0jsHn7t0OX1sFy3ytUwI8v3vB4DEIY5jLwUUGq7DrOylb2nGW+Z2fSLHzisR0lffOoktLwfjSBXddwpJXM+mGmDW9nfdbaMCi6vALQMgZh5KGHQrKICtECjFLek4FfwiCZBXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632910; c=relaxed/simple;
	bh=g4tN38ZQdvBNUKmLr8XIM93tcq62pCUYXnI/PtosVuI=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=bBp021pAzG5WVPQA0ikYJd3bq0lxaM1pIkMb+4qPnm4jMvw7+F+/+j9BOrMecgFDjtPLYHGDAJXqcEd9t3uGmmkMUv2H0JEVbOKqeq+LHfn2X0hTvqzobpTA4mLrOOkxo9t5ApJFd5qG9qv3Cne0/QNaRyrMRVFUPUwxY16qEhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PvpiscmW; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PvpiscmW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774632909; x=1806168909;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=g4tN38ZQdvBNUKmLr8XIM93tcq62pCUYXnI/PtosVuI=;
  b=PvpiscmW1Mp192CHBKJc9a4GgZnPvWOvzs3zajvMCxAuxcm4q1yBXGAJ
   7tY8CbiY/EiU+p9fDYfV132U0KQegk53oJ3c6UksuAWdqnwH2YFpRTF2Y
   JzXPgOL65IAsHVLTx2Y7nhBfuO7vBLoDnb3M7a89pWDlFS1g4pXASN/w0
   64Y9gLqLQySaWRBREjyvX/QNs6PrlzGmiLy6jV8CbFuVYdxqySFADmGvz
   HGbYmXLolVaBWGYu9l19UxvSYTF+u/ehNtTPsmDbh0BnWKOsuBf7yLW8J
   kHfzhjviR/5EJxSvt2vu2Y/kBLjqojYeWJsfHqHYKi4X9eIIgYM8FpUQI
   Q==;
X-CSE-ConnectionGUID: gigVthPiSOq6hlGYmF6r2Q==
X-CSE-MsgGUID: C3hvXAj9T9KsJq2l5/+hUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="74742670"
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="74742670"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 10:34:55 -0700
X-CSE-ConnectionGUID: 98+cuf0TSWCMZEK/kDz0Tw==
X-CSE-MsgGUID: kyUtY0oORL+lvJpKHGpK5Q==
X-ExtLoop1: 1
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.186])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 10:34:49 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Fri, 27 Mar 2026 19:34:46 +0200 (EET)
To: Reinette Chatre <reinette.chatre@intel.com>
cc: shuah@kernel.org, Dave.Martin@arm.com, james.morse@arm.com, 
    tony.luck@intel.com, babu.moger@amd.com, ilpo.jarvinen@linux.intel.com, 
    fenghuay@nvidia.com, peternewman@google.com, zide.chen@intel.com, 
    dapeng1.mi@linux.intel.com, ben.horgan@arm.com, yu.c.chen@intel.com, 
    jason.zeng@intel.com, linux-kselftest@vger.kernel.org, 
    linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v3 07/10] selftests/resctrl: Raise threshold at which
 MBM and PMU values are compared
In-Reply-To: <1bdca244a899a605c1ddd701a09d6a9d0c242856.1773432891.git.reinette.chatre@intel.com>
Message-ID: <c5dd1a0f-ed9d-d5c0-8b7a-25992ae713ab@linux.intel.com>
References: <cover.1773432891.git.reinette.chatre@intel.com> <1bdca244a899a605c1ddd701a09d6a9d0c242856.1773432891.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-263950525-1774632886=:1037"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-263950525-1774632886=:1037
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 13 Mar 2026, Reinette Chatre wrote:

> commit 501cfdba0a40 ("selftests/resctrl: Do not compare performance

Should start with a capital letter.

> counters and resctrl at low bandwidth") introduced a threshold under whic=
h
> memory bandwidth values from MBM and performance counters are not compare=
d.
> This is needed because MBM and the PMUs do not have an identical view of
> memory bandwidth since PMUs can count all memory traffic while MBM does n=
ot
> count "overhead" (for example RAS) traffic that cannot be attributed to a=
n
> RMID. As a ratio this difference in view of memory bandwidth is pronounce=
d
> at low memory bandwidths.
>=20
> The 750MiB threshold was chosen arbitrarily after comparisons on differen=
t
> platforms. Exposed to more platforms after introduction this threshold ha=
s
> proven to be inadequate.
>=20
> Having accurate comparison between performance counters and MBM requires
> careful management of system load as well as control of features that
> introduce extra memory traffic, for example, patrol scrub. This is not
> appropriate for the resctrl selftests that are intended to run on a
> variety of systems with various configurations.
>=20
> Increase the memory bandwidth threshold under which no comparison is made
> between performance counters and MBM. Add additional leniency by increasi=
ng
> the percentage of difference that will be tolerated between these counts.
>=20
> There is no impact to the validity of the resctrl selftests results as a
> measure of resctrl subsystem health.
>=20
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Tested-by: Chen Yu <yu.c.chen@intel.com>
> ---
> Changes since v2:
> - Add Chen Yu's tag.
> ---
>  tools/testing/selftests/resctrl/mba_test.c | 2 +-
>  tools/testing/selftests/resctrl/mbm_test.c | 2 +-
>  tools/testing/selftests/resctrl/resctrl.h  | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/tools/testing/selftests/resctrl/mba_test.c b/tools/testing/s=
elftests/resctrl/mba_test.c
> index cd4c715b7ffd..39cee9898359 100644
> --- a/tools/testing/selftests/resctrl/mba_test.c
> +++ b/tools/testing/selftests/resctrl/mba_test.c
> @@ -12,7 +12,7 @@
> =20
>  #define RESULT_FILE_NAME=09"result_mba"
>  #define NUM_OF_RUNS=09=095
> -#define MAX_DIFF_PERCENT=098
> +#define MAX_DIFF_PERCENT=0915
>  #define ALLOCATION_MAX=09=09100
>  #define ALLOCATION_MIN=09=0910
>  #define ALLOCATION_STEP=09=0910
> diff --git a/tools/testing/selftests/resctrl/mbm_test.c b/tools/testing/s=
elftests/resctrl/mbm_test.c
> index 58201f844740..6dbbc3b76003 100644
> --- a/tools/testing/selftests/resctrl/mbm_test.c
> +++ b/tools/testing/selftests/resctrl/mbm_test.c
> @@ -11,7 +11,7 @@
>  #include "resctrl.h"
> =20
>  #define RESULT_FILE_NAME=09"result_mbm"
> -#define MAX_DIFF_PERCENT=098
> +#define MAX_DIFF_PERCENT=0915
>  #define NUM_OF_RUNS=09=095
> =20
>  static int
> diff --git a/tools/testing/selftests/resctrl/resctrl.h b/tools/testing/se=
lftests/resctrl/resctrl.h
> index 7f2ab28be857..3bad2d80c09b 100644
> --- a/tools/testing/selftests/resctrl/resctrl.h
> +++ b/tools/testing/selftests/resctrl/resctrl.h
> @@ -55,7 +55,7 @@
>   * and MBM respectively, for instance generating "overhead" traffic whic=
h
>   * is not counted against any specific RMID.
>   */
> -#define THROTTLE_THRESHOLD=09750
> +#define THROTTLE_THRESHOLD=092500
> =20
>  /*
>   * fill_buf_param:=09"fill_buf" benchmark parameters
>=20

Reviewed-by: Ilpo J=E4rvinen <ilpo.jarvinen@linux.intel.com>

--=20
 i.

--8323328-263950525-1774632886=:1037--
