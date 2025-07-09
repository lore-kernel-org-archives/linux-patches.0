Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A563944F
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 22:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752101320; cv=none; b=iE8N/OV+vKR3tt2SBb8lVEff2QKnSFtcV36JlYfl6KUe7lHF89rDI1b9n1NKh0bHQsXTro2mXKkyR70roEoFIWtLaMFGYQbghGaJ/3d7gxkxExfdo/I6CmcgIBOEgtsINGvW/cnSwOEvOvI2cyIdDZeAH08/EyHJFN1Sa/0jfXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752101320; c=relaxed/simple;
	bh=HFbiJ2A2Xz5p0qQ5IF/YRWPs2zn55kHge0Qr75pRJ0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Skm9p+RLn8ScPkADsSLACejMhcIo4+CdI9BtotXBoZs2CTqQTjX3AXdPnV5bRn3iA8CYjfp3rygdoEsCvfreQE78wkFcitjxRzexuK+6UIegin8Pf4F3mSA6RoCDPpwKYdb+t0burTi+4RyhJAPyPW5A5T1O3Gj625nERgLhONA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iU3kiWvc; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iU3kiWvc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752101319; x=1783637319;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HFbiJ2A2Xz5p0qQ5IF/YRWPs2zn55kHge0Qr75pRJ0s=;
  b=iU3kiWvco94ecrXZrA8cfnehBq+BgjVcjVTmvRPMHCDY/hRQNRDwnI1H
   aLrbWvKyrkGcIb58rPPSsw/2pPoJm7VxM5Eg1/NOAqT8lpJ8NTArfA1tv
   KCWsoJYzD19Bzszr8vxy/1rsb5ifcMHqlZDx9k0EA1s7bqhNJzNnvcZkh
   ClieXcN/POBsAgO59fGWTtWy5CraPpho4qtB/wSguUoZ+IfsE4Ur9T0dD
   R+hgflLQAiU0QsHG9CPVWtp6oC8Ws4D49D5clRBCqbKCj1j7iIZ9H/3e2
   BCMpITRFudCry5a1DM3GC4tyRwzml0Y60SfYhkKoQw2y9xW1jO8jQf4zi
   g==;
X-CSE-ConnectionGUID: qwhd8snNRJyKtyN2bW4meg==
X-CSE-MsgGUID: vM8PGyliS9+vzQH7iDupFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="58179321"
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="58179321"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 15:48:37 -0700
X-CSE-ConnectionGUID: jNcmKpYlSbKbYEEiOcHENA==
X-CSE-MsgGUID: ThRvWv04TzyrNTCx7yEY2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="186871858"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 15:48:37 -0700
Date: Wed, 9 Jul 2025 15:48:36 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v6 18/30] x86/resctrl: Count valid telemetry aggregators
 per package
Message-ID: <aG7xxIzTZ2hAVrxP@agluck-desk3>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-19-tony.luck@intel.com>
 <69f18b65-4e20-4383-a559-46fe1eda7db0@intel.com>
 <aG6xGGiOy3xKL-t4@agluck-desk3>
 <74a1e5f0-5484-4952-9a61-7a4e5b96b707@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74a1e5f0-5484-4952-9a61-7a4e5b96b707@intel.com>

On Wed, Jul 09, 2025 at 03:13:20PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 7/9/25 11:12 AM, Luck, Tony wrote:
> > On Tue, Jul 08, 2025 at 07:20:35PM -0700, Reinette Chatre wrote:
> >> As I understand there is 1:1 relationship between struct event_group and struct pmt_feature_group.
> >> It thus seems unnecessary to loop through all the telemetry regions of a struct pmt_feature_group
> >> if it is known to not be associated with the "event group"?
> >> Could it be helpful to add a new (hardcoded) event_group::id that is of type enum pmt_feature_id
> >> that can be used to ensure that only relevant struct pmt_feature_group is used to discover events
> >> for a particular struct event_group?
> >>
> >> Another consideration is that this implementation seems to require that guids are unique across
> >> all telemetry regions of all RMID telemetry features, is this guaranteed?
> > 
> > The guids are unique. The XML file tags them like this:
> > 
> > 	<TELEM:uniqueid>26557651</TELEM:uniqueid>
> 
> I interpret above that guid is expected to be unique for one
> telemetry feature. It is not clear to me that it implies that the guid
> is unique across all telemetry features. For example, what prevents
> a platform from using the same guid for all the telemetry features it
> supports?

There are several non-RMID based telemetry MMIO regions in addition to
the two used by this patch series.

Think of the uniqueid as a signature for the format of the region.
Which event counters are present, in which order? How many total
counters? What is the binary format of each counter?

Or think of it as a key. Usermode telemetry tools that access these MMIO
regions use the uniqueid to choose which XML file to use to interpret
the data. I'm effectively doing this, but without including an XML
parser in the kernel. Just distilling each XML file to the basic
essence described in the event_group structure.

It would be a catastrophic failure if Intel assigned the same uniqueid
to regions that had different formats.

> 
> > 
> > the "guid" naming of the value comes from the Intel PMT_DISCOVERY driver.
> > 
> > An alternative to adding the new event_group::id field would be to
> > separate the arrays of known event groups. I.e. change from:
> > 
> > static struct event_group *known_event_groups[] = {
> >         &energy_0x26696143,
> >         &perf_0x26557651,
> > };
> > 
> > to
> > 
> > static struct event_group *known_energy_event_groups[] = {
> >         &energy_0x26696143,
> > };
> > 
> > static struct event_group *known_perf_event_groups[] = {
> >         &perf_0x26557651,
> > };
> > 
> > then only scan the appropriate array that matches the
> > enum pmt_feature_id passed to get_pmt_feature().
> > 
> > 
> > With only one option in each array today this looks
> > like extra infrasctruture. But I already have a patch
> > for the next generation system that adds another guid.
> 
> This also sounds good. Thank you.

Ok. Thanks. I'll put this idea into code in the next version.

> 
> Reinette
> 

-Tony
