Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAD428C862
	for <patches@lists.linux.dev>; Fri, 27 Jun 2025 22:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751063293; cv=none; b=fQrHrqV6mUoqMe4UpMkqwvwDGnDsPP40ZaK0iMg5qtolia/ambv11zKTTb4wiBBvaeNZHyegKA66UjPMGIy3KO9s6BQHq/VtqHv3I134ZSquYPwGue4hvJC+3wFGzd9KZnD7zQUFHg7/y1uL9koTpNMVckzMzmIskCimJi2NiTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751063293; c=relaxed/simple;
	bh=mvyzCImA9C9zhndmyufLSspMX/CTzojFGEHMAVwofdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mA1FdR6ROITS13lDdgHxRMowUEIQPh6whzPhHpKY8B/yR68xNdo3W3qmXPAVnjX9jZRXgXtvhtqJYGjTRUs0BQDBsIlMPIgRmfhxDaoQVYvU8eEbPXvmjSrZ3GDayklUlT0kkCp0BHYNAbxqRUPdFl8+9FLdVcVODnBndOoolzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oFrLFPDF; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oFrLFPDF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751063291; x=1782599291;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=mvyzCImA9C9zhndmyufLSspMX/CTzojFGEHMAVwofdc=;
  b=oFrLFPDFC9xXUeW+J/AUwmpQoSIqQUD2vO/FRIwN2z6/pRg7px3DfAcB
   7haHyVN5mNK4V3pBvkrNJ0Nb1f9nkOtZUevmwpFKkq6WnNyKyzl9MyisG
   UwGeYX5JS79KEJztbtZKHCatIh1WQqFns01nsHcOfzdOeMZ3mFo6mMcf0
   nDX0sy+aNAyL++mXcPBkFnVgulV5rTuxlDVb9JqwlF2+AimmGmbig09z1
   Pzm+Li/DlkRKQ4yCdYeeDW55rLZpMEqcQWGYjBfq2+Gbt19mJht6E0XN3
   FUSWQzTfwrYuxUVu4bMcrbrFBVAYbGHj7cDiDJXCuen19OB3dgUjsVW1y
   A==;
X-CSE-ConnectionGUID: 50mLB3XVQsSU4Ry+8nZ8ng==
X-CSE-MsgGUID: gYdCKPyIQ8aa1Lp/f0wV1Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11477"; a="64074397"
X-IronPort-AV: E=Sophos;i="6.16,271,1744095600"; 
   d="scan'208";a="64074397"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2025 15:28:10 -0700
X-CSE-ConnectionGUID: eUDheSWeQDugdt2kld5bYQ==
X-CSE-MsgGUID: VYGaKQjMRM+ErcoFLQB7xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,271,1744095600"; 
   d="scan'208";a="156959491"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2025 15:28:10 -0700
Date: Fri, 27 Jun 2025 15:28:09 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v6 14/30] x86,fs/resctrl: Support binary fixed point
 event counters
Message-ID: <aF8a-bbfn2xhnKXz@agluck-desk3>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-15-tony.luck@intel.com>
 <a14b2ed0-c319-43df-85f1-f97ecd6b688b@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a14b2ed0-c319-43df-85f1-f97ecd6b688b@nvidia.com>

On Fri, Jun 27, 2025 at 02:22:18PM -0700, Fenghua Yu wrote:
> Hi, Tony,
> 
> On 6/26/25 09:49, Tony Luck wrote:
> > Resctrl was written with the assumption that all monitor events can be
> > displayed as unsigned decimal integers.
> > 
> > Hardware architecture counters may provide some telemetry events with
> > greater precision where the event is not a simple count, but is a
> > measurement of some sort (e.g. Joules for energy consumed).
> > 
> > Add a new argument to resctrl_enable_mon_event() for architecture code
> > to inform the file system that the value for a counter is a fixed-point
> > value with a specific number of binary places.  The file system will
> > only allow architecture to use floating point format on events that it
> > marked with mon_evt::is_floating_point.
> 
> User app needs to know if a number is a floating pointer value or an integer
> value. I see you document the energy and activity events as floating point
> values and all others are integer values.
> 
> Is it better to show the value types in info directory?
> 
> e.g. create an info file "events_floating" which shows all events with
> floating point values. Events not in this info are integer by default.
> 
> This may have two benefits:
> 
> 1. An app can query the type info to parse the values accordingly without
> hard coding event types.
> 
> 2. Any future floating point events can be added here without changing the
> document.

Maybe. It's obvious which are floating point because the values
have a "." in them.  Some apps may not care about the difference
and just read everything as if they are floating point. Maybe
likely since the next step is to compute the rate with:
	(current_value - previous_value) / delta_t
which will be done as a floating point calculation with
microsecond timestamps.

But it wouldn't be hard to add an info file that lists which are
in floating point (maybe also to provide the precision as
suggested by Dave Martin).

[snip]

> > +static void print_event_value(struct seq_file *m, int binary_bits, u64 val)
> > +{
> > +	struct fixed_params *fp = &fixed_params[binary_bits];
> 
> Is it worth to have a boundary check here like? I'm afraid without the
> hardening check, a future caller may give a wrong value and cause hard
> debugged failure.
> 
> if (WARN_ON_ONCE(binary_bits >=MAX_BINARY_BITS))
> 
>     return;

Seems like belt and braces overkill. resctrl_enable_mon_event()
already has a check for MAX_BINARY_BITS and will not enable
an event if architecture provides a too-large value.

-Tony
