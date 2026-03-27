Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DE13F7E6A
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 17:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632643; cv=none; b=Qy9nhmfDD6SjwJxWTF94CrcbS3fypO9U/ef0jmxCtPmDjBQUqi6EkoLLmAXKChe7DevYtEKMQaxpdsD+kfNLEBBmb3lK7ghFo2R9EEVbKZ4LYCPT/5UpOYjfx0MZErMEzpBCUZ/dbWCNXs2wGBU7seUsjhkw2/z/0O+Zhh07TJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632643; c=relaxed/simple;
	bh=vdVGOFggcLsLjQO8Oz6D8OHxU7nWHZuMBjavtoRryUk=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=D0NTC0c3n8lfmsSU7n4EJ+B0Jj5TZl08P70qIbW/iXZDqVacVN0y7mU2yGdjIxUWnBnw3DeZ3tnMJmck40q5W9AoeW87vQ3BmpiYVgjJNxMWpTwJo48vShMmjrBqSSmwZw/y5zvpJWRJvkGkqWDsUnJKNjAVyucaWLfgAbJGrbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RAfJeJ7/; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RAfJeJ7/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774632643; x=1806168643;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=vdVGOFggcLsLjQO8Oz6D8OHxU7nWHZuMBjavtoRryUk=;
  b=RAfJeJ7/p/28znAPbcWe1IJlhCAD3VjCqLb7BMoqadtyovIjRNNB225G
   JK7u7SpL+wZqGvIcmhjj9QHAOOQFG09xl23jcTU2jfcL9NDvJnli/FX3c
   ft4tOCS7I6Uh+nE854Uu6JXmB9VV3J6tJlnq6kU+t7Uxk0WjZi4SmmYzN
   FoL160M0BNkxCujTo9bkdwv7FPU7GFaPcNjNcxe2kZeARP5o63liXS3e2
   H4xcNCNXwKlFDuZW7qS1jIVfQxi6rvtEuZRbXJx60zxNNbtCb10HFRJKE
   3ypVi8sxWkYi37vZFUAiCwmCkBAQRzFjHkA5z2eyuMzCcjHRnyepiXCOJ
   Q==;
X-CSE-ConnectionGUID: Jr9i7t4fSbam0qNDJLtnsg==
X-CSE-MsgGUID: Kfu1pPiYSLicQlZnSNmKOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="93096790"
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="93096790"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 10:30:42 -0700
X-CSE-ConnectionGUID: cWehFI2GSB+XxZQ7vRayEw==
X-CSE-MsgGUID: 14DaV494Qz63ZNO+q3impQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="224582943"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.186])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 10:30:36 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Fri, 27 Mar 2026 19:30:27 +0200 (EET)
To: Reinette Chatre <reinette.chatre@intel.com>
cc: shuah@kernel.org, Dave.Martin@arm.com, james.morse@arm.com, 
    tony.luck@intel.com, babu.moger@amd.com, fenghuay@nvidia.com, 
    peternewman@google.com, zide.chen@intel.com, dapeng1.mi@linux.intel.com, 
    ben.horgan@arm.com, yu.c.chen@intel.com, jason.zeng@intel.com, 
    linux-kselftest@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, 
    patches@lists.linux.dev
Subject: Re: [PATCH v3 06/10] selftests/resctrl: Increase size of buffer used
 in MBM and MBA tests
In-Reply-To: <32e610855f87010cd37ccc18c5eb23a1117fbb41.1773432891.git.reinette.chatre@intel.com>
Message-ID: <3416b137-c79c-447a-3271-c576e8491082@linux.intel.com>
References: <cover.1773432891.git.reinette.chatre@intel.com> <32e610855f87010cd37ccc18c5eb23a1117fbb41.1773432891.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-176699374-1774632627=:1037"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-176699374-1774632627=:1037
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 13 Mar 2026, Reinette Chatre wrote:

> Errata for Sierra Forest [1] (SRF42) and Granite Rapids [2] (GNR12)
> describe the problem that MBM on Intel RDT may overcount memory bandwidth
> measurements. The resctrl tests compare memory bandwidth reported by iMC
> PMU to that reported by MBM causing the tests to fail on these systems
> depending on the settings of the platform related to the errata.
>=20
> Since the resctrl tests need to run under various conditions it is not
> possible to ensure system settings are such that MBM will not overcount.
> It has been observed that the overcounting can be controlled via the
> buffer size used in the MBM and MBA tests that rely on comparisons
> between iMC PMU and MBM measurements.
>=20
> Running the MBM test on affected platforms with different buffer sizes it
> can be observed that the difference between iMC PMU and MBM counts reduce
> as the buffer size increases. After increasing the buffer size to more
> than 4X the differences between iMC PMU and MBM become insignificant.
>=20
> Increase the buffer size used in MBM and MBA tests to 4X L3 size to reduc=
e
> possibility of tests failing due to difference in counts reported by iMC
> PMU and MBM.
>=20
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Tested-by: Chen Yu <yu.c.chen@intel.com>
> Link: https://edc.intel.com/content/www/us/en/design/products-and-solutio=
ns/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-=
cores-specification-update/errata-details/ # [1]
> Link: https://edc.intel.com/content/www/us/en/design/products-and-solutio=
ns/processors-and-chipsets/birch-stream/xeon-6900-6700-6500-series-processo=
rs-with-p-cores-specification-update/011US/errata-details/ # [2]
> ---
> Changes since v2:
> - Add Chen Yu's tag.
> ---
>  tools/testing/selftests/resctrl/fill_buf.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/tools/testing/selftests/resctrl/fill_buf.c b/tools/testing/s=
elftests/resctrl/fill_buf.c
> index 19a01a52dc1a..b9fa7968cd6e 100644
> --- a/tools/testing/selftests/resctrl/fill_buf.c
> +++ b/tools/testing/selftests/resctrl/fill_buf.c
> @@ -139,6 +139,6 @@ ssize_t get_fill_buf_size(int cpu_no, const char *cac=
he_type)
>  =09if (ret)
>  =09=09return ret;
> =20
> -=09return cache_total_size * 2 > MINIMUM_SPAN ?
> -=09=09=09cache_total_size * 2 : MINIMUM_SPAN;
> +=09return cache_total_size * 4 > MINIMUM_SPAN ?
> +=09=09=09cache_total_size * 4 : MINIMUM_SPAN;
>  }
>=20

Reviewed-by: Ilpo J=E4rvinen <ilpo.jarvinen@linux.intel.com>

--=20
 i.

--8323328-176699374-1774632627=:1037--
