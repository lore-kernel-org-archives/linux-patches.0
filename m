Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627563F074F
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 17:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632544; cv=none; b=oqoiaDzKFsI8YJmvyfp36C1bweeDJCPdElh29KOtjDumjH3Oeo/ooAS7LGY4ABt+e0ITfa5w2Xcq3K9+4Mxeygk9yBiBtGWKDDXEWdtpW1nU5xWYRgUTP3fsSwBBJyuvSH5JfyIxnK2gbSFZFfe29eRp/M3oXqEw4Wo49qAxTTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632544; c=relaxed/simple;
	bh=+4zdTLCSRoq9rQxavDFDv+FFD1HM2TkG67QaSqNoqXI=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=bTzOC3kx3kb14Opm4tIFpDzEuo3vtz6pcKHw+LsuLZxPxcxGUbvfXMV7zOo2axwvhxkra2WM7Lyl4bKgAfd2U7I9absSbroIXbVmIZkGgT8qifTyTitvVq7UintX5qNz1oFgJStC1m3QhmRzGfwwdJ3hfZHGQu7gsIvbq0oaFF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PfunGB0r; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PfunGB0r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774632541; x=1806168541;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=+4zdTLCSRoq9rQxavDFDv+FFD1HM2TkG67QaSqNoqXI=;
  b=PfunGB0r+yECTAbw3S5Uz6s0XHUsk7qkfXAy0vnlhTQpZwAewT20RmeE
   e0MUdlL8mj0ekYkMKNA6s9ldsvCZi59UPwHzmeP2RbTvHLmlkMmkVl3px
   O+otxxZht8+sDoRmSFVTF1D+gceHNGmD8NP8rQBa2C1l3iF+kz+NcERxX
   jyfRD5m5pCT89q7A6qY9OWoB3Ls1TDyGOpJc+dniQsQ/iVj1VVv9mY0Im
   FQKNJgHC8vK35ur38eBFphNMmo7TrjPirmDkMBRGNK/rGY47IWK6F20uW
   eH30VIikCUeVsNaaboKWec6Er45Nc3n9czO3/lLlSrwbNUBMK0bDXBbLU
   A==;
X-CSE-ConnectionGUID: xMErF/5fQvSjEWWZfxOkLQ==
X-CSE-MsgGUID: QH07YBEHSQCEZj0wCFkcXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="75678577"
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="75678577"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 10:29:00 -0700
X-CSE-ConnectionGUID: FQSDfoBXRhKIx9a5Z0Egvw==
X-CSE-MsgGUID: 6Lrvi0EGTNWs6XU0gG6KvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="225392355"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.186])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 10:28:55 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Fri, 27 Mar 2026 19:28:50 +0200 (EET)
To: Reinette Chatre <reinette.chatre@intel.com>
cc: shuah@kernel.org, Dave.Martin@arm.com, james.morse@arm.com, 
    tony.luck@intel.com, babu.moger@amd.com, fenghuay@nvidia.com, 
    peternewman@google.com, zide.chen@intel.com, dapeng1.mi@linux.intel.com, 
    ben.horgan@arm.com, yu.c.chen@intel.com, jason.zeng@intel.com, 
    linux-kselftest@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, 
    patches@lists.linux.dev
Subject: Re: [PATCH v3 05/10] selftests/resctrl: Support multiple events
 associated with iMC
In-Reply-To: <f580adeab0d8369392f9cc1421aa0806a4f32e07.1773432891.git.reinette.chatre@intel.com>
Message-ID: <cb4cc6f7-a7be-3d45-a484-5802b0ea0db3@linux.intel.com>
References: <cover.1773432891.git.reinette.chatre@intel.com> <f580adeab0d8369392f9cc1421aa0806a4f32e07.1773432891.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-2012513355-1774632530=:1037"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2012513355-1774632530=:1037
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 13 Mar 2026, Reinette Chatre wrote:

> The resctrl selftests discover needed parameters to perf_event_open() via
> sysfs. The PMU associated with every memory controller (iMC) is discovere=
d
> via the /sys/bus/event_source/devices/uncore_imc_N/type file while
> the read memory bandwidth event type and umask is discovered via
> /sys/bus/event_source/devices/uncore_imc_N/events/cas_count_read.
>=20
> Newer systems may have multiple events that expose read memory bandwidth.
> Running a recent kernel that includes
> commit 6a8a48644c4b ("perf/x86/intel/uncore: Add per-scheduler IMC CAS co=
unt events")
> on these systems expose the multiple events. For example,
>  /sys/bus/event_source/devices/uncore_imc_N/events/cas_count_read_sch0
>  /sys/bus/event_source/devices/uncore_imc_N/events/cas_count_read_sch1
>=20
> Support parsing of iMC PMU properties when the PMU may have multiple even=
ts
> to measure read memory bandwidth. The PMU only needs to be discovered onc=
e.
> Split the parsing of event details from actual PMU discovery in order to
> loop over all events associated with the PMU. Match all events with the
> cas_count_read prefix instead of requiring there to be one file with that
> name.
>=20
> Make the parsing code more robust. With strings passed around to create
> needed paths, use snprintf() instead of sprintf() to ensure there is
> always enough space to create the path while using the standard PATH_MAX
> for path lengths. Ensure there is enough room in imc_counters_config[]
> before attempting to add an entry.
>=20
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Tested-by: Chen Yu <yu.c.chen@intel.com>
> Reviewed-by: Zide Chen <zide.chen@intel.com>

Reviewed-by: Ilpo J=E4rvinen <ilpo.jarvinen@linux.intel.com>

--=20
 i.

> ---
> Changes since v1:
> - Add Zide Chen's RB tag.
>=20
> Changes since v2:
> - Update changelog to note merged perf change that supports this change.
> - Use PATH_MAX instead of magic number for path lengths. (Ilpo)
> - Rename "org_count" -> "orig_count". (Ilpo)
> - Rework flow surrounding fscanf() used in both parse_imc_read_bw_events(=
)
>   and read_from_imc_dir(). (Ilpo)
> - Handle error first to reduce indentation. (Ilpo)
> - Add Chen Yu's tag.
> ---
>  tools/testing/selftests/resctrl/resctrl_val.c | 118 ++++++++++++++----
>  1 file changed, 93 insertions(+), 25 deletions(-)
>=20
> diff --git a/tools/testing/selftests/resctrl/resctrl_val.c b/tools/testin=
g/selftests/resctrl/resctrl_val.c
> index 6d766347e3fc..f20d2194c35f 100644
> --- a/tools/testing/selftests/resctrl/resctrl_val.c
> +++ b/tools/testing/selftests/resctrl/resctrl_val.c
> @@ -11,10 +11,10 @@
>  #include "resctrl.h"
> =20
>  #define UNCORE_IMC=09=09"uncore_imc"
> -#define READ_FILE_NAME=09=09"events/cas_count_read"
> +#define READ_FILE_NAME=09=09"cas_count_read"
>  #define DYN_PMU_PATH=09=09"/sys/bus/event_source/devices"
>  #define SCALE=09=09=090.00006103515625
> -#define MAX_IMCS=09=0920
> +#define MAX_IMCS=09=0940
>  #define MAX_TOKENS=09=095
> =20
>  #define CON_MBM_LOCAL_BYTES_PATH=09=09\
> @@ -109,46 +109,114 @@ static int open_perf_read_event(int i, int cpu_no)
>  =09return 0;
>  }
> =20
> -/* Get type and config of an iMC counter's read event. */
> -static int read_from_imc_dir(char *imc_dir, unsigned int *count)
> +static int parse_imc_read_bw_events(char *imc_dir, unsigned int type,
> +=09=09=09=09    unsigned int *count)
>  {
> -=09char cas_count_cfg[1024], imc_counter_cfg[1024], imc_counter_type[102=
4];
> +=09char imc_events_dir[PATH_MAX], imc_counter_cfg[PATH_MAX];
> +=09unsigned int orig_count =3D *count;
> +=09char cas_count_cfg[1024];
> +=09struct dirent *ep;
> +=09int path_len;
> +=09int ret =3D -1;
> +=09int num_cfg;
>  =09FILE *fp;
> +=09DIR *dp;
> =20
> -=09/* Get type of iMC counter */
> -=09sprintf(imc_counter_type, "%s%s", imc_dir, "type");
> -=09fp =3D fopen(imc_counter_type, "r");
> -=09if (!fp) {
> -=09=09ksft_perror("Failed to open iMC counter type file");
> +=09path_len =3D snprintf(imc_events_dir, sizeof(imc_events_dir), "%seven=
ts",
> +=09=09=09    imc_dir);
> +=09if (path_len >=3D sizeof(imc_events_dir)) {
> +=09=09ksft_print_msg("Unable to create path to %sevents\n", imc_dir);
> +=09=09return -1;
> +=09}
> =20
> +=09dp =3D opendir(imc_events_dir);
> +=09if (!dp) {
> +=09=09ksft_perror("Unable to open PMU events directory");
>  =09=09return -1;
>  =09}
> -=09if (fscanf(fp, "%u", &imc_counters_config[*count].type) <=3D 0) {
> -=09=09ksft_perror("Could not get iMC type");
> +
> +=09while ((ep =3D readdir(dp))) {
> +=09=09/*
> +=09=09 * Parse all event files with READ_FILE_NAME prefix that
> +=09=09 * contain the event number and umask. Skip files containing
> +=09=09 * "." that contain unused properties of event.
> +=09=09 */
> +=09=09if (!strstr(ep->d_name, READ_FILE_NAME) ||
> +=09=09    strchr(ep->d_name, '.'))
> +=09=09=09continue;
> +
> +=09=09path_len =3D snprintf(imc_counter_cfg, sizeof(imc_counter_cfg),
> +=09=09=09=09    "%s/%s", imc_events_dir, ep->d_name);
> +=09=09if (path_len >=3D sizeof(imc_counter_cfg)) {
> +=09=09=09ksft_print_msg("Unable to create path to %s/%s\n",
> +=09=09=09=09       imc_events_dir, ep->d_name);
> +=09=09=09goto out_close;
> +=09=09}
> +=09=09fp =3D fopen(imc_counter_cfg, "r");
> +=09=09if (!fp) {
> +=09=09=09ksft_perror("Failed to open iMC config file");
> +=09=09=09goto out_close;
> +=09=09}
> +=09=09num_cfg =3D fscanf(fp, "%1023s", cas_count_cfg);
>  =09=09fclose(fp);
> +=09=09if (num_cfg <=3D 0) {
> +=09=09=09ksft_perror("Could not get iMC cas count read");
> +=09=09=09goto out_close;
> +=09=09}
> +=09=09if (*count >=3D MAX_IMCS) {
> +=09=09=09ksft_print_msg("Maximum iMC count exceeded\n");
> +=09=09=09goto out_close;
> +=09=09}
> =20
> -=09=09return -1;
> +=09=09imc_counters_config[*count].type =3D type;
> +=09=09get_read_event_and_umask(cas_count_cfg, *count);
> +=09=09/* Do not fail after incrementing *count. */
> +=09=09*count +=3D 1;
>  =09}
> -=09fclose(fp);
> +=09if (*count =3D=3D orig_count) {
> +=09=09ksft_print_msg("Unable to find events in %s\n", imc_events_dir);
> +=09=09goto out_close;
> +=09}
> +=09ret =3D 0;
> +out_close:
> +=09closedir(dp);
> +=09return ret;
> +}
> =20
> -=09/* Get read config */
> -=09sprintf(imc_counter_cfg, "%s%s", imc_dir, READ_FILE_NAME);
> -=09fp =3D fopen(imc_counter_cfg, "r");
> -=09if (!fp) {
> -=09=09ksft_perror("Failed to open iMC config file");
> +/* Get type and config of an iMC counter's read event. */
> +static int read_from_imc_dir(char *imc_dir, unsigned int *count)
> +{
> +=09char imc_counter_type[PATH_MAX];
> +=09unsigned int type;
> +=09int path_len;
> +=09FILE *fp;
> +=09int ret;
> =20
> +=09/* Get type of iMC counter */
> +=09path_len =3D snprintf(imc_counter_type, sizeof(imc_counter_type),
> +=09=09=09    "%s%s", imc_dir, "type");
> +=09if (path_len >=3D sizeof(imc_counter_type)) {
> +=09=09ksft_print_msg("Unable to create path to %s%s\n",
> +=09=09=09       imc_dir, "type");
>  =09=09return -1;
>  =09}
> -=09if (fscanf(fp, "%1023s", cas_count_cfg) <=3D 0) {
> -=09=09ksft_perror("Could not get iMC cas count read");
> -=09=09fclose(fp);
> +=09fp =3D fopen(imc_counter_type, "r");
> +=09if (!fp) {
> +=09=09ksft_perror("Failed to open iMC counter type file");
> =20
>  =09=09return -1;
>  =09}
> +=09ret =3D fscanf(fp, "%u", &type);
>  =09fclose(fp);
> -
> -=09get_read_event_and_umask(cas_count_cfg, *count);
> -=09*count +=3D 1;
> +=09if (ret <=3D 0) {
> +=09=09ksft_perror("Could not get iMC type");
> +=09=09return -1;
> +=09}
> +=09ret =3D parse_imc_read_bw_events(imc_dir, type, count);
> +=09if (ret) {
> +=09=09ksft_print_msg("Unable to parse bandwidth event and umask\n");
> +=09=09return ret;
> +=09}
> =20
>  =09return 0;
>  }
>=20
--8323328-2012513355-1774632530=:1037--
