Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28593DD52A
	for <patches@lists.linux.dev>; Tue, 31 Mar 2026 08:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774944454; cv=none; b=HOGhTa3lUsqv/j73lVhPpaA0I7f/WbSfnJwcyvrhFRdpZIV+oXRz3v7lgLOnIgksLvLCzAHxyIKuugOWs9ZhwR9xiXVETdfOxoZ01w7otB9jXO9Lyuy89TiTze/NOO/c7BYS564wr5pJaEh+JknLLtnt1wFAqES9zZ6TuzBfySw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774944454; c=relaxed/simple;
	bh=Fyn3m8tQ9ZqI4d1rGSmG3Tu3W738dZiK0Hv5V3n0sNo=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=uZ93ONCKbfsnXufZYAQwJ5wwzuoiOPHVsQeJxFeZkwhbvVpwP9D6mzsbWwE6pkxyQJlM/qIuR9RLavym+AVOwh2BOFhX3aco5c5TYT5smk4zkCi2jR3+E8sSiahSZNeze307tHnEXHYA2dWNVA+eiKhCu7d08W1fG3S8vqhzQFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P4Edl2Tk; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P4Edl2Tk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774944451; x=1806480451;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=Fyn3m8tQ9ZqI4d1rGSmG3Tu3W738dZiK0Hv5V3n0sNo=;
  b=P4Edl2Tk0x3oS/UxwsD0avKOiGBaN5MsNPRjwJYs1ODzRlyD11fExYfD
   E6/IERiB1YP1D2vtZoiNIZPuSwmFrVYzEuKzyWAQrLD6gm8UraVXiJ+wa
   AQiuR58FyJfF/QmzM1hvLhK8Ur+ogkxcQomPAbifzXLLEDx1gHzMFpEw3
   D9hbherH+UMbIHYV2Du5oJTDqGTjrih9H63hwsqkUYZE2rgxanDpuHs6D
   dkpEKUgeBhXRXKqv281S7Q3Gkuqx27Xfx1gfyKELWOFMDi1teCxU/uXuP
   c/SzAn/Q9BaNXRhRXWcuEOwz3NUJ/xfkPQ9RVmQ/UGMdUbkqXuhdSHnCE
   Q==;
X-CSE-ConnectionGUID: xFRsmjS0R+S+HATI9yokgg==
X-CSE-MsgGUID: M28DfThfQgeyfJQcbL6IJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11744"; a="93333160"
X-IronPort-AV: E=Sophos;i="6.23,151,1770624000"; 
   d="scan'208";a="93333160"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 01:07:30 -0700
X-CSE-ConnectionGUID: ssW1b8bwSpq+z3xOmCnZJA==
X-CSE-MsgGUID: 7ABUu+S6ThKYVsFnZiWBig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,151,1770624000"; 
   d="scan'208";a="256801694"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.6])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 01:07:23 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Tue, 31 Mar 2026 11:07:16 +0300 (EEST)
To: Reinette Chatre <reinette.chatre@intel.com>
cc: shuah@kernel.org, Dave.Martin@arm.com, james.morse@arm.com, 
    tony.luck@intel.com, babu.moger@amd.com, fenghuay@nvidia.com, 
    peternewman@google.com, zide.chen@intel.com, dapeng1.mi@linux.intel.com, 
    ben.horgan@arm.com, yu.c.chen@intel.com, jason.zeng@intel.com, 
    linux-kselftest@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, 
    patches@lists.linux.dev
Subject: Re: [PATCH v3 08/10] selftests/resctrl: Remove requirement on cache
 miss rate
In-Reply-To: <ef8bb064-f562-4237-ac72-fc2c00a5708e@intel.com>
Message-ID: <42de2e76-5962-caf5-3b8d-453784b43af2@linux.intel.com>
References: <cover.1773432891.git.reinette.chatre@intel.com> <1fc79420f76d585231252e59d4fcf19b3e704ee3.1773432891.git.reinette.chatre@intel.com> <4e3b5362-e751-03a4-f98c-a760ad274d02@linux.intel.com> <ef8bb064-f562-4237-ac72-fc2c00a5708e@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1675499677-1774944436=:989"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1675499677-1774944436=:989
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 27 Mar 2026, Reinette Chatre wrote:

> Hi Ilpo,
>=20
> On 3/27/26 10:45 AM, Ilpo J=C3=A4rvinen wrote:
> > On Fri, 13 Mar 2026, Reinette Chatre wrote:
> >> -/*
> >> - * Minimum difference in LLC misses between a test with n+1 bits CBM =
to the
> >> - * test with n bits is MIN_DIFF_PERCENT_PER_BIT * (n - 1). With e.g. =
5 vs 4
> >> - * bits in the CBM mask, the minimum difference must be at least
> >> - * MIN_DIFF_PERCENT_PER_BIT * (4 - 1) =3D 3 percent.
> >> - *
> >> - * The relationship between number of used CBM bits and difference in=
 LLC
> >> - * misses is not expected to be linear. With a small number of bits, =
the
> >> - * margin is smaller than with larger number of bits. For selftest pu=
rposes,
> >> - * however, linear approach is enough because ultimately only pass/fa=
il
> >> - * decision has to be made and distinction between strong and stronge=
r
> >> - * signal is irrelevant.
> >> - */
> >> -#define MIN_DIFF_PERCENT_PER_BIT=091UL
> >> -
> >>  static int show_results_info(__u64 sum_llc_val, int no_of_bits,
> >>  =09=09=09     unsigned long cache_span,
> >> -=09=09=09     unsigned long min_diff_percent,
> >>  =09=09=09     unsigned long num_of_runs, bool platform,
> >>  =09=09=09     __s64 *prev_avg_llc_val)
> >>  {
> >>  =09__u64 avg_llc_val =3D 0;
> >> -=09float avg_diff;
> >>  =09int ret =3D 0;
> >> =20
> >>  =09avg_llc_val =3D sum_llc_val / num_of_runs;
> >>  =09if (*prev_avg_llc_val) {
> >> -=09=09float delta =3D (__s64)(avg_llc_val - *prev_avg_llc_val);
> >> -
> >> -=09=09avg_diff =3D delta / *prev_avg_llc_val;
> >> -=09=09ret =3D platform && (avg_diff * 100) < (float)min_diff_percent;
> >> -
> >> -=09=09ksft_print_msg("%s Check cache miss rate changed more than %.1f=
%%\n",
> >> -=09=09=09       ret ? "Fail:" : "Pass:", (float)min_diff_percent);
> >> +=09=09ret =3D platform && (avg_llc_val < *prev_avg_llc_val);
> >> =20
> >> -=09=09ksft_print_msg("Percent diff=3D%.1f\n", avg_diff * 100);
> >> +=09=09ksft_print_msg("%s Check cache miss rate increased\n",
> >> +=09=09=09       ret ? "Fail:" : "Pass:");
> >=20
> > While I'm fine with removing the amount of change check, this no longer=
=20
> > shows any numbers which would be a bit annoying if/when there's a failu=
re.
> >=20
>=20
> This snippet only removes display of the number that is no longer compute=
d ("avg_diff").
> The values that are compared now, avg_llc_val and it previous value, are =
printed
> in the call to show_cache_info() that follows this snippet but is not vis=
ible in the diff.
> =20
> Below is an example of what a user running the CAT test will see after th=
ese changes.
> Since show_cache_info() always prints avg_llc_val the user can obtain ins=
ight into failure
> by considering it and its previous measurement.
>=20
> # Starting L3_CAT test ...
> # Mounting resctrl to "/sys/fs/resctrl"
> # Cache size :117964800
> # Writing benchmark parameters to resctrl FS
> # Write schema "L2:1=3D0x1" to resctrl FS
> # Write schema "L3:0=3D1fc0" to resctrl FS
> # Write schema "L3:0=3D3f" to resctrl FS
> # Write schema "L3:0=3D1ff0" to resctrl FS
> # Write schema "L3:0=3Df" to resctrl FS
> # Write schema "L3:0=3D1ffc" to resctrl FS
> # Write schema "L3:0=3D3" to resctrl FS
> # Checking for pass/fail
> # Number of bits: 6
> # Average LLC val: 445092
> # Cache span (lines): 737280
> # Pass: Check cache miss rate increased
> # Number of bits: 4
> # Average LLC val: 724472
> # Cache span (lines): 491520
> # Pass: Check cache miss rate increased
> # Number of bits: 2
> # Average LLC val: 1085470
> # Cache span (lines): 245760
> ok 4 L3_CAT: test

Okay, I didn't remember there was another place printing the numbers.
No problem with this then,

Reviewed-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>

--=20
 i.

--8323328-1675499677-1774944436=:989--
