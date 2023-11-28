Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70784374D7
	for <patches@lists.linux.dev>; Tue, 28 Nov 2023 13:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z8DeZ0Az"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701177062; x=1732713062;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version:content-id;
  bh=W/qpGnBzy7ezU7GIo/j4bVFtt1My8WartS/I7Lj/zZo=;
  b=Z8DeZ0AzQALy7516Yam2sD9lML/A2n4ZmTmAmk2HQ28y2SCw+vdOQhWI
   2YcCL0ObLFFXLux0/sS/j6y3gBjpfwB00oiElaM0K/lZZE+2ixPLmloCz
   FPVEkayESqjZ6/BDtnTKNtWMw4QejMUBpGJCyvc2p7mD4NSbWJ66ZAUj3
   Dy30WJZmgNYHeEGUHkJumjKIKQKinfGVnZE03buflFLOXdxO3nEqslimd
   kmWR8ds6YEdZy2/hwrwP5OA/14EHSCCto9LgJWCgpvo+FrbLYHLVGjZo2
   WiVRPqi62nf7/0My50mFfIS6FIRI/UHLq+KaayaA1vDc+qS6O1k8fSooE
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="383305462"
X-IronPort-AV: E=Sophos;i="6.04,233,1695711600"; 
   d="scan'208";a="383305462"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 05:11:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="772305939"
X-IronPort-AV: E=Sophos;i="6.04,233,1695711600"; 
   d="scan'208";a="772305939"
Received: from haslam-mobl1.ger.corp.intel.com ([10.252.43.79])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 05:10:55 -0800
Date: Tue, 28 Nov 2023 15:10:53 +0200 (EET)
From: =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: Pavel Machek <pavel@denx.de>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
    patches@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>, 
    torvalds@linux-foundation.org, akpm@linux-foundation.org, 
    linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
    lkft-triage@lists.linaro.org, jonathanh@nvidia.com, f.fainelli@gmail.com, 
    sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
    conor@kernel.org, allen.lkml@gmail.com, alexander.deucher@amd.com, 
    mario.limonciello@amd.com, zhujun2@cmss.chinamobile.com, sashal@kernel.org, 
    skhan@linuxfoundation.org, bhelgaas@google.com
Subject: Re: [PATCH 4.14 00/53] 4.14.331-rc2 review
In-Reply-To: <ZWUBaYipygLMkfjz@duo.ucw.cz>
Message-ID: <f4a7634-3d34-af29-36ca-6f3439b4ce9@linux.intel.com>
References: <20231125163059.878143365@linuxfoundation.org> <ZWUBaYipygLMkfjz@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-1757973175-1701176421=:1797"
Content-ID: <f1416554-45a2-88f4-cbbe-be3bf3f8463f@linux.intel.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1757973175-1701176421=:1797
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <e158dfad-df96-d4e1-9415-2ce71679a57@linux.intel.com>

On Mon, 27 Nov 2023, Pavel Machek wrote:

> Hi!
> 
> > This is the start of the stable review cycle for the 4.14.331 release.
> > There are 53 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.

> > Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> >     RDMA/hfi1: Use FIELD_GET() to extract Link Width
> 
> This is a good cleanup, but not a bugfix.
> 
> > Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> >     atm: iphase: Do PCI error checks on own line
> 
> Just a cleanup, not sure why it was picked for stable.

Just an additional bit of information, there have been quite many cleanups 
from me which have recently gotten the stable notification for some 
mysterious reason. When I had tens of them in my inbox and for various 
kernel versions, I immediately stopped caring to stop it from happening.

AFAIK, I've not marked those for stable inclusion so I've no idea what
got them included.


-- 
 i.
--8323329-1757973175-1701176421=:1797--
