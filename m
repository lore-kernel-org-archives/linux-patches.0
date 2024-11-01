Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF171D07B9
	for <patches@lists.linux.dev>; Fri,  1 Nov 2024 22:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730501840; cv=none; b=sCRAGNxcXgfefgfH1qta3pMAqnB2J9FukxH3qyKap1ZnMOqCENpb5iOEZR1NnCRe1YS2D+xDiNpArEzz8ASrOW6izlJaWx+MEH1oP2QfR4Vf1Yw1AMzG5LQPnzC9/dX2P4V1D5MEbf+YJHKPGWkb6dvNkJ5Bi+3fWZfqQVgc068=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730501840; c=relaxed/simple;
	bh=vmT7+CCFd/QZK9Eg99Oxk4g7E1EEhZ7GyXf1q1Wh8Fo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lu4rqcN1900LrXCOOhalBT7ykTm3DZgPhg+k/dUsKJn5Aixwr+XSdaWbosVZAbpflzMc4vetzTY5UHiQAJ3SWpEuCWtM4TwFL/xu/SThuzz1wWfeS+E/y9/iI9cj4VNaUX7WKQYu6pEe8Td3UzyU8mNeujaJ+vwKbnEO8YhSZ1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T+xl5H+B; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T+xl5H+B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730501838; x=1762037838;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vmT7+CCFd/QZK9Eg99Oxk4g7E1EEhZ7GyXf1q1Wh8Fo=;
  b=T+xl5H+Bz0+4UWy7OjVC1fCmMmNTXs8u6wkDiE2PW1GYn6JB2RFB1lgo
   pDNJ+nXG2NSL2+JmKFvuy17/dO6JlkLKWnkUMSDPy8mPq6kVNpF63X4V4
   1LsfSG+ZcpuXEjzdJxJk7e0Vnvt9KVFXQkmjDna3uZyFH3i4h1XNCG06N
   3wT6hoFkJVj5bKQwLVnnDRuxkExkrfOCkrFUUslu8xSQ1BL8U9wruLXfd
   7DjCvNhghosrYRNny1k4dDgiybLwLvFk8fiE9cx9uPlztEVSpr79dhe1n
   yg0cUgpAFFrrRhjtFKw/bqGkaGk1t/WrHJUYRjMBncnL8PVhXupKaf+ZS
   g==;
X-CSE-ConnectionGUID: JtWdW6XURleVm15ULy5vMw==
X-CSE-MsgGUID: 3jVwTRFrQLizCx8ohTTXsg==
X-IronPort-AV: E=McAfee;i="6700,10204,11243"; a="17903889"
X-IronPort-AV: E=Sophos;i="6.11,251,1725346800"; 
   d="scan'208";a="17903889"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2024 15:57:18 -0700
X-CSE-ConnectionGUID: QGEVpm9pRQ22GCOLu70Gvg==
X-CSE-MsgGUID: PX4AfcU+QOW4DzsD+Yyw9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,251,1725346800"; 
   d="scan'208";a="83919244"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2024 15:57:17 -0700
Date: Fri, 1 Nov 2024 15:57:15 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v8 3/7] x86/resctrl: Refactor mbm_update()
Message-ID: <ZyVcy-7BkqO6Vcr6@agluck-desk3>
References: <20241029172832.93963-1-tony.luck@intel.com>
 <20241029172832.93963-4-tony.luck@intel.com>
 <2ed76893-ac65-d9a2-aeea-c927ebd2a1e8@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ed76893-ac65-d9a2-aeea-c927ebd2a1e8@intel.com>

On Fri, Nov 01, 2024 at 03:08:27PM -0700, Fenghua Yu wrote:
> > -		/*
> > -		 * Call the MBA software controller only for the
> > -		 * control groups and when user has enabled
> > -		 * the software controller explicitly.
> > -		 */
> 
> Same comment was added in patch 2 but is removed in the helper. Maybe it's
> better to add back the comment in the helper.
> 
> > -		if (is_mba_sc(NULL))
> > -			mbm_bw_count(closid, rmid, &rr);

In patch 2 I cut & pasted the comment along with the code from
the if (is_mbm_local()) {...}  clause into the if (is_mbm_total()) { ... }
clause. Maybe to make it more obvious that the code was duplicated.

But I had doubts about the usefulness/accuracy when making the
helper function.

Breaking the comment into pieces:

    "Call the MBA software controller"

This code isn't calling the "controller". To me that's the
update_mba_bw() function that adjusts the MBA values. The
call to mbm_bw_count() is simply computing the bandwidth.

    "only for the control groups"

while this is true, the test in the code here "if (is_mba_sc(NULL))"
isn't making any checks about control groups.

    "and when user has enabled the software controller"

Accurate.

    "explicitly"

Redundant (or confusing, there is no "implicit" way to enable
the s/w controller).


If a comment is needed (and I'm not convinced that it is)
maybe something like:

	/*
	 * If the software controller controller is enabled, compute the
	 * bandwidth for this event id.
	 */

-Tony
