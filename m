Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9576669B
	for <patches@lists.linux.dev>; Fri, 29 Sep 2023 21:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696021582; x=1727557582;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=v9BueRZQjerm83oD7OFPRBkzsAT7x+Db9BsxRYzoMU0=;
  b=TW5GmCP1ddk76NM8ajsqbPqR+QYaX6Y7PxvMBKCo6pMqqG9lA6HWflVu
   1IZeKyQUvkVgWOwnbLlA7Km1jukG058ZtOkXfvDThu08BFK6n0zsL1UGX
   NnBQW3mNmmdbSijG06p8fGpWbszZzs0x02Y2eCiiR6emaMQGUkxxJetpj
   qE8O78MbR22zmLgRrkBvyeiVeTMsWT7a0XeFjMk4Y8uLXDzAgzDaJlmqG
   REUkrKECoST+GSnUkdf2Lr4e+MhvMPIu47NCU4xPPfP8TUHSJpC/1vISs
   88YxAA0dsOk6RPK1tqVZzjNaUXZGSljhX8GLlRfK4g45YrL/pnShj+NlY
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10848"; a="446539374"
X-IronPort-AV: E=Sophos;i="6.03,188,1694761200"; 
   d="scan'208";a="446539374"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2023 14:06:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10848"; a="923694203"
X-IronPort-AV: E=Sophos;i="6.03,188,1694761200"; 
   d="scan'208";a="923694203"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.74])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2023 14:06:21 -0700
Date: Fri, 29 Sep 2023 14:06:19 -0700
From: Tony Luck <tony.luck@intel.com>
To: Peter Newman <peternewman@google.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org,
	Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v6 0/8] Add support for Sub-NUMA cluster (SNC) systems
Message-ID: <ZRc8SzTgLd1dACHy@agluck-desk3>
References: <20230829234426.64421-1-tony.luck@intel.com>
 <20230928191350.205703-1-tony.luck@intel.com>
 <CALPaoCjxW70h=rTNNiShEc8bmgwEaHpFnAHRB-m=ch47WdQsig@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALPaoCjxW70h=rTNNiShEc8bmgwEaHpFnAHRB-m=ch47WdQsig@mail.gmail.com>

On Fri, Sep 29, 2023 at 04:33:17PM +0200, Peter Newman wrote:
> Hi Tony,
> 
> On Thu, Sep 28, 2023 at 9:14 PM Tony Luck <tony.luck@intel.com> wrote:
> >
> > The Sub-NUMA cluster feature on some Intel processors partitions
> > the CPUs that share an L3 cache into two or more sets. This plays
> > havoc with the Resource Director Technology (RDT) monitoring features.
> > Prior to this patch Intel has advised that SNC and RDT are incompatible.
> >
> > Some of these CPU support an MSR that can partition the RMID
> > counters in the same way. This allows for monitoring features
> > to be used (with the caveat that memory accesses between different
> > SNC NUMA nodes may still not be counted accuratlely.
> 
> Is an "SNC NUMA node" a "sub-NUMA node", or a NUMA node on which SNC
> has been enabled?

It would be architecturally possible to enable SNC mode on
a subset of CPU sockets. But there isn't a BIOS setup option
to do that. You either have SNC everywhere, or nowhere.

I prefer "SNC NUMA node" == "sub-NUMA node".

This version "NUMA node on which SNC has been enabled"
makes it sound like there is a control on a NUMA node
that can be switched.  The control is on the CPU socket.
That's often equivalent to a NUMA node, but Intel has
had CPUs in the past where this isn't the case (e.g.
Cascade Lake -AP and Cooper Lake).
> 
> Thanks!
> -Peter


Thanks for the review of the series. I've applied changes
to my local tree. Will post v7 of the series early next
week if no other reviews come in.

-Tony
