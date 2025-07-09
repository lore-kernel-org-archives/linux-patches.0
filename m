Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514BB23B633
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 21:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752098260; cv=none; b=aQ6JuAqWmkjhEwYedp2kU2r7VWgqR8KNmH02J/462xSzULwvM/yw7PP4MbbVk0Ur6LyfQ/IM6Zgd/f1wIg8kPcDpOCLWv+I2gMZyD/JWJv+IcmrWCptSvCUKU9t1bBlGZuiE8k3VAKEY664rXCHL3zNT8e7K3uRV3uh5ltVzUU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752098260; c=relaxed/simple;
	bh=L+oOjGdgDmkf3PbFY2vi1iBtBL7ECDGcI78dN08WW8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J5AJZBYCBWz7snsoxGWUnn+X2nu1uZttgQG+12btqtORuCx+kKazgsDF8FYIJ10bQnlPVE4LhyASKlxgxmsXscIe+q1QP3a22noiceVEFcQ1rEXY7v0hN0UV7cT2rghMDTtNgsIr99BPXYRpuanbv6/CzLw8u3YMDCav/T8dBQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ii7i5fga; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ii7i5fga"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752098258; x=1783634258;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=L+oOjGdgDmkf3PbFY2vi1iBtBL7ECDGcI78dN08WW8E=;
  b=Ii7i5fgan8WBE/7YIwH2cJCUGqvqCYdBrptXdj1tUpafdEj8Rd22QaLv
   glsJKDiPckMHexkR02xAxlDjM5bqOni6SucSK7pYogAWCYeoI1vhNnAzq
   undAtVOYxemY7qQS3tkQKwzAr3O5S1AwUWWWqF/VUTBe54u86TVuPlfUg
   +VH1RLYeoDSqohBtvDWYMRzLKD/CLsyoW7iDlco/sJtmq8+QZXNMvB62u
   YW9SmFo3GwP7Pr2JaFcDoWJjQxciZh0A7XUCxjfQsqaEJrDMiE2plRcpJ
   xLIac521WiH+7Y9w66GEFlCWhoOsmphWAXVARns4ms39225HL0Gj1XFC4
   w==;
X-CSE-ConnectionGUID: yMMVvI0ZSTGYJBe3j70sqA==
X-CSE-MsgGUID: DwGPd2uJRcy4onty57CLXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="54499451"
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="54499451"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 14:57:38 -0700
X-CSE-ConnectionGUID: v7nhlobwR0eUOwEp+k0E0g==
X-CSE-MsgGUID: Cg+LDhraS1KNhP9g+AP3ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="155992453"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 14:57:37 -0700
Date: Wed, 9 Jul 2025 14:57:36 -0700
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
Subject: Re: [PATCH v6 22/30] x86/resctrl: Read core telemetry events
Message-ID: <aG7l0M1axoSDk1xa@agluck-desk3>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-23-tony.luck@intel.com>
 <37708e34-9634-4488-aeb7-6a61ab01947a@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <37708e34-9634-4488-aeb7-6a61ab01947a@intel.com>

On Wed, Jul 09, 2025 at 08:48:47AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> What does the "core" in the subject refer to?

The events are collected by each core. But since resctrl reports the
aggregated per-package values this is confusing. I'll drop "core" from
the Subject line.

[snip]

> > +/*
> > + * Read counter for an event on a domain (summing all aggregators
> > + * on the domain).
> > + */
> > +int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id eventid,
> > +			 void *arch_priv, u64 *val)
> > +{
> > +	struct pmt_event *pevt = arch_priv;
> > +	struct mmio_info *mmi;
> > +	struct event_group *e;
> > +	u64 evtcount;
> > +	void *pevt0;
> 
> Should this be a struct pmt_event *?

I thought that too. But container_of() gets confused about types (I
think because the evts[] element is a flex array.

With "struct pmt_event *pevt0;" the compiler complains:

arch/x86/kernel/cpu/resctrl/intel_aet.c: In function ‘intel_aet_read_event’:
./include/linux/build_bug.h:78:41: error: static assertion failed: "pointer type mismatch in container_of()"
   78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
      |                                         ^~~~~~~~~~~~~~
./include/linux/build_bug.h:77:34: note: in expansion of macro ‘__static_assert’
   77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
      |                                  ^~~~~~~~~~~~~~~
./include/linux/container_of.h:20:9: note: in expansion of macro ‘static_assert’
   20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
      |         ^~~~~~~~~~~~~
arch/x86/kernel/cpu/resctrl/intel_aet.c:311:13: note: in expansion of macro ‘container_of’
  311 |         e = container_of(pevt0, struct event_group, evts);
      |             ^~~~~~~~~~~~

Making it void * is the "get of of jail free" case in container_of()
with the test " || __same_type(*(ptr), void)"

If there is a better way to do this, let me know.

-Tony
