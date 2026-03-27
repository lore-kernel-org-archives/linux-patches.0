Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BE13FF89B
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 17:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774633799; cv=none; b=H9p+qkAV7SW4Q37IyPtLi99qtknb6ALOvqH3ABN1UTmOKRf3+WpgqSGcx7jOFc9foBV+QIbIkYczBHVpcJqgtlgMAA7eDHvEqPTwCfhKrbljEuSWXPr/SgFjLK7NfNaj55g2/2UqEr8nQ0FklyoHSZjoLSBIeiD5taNHZSZ5vvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774633799; c=relaxed/simple;
	bh=9F+JwO9GwB+hbNoAofMWqhQyQzYejVy8kAdlUKIZeKg=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Og8idS8adVoLQf+rzOtUrSLu8BP8orxP0aUyo9QlKkCm5boCQLjNIoCuXLoXSA3rW8byYmzSaEovHGqbpTdYsMmiG96oFeOrlVYz/pzRlg11HCrRRNljrT74D9xxSRaMNkmfr4P/jc8rj1CBsgGy+5I2KnDqBIx5KwOcWaZRqb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WykhkTLw; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WykhkTLw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774633799; x=1806169799;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=9F+JwO9GwB+hbNoAofMWqhQyQzYejVy8kAdlUKIZeKg=;
  b=WykhkTLwU7vuY+zhemPWEvrLLBblJJVitX6VMY/p6SlmvTFOttEWuMMz
   nC+V9iwaeMDVlDXEh5hY+L9e8kD5s+DKyjUcXhh9R7fog8ue6KK7fGwqy
   PLLl9NsMlR2PfSgCLHjP7g67QkXRdRwOVaPZ36oKG9TpMeB91IDmWE6IS
   yRxhBBZq/DSKxpJ52AMmRrC3ZSgTtiRY8uEKQ7rp3z6icNkn1g5CZMw8m
   qIaYgaIWm3ub1guDwlqw3w5ws/ZlvI25boh/892kaPcMDzq+UebuoNSvf
   ehu57uXIDeDhd+sRTVpQscZ7Z5cfLAQpOQtMGtvojE4I4yb7HNoLoumaI
   w==;
X-CSE-ConnectionGUID: 5NqZ5lWnRK2WAT+bOtecYQ==
X-CSE-MsgGUID: yYcghnlITkiKFgvMtVs+3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="87100354"
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="87100354"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 10:49:57 -0700
X-CSE-ConnectionGUID: xGD/MJiCS4yuyggIWhEGCQ==
X-CSE-MsgGUID: 23ly9QQTSBi9ddjKl19H+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="224588013"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.186])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 10:49:50 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Fri, 27 Mar 2026 19:49:47 +0200 (EET)
To: Reinette Chatre <reinette.chatre@intel.com>
cc: shuah@kernel.org, Dave.Martin@arm.com, james.morse@arm.com, 
    tony.luck@intel.com, babu.moger@amd.com, fenghuay@nvidia.com, 
    peternewman@google.com, zide.chen@intel.com, dapeng1.mi@linux.intel.com, 
    ben.horgan@arm.com, yu.c.chen@intel.com, jason.zeng@intel.com, 
    linux-kselftest@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, 
    patches@lists.linux.dev
Subject: Re: [PATCH v3 10/10] selftests/resctrl: Reduce L2 impact on CAT
 test
In-Reply-To: <d4e13dec81de69c7ab08638d3f928b7d4ee2b1ac.1773432891.git.reinette.chatre@intel.com>
Message-ID: <afefcfb5-3f6a-6d6d-976e-c10dcaa61abb@linux.intel.com>
References: <cover.1773432891.git.reinette.chatre@intel.com> <d4e13dec81de69c7ab08638d3f928b7d4ee2b1ac.1773432891.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1564639018-1774633787=:1037"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1564639018-1774633787=:1037
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 13 Mar 2026, Reinette Chatre wrote:

> The L3 CAT test loads a buffer into cache that is proportional to the L3
> size allocated for the workload and measures cache misses when accessing
> the buffer as a test of L3 occupancy. When loading the buffer it can be
> assumed that a portion of the buffer will be loaded into the L2 cache and
> depending on cache design may not be present in L3. It is thus possible
> for data to not be in L3 but also not trigger an L3 cache miss when
> accessed.
>=20
> Reduce impact of L2 on the L3 CAT test by, if L2 allocation is supported,
> minimizing the portion of L2 that the workload can allocate into. This
> encourages most of buffer to be loaded into L3 and support better
> comparison between buffer size, cache portion, and cache misses when
> accessing the buffer.
>=20
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Tested-by: Chen Yu <yu.c.chen@intel.com>
> ---
> Changes since v2:
> - Add Chen Yu's tag.
> ---
>  tools/testing/selftests/resctrl/cat_test.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/tools/testing/selftests/resctrl/cat_test.c b/tools/testing/s=
elftests/resctrl/cat_test.c
> index 6aac03147d41..371a2f26dc47 100644
> --- a/tools/testing/selftests/resctrl/cat_test.c
> +++ b/tools/testing/selftests/resctrl/cat_test.c
> @@ -157,6 +157,10 @@ static int cat_test(const struct resctrl_test *test,
>  =09if (ret)
>  =09=09goto reset_affinity;
> =20
> +=09ret =3D minimize_l2_occupancy(test, uparams, param);
> +=09if (ret)
> +=09=09goto reset_affinity;
> +
>  =09perf_event_attr_initialize(&pea, PERF_COUNT_HW_CACHE_MISSES);
>  =09pe_fd =3D perf_open(&pea, bm_pid, uparams->cpu);
>  =09if (pe_fd < 0) {
>=20

Reviewed-by: Ilpo J=E4rvinen <ilpo.jarvinen@linux.intel.com>

--=20
 i.

--8323328-1564639018-1774633787=:1037--
