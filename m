Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271C8225413
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 23:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746054173; cv=none; b=Wvqfvfu/XHPQZslVT3v8EHernCVDueHXPwo/d7a3Rw0cJZO5gF+lxjzBNPtH+wIKxf5hySBqOGjr4GqdN61HOgNYuWyPFx29R+7c/zfqEK1dOp5GQeoWa0pefAwAmO5HX4E0Akkjb8xENOd/yK6qee6xFKUR/y31WW4HcALht04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746054173; c=relaxed/simple;
	bh=QcyPLVBYkw8YT/YG26ONvu5F6rsCMN1k+vumcWe39Zc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jRULwAExoBNJo5lSlpCOanUN2R+Aumpzxb+JXff2cR3OwioQa6D8NozAFkplid0Z3Pzs/QamauA+NeHYej8teToXNl+Ou+IdZt3F2CCkIUdZ1C9Ef/ftIF7QHAYn2MaSeA8/FAX9Q9Lj+noRxc1N4VXVb25SE3NWstQhHPijt8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BSyEHhFd; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BSyEHhFd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746054172; x=1777590172;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QcyPLVBYkw8YT/YG26ONvu5F6rsCMN1k+vumcWe39Zc=;
  b=BSyEHhFdMnUhsc550XNuTz8x2jEHFvq8trZJo5QrKHTtanTuLWPWj0Y5
   t9QbgCCsqe4tt8eP6/ptqouf8qJ/U0/6Jh2QVI18vBwrzNkBHQf0PR8hb
   pvR8eZuk4q1z+FZSXTdIGjtuCScf/Pfvr00MTQgpy9MUS6Nxfz4+kBySi
   OleaW4vSQcl4XVTqhjtvcaLBbF71aJNP7aI4LbcFnemV+aehzi6Xvh33O
   892qYHNCOk0Qe9+uOoQnffBMTcbAjgXXmy7AWj/NsjqwwdwVRgJm1EWMH
   QgyBUgvdk6Vgf5URznv2+LK9vxbv9D1xqkOEj9H/jSj+Y9NQBvgH7dzqN
   w==;
X-CSE-ConnectionGUID: P7EugbyjQ+6GEQQ/n0mZ3Q==
X-CSE-MsgGUID: hvP2qRZAQvS4IFKORFZ5eQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11419"; a="47449917"
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="47449917"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 16:02:51 -0700
X-CSE-ConnectionGUID: uwnAy4y5T1y09PQXV6LABQ==
X-CSE-MsgGUID: 0rKYNfIdTZ6qBwurhY76rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="139067559"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 16:02:51 -0700
Date: Wed, 30 Apr 2025 16:02:49 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v4 06/31] x86/rectrl: Fake OOBMSM interface
Message-ID: <aBKsGa4tdcuPHf1x@agluck-desk3>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-7-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250429003359.375508-7-tony.luck@intel.com>

On Mon, Apr 28, 2025 at 05:33:32PM -0700, Tony Luck wrote:
> Real version is coming soon ... this is here so the remaining parts
> will build (and run ... assuming a 2 socket system that supports RDT
> monitoring ... only missing part is that the event counters just
> report fixed values).

Real OOBMSM discovery patches have now been posted:

https://lore.kernel.org/all/20250430212106.369208-1-david.e.box@linux.intel.com/

-Tony
