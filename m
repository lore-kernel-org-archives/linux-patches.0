Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF05107A8
	for <patches@lists.linux.dev>; Fri, 25 Aug 2023 17:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692983641; x=1724519641;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wNizbAUX2vHUEcLO1lnDqTj1v3bGzD9yzFiCUNYjnNk=;
  b=hfMmSBNzsMzK6WUTqsCJmtUF3WNpauP+ka7Gh3uKsvnF8BmRBF02lWXR
   ZLEg8ZFLPvnwswErO6uLPtdalKfTVyud9gK521aZtvd1/dhKQBlFo9Jvp
   8KUsYtRCsiG6+TSXRthiic9EKLiEOwawPB48meNhmWMf2g02Fzvhbfifd
   hnr7Dbu3nDujUwfy27c27d2X1EXkaqBdKkuNBS/EeMAylQZz5mn2nVdNu
   UshONeFISat1uz2PFa6IolMdNqUkt8ZHle/hOxwtrv8QUaL02Jhe+yV3n
   OmvkCK67VYFj2zvquZieFiSztLXQWFBAMu03uLEe8Sw3cZmBL+oH7qerV
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10813"; a="373627372"
X-IronPort-AV: E=Sophos;i="6.02,201,1688454000"; 
   d="scan'208";a="373627372"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 10:13:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10813"; a="861144294"
X-IronPort-AV: E=Sophos;i="6.02,201,1688454000"; 
   d="scan'208";a="861144294"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.74])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 10:13:49 -0700
Date: Fri, 25 Aug 2023 10:13:47 -0700
From: Tony Luck <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org,
	Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v4 4/7] x86/resctrl: Delete unused fields from struct
 rdt_domain
Message-ID: <ZOjhS32vVBfrYgrG@agluck-desk3>
References: <20230713163207.219710-1-tony.luck@intel.com>
 <20230722190740.326190-1-tony.luck@intel.com>
 <20230722190740.326190-5-tony.luck@intel.com>
 <8a5722f0-35aa-a0f4-84a6-467c263e4a88@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a5722f0-35aa-a0f4-84a6-467c263e4a88@intel.com>

On Fri, Aug 11, 2023 at 10:30:47AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 7/22/2023 12:07 PM, Tony Luck wrote:
> > Now that all the monitoring functions use struct rdt_mondomain the
> > monitor fields can be dropped from the structure used for control
> > operations.
> 
> Please provide some context for this patch so that it
> can stand by itself when merged.
> 
> Note that two structures are changed in the patch.
> 
> Reinette

Commit comment rewritten.

-Tony
