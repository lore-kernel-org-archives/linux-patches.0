Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E35A48D8
	for <patches@lists.linux.dev>; Fri, 18 Mar 2022 12:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647606084; x=1679142084;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vVgvop8ogGrUADiEvIVvjtGIkCVphzfkaitXclPagy8=;
  b=MlJx7bPMyMaxQgqXp8QCwjVHGSglBcsC4ZQskwZa/gdqGnTegrz/bpFP
   uXs/1Ht74hlISX74MvuvzncQwX7bd749qu7Mu8vk96OsaWiAAWkIGQGte
   28HUsQOO5mkjl/moXDSgbVem2mwL7UDKYzSaeY1R6fBYpSwMBNazG55Pt
   QXeOuLC091iaIIvUGggKniP5DL3UZQD3ciTvnVoT1DkYmOaxIaxrsQ82N
   Zds2tQoJ0h4wYgJnWXesySIAV8Xl+kt8288Eg2ogMK6K9nybjR4sovZJ3
   Dc68nJgEyn4wdX58SLcAkLyZE1mQA5ZSsXpXzko0Z3mTwVYIE2rAPyhaU
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="320335954"
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="320335954"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 05:21:23 -0700
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="715457854"
Received: from otcwcpicx3.sc.intel.com ([172.25.55.73])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 05:21:23 -0700
Date: Fri, 18 Mar 2022 05:21:18 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: David Laight <David.Laight@ACULAB.COM>,
	'Thomas Gleixner' <tglx@linutronix.de>,
	Pavel Machek <pavel@denx.de>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v2 1/2] x86/split_lock: Make life miserable for split
 lockers
Message-ID: <YjR5Pl2uAUPbDZzT@otcwcpicx3.sc.intel.com>
References: <20220217012721.9694-1-tony.luck@intel.com>
 <20220310204854.31752-1-tony.luck@intel.com>
 <20220310204854.31752-2-tony.luck@intel.com>
 <20220317111305.GB2237@amd>
 <87fsngcv25.ffs@tglx>
 <e2baf93885684512b4c7dc5363620a6f@AcuMS.aculab.com>
 <8ceaa1e7624b46feafb15da0935e161c@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ceaa1e7624b46feafb15da0935e161c@intel.com>

On Thu, Mar 17, 2022 at 03:40:16PM -0700, Luck, Tony wrote:
> > They are actually more likely to happen in the kernel
> > when code casts int[] to long[] and then uses the 'BIT' functions to
> > set/clear bits - which do locked operations.
> > Quite often then don't need the locks anyway.
> > And that cast is surprisingly common and completely broken on BE.
> 
> Default split lock mode is "kernel dies". We had to fix up a dozen or
> so places (mostly involving set_bit/clr_bit as you describe). But
> all Ice Lake. Tiger Lake and Alder Lake systems are running in
> that mode ... and we haven't heard of widespread death (or disabling
> the boot option).

Split lock is designed to report this kind of "hidden" performance issues.
After initial fix up wave, it has been sparse to find any legacy split lock
issue in the kernel.

If a new split lock issue is introduced, the developer hopefully will
capture and fix it before upstream. So others won't see it any more.

Thanks.

-Fenghua
