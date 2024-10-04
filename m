Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8262B139D0B
	for <patches@lists.linux.dev>; Fri,  4 Oct 2024 09:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728033299; cv=none; b=ffrd8lgRrpp529zEr4YuFgqDArS8FGNeFPrXpBjYSJ9NO6yQHDpRhZvxLffq6LaxhlrEdH6TBYcWojWv+Ij3QwQG4SCn8jkOF69UvHRS59ZngHUGeBihRXr3hNXhsRHETMFrWH1W4COKZz4E24Oh5VuK5m7/LcWz12yuuGuUbhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728033299; c=relaxed/simple;
	bh=1C7OiAdPfBqnpWez5BahZoMLagkw/f2Vepo1VUMoKwk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FSfdNCEa9I9smR8m/3y9DDDEqZZppHqPviiRsn4DznsXtEJAv6zIMxH+QOsnoN5uXJOTmwcdGagmYxAPZ/wQB61OOvDwRqDx9nyBP/vFXVw3YwQZDBZGAGlMPcfFDNKGDmCbo4bbDklWPZTZoqibKEa0+ozSBBmMhQyGw5Ia4qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eryRPZaC; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eryRPZaC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728033298; x=1759569298;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=1C7OiAdPfBqnpWez5BahZoMLagkw/f2Vepo1VUMoKwk=;
  b=eryRPZaCvJSoO6s/pTiXpb4c1Yc/vIXoxS3QZDNzT7LCE2SguGRuRnTX
   ixcbhvRBNR6eG7sCxIonIPc8UXXiIbLRoASjmH6L2geqxm0fgl8PZMt8d
   aJ54bizTVRoJvj0k6BqnwL9FUobWhfHrt5hFsVUKYF9wataodN/C97Lqj
   L4JygAJqz0G2RlUSEVr02MiEylK9C7LTi/6sCJ+pDf9vMUhxg6zeCW13/
   I7Yx891nz1Fe3ft1x0ZSRczLHdofQkJu969Vfs9Qb+668oR6snYStbwdM
   dT4vZ3JgzeGXKgFPMaYFPgZho+PWkAZfr02Ux3OzoBMnGxfxwaaoiH8hB
   w==;
X-CSE-ConnectionGUID: HBvytu3zTzOPv+cGET1OxA==
X-CSE-MsgGUID: LMdT+J2ERK+ynwvs/FsZwQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11214"; a="27384894"
X-IronPort-AV: E=Sophos;i="6.11,177,1725346800"; 
   d="scan'208";a="27384894"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2024 02:14:57 -0700
X-CSE-ConnectionGUID: qEPVMXIBSqejCohLUqyHmA==
X-CSE-MsgGUID: 8iPdFBTKQ0eFmCma1/mkaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,177,1725346800"; 
   d="scan'208";a="74647452"
Received: from linux.intel.com ([10.54.29.200])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2024 02:14:58 -0700
Received: from abityuts-desk1.fi.intel.com (abityuts-desk1.fi.intel.com [10.237.68.150])
	by linux.intel.com (Postfix) with ESMTP id 80A2F20B5782;
	Fri,  4 Oct 2024 02:14:56 -0700 (PDT)
Message-ID: <5a0d003078c7cb5aa5196c2dcf0508996ff88fcc.camel@linux.intel.com>
Subject: Re: [PATCH 6.11 608/695] intel_idle: add Granite Rapids Xeon support
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Fri, 04 Oct 2024 12:14:55 +0300
In-Reply-To: <20241002125846.785351246@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
	 <20241002125846.785351246@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 (3.52.3-1.fc40) 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-10-02 at 15:00 +0200, Greg Kroah-Hartman wrote:
> 6.11-stable review patch.=C2=A0 If anyone has any objections, please let =
me know.
>=20
> ------------------
>=20
> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
>=20
> commit 370406bf5738dade8ac95a2ee95c29299d4ac902 upstream.
>=20
> Add Granite Rapids Xeon C-states, which are C1, C1E, C6, and C6P.
>=20
... snip ...

Hi Greg, I was on vacation. Looks good, but I'll test 6.11-stable with thes=
e
patches (#608 and #609) to double check, and let you know if there are issu=
es.

Thanks!
