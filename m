Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF531D0BBC
	for <patches@lists.linux.dev>; Wed,  2 Oct 2024 16:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727885044; cv=none; b=V+V47rl50CPizWWvMPQEO9f67YBvhA+zWpIf+BASF4FU9se0zg6Np0yodbfV3Gr8AMWhmGjiyE4zbHcKOXYfcBhMpBODAs4OVdsOtiApnOGgCkS88vbcYyg49qzOhQfvL1vAAmNhrZtzwdH/VW7gsYBopPd4wbjjfjmwr31MMYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727885044; c=relaxed/simple;
	bh=xll5ewsNSWb8KrDgYCL/pj1w4tjE0i3lMugj8Y5arWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q6DKQd+b75Qj/4cVR5b4TtJMr32jvaneSDqaiDLbsjS0lGZSVmkzgSl7hiX3dzvSMqcdFLJPyu9OOm1BlgSdSZaM1bLdbxmO6FFpb2b5WjarjWIcdq2WLrFE8Xpz3KnYJy8PLNqnf5DVxv4gSp4j7hhZpp7q7wanFSbeEiFitwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PfnAnMat; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PfnAnMat"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727885042; x=1759421042;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xll5ewsNSWb8KrDgYCL/pj1w4tjE0i3lMugj8Y5arWg=;
  b=PfnAnMatumZzrcsglX7eOzk5l2mHw+g1FBMeXykDv8n0LFjmmuojdChO
   c2wBfIYdfUxuIeH+OUBIat9fFOCUH2vGKCOgWIbsQhoIhw+YkCJDnJZBj
   TmwWFxcxRshyNo6zbH6USNNsP9j2bDWaGYXYofWmwJXaqtNR8IdoJNSI3
   MHnC6uLFvPYJSxMR7BX8aVKr6IWhckEcAEIFn0zu3t82gFY5/dVw4KEgR
   Fh5MmZq7+pzc2yVvdsxakFaSCqPbMkTVU6f42+7/fFF7MxPbuc2gwaV7m
   hZY3QxugX5UDkc7foKmxZrwOtHaaVPuResn9+4rJRNu70rny1fjioZ1Ok
   g==;
X-CSE-ConnectionGUID: hZyu1FbOTYCIVUAIWw7L1w==
X-CSE-MsgGUID: Q+wEc209S0i9PTY7K5jNzA==
X-IronPort-AV: E=McAfee;i="6700,10204,11213"; a="30848090"
X-IronPort-AV: E=Sophos;i="6.11,172,1725346800"; 
   d="scan'208";a="30848090"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2024 09:03:59 -0700
X-CSE-ConnectionGUID: vFZ3zjy5RfKgid1YAEt8Sw==
X-CSE-MsgGUID: ed/HeQCpQ4CIspbItsQLBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,172,1725346800"; 
   d="scan'208";a="78579028"
Received: from tassilo.jf.intel.com (HELO tassilo) ([10.54.38.190])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2024 09:03:58 -0700
Date: Wed, 2 Oct 2024 09:03:56 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Anne Macedo <retpolanne@posteo.net>,
	Changbin Du <changbin.du@huawei.com>,
	Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 247/538] perf callchain: Fix stitch LBR memory leaks
Message-ID: <Zv1u7P2GlV6w7WJZ@tassilo>
References: <20241002125751.964700919@linuxfoundation.org>
 <20241002125802.002549697@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241002125802.002549697@linuxfoundation.org>

On Wed, Oct 02, 2024 at 02:58:06PM +0200, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ian Rogers <irogers@google.com>
> 
> [ Upstream commit 599c19397b17d197fc1184bbc950f163a292efc9 ]
> 
> The 'struct callchain_cursor_node' has a 'struct map_symbol' whose maps
> and map members are reference counted. Ensure these values use a _get
> routine to increment the reference counts and use map_symbol__exit() to
> release the reference counts.
> 
> Do similar for 'struct thread's prev_lbr_cursor, but save the size of
> the prev_lbr_cursor array so that it may be iterated.
> 
> Ensure that when stitch_nodes are placed on the free list the
> map_symbols are exited.
> 
> Fix resolve_lbr_callchain_sample() by replacing list_replace_init() to
> list_splice_init(), so the whole list is moved and nodes aren't leaked.
> 
> A reproduction of the memory leaks is possible with a leak sanitizer
> build in the perf report command of:

IMHO this doesn't meet stable criteria. It's a theoretical problem
that only causes noise in leak checker outputs, but doesn't actually
affect any real user.  The memory is always freed on exit anyways.


-Andi
