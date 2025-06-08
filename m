Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868BF1EBA14
	for <patches@lists.linux.dev>; Sun,  8 Jun 2025 22:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749420220; cv=none; b=Q2HHTj2FiSnKicZ7GdUXRi3+C5SdoY8aJRtsnjsd+V0bPRpzNFJnG3qIvemfT9KK0I7rHA7w1/a89zvEFrRZjKhrJe3ib4Uyg8QgpoLIa5GmLJYFEAAXyxStbNwkuw92BWmZ7wvoQ0um3NcmiYzXANTnmU3QmUX7SyiQwRhHA6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749420220; c=relaxed/simple;
	bh=sOgIZl9JDRuhvnkUVkrZS9RJ17+4m5FbMvGt4avTgIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XPJCtP3hg6DdKrP3BP4rurJgtQeOtTmctXXQJbsKLbp0y9j2CE1v2a3jhxIAzwpWEyDAlZS+VdX2Espv4J5nGzwgXdgRby4imGXqWwDmDGCMAJr+jv8lDuvzxCvF56Im1kLsC3gu4EweNFwrp3o6GdyXcFLx9e42FJJ08DUrEbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OtT9iUFm; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OtT9iUFm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749420220; x=1780956220;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sOgIZl9JDRuhvnkUVkrZS9RJ17+4m5FbMvGt4avTgIg=;
  b=OtT9iUFmicCQn43dRvI3wAhZdJRmiGPHAXBFr+Gv3DukVlg9TCK9v4BE
   Zimtzm4+gbJiIifp06uoL6hijGYUeMm5nsepdGTjK3qhdN2upVbLiIRyH
   RzClqvMLgDg3XBYTFtwYqA19Aa5qrFp6N8cEgcpc6U+uh4n43kAdnZa6P
   hKn/nvUZDpcuLKZWahCWY/D0Lm/kQfwEGab+LuT53p/NQTeWsciLo1FGs
   05QbUJUTkUE4gwhuYgOj6JwGuP0tPZXQvjNm36V1QdbGKm/JpJQsLD271
   Ged/sIToDk/p4vYpQ3kPwVGKbGFj4VVJ2YtTrrfExqcZLIl1Js75VvIb3
   w==;
X-CSE-ConnectionGUID: 6Nbuq7JUQC+awMM+1j+q3g==
X-CSE-MsgGUID: xMfsbXzcR6WegCo0C4juIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11458"; a="51581826"
X-IronPort-AV: E=Sophos;i="6.16,221,1744095600"; 
   d="scan'208";a="51581826"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2025 15:03:39 -0700
X-CSE-ConnectionGUID: A+nUbwODQueO5fDXMv1yeQ==
X-CSE-MsgGUID: S3XpvY7bSv2blbZbLOuPFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,221,1744095600"; 
   d="scan'208";a="147314447"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2025 15:03:39 -0700
Date: Sun, 8 Jun 2025 15:03:36 -0700
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
Subject: Re: [PATCH v5 22/29] x86,fs/resctrl: Handle domain creation/deletion
 for RDT_RESOURCE_PERF_PKG
Message-ID: <aEYIuGOgnHkt-nZr@agluck-desk3>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-23-tony.luck@intel.com>
 <9ca45c27-7d1c-4bcf-bcc9-baa24fb7c95d@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ca45c27-7d1c-4bcf-bcc9-baa24fb7c95d@nvidia.com>

On Fri, Jun 06, 2025 at 05:54:29PM -0700, Fenghua Yu wrote:
> > @@ -666,6 +701,12 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
> >   	default:
> >   		pr_warn_once("Unknown resource rid=%d\n", r->rid);
> >   		break;
> > +	case RDT_RESOURCE_PERF_PKG:
> > +		resctrl_offline_mon_domain(r, hdr);
> > +		list_del_rcu(&hdr->list);
> > +		synchronize_rcu();
> > +		kfree(container_of(hdr, struct rdt_perf_pkg_mon_domain, hdr));
> > +		break;
> >   	}
> 
> Why default is not the last one?

Fixed.

Thanks

-Tony
