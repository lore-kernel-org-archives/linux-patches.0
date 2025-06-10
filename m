Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13BF2472A8
	for <patches@lists.linux.dev>; Tue, 10 Jun 2025 18:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749581318; cv=none; b=t/sfRW+Z/fzZVIcPfs1Anz9gbJ83eV9Ybjb0k+eubIkQ9RIWgnENnIvQHk6degTVJ8ta3nzHwut0fM+fEZvoL4ingeQ0zy5UAWnLjyJgJFJ4mfmrYwGgYag6ML5hmaYX8zt/0Jmbn0KDRaUKthJlQEA/cue7UKSlawNgD0B96b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749581318; c=relaxed/simple;
	bh=JdYBANVXTPzIVDhBJ340XB4Orydp/8+n8ekFirtZGg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kmQQG91jF6sWLsc/VPJ6qjAn3s77S05UTyiEYYE3O8oP39U+wzOpsOmkYm4oDPhIz6YTHyxplHFxJTPbobwRZyfoKWhQRFpatXrSX66YQ3NnxRwf3Y5sjPp7CVygOAcawd0b7/ddvvRRdhEaiZ3uSyQAu5G7urHX17E8o0Hx4Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PfQ5/WbF; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PfQ5/WbF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749581317; x=1781117317;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JdYBANVXTPzIVDhBJ340XB4Orydp/8+n8ekFirtZGg4=;
  b=PfQ5/WbF1ONu3mDtrAdomkW3UZ6xXr0PTXgIgrKEr+MAyW5uGuDsqOt3
   0h3kLf3b0hPS4GPoof5ul3UVGdGKl8RvkHjpo+JWowYNFml/iQpB2r8jj
   RKu+m5TetBU0kWWoSaNUQhl9zYU7JR55ie2l6aSMS3C8x89dMFsRyxLgF
   p+cMPEKLoamLn1s+0tUBll3bZ0sIqawMIBxTVzBHyJ7aTorQHElVebG9R
   juwtHGvbyQ+tLD6iHRGiM0+hWumcH3n9GEvgXp8ytDPAInNXUHZcIpHl7
   wzRrXEouZY2lS+M2ZZsoKX6sKauGJMSWKIO11YcUJkLrvzli28tGhUsRW
   g==;
X-CSE-ConnectionGUID: 41Pyh7HYQjO8gH2N6HVe3g==
X-CSE-MsgGUID: lLLbRE+5StSBnuqrgTwNgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="50932540"
X-IronPort-AV: E=Sophos;i="6.16,225,1744095600"; 
   d="scan'208";a="50932540"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 11:48:36 -0700
X-CSE-ConnectionGUID: FdqcHoJMR0mFF0WuHWi5ew==
X-CSE-MsgGUID: E7hbCtomS7+Gz1L5FtuHig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,225,1744095600"; 
   d="scan'208";a="146904849"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 11:48:36 -0700
Date: Tue, 10 Jun 2025 11:48:33 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	"Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
	"Chen, Yu C" <yu.c.chen@intel.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v5 27/29] fs/resctrl: Add file system mechanism for
 architecture info file
Message-ID: <aEh-AbZ8N_WZqogb@agluck-desk3>
References: <20250521225049.132551-28-tony.luck@intel.com>
 <f25d136c-b1d3-483a-ac77-92464d7fe25c@intel.com>
 <aEIxzbuFybLBE3xt@agluck-desk3>
 <9eb9a466-2895-405a-91f7-cda75e75f7ae@intel.com>
 <aEMlznLgnn6bK9lo@agluck-desk3>
 <d2be3a4e-1075-459d-9bf7-b6aefcb93820@intel.com>
 <aEcsxjWroliWf3G0@agluck-desk3>
 <fb2396c1-3799-4d45-ae24-ce7e6f0d42e2@intel.com>
 <SJ1PR11MB60834D5E5D78CE229D04204FFC6BA@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <71a51672-4cc7-47eb-bbbb-a3195189becc@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71a51672-4cc7-47eb-bbbb-a3195189becc@intel.com>

On Mon, Jun 09, 2025 at 05:30:34PM -0700, Reinette Chatre wrote:
> This should be a directory, a directory owned by the arch where it can create
> debug infrastructure required by arch. The directory name chosen and
> assigned by resctrl fs, while arch has freedom to create more directories
> and add files underneath it. Goal is to isolate all arch specific debug to
> a known location.
> 
> Again, we need to prepare for resctrl fs to potentially use debugfs for its own
> debug and when it does this the expectation is that the layout will mirror
> /sys/fs/resctrl. Creating a directory /sys/kernel/debug/resctrl/info/<rdt_resource::name>_MON
> and then handing it off to the arch goes *against* this. It gives arch
> control over a directory that should be owned by resctrl fs.
> 
> What I have been trying to propose is that resctrl fs create a directory
> /sys/kernel/debug/resctrl/info/<rdt_resource::name>_MON/arch_debug_name_TBD and hand
> a dentry pointer to it to the arch where it can do what is needed to support its debugging needs.
> Isn't this exactly what I wrote in the snippet above? Above you respond with
> statement that you were under impression that it was a directory ... and then
> send a patch that does something else. I am so confused. Gaslighting is
> beneath you.

For the precise name of the "arch_debug_name_TBD" directory, is simply "arch"
sufficient? That leaves every other name available for resctrl
filesystem code free choice if it does add some debug files here.

Or would $ARCH ("x86" in my case) be better to keep distinct debug name
spaces between architectures?

-Tony
