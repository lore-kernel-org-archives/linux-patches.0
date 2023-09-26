Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843D31D526
	for <patches@lists.linux.dev>; Tue, 26 Sep 2023 10:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695723646; x=1727259646;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=IdqZHPJOPwcVDTSKXmZ43RFoTiFmfhgBH2q0cF9aCoU=;
  b=m9L26JFNt3m/Z6ZH0970wt8iXqg/fHvdlnKCaim2HYEJLCGS7NrVOVM3
   3P0FVQpiY8+XwK3HDJSnI0tCNZGVLSYVS8VCHJ9JrlcSBQ5vLktGYRnaF
   H+VEsA9xcHiWiIaSSAWtDgdNYlpf6DSUscto0v0p/mPeiz6ffkVHjt03n
   5F+u7wLjSVP8Ezsv5mlR8fxHqNi9sT353u/nBYebFugVdVwOxOpTqaHr0
   zHk7SIVQj0pbP0UbiAkfMGkzkZQ5y4V3f8zH6Wz5mQiW6Hl1D4DY7LyXq
   Ar7ArsZO7Cv+wiR2wFG6ukWvPoPyQmuXUKwjAvoWnc/Epw/Sf9lTsF64T
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="380401634"
X-IronPort-AV: E=Sophos;i="6.03,177,1694761200"; 
   d="scan'208";a="380401634"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 03:20:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="778087554"
X-IronPort-AV: E=Sophos;i="6.03,177,1694761200"; 
   d="scan'208";a="778087554"
Received: from hhalmen-mobl.ger.corp.intel.com ([10.251.219.207])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 03:20:40 -0700
Date: Tue, 26 Sep 2023 13:20:34 +0300 (EEST)
From: =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: "Joseph, Jithu" <jithu.joseph@intel.com>
cc: Hans de Goede <hdegoede@redhat.com>, markgross@kernel.org, 
    tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
    dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
    rostedt@goodmis.org, ashok.raj@intel.com, tony.luck@intel.com, 
    LKML <linux-kernel@vger.kernel.org>, platform-driver-x86@vger.kernel.org, 
    patches@lists.linux.dev, ravi.v.shankar@intel.com, pengfei.xu@intel.com
Subject: Re: [PATCH v2 4/9] platform/x86/intel/ifs: Gen2 Scan test support
In-Reply-To: <89f48b0a-a6b6-2204-7d96-28ebbe96b18a@intel.com>
Message-ID: <e22bf1b7-48c1-39e8-f0d3-636a6a61bc48@linux.intel.com>
References: <20230913183348.1349409-1-jithu.joseph@intel.com> <20230922232606.1928026-1-jithu.joseph@intel.com> <20230922232606.1928026-5-jithu.joseph@intel.com> <c390bdaf-ab5c-bf1f-bd64-29e2827d01f@linux.intel.com>
 <89f48b0a-a6b6-2204-7d96-28ebbe96b18a@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1786874099-1695723644=:1894"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1786874099-1695723644=:1894
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 25 Sep 2023, Joseph, Jithu wrote:
> On 9/25/2023 8:39 AM, Ilpo Järvinen wrote:
> > On Fri, 22 Sep 2023, Jithu Joseph wrote:
> > 
> 
> ...
> 
> >>  
> >> -	activate.rsvd = 0;
> >>  	activate.delay = IFS_THREAD_WAIT;
> >>  	activate.sigmce = 0;
> >> -	activate.start = 0;
> >> -	activate.stop = ifsd->valid_chunks - 1;
> >> +	to_start = 0;
> >> +	to_stop = ifsd->valid_chunks - 1;
> >> +
> >> +	if (ifsd->generation) {
> >> +		activate.gen2.start = to_start;
> >> +		activate.gen2.stop = to_stop;
> >> +	} else {
> >> +		activate.gen0.start = to_start;
> >> +		activate.gen0.stop = to_stop;
> >> +	}
> > 
> > Is it okay to not do activate.gen0.rsvd = 0 anymore? If you know it is, it 
> > would be nice to record that fact into the changelog so that it can be 
> > found in the history.
> 
> I did test on a gen0 to check if there is a problem due to this (and it seemed fine).
> I will make a note in changelog as you suggest

Actually, I realized activate is a variable in stack and those bits are
uninitilized without that assignment so don't remove it.

-- 
 i.

--8323329-1786874099-1695723644=:1894--
