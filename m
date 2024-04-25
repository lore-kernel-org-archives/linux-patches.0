Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A1C1494C7
	for <patches@lists.linux.dev>; Thu, 25 Apr 2024 12:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714048409; cv=none; b=Gy/4vAv75fhmaBC5485MifiN2i3fQXCdu7CW3MKCtQBNNJYDarTfelrHIYwF4H38HQjh4ZosIY5oiVH6F6Ev4kiC5Y/r3M9MFpYb6pk25lbcnndFuOjRucASC6s2RJoXpSCWaZp8iLYB3+T6TnvCvh3wlCV5TDl/bzUXgXC/kYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714048409; c=relaxed/simple;
	bh=AT1p51Nd/Ndno6KDZTIXRoxxWTb7rV0Thh15ObEv6DE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=N65JGOHIpSumG055ylro8DFJ/O+E/H9kg6K0hTnmkzdDuZL0w7wtW1POF/lvaTe7rCU8YFQdVTBpu51djlBAMv8ieXqMGrCeAlXUgyD+0k27mWsiKltMxheOjrZORktchEBHsCg62qpGiEeP3sg7YUCJU9My5JjD10vS4/GjiEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ALmB5Ltq; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ALmB5Ltq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714048406; x=1745584406;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=AT1p51Nd/Ndno6KDZTIXRoxxWTb7rV0Thh15ObEv6DE=;
  b=ALmB5LtqqxpFwFr+sCvU54hrGj4UZdWM2FRcCluHxXj44XBapWpLpvC7
   O/A6Codnq7cPB6ybwSLLKQ85EuVN2nSrnh7L1Qj42f+xW0qC+Koqo4tA6
   Aw+2VEnrsspvHjxSDSd2gxwyfRULsZtwgH6a/e6/ZI4elbAuRox51vS+X
   nu2vg4vnYemW5rV5VRjNSFAZa+dc5IdeCmOlD2aSi2a2OWkZ7n/n7ALO4
   w2UGcZgQ0Jq+IjVqFwIQbrLfVu6pMY5xucIs3dg9yRm9SpvRzA0h8Un7j
   y1efFKFSqVzxZ21EasAfrbueMES/dY8Yvr9jkXLUAJScDmkmj4BZYFjqz
   w==;
X-CSE-ConnectionGUID: bGu77Qr1Qca3uKrVvpCSBA==
X-CSE-MsgGUID: z2L6iffPS7C1A44DscbI2Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9656382"
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="9656382"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 05:33:26 -0700
X-CSE-ConnectionGUID: gIgjxxA6Tr6Sh9hw8V6S3g==
X-CSE-MsgGUID: n5ScX5ltTlaZtoDYSdPl3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="25544925"
Received: from spandruv-desk.jf.intel.com (HELO spandruv-desk.amr.corp.intel.com) ([10.54.75.14])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 05:33:26 -0700
Message-ID: <293e2aac01edf24460ba15ed4605ffc90476bedd.camel@linux.intel.com>
Subject: Re: [PATCH v4 61/71] platform/x86: intel_speed_select_if: Switch to
 new Intel CPU model defines
From: srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
To: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, Hans de
 Goede <hdegoede@redhat.com>, Ilpo =?ISO-8859-1?Q?J=E4rvinen?=
 <ilpo.jarvinen@linux.intel.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Date: Thu, 25 Apr 2024 05:33:26 -0700
In-Reply-To: <20240424181540.42330-1-tony.luck@intel.com>
References: <20240424181245.41141-1-tony.luck@intel.com>
	 <20240424181540.42330-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-3.fc36) 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-04-24 at 11:15 -0700, Tony Luck wrote:
> New CPU #defines encode vendor and family as well as model.
>=20
> Signed-off-by: Tony Luck <tony.luck@intel.com>

Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

> ---
> =C2=A0drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c | 2 +=
-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git
> a/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c
> b/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c
> index 1b6eab071068..6c36f7704fe7 100644
> --- a/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c
> +++ b/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c
> @@ -161,7 +161,7 @@ static struct notifier_block isst_pm_nb =3D {
> =C2=A0};
> =C2=A0
> =C2=A0static const struct x86_cpu_id isst_if_cpu_ids[] =3D {
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0X86_MATCH_INTEL_FAM6_MODEL(SKY=
LAKE_X, NULL),
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0X86_MATCH_VFM(INTEL_SKYLAKE_X,=
 NULL),
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0{}
> =C2=A0};
> =C2=A0MODULE_DEVICE_TABLE(x86cpu, isst_if_cpu_ids);

