Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E779A3624C2
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 17:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774633689; cv=none; b=Q2l+oynPlepyQkE517dz9pqEW80U2im81A//rRvAR6SriFDRww1c8eYKJbLTuPfXyLgdm25hoeodPRkX1PtvJhVOrNy/ScjMw36IJgphxGM/wH71BgG7aWPNIe8YKYrokHKgF/lr6F0nnk09J4yqPP3bzWo571gogrJUr9B2Ckw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774633689; c=relaxed/simple;
	bh=PGuYUTv91ajLu43m6JZUvnulAqH+tQEuNbaxA3m42h4=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=jDH++LAeCZAs786idUBTCv+12lBb1zj2XPuQ3n/jMKg5kLZ4YU8fVTPrRJKQtnz7lEhkPbbAR5byWAXsxjIYKyAN2kqHQG7JGM4vghIz2PLQYUNYB+ufuDcsivfI5vWn9pr/P4A5y+KEe1E1moGC5AhgsmerTCxsgb4aycMEE/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BxI+BSfS; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BxI+BSfS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774633688; x=1806169688;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=PGuYUTv91ajLu43m6JZUvnulAqH+tQEuNbaxA3m42h4=;
  b=BxI+BSfSQ16NwMqdUjf9CpwhgG0uDcyD8qXigU3jyG6Y8eP2o2cuqE5N
   rlfdlAMwUVqoNWlQ2YHovlLBtfwPAtD+ItVEtCGRu13/Bbtu/lq+2rm/g
   GE+lBbyK3PqHt9mmJJ5l5rwksux/fsU/qOn2+MtfMBmj5rQRUKM6WkRHY
   QIVJfNAPRVPC+V9RPeV3AipGWpNQ6xeqoPbEtwoW1qAn8WrBFvuJ1Guqv
   Eer/ypsoOuVKXhgz161pU5UoXzKDFWf4Fo52w78ZojF09AlLoJwVuk55X
   C5mqw1Js01vE2gb3LEqIedsohZI7bPHQR5WZA0gFaO0EKwiTuZQDxKJFt
   w==;
X-CSE-ConnectionGUID: xBITqu3sSJqP7tJbm4rijQ==
X-CSE-MsgGUID: ASf/H/hPRzWVhz6/CFqAmQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="86788998"
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="86788998"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 10:48:08 -0700
X-CSE-ConnectionGUID: 9htQct0NSY6raxnlgqWadg==
X-CSE-MsgGUID: u1s92T/AQDGVolXx+eItfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="248414526"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.186])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 10:48:01 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Fri, 27 Mar 2026 19:47:58 +0200 (EET)
To: Reinette Chatre <reinette.chatre@intel.com>
cc: shuah@kernel.org, Dave.Martin@arm.com, james.morse@arm.com, 
    tony.luck@intel.com, babu.moger@amd.com, fenghuay@nvidia.com, 
    peternewman@google.com, zide.chen@intel.com, dapeng1.mi@linux.intel.com, 
    ben.horgan@arm.com, yu.c.chen@intel.com, jason.zeng@intel.com, 
    linux-kselftest@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, 
    patches@lists.linux.dev
Subject: Re: [PATCH v3 09/10] selftests/resctrl: Simplify perf usage in CAT
 test
In-Reply-To: <ff80aaca24d306435b72a1b53ef8fa01f2b5010f.1773432891.git.reinette.chatre@intel.com>
Message-ID: <2e88c88e-35ef-dc38-5717-f732064f9ab8@linux.intel.com>
References: <cover.1773432891.git.reinette.chatre@intel.com> <ff80aaca24d306435b72a1b53ef8fa01f2b5010f.1773432891.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-823094273-1774633678=:1037"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-823094273-1774633678=:1037
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 13 Mar 2026, Reinette Chatre wrote:

> The CAT test relies on the PERF_COUNT_HW_CACHE_MISSES event to determine =
if
> modifying a cache portion size is successful. This event is configured to
> report the data as part of an event group, but no other events are added =
to
> the group.
>=20
> Remove the unnecessary PERF_FORMAT_GROUP format setting. This eliminates
> the need for struct perf_event_read and results in read() of the associat=
ed
> file descriptor to return just one value associated with the
> PERF_COUNT_HW_CACHE_MISSES event of interest.
>=20
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Tested-by: Chen Yu <yu.c.chen@intel.com>
> ---
> Changes since v2:
> - Add Chen Yu's tag.
> ---
>  tools/testing/selftests/resctrl/cache.c    | 17 +++++------------
>  tools/testing/selftests/resctrl/cat_test.c |  4 +---
>  tools/testing/selftests/resctrl/resctrl.h  | 11 +----------
>  3 files changed, 7 insertions(+), 25 deletions(-)
>=20
> diff --git a/tools/testing/selftests/resctrl/cache.c b/tools/testing/self=
tests/resctrl/cache.c
> index bef71b6feacc..df9bea584a2d 100644
> --- a/tools/testing/selftests/resctrl/cache.c
> +++ b/tools/testing/selftests/resctrl/cache.c
> @@ -10,7 +10,6 @@ void perf_event_attr_initialize(struct perf_event_attr =
*pea, __u64 config)
>  =09memset(pea, 0, sizeof(*pea));
>  =09pea->type =3D PERF_TYPE_HARDWARE;
>  =09pea->size =3D sizeof(*pea);
> -=09pea->read_format =3D PERF_FORMAT_GROUP;
>  =09pea->exclude_kernel =3D 1;
>  =09pea->exclude_hv =3D 1;
>  =09pea->exclude_idle =3D 1;
> @@ -37,19 +36,13 @@ int perf_event_reset_enable(int pe_fd)
>  =09return 0;
>  }
> =20
> -void perf_event_initialize_read_format(struct perf_event_read *pe_read)
> -{
> -=09memset(pe_read, 0, sizeof(*pe_read));
> -=09pe_read->nr =3D 1;
> -}
> -
>  int perf_open(struct perf_event_attr *pea, pid_t pid, int cpu_no)
>  {
>  =09int pe_fd;
> =20
>  =09pe_fd =3D perf_event_open(pea, pid, cpu_no, -1, PERF_FLAG_FD_CLOEXEC)=
;
>  =09if (pe_fd =3D=3D -1) {
> -=09=09ksft_perror("Error opening leader");
> +=09=09ksft_perror("Unable to set up performance monitoring");
>  =09=09return -1;
>  =09}
> =20
> @@ -132,9 +125,9 @@ static int print_results_cache(const char *filename, =
pid_t bm_pid, __u64 llc_val
>   *
>   * Return: =3D0 on success. <0 on failure.
>   */
> -int perf_event_measure(int pe_fd, struct perf_event_read *pe_read,
> -=09=09       const char *filename, pid_t bm_pid)
> +int perf_event_measure(int pe_fd, const char *filename, pid_t bm_pid)
>  {
> +=09__u64 value;
>  =09int ret;
> =20
>  =09/* Stop counters after one span to get miss rate */
> @@ -142,13 +135,13 @@ int perf_event_measure(int pe_fd, struct perf_event=
_read *pe_read,
>  =09if (ret < 0)
>  =09=09return ret;
> =20
> -=09ret =3D read(pe_fd, pe_read, sizeof(*pe_read));
> +=09ret =3D read(pe_fd, &value, sizeof(value));
>  =09if (ret =3D=3D -1) {
>  =09=09ksft_perror("Could not get perf value");
>  =09=09return -1;
>  =09}
> =20
> -=09return print_results_cache(filename, bm_pid, pe_read->values[0].value=
);
> +=09return print_results_cache(filename, bm_pid, value);
>  }
> =20
>  /*
> diff --git a/tools/testing/selftests/resctrl/cat_test.c b/tools/testing/s=
elftests/resctrl/cat_test.c
> index 8bc47f06679a..6aac03147d41 100644
> --- a/tools/testing/selftests/resctrl/cat_test.c
> +++ b/tools/testing/selftests/resctrl/cat_test.c
> @@ -135,7 +135,6 @@ static int cat_test(const struct resctrl_test *test,
>  =09=09    struct resctrl_val_param *param,
>  =09=09    size_t span, unsigned long current_mask)
>  {
> -=09struct perf_event_read pe_read;
>  =09struct perf_event_attr pea;
>  =09cpu_set_t old_affinity;
>  =09unsigned char *buf;
> @@ -159,7 +158,6 @@ static int cat_test(const struct resctrl_test *test,
>  =09=09goto reset_affinity;
> =20
>  =09perf_event_attr_initialize(&pea, PERF_COUNT_HW_CACHE_MISSES);
> -=09perf_event_initialize_read_format(&pe_read);
>  =09pe_fd =3D perf_open(&pea, bm_pid, uparams->cpu);
>  =09if (pe_fd < 0) {
>  =09=09ret =3D -1;
> @@ -192,7 +190,7 @@ static int cat_test(const struct resctrl_test *test,
> =20
>  =09=09=09fill_cache_read(buf, span, true);
> =20
> -=09=09=09ret =3D perf_event_measure(pe_fd, &pe_read, param->filename, bm=
_pid);
> +=09=09=09ret =3D perf_event_measure(pe_fd, param->filename, bm_pid);
>  =09=09=09if (ret)
>  =09=09=09=09goto free_buf;
>  =09=09}
> diff --git a/tools/testing/selftests/resctrl/resctrl.h b/tools/testing/se=
lftests/resctrl/resctrl.h
> index 3bad2d80c09b..175101022bf3 100644
> --- a/tools/testing/selftests/resctrl/resctrl.h
> +++ b/tools/testing/selftests/resctrl/resctrl.h
> @@ -148,13 +148,6 @@ struct resctrl_val_param {
>  =09struct fill_buf_param=09*fill_buf;
>  };
> =20
> -struct perf_event_read {
> -=09__u64 nr;=09=09=09/* The number of events */
> -=09struct {
> -=09=09__u64 value;=09=09/* The value of the event */
> -=09} values[2];
> -};
> -
>  /*
>   * Memory location that consumes values compiler must not optimize away.
>   * Volatile ensures writes to this location cannot be optimized away by
> @@ -210,11 +203,9 @@ unsigned int count_bits(unsigned long n);
>  int snc_kernel_support(void);
> =20
>  void perf_event_attr_initialize(struct perf_event_attr *pea, __u64 confi=
g);
> -void perf_event_initialize_read_format(struct perf_event_read *pe_read);
>  int perf_open(struct perf_event_attr *pea, pid_t pid, int cpu_no);
>  int perf_event_reset_enable(int pe_fd);
> -int perf_event_measure(int pe_fd, struct perf_event_read *pe_read,
> -=09=09       const char *filename, pid_t bm_pid);
> +int perf_event_measure(int pe_fd, const char *filename, pid_t bm_pid);
>  int measure_llc_resctrl(const char *filename, pid_t bm_pid);
>  int minimize_l2_occupancy(const struct resctrl_test *test,
>  =09=09=09  const struct user_params *uparams,
>=20

Reviewed-by: Ilpo J=E4rvinen <ilpo.jarvinen@linux.intel.com>


--=20
 i.

--8323328-823094273-1774633678=:1037--
