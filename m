Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B90225554
	for <patches@lists.linux.dev>; Thu,  4 Jan 2024 17:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V/te0wKh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704387788; x=1735923788;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=MFQ6qJE8e0dUgh7NSSzr8MmZzIEvL6EpBU67MVSdZxA=;
  b=V/te0wKhTUj9ypD4r7uLDE1V2UJRbkZ+MXRPD6eLpxbLcP6vqunrby9C
   16bkSJi24QFFEQ3fbBGwG2UOirumEHvQlflbzy0fHbnNPTaljJr/mV7fE
   BwUeqP7uSRpb8g5vSkB1gGklyQVPh74k0jRa/9Od+HyTUGNzmfmbxGJkv
   1aExdgtTFqSim6i3F/6Sh6J8dg48BOSa/yrEdC/fRPRpEhm/B7LC2seNJ
   dB9My0/Znqe6jsCoJ+RZu0bWgoHczKRwSA3kofUlJ5kPtDeecItK+K7tA
   piD59tuLerP7ScM+bFTh8ccCNlQoewl5ZfoI6RhrvgAN8F5WKyKo5N6k/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="461602723"
X-IronPort-AV: E=Sophos;i="6.04,331,1695711600"; 
   d="scan'208";a="461602723"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2024 09:02:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="783943975"
X-IronPort-AV: E=Sophos;i="6.04,331,1695711600"; 
   d="scan'208";a="783943975"
Received: from asebenix-mobl1.ger.corp.intel.com ([10.251.210.215])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2024 09:02:57 -0800
Date: Thu, 4 Jan 2024 19:02:52 +0200 (EET)
From: =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
    "stable@vger.kernel.org" <stable@vger.kernel.org>, 
    "patches@lists.linux.dev" <patches@lists.linux.dev>, 
    Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 6.1 086/100] platform/x86: p2sb: Allow p2sb_bar() calls
 during PCI device probe
In-Reply-To: <djjzvybh5z5q5ojn3isltl6g32gpvhcilzfr3rznb5hlijjavm@z3itpol7wec7>
Message-ID: <5f97aaa-2d8e-498b-18d1-88e048443dcc@linux.intel.com>
References: <20240103164856.169912722@linuxfoundation.org> <20240103164909.026702193@linuxfoundation.org> <ikeipirtlgca6durdso7md6khlyd5wwh4wl2jzlxkqr2utu4p4@ou2wcovon7jt> <2024010401-shell-easiness-47c9@gregkh>
 <djjzvybh5z5q5ojn3isltl6g32gpvhcilzfr3rznb5hlijjavm@z3itpol7wec7>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Thu, 4 Jan 2024, Shinichiro Kawasaki wrote:

> On Jan 04, 2024 / 09:58, Greg Kroah-Hartman wrote:
> > On Thu, Jan 04, 2024 at 08:54:48AM +0000, Shinichiro Kawasaki wrote:
> 
> ...
> 
> > > Greg, please drop this patch from 6.1-stable for now. Unfortunately, one issue
> > > has got reported [*].
> > > 
> > > [*] https://lore.kernel.org/platform-driver-x86/CABq1_vjfyp_B-f4LAL6pg394bP6nDFyvg110TOLHHb0x4aCPeg@mail.gmail.com/T/#u
> > 
> > What about 6.6.y, this is also queued up there too.
> 
> Please drop it from 6.6.y too.
> 
> > And when is this going to be reverted in Linus's tree?  6.7-rc8 has this
> > issue right now, right?
> 
> Yes. I agree that revert action is needed.
> 
> Ilpo,
> 
> As I commented to the response to the bug report, fix does not look straight
> forward to me. I guess fix discussion with x86 experts' will take some time
> (Andy is now away...). I will post a revert patch later. May I ask you to handle
> it?

I've applied the revert and made a PR out of it:

https://lore.kernel.org/platform-driver-x86/1a6657ef8475862e4fc282efe832fa86.=%3FUTF-8%3Fq%3FIlpo=20J=C3=A4rvinen%3F=%20%3Cilpo.jarvinen@linux.intel.com/T/#u


I found it a bit disappointing to hear from Greg that patches can no 
longer be dropped from stable-queue (it certainly used to be possible 
earlier) but things are to be handled indirectly through commits in Linus' 
tree.

I'll probably just /dev/null those stable queue notification emails then 
if they no longer serve any other purpose than spamming my inbox (which is 
largely thanks to me bothering to review other people patches :-/)...

-- 
 i.

