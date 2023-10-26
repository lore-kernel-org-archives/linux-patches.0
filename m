Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A63F3B7BB
	for <patches@lists.linux.dev>; Thu, 26 Oct 2023 19:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hXtmQgap"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698350044; x=1729886044;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YoVYbR7RlCt/ClEPZWOyiJe3KsZblEHvYygtlHWLDFU=;
  b=hXtmQgapFB5qFLFAL430n+OyhREfIFgUuMmOmIIDjsOTEDDLpqvnS4FC
   asuzBvUPaD80LJVVQQV4BB6rQHpLV4dNlL6wV/rAW3up/echCDB/qK/EY
   I2FIh0cs3/MeFnDH8HKVDMMPXG/WJQU9BhRtObyKWKFk2SFp/K0tCXwYx
   ox3rK9E5NsNUx0PbgOyURskjFT7MmsDTN44GKxJNCKxlWAD5A+nggHv56
   Q9q989pqkthAFUTS1MVFolfPmjeTKojulYGHmclIqXzb0LFTlIzXLB572
   jNSupiiNIfWMwOmNWk2eSwyVzg7cnRoQ1LRdi6VH6MeGLMKLLmJk0xl9i
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="384841176"
X-IronPort-AV: E=Sophos;i="6.03,254,1694761200"; 
   d="scan'208";a="384841176"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2023 12:54:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="735856795"
X-IronPort-AV: E=Sophos;i="6.03,254,1694761200"; 
   d="scan'208";a="735856795"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.74])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2023 12:54:02 -0700
Date: Thu, 26 Oct 2023 12:54:01 -0700
From: Tony Luck <tony.luck@intel.com>
To: "Moger, Babu" <babu.moger@amd.com>
Cc: Peter Newman <peternewman@google.com>,
	"Yu, Fenghua" <fenghua.yu@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"x86@kernel.org" <x86@kernel.org>,
	Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH] x86/resctrl: mba_MBps: Fall back to total b/w if local
 b/w unavailable
Message-ID: <ZTrD2Q8Hpk1EjIBA@agluck-desk3>
References: <20231024181600.8270-1-tony.luck@intel.com>
 <CALPaoChftF-H6GauKq4-c_qBJP1GJbR3-ByE5krsaQF4y4y9oQ@mail.gmail.com>
 <ZTluypa9bCWv4k2n@agluck-desk3>
 <CALPaoCj72V=o60tqsFMRzaeUw-1+rN7pyhsdCyVEV=0tN_CZ7A@mail.gmail.com>
 <95fc35a2-2f19-4ba5-ad3a-7d7ae578289c@amd.com>
 <SJ1PR11MB60837D379853EFB14A6A20BBFCDDA@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <a55c7d7e-019f-4eb1-9ae7-ec5e0f810bd3@amd.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55c7d7e-019f-4eb1-9ae7-ec5e0f810bd3@amd.com>

On Thu, Oct 26, 2023 at 12:19:14PM -0500, Moger, Babu wrote:
> Hi Tony,
> 
> On 10/26/23 11:09, Luck, Tony wrote:
> >>> What I meant was I think it would be enough to just give the function
> >>> you added a name that's more specific to the Mbps controller use case.
> >>> For example, get_mba_sc_mbm_state().
> >>
> >> I actually liked this idea. Add a new function get_mba_sc_mbm_state. That
> >> way we exactly know why this function is used. I see you already sent a v2
> >> making the event global. Making it global may not be good idea. Can you
> >> please update the patch and resend. Also please add the comment about why
> >> you are adding that function.
> > 
> > Can you explain why you don't like the global? If there is a better name for it,
> > or a better comment for what it does, or you think the code that sets the value
> > could be clearer, then I'm happy to make changes there.
> 
> My theory is always try to localize the changes and avoid global variables
> when there are other ways to do the same thing. It may not be strong argument.

A good theory. I do this too. But it seems I'm more likely to go with
global variables if the cost of avoiding them is high. But "cost" is
a very subjective thing.

> > Which events are supported by a system is a static property. Figuring out once
> > at "init" time which event to use for mba_MBps seems a better choice than
> > re-checking for each of possibly hundreds of RMIDs every second. Even though
> > the check is cheap, it is utterly pointless.
> 
> mbm_update happens here only to the active group (not on all the available
> rmids).

mbaMBps needs to get data from all active RMIDs to provide input to
the feedback loop. That might be a lot of RMIDs if many jobs are being
monitored independently (which I believe is a common mode of operation).

> Also, I am not clear about weather this is going fix your problem.
> You are setting the MSR limit based on total bandwidth. The MSR you are
> writing may only have the local socket effect. In cases where all the
> memory is allocated from remote socket then writing the MSR may not have
> any effect.

Intel MBA controls operate on all memory operations that miss the L3
cache (whether they are going to a local memory controller, or across
a UPI link to a memory controller on another socket).

> Also you said you don't have the hardware to verify. Its always good to
> verify if is really fixing the problem. my 02 cents.

I don't have hardare that enforces this. But Linux does have a boot
option clearcpuid=cqm_mbm_local to tell Linux that the system doesn't
provide a local counter. I've been using that for all my testing.

-Tony
