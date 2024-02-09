Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5B457337
	for <patches@lists.linux.dev>; Fri,  9 Feb 2024 18:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707503494; cv=none; b=l4eZC7mraw7zebISowJTfm9xkNIM7LClDaohxM98uKJm3WxLZO+zx8f1S9IV1JKuePhDqpjWhPhVVxv+Cg1TwMi5gBUZACkMbWcm/gNLORFNWDAL9Jr0BSFvA8mcLbJ3aJn/lE/8qkBap84rVkqDtP5ONyNUKCNYEOLV5TJ5WoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707503494; c=relaxed/simple;
	bh=M3/AQ82yfrpbo27RiP67TArS5rEkXNxRZ/v2g1yjKCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fzHLKV+8aXaZOtQEsoW+GCCyX1IwGEUUFcJx3V03wAeSaJ3NYBlMElHoWPw4o5U4mJj1f8HRFIZ8S6rB7hY5/PyBtqQowHyMC63CXPUZFcEDidiBgCtzCPff2MJlHDydvOh3VCKSNHYfb34FD453GRHIgAqu+605VqW8O4jF4LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qerhjo/9; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qerhjo/9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707503493; x=1739039493;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=M3/AQ82yfrpbo27RiP67TArS5rEkXNxRZ/v2g1yjKCs=;
  b=Qerhjo/9H/w0C+GQyNyObD859krV5jFP8tMB15pGcVCFqXlkN0Ex4kbe
   wCrnKY1SPtn9t1sCI3yGMNbIgg5tBtD89opy5Uu/D3JCgKSC8P6oHrBSE
   E0BlEGYJJjI/TNkxBBHgaJUSUTXoBncZeAfrvjjO5/qAVoyu1wNwgib6Y
   D+BD+3rYGuE28UMZW3usjw5xy4ZgToiQ2Eq2eTqOERAzmfpreo7TiK01u
   Ycj6CTcvuoatXd6bNJJM+omtH0sm+59qSWNhgZKRkI4tX1a+/yv5/Yr0X
   ZTatIBymosouBTlGZgLQlflYQhEWfbhUaR8Iq8o9MNPpS2CAhU30ack4v
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10979"; a="12211012"
X-IronPort-AV: E=Sophos;i="6.05,257,1701158400"; 
   d="scan'208";a="12211012"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2024 10:31:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,257,1701158400"; 
   d="scan'208";a="2297834"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.74])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2024 10:31:32 -0800
Date: Fri, 9 Feb 2024 10:31:30 -0800
From: Tony Luck <tony.luck@intel.com>
To: "Moger, Babu" <babu.moger@amd.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org,
	Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Drew Fustini <dfustini@baylibre.com>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v15-RFC 0/8] Add support for Sub-NUMA cluster (SNC)
 systems
Message-ID: <ZcZvguSNel-z3Xe5@agluck-desk3>
References: <20240126223837.21835-1-tony.luck@intel.com>
 <20240130222034.37181-1-tony.luck@intel.com>
 <91bd281e-e21f-4b60-9e73-2f14fcbec316@amd.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91bd281e-e21f-4b60-9e73-2f14fcbec316@amd.com>

On Fri, Feb 09, 2024 at 09:27:56AM -0600, Moger, Babu wrote:
> Hi Tony,
> 
> On 1/30/24 16:20, Tony Luck wrote:
> > This is the re-worked version of this series that I promised to post
> > yesterday. Check that e-mail for the arguments for this alternate
> > approach.
> 
> To be honest, I like this series more than the previous series. I always
> thought RDT_RESOURCE_L3_MON should have been a separate resource by itself.
> 
> You need to separate the domain lists for RDT_RESOURCE_L3 and
> RDT_RESOURCE_L3_MON if you are going this route. I didn't see that in this
> series. Also I have few other comments as well.

They are separated. Each "struct rdt_resource" has its own domain list.

Or do you mean break up the struct rdt_domain into the control and
monitor versions as was done in the previous series?
> 
> Thanks
> Babu
> 
