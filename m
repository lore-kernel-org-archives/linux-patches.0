Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C3A2C9C
	for <patches@lists.linux.dev>; Mon, 31 Jan 2022 17:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643649802; x=1675185802;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xIYOgmHAUu2Fj3KeMiX4Tf2d+2ukgp180usOlMKTEGc=;
  b=UuRnukYix4gIqVyTI+seyv5YAW6BpIjuvj8lp82/z9alpUwb1KSV4sZA
   +UvBNfiouS7Bz4fLcvi5XgY2Ie1UQsDvikd0lMgeTFU1+w5p8mOF8wnk8
   YIoDN+i04WQGIk8jYNdmISD8TV2lGKfoLhHDY2sbondxonNd25Ebm22Lj
   siSAdt0JcBh3+kIHVObQp8IGRCQM5cVqFqI7DnzVfSKLxv6VR5odxALNp
   qpDRg9ryAza7j6cZZG3UFg2Tws3w3S50iJVLWs/ku1GHj8krxxozshNWt
   Bpm2S0zi+ZhvlBWhY4FvwRzl291HGu7hs2IL/Kl1YMb/gbQ7Yfzt3MH7h
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="228172482"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="228172482"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 09:23:21 -0800
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="582731220"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.146])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 09:23:21 -0800
Date: Mon, 31 Jan 2022 09:23:20 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Smita Koralahalli Channabasappa <smita.koralahallichannabasappa@amd.com>,
	Wei Huang <wei.huang2@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, patches@lists.linux.dev
Subject: Re: [PATCH v2 0/6] PPIN (Protected Processor Inventory Number)
 updates
Message-ID: <YfgbCFNeNEkypCmC@agluck-desk2.amr.corp.intel.com>
References: <20220107225442.1690165-1-tony.luck@intel.com>
 <20220121174743.1875294-1-tony.luck@intel.com>
 <YffWtTq2y6K8+gHF@zn.tnic>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YffWtTq2y6K8+gHF@zn.tnic>

On Mon, Jan 31, 2022 at 01:31:49PM +0100, Borislav Petkov wrote:
> On Fri, Jan 21, 2022 at 09:47:37AM -0800, Tony Luck wrote:
> > ...
> 
> They look good so far on my PPIN-enabled AMD box.
> 
> > 5) Add "ppin" to /sys/devices/system/cpu/cpu*/topology/ppin
> > 
> > The big question for this part is whether there is a better
> > place to expose this value. I'm open to other suggestions.
> 
> Yeah, I'm not sure about that either. I have
> 
> $ grep -r . /sys/devices/system/cpu/cpu*/topology/ppin | cut -d: -f 2 | uniq -c
>      32 0xxxxx
> 
> 32 times the same number.
> 
> Wouldn't
> 
> /sys/devices/system/node/
> 
> be a better place?

Maybe.

> Even if those were logical nodes, it would still be less needless
> replication and that would be one more way for root to figure out which
> logical nodes belong to the same physical package... :-)

That would work for existing products. There are some cases where
a single package appears as mutiple nodes. But that's ok ... as you
say, one more clue to the topology.

I'm worried that some future thing might reverse that and have
a "package" id for each die in a multi-die package which still
appears as a single node. That would distort the meaning of "package",
so it isn't supposed to happen. But if it did, Linux would be stuck
just reporting one of the "package" ids.

-Tony
