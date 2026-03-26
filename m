Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F802848A7
	for <patches@lists.linux.dev>; Thu, 26 Mar 2026 13:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774530242; cv=none; b=rD3X9JQCiOcEzJT9L0hOU4JTh1ZVLIsK+w+IJsHtFBRrEDx5Au10JQltaphK/D4zPY8B/yJfCyiO7RJmwSXWpmPvI5/my4jGTfD/2Ot8cNRdcwYGIh+OQKL8UjathpmWjSoBmGzczn7094Zrs6li0wal9bm1BwZS/qL+Croj254=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774530242; c=relaxed/simple;
	bh=pxJex+2BKbWlg1hFjQ3Ojgz8flGSCrPNkqxv6T0XDdE=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Fvo5448sIzv4bIAjByYIrUbT5bjJsPOGnaveQX4KBFYkB6FeEPl6vUp5eiVDrmKt1t9r44O9QPvnSSS6tr5yTEYNXMJMuP8hOVuDs4rkVF+V2VrjYj/cMgEMqSJVtIQtlGJx3XK4Tj22zVZhySkSkGf8CQ0WhaoAfUJRZXKw8Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l1S+iobC; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l1S+iobC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774530241; x=1806066241;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=pxJex+2BKbWlg1hFjQ3Ojgz8flGSCrPNkqxv6T0XDdE=;
  b=l1S+iobClMxFJHT3iPr0jGA/j1NclFECwVGTVmbzUsWZq+UpwlR9SHeq
   RD/gB5k1ni+1UyGoKzEendD8iW3uQlO+gIT+nHvmDcU0Eb7DR/ECQmzWH
   /YrGNEa60Uauc4mQ8gRwnP2lAY77U71i1/TDa/2SgHpWPiRZpxtuYwrds
   Ur1E1csWDT/knOhfC7bIbsiCMbFaKUakw9o9++oHPVr8NOBPE/CrxZjKx
   VG5FQqidui+0mtvRWnOCDiMEBVIRu2mVCEMkx11uX/kHyq7Hl91l3nq/r
   JzZn+dKyuozD8QQ9zS4qGsRI2N35TVLrisxNSbF+VXPonOBQVIQdDL9Lp
   w==;
X-CSE-ConnectionGUID: upPoeBa3Rn2GeNe/d8IqNg==
X-CSE-MsgGUID: SzoVb9RDSsikXWTAQ/qPxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11740"; a="75654346"
X-IronPort-AV: E=Sophos;i="6.23,142,1770624000"; 
   d="scan'208";a="75654346"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 06:04:01 -0700
X-CSE-ConnectionGUID: KfG/6R/LSN2jHZV1qNHrmQ==
X-CSE-MsgGUID: aMUDyOIZSraMX/CzBVUOfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,142,1770624000"; 
   d="scan'208";a="218402126"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.32])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 06:03:55 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Thu, 26 Mar 2026 15:03:51 +0200 (EET)
To: Reinette Chatre <reinette.chatre@intel.com>
cc: shuah@kernel.org, Dave.Martin@arm.com, james.morse@arm.com, 
    tony.luck@intel.com, babu.moger@amd.com, fenghuay@nvidia.com, 
    peternewman@google.com, zide.chen@intel.com, dapeng1.mi@linux.intel.com, 
    ben.horgan@arm.com, yu.c.chen@intel.com, jason.zeng@intel.com, 
    linux-kselftest@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, 
    patches@lists.linux.dev
Subject: Re: [PATCH v3 04/10] selftests/resctrl: Prepare for parsing multiple
 events per iMC
In-Reply-To: <dea5825ffde55254e8b37dfa1a1723854ec257ac.1773432891.git.reinette.chatre@intel.com>
Message-ID: <cf4e456d-2573-3c11-17d5-8d410e3fc26a@linux.intel.com>
References: <cover.1773432891.git.reinette.chatre@intel.com> <dea5825ffde55254e8b37dfa1a1723854ec257ac.1773432891.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-886281517-1774530231=:986"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-886281517-1774530231=:986
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 13 Mar 2026, Reinette Chatre wrote:

> The events needed to read memory bandwidth are discovered by iterating
> over every memory controller (iMC) within /sys/bus/event_source/devices.
> Each iMC's PMU is assumed to have one event to measure read memory
> bandwidth that is represented by the sysfs cas_count_read file. The event=
's
> configuration is read from "cas_count_read" and stored as an element of
> imc_counters_config[] by read_from_imc_dir() that receives the
> index of the array where to store the configuration as argument.
>=20
> It is possible that an iMC's PMU may have more than one event that should
> be used to measure memory bandwidth.
>=20
> Change semantics to not provide the index of the array to
> read_from_imc_dir() but instead a pointer to the index. This enables
> read_from_imc_dir() to store configurations for more than one event by
> incrementing the index to imc_counters_config[] itself.
>=20
> Ensure that the same type is consistently used for the index as it is
> passed around during counter configuration.
>=20
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Tested-by: Chen Yu <yu.c.chen@intel.com>
> Reviewed-by: Zide Chen <zide.chen@intel.com>
> ---
> Changes since v1:
> - Add Zide Chen's RB tag.
>=20
> Changes since v2:
> - Add Chen Yu's tag.
> ---
>  tools/testing/selftests/resctrl/resctrl_val.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/tools/testing/selftests/resctrl/resctrl_val.c b/tools/testin=
g/selftests/resctrl/resctrl_val.c
> index 71d6f88cc1f7..6d766347e3fc 100644
> --- a/tools/testing/selftests/resctrl/resctrl_val.c
> +++ b/tools/testing/selftests/resctrl/resctrl_val.c
> @@ -73,7 +73,7 @@ static void read_mem_bw_ioctl_perf_event_ioc_disable(in=
t i)
>   * @cas_count_cfg:=09Config
>   * @count:=09=09iMC number
>   */
> -static void get_read_event_and_umask(char *cas_count_cfg, int count)
> +static void get_read_event_and_umask(char *cas_count_cfg, unsigned int c=
ount)
>  {
>  =09char *token[MAX_TOKENS];
>  =09int i =3D 0;
> @@ -110,7 +110,7 @@ static int open_perf_read_event(int i, int cpu_no)
>  }
> =20
>  /* Get type and config of an iMC counter's read event. */
> -static int read_from_imc_dir(char *imc_dir, int count)
> +static int read_from_imc_dir(char *imc_dir, unsigned int *count)
>  {
>  =09char cas_count_cfg[1024], imc_counter_cfg[1024], imc_counter_type[102=
4];
>  =09FILE *fp;
> @@ -123,7 +123,7 @@ static int read_from_imc_dir(char *imc_dir, int count=
)
> =20
>  =09=09return -1;
>  =09}
> -=09if (fscanf(fp, "%u", &imc_counters_config[count].type) <=3D 0) {
> +=09if (fscanf(fp, "%u", &imc_counters_config[*count].type) <=3D 0) {
>  =09=09ksft_perror("Could not get iMC type");
>  =09=09fclose(fp);
> =20
> @@ -147,7 +147,8 @@ static int read_from_imc_dir(char *imc_dir, int count=
)
>  =09}
>  =09fclose(fp);
> =20
> -=09get_read_event_and_umask(cas_count_cfg, count);
> +=09get_read_event_and_umask(cas_count_cfg, *count);
> +=09*count +=3D 1;
> =20
>  =09return 0;
>  }
> @@ -196,13 +197,12 @@ static int num_of_imcs(void)
>  =09=09=09if (temp[0] >=3D '0' && temp[0] <=3D '9') {
>  =09=09=09=09sprintf(imc_dir, "%s/%s/", DYN_PMU_PATH,
>  =09=09=09=09=09ep->d_name);
> -=09=09=09=09ret =3D read_from_imc_dir(imc_dir, count);
> +=09=09=09=09ret =3D read_from_imc_dir(imc_dir, &count);
>  =09=09=09=09if (ret) {
>  =09=09=09=09=09closedir(dp);
> =20
>  =09=09=09=09=09return ret;
>  =09=09=09=09}
> -=09=09=09=09count++;
>  =09=09=09}
>  =09=09}
>  =09=09closedir(dp);
>=20

Reviewed-by: Ilpo J=E4rvinen <ilpo.jarvinen@linux.intel.com>

--=20
 i.

--8323328-886281517-1774530231=:986--
