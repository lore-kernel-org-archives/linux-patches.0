Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8007F27D773
	for <patches@lists.linux.dev>; Tue,  4 Mar 2025 15:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741101767; cv=none; b=oDtibm6CFrFQ6Nzlx4nUcUgrHwFkExPNrTfTdXANynLwG6zIxKNCuBqzT1mi6/tAmb89oK2d3FyMoSrcYkSoFfX+wcAPJu8RxXteb6CaRvmlX5jNWRp4FSiM8bjrIsYn+Xbdq7XjeMG7+I+R4L6v77rwjzOsp4IDX5nPM8MVGWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741101767; c=relaxed/simple;
	bh=+dAPuvvzkT/7liQQpyStWyWFx3lvMg5W0ztMqyxWWmg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=e2WVZM2i+mKsBG++pddrhg9OiGeszoBDlwHScPNJbrYOV1ZJlpCN+eIDjnpc1+qS4oWZEKkM0fN8I397O/J6QbYgzP19DV27C4JMPlRiPZX3ki377rykKR73Mv7jX3cDZoRx+xFpEvH2hprwvI/nqtRjoX+khihLOqdXJrEqeH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e6tBUcRK; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e6tBUcRK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741101766; x=1772637766;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=+dAPuvvzkT/7liQQpyStWyWFx3lvMg5W0ztMqyxWWmg=;
  b=e6tBUcRKnFgQPXtjumnvq3TnNAXvn3mcPBH/Sfew9IucI6EAe+vyJThA
   cdoG8/FIzDKmHQFOSwlSWJwLLEr8i43YFi2jIIlNPxyq6fGHdNJEjAx/7
   QBoVYfJ9k1wEd9n/QnZPYwjVMEfmkDzPd4tIfco0u2lEAz4TpopNXWjCj
   aiPTlKDRO6eC8CXmTcVIH6cdqZ5YNFHum4Ug0q8O6vGwXvOPDzdWZoJUO
   C5KVfSWqibIrwC8I/ZKLPhWbDqnBJiOuTKW8IM1ADi1sDGtpSno1OYtfQ
   SPCh0/IBRlWLtzrgw2j5+5g5S9GFCUZmSfO9Dgk//Ny3dR6IBnftGdPbQ
   Q==;
X-CSE-ConnectionGUID: pcJC/DkbSYOBHXZyjcPUgg==
X-CSE-MsgGUID: LHuHxo6pSQqGLwi8JVz5dg==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="41738245"
X-IronPort-AV: E=Sophos;i="6.14,220,1736841600"; 
   d="scan'208";a="41738245"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 07:22:45 -0800
X-CSE-ConnectionGUID: qXLQoZ6hQTGUg/NhszrptA==
X-CSE-MsgGUID: q8671CrASSiGtXIWFAnN1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="122532571"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.192])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 07:22:41 -0800
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Aditya Garg <gargaditya08@live.com>, Nathan Chancellor <nathan@kernel.org>
Cc: Aun-Ali Zaidi <admin@kodeit.net>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, Atharva Tiwari
 <evepolonium@gmail.com>, Kerem Karabay <kekrby@gmail.com>,
 "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>, Nathan Chancellor
 <nathan@kernel.org>
Subject: Re: [PATCH] drm/appletbdrm: Fix format specifier for size_t variables
In-Reply-To: <PN3PR01MB959766B5334E2D3B953ADE0EB8C82@PN3PR01MB9597.INDPRD01.PROD.OUTLOOK.COM>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20250304-appletbdrm-fix-size_t-specifier-v1-1-94fe1d2c91f8@kernel.org>
 <PN3PR01MB959766B5334E2D3B953ADE0EB8C82@PN3PR01MB9597.INDPRD01.PROD.OUTLOOK.COM>
Date: Tue, 04 Mar 2025 17:22:38 +0200
Message-ID: <877c54zupt.fsf@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, 04 Mar 2025, Aditya Garg <gargaditya08@live.com> wrote:
>> On 4 Mar 2025, at 6:49=E2=80=AFPM, Nathan Chancellor <nathan@kernel.org>=
 wrote:
>>=20
>> =EF=BB=BFWhen building for a 32-bit platform, there are some warnings (o=
r errors
>> with CONFIG_WERROR=3Dy) due to an incorrect specifier for 'size_t'
>> variables, which is typedef'd as 'unsigned int' for these architectures:
>>=20
>>  drivers/gpu/drm/tiny/appletbdrm.c:171:17: error: format specifies type =
'unsigned long' but the argument has type 'size_t' (aka 'unsigned int') [-W=
error,-Wformat]
>>    170 |                 drm_err(drm, "Actual size (%d) doesn't match ex=
pected size (%lu)\n",
>>        |                                                                =
             ~~~
>>        |                                                                =
             %zu
>>    171 |                         actual_size, size);
>>        |                                      ^~~~
>>  ...
>>  drivers/gpu/drm/tiny/appletbdrm.c:212:17: error: format specifies type =
'unsigned long' but the argument has type 'size_t' (aka 'unsigned int') [-W=
error,-Wformat]
>>    211 |                 drm_err(drm, "Actual size (%d) doesn't match ex=
pected size (%lu)\n",
>>        |                                                                =
             ~~~
>>        |                                                                =
             %zu
>>    212 |                         actual_size, size);
>>        |                                      ^~~~
>>=20
>> Use '%zu' as suggested, clearing up the warnings.
>>=20
>> Fixes: 0670c2f56e45 ("drm/tiny: add driver for Apple Touch Bars in x86 M=
acs")
>> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
>> ---
>> drivers/gpu/drm/tiny/appletbdrm.c | 4 ++--
>> 1 file changed, 2 insertions(+), 2 deletions(-)
>
> This went into my spam for some reason, but looks like Jani already infor=
med you about my Ack :)

Thanks for the patch and ack, pushed to drm-misc-next.

BR,
Jani.



--=20
Jani Nikula, Intel
