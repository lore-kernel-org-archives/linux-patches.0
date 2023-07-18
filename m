Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC9615AC4
	for <patches@lists.linux.dev>; Tue, 18 Jul 2023 23:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689721529; x=1721257529;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VhODeFD5Y7nvrP5kQrGvm1ObDGUld/Q0gKN5ouYFzwo=;
  b=WmTHuMaLpfsIncM5RX52LKKL4Ldz1cvdKPZZ4uOb/Vs2gbJ4EEZH9/lC
   pe00b4fQP5Cwf0rjI5Ii/jePY+IdIubOYP+4lyR6ihL5dDNEbygBplMll
   1if99z1EQ+vpsJirDls8QKnSSqPNTbMkVmwjqBBw5CzBiGsnPyetHrYCd
   iKkdU/7PeI7c5rQTOGh1OrgpP/EM2Q4fs5PVK3WcJEBtEcVPDDlmnf4Ct
   SXgT01LHMcYTHhet0+rL8X+fjZtAIdVsagJfSErv9YaJ/YUra5GHrcHMM
   YSBiU16hvOrUiEzyav5UWd45ZKnteWcODARrOpUAscwGcQPOFh0OIiTH6
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="363790160"
X-IronPort-AV: E=Sophos;i="6.01,215,1684825200"; 
   d="scan'208";a="363790160"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 16:05:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="897711266"
X-IronPort-AV: E=Sophos;i="6.01,215,1684825200"; 
   d="scan'208";a="897711266"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.74])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 16:05:27 -0700
Date: Tue, 18 Jul 2023 16:05:26 -0700
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
Subject: Re: [PATCH v3 5/8] x86/resctrl: Add package scoped resource
Message-ID: <ZLcatuA9nndt075/@agluck-desk3>
References: <20230713163207.219710-1-tony.luck@intel.com>
 <20230713163207.219710-6-tony.luck@intel.com>
 <ef5b5a4b-d8b1-b82f-243f-170213883f05@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef5b5a4b-d8b1-b82f-243f-170213883f05@intel.com>

On Tue, Jul 18, 2023 at 01:43:45PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 7/13/2023 9:32 AM, Tony Luck wrote:
> > Some Intel features require setting a package scoped model specific
> > register.
> > 
> > Add a new resource that builds domains for each package.
> 
> If I understand correctly the only purpose of this new resource
> is to know when the first CPU associated with a package
> comes online. Am I not reading this right? Using a resctrl resource
> for this purpose seems inappropriate and unnecessary while also
> making the code very hard to follow.

Reinette,

Yes. You understand.

I agree that this is blatant abuse of the resource structures.  I can find
another way to perform an action on the first CPU of a package online,
and the last CPU of a package offline.

-Tony
