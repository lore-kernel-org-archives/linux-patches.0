Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EF41C6AE
	for <patches@lists.linux.dev>; Tue, 21 May 2024 15:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716306518; cv=none; b=fh6LrXvNNFOxU7/UyTZ9wjWjPaAe4JoFpup1LVTm02pZblOTBK8AmpX6O/OyxDt0DiJFQJiK5/FqSYTviQ/n77nSWp6GyD7eTVtYKPqclD/6k4WL+6H+IGAwXEjpvj7y730v3X7oiBQpO6NJHzoIzo8Y8i/3cbOxVEBDRTBsbOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716306518; c=relaxed/simple;
	bh=pmM6ansB1dZBHsDH5k5F1CVlJa0N3KOCL5F3ugY4XZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oSvQDxVDdYLHfNg1DDFd5ZTS3YU2TlptEt2Q1MSwf7fQjxyAeSyLn5ueBP4J0ZRQJesHB2LZpmZwMFhBW4dm8fH6ucmHlS2ITFUMmj9BtOpJ8gml+Cpdf6gUd/9B0+VnbBXhCOzbtIOPp6vY/BdXZ4TX+s27cPsuHFe2hvUgSb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j3jEYlKS; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j3jEYlKS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716306517; x=1747842517;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pmM6ansB1dZBHsDH5k5F1CVlJa0N3KOCL5F3ugY4XZs=;
  b=j3jEYlKSnrBqztZtWNDamYE91zg1ZBSekZKlj6dezTWX736vQIRliQel
   1Xur66nASPWJ6W7m9DQaO5NNMcUGJyvbAEw1NLQbqOyJksAOi8C7L52eq
   CFShw9mftX/FeuYOawpUFr2so9ajABOedqVHfQdNbnn4gEC6FsduQfroV
   SnFIkILzLdKyrimF4FrDimcKOW/vjF4bw/RmT9VHfsyBgLzU1wflxaWRJ
   AlFBJn8JN1BS6twCx1UEdeiE/8KUQnxkgpg0q7YDudIXIM5opxSxcqpsw
   69oVqKcE0tCstoNzin9PFpS8OPM7b8Cd4U0Kv8Ro4aCYpB2iPhO27TTgt
   g==;
X-CSE-ConnectionGUID: 0O2DElxbR+KpYswO6xkqsw==
X-CSE-MsgGUID: JJPpo4TrSMa54jRzcKxRsw==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12740356"
X-IronPort-AV: E=Sophos;i="6.08,178,1712646000"; 
   d="scan'208";a="12740356"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 08:48:36 -0700
X-CSE-ConnectionGUID: ea1Ln2QSRiyduUE4IWDW5g==
X-CSE-MsgGUID: uKpOg7O+Rk+t4ZiKxK7GsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,178,1712646000"; 
   d="scan'208";a="37546261"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 08:48:35 -0700
Date: Tue, 21 May 2024 08:48:34 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>, Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v6 02/49] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
Message-ID: <ZkzCUj7zCcGPT-IX@agluck-desk3.sc.intel.com>
References: <20240520224620.9480-1-tony.luck@intel.com>
 <20240520224620.9480-3-tony.luck@intel.com>
 <20240521074947.GAZkxSG_u08uLDqZ_m@fat_crate.local>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240521074947.GAZkxSG_u08uLDqZ_m@fat_crate.local>

On Tue, May 21, 2024 at 09:49:47AM +0200, Borislav Petkov wrote:
> On Mon, May 20, 2024 at 03:45:33PM -0700, Tony Luck wrote:
> > Fixes: 644e9cbbe3fc ("Add driver auto probing for x86 features v4")
> 
> Do you really want to backport this to everything since 2012, as that
> patch is from then?

I didn't include a Cc: stable. Is there some better way to report
the source commit for a problem without triggering a backport?

> 
> > @@ -690,6 +690,7 @@ struct x86_cpu_id {
> >  	__u16 model;
> >  	__u16 steppings;
> >  	__u16 feature;	/* bit index */
> > +	__u16 flags;
> >  	kernel_ulong_t driver_data;
> >  };
> >  
> > @@ -700,6 +701,9 @@ struct x86_cpu_id {
> >  #define X86_STEPPING_ANY 0
> >  #define X86_FEATURE_ANY 0	/* Same as FPU, you can't test for that */
> >  
> > +/* x86_cpu_id::flags */
> > +#define X86_CPU_ID_FLAG_ENTRY_VALID	BIT(0)
> 
> I would definitely not want to have those visible in userspace.
> 
> IOW, something like this:

Agreed. Looks better to keep the define out of a <linux/*.h> file.

Do you want me to spin a new patch? Or can you fold your change into
my patch when applying?

-Tony
