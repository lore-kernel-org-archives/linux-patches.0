Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C1A156C72
	for <patches@lists.linux.dev>; Fri,  1 Nov 2024 22:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730500826; cv=none; b=LjLbS5uMQXRrBHic44OnYVJg8982t71cYVGbx0njcQTZ0QzfUcw0YZX4u4NyrNLWxhAp5zd5P/YtkFuJt28w73QUqJuYNlQZ74UQyhEyw1WAVMaL2di0TUlpw+SQ/eS5DNzW2AyRBduykAR/TEyoyNjfoquULbZoc0tXo4MQemc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730500826; c=relaxed/simple;
	bh=sMW1iMQ4lLqWN3HqoFgf6CYTcFcZSa67VJDpiJOY6+o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M5PGtpGIzJu5EIECpTRMNTj+s+UxJRrQcf2y7ovH+n09VckdEQt3sAPSOIzSsyb0MvHpnzBHdlJU78pkHQg09tlIJHLOMGn708BqR+d6x4c6MqqhZIDsAqanWPAsv9PTzM5k5nKCXtV1JmCzEeDd8JSfMmxnPeZ/fSRxJuVH2PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KYjSc3XC; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KYjSc3XC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730500825; x=1762036825;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sMW1iMQ4lLqWN3HqoFgf6CYTcFcZSa67VJDpiJOY6+o=;
  b=KYjSc3XCPAzvQWlaMHd+cgvlY9kvBg6Dau5HMtd9q6rxnaMA/+5yP8Jx
   pSZzPjYkDC05KP10kDPvk/73EGpX6PRHo/w4gjT8ozCoLZyxYUFkKXM11
   iGbQOroyJ+SNBAt6LaHOwiKujhcxeUBKbMb7DI8swJIZWYHs2ze5E/C6J
   rClVBtPVBqDmENYA/rzGNQI5Z6Vz6w29vcD1pe9h0k8U2ClbFyerrCVMo
   kt5EbXJj34Kt/VfA/029g/pkdyTWwE9U1bqjlbomj+Pk5MGsD0c1b3SZ1
   BRHBCyK2HjuQee0gnyUFEiYcrfhAPHRHfuyRYStiNvj9PfDqy58JIUAWC
   g==;
X-CSE-ConnectionGUID: jYwLwY+CQaekUyutsj7SDA==
X-CSE-MsgGUID: SExNoHWUTmSDrfGLQU/B8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="33971628"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="33971628"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2024 15:40:24 -0700
X-CSE-ConnectionGUID: MVxzXCWySY2A3JHFUc4O8w==
X-CSE-MsgGUID: 7btia7agTySAFPD1MCQDlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,251,1725346800"; 
   d="scan'208";a="87032201"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2024 15:40:22 -0700
Date: Fri, 1 Nov 2024 15:40:21 -0700
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
Subject: Re: [PATCH v8 1/7] x86/resctrl: Prepare for per-ctrl_mon group
 mba_MBps control
Message-ID: <ZyVY1UdOCu7ZPVsw@agluck-desk3>
References: <20241029172832.93963-1-tony.luck@intel.com>
 <20241029172832.93963-2-tony.luck@intel.com>
 <f6205054-c29e-97d6-67d3-dd3544a01dec@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6205054-c29e-97d6-67d3-dd3544a01dec@intel.com>

On Fri, Nov 01, 2024 at 03:03:32PM -0700, Fenghua Yu wrote:
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index b681c2e07dbf..5b55a7ac7013 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -958,6 +958,11 @@ static __init bool get_rdt_mon_resources(void)
> >   	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL))
> >   		rdt_mon_features |= (1 << QOS_L3_MBM_LOCAL_EVENT_ID);
> > +	if (rdt_mon_features & (1 << QOS_L3_MBM_LOCAL_EVENT_ID))
> 
> Please change this check to:
> 
> 	if (is_mbm_local_enabled())
> 
> > +		mba_mbps_default_event = QOS_L3_MBM_LOCAL_EVENT_ID;
> > +	else if (rdt_mon_features & (1 << QOS_L3_MBM_TOTAL_EVENT_ID))
> 
> and this check to:
> 
> 	else if (is_mbm_total_enabled())
> 
> > +		mba_mbps_default_event = QOS_L3_MBM_TOTAL_EVENT_ID;
> > +

You are correct. I had a moment of amnesia and forgot those
helpers existed and just pasted the expressions used to set
each of the bits in rdt_mon_features.

I will change as you suggest.

-Tony
