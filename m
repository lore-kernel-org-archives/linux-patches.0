Received: from mgamail.intel.com (unknown [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3F036C
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 00:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690849174; x=1722385174;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZEulNWdnP1duSXBMmYXkpzEDKmjHjBb+oQsjgX3lU0w=;
  b=jSGvCXp6cmIsjZVh88vu8BeLa9XhmwlGqIa9RqLbW5SI+ApyDR9W49OA
   X663NWPvG06s0+HlnyBDz/Zu27GreVvJTNewyvbpAgEnnC6qgq4vzv/gL
   cI0CMfRPb5AZVoa9vqjS13cLTU7hH98b7r0C6BVZh2mZJdB9fB4lJR3Sd
   jPKUE93vaGkRO+PiH0e0wOy7qLFbpUQHrRJfuxPCDVRmbf7a96d6lY4hD
   Kmeq9XyrtdhnzqPtrEWGYBN5zumDdoN42DhGOstjm/dsKgIXf26bqvH/I
   jHNdZt6Tv8yMrVB/zc0j/SsIlEpy6zdvBRuemFE+JXTqPNwArxYtu05KX
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="348754691"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="348754691"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 17:19:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="728465612"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="728465612"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.74])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 17:19:32 -0700
Date: Mon, 31 Jul 2023 17:19:31 -0700
From: Tony Luck <tony.luck@intel.com>
To: Drew Fustini <dfustini@baylibre.com>
Cc: James Morse <james.morse@arm.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	Babu Moger <Babu.Moger@amd.com>,
	Peter Newman <peternewman@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	H Peter Anvin <hpa@zytor.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>,
	D Scott Phillips OS <scott@os.amperecomputing.com>,
	"carl@os.amperecomputing.com" <carl@os.amperecomputing.com>,
	"lcherian@marvell.com" <lcherian@marvell.com>,
	"bobo.shaobowang@huawei.com" <bobo.shaobowang@huawei.com>,
	"tan.shaopeng@fujitsu.com" <tan.shaopeng@fujitsu.com>,
	"xingxin.hx@openanolis.org" <xingxin.hx@openanolis.org>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Xin Hao <xhao@linux.alibaba.com>,
	"Pitre, Nicolas" <npitre@baylibre.com>,
	Kevin Hilman <khilman@baylibre.com>,
	"aricciardi@baylibre.com" <aricciardi@baylibre.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [RFC PATCH 0/2] Resctrl - rewrite (WIP)
Message-ID: <ZMhPk8xckzkLEGJc@agluck-desk3>
References: <20230620033702.33344-1-tony.luck@intel.com>
 <ZJqhDYLG+/Kr44sp@x1>
 <SJ1PR11MB60832BA425B43CA19C778100FC27A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <ZJ4clUlN2OujgHlC@agluck-desk3>
 <ZMCEjZgyi5oI+KWh@x1>
 <ZMElMLPWi0+2jCp8@agluck-desk3>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZMElMLPWi0+2jCp8@agluck-desk3>

On Wed, Jul 26, 2023 at 06:52:48AM -0700, Tony Luck wrote:
> On Tue, Jul 25, 2023 at 07:27:25PM -0700, Drew Fustini wrote:
> > 
> > Also, is resctrl2_v65rc1 the latest to branch to test?
> 
> Yes. That's the latest. There haven't been any updates for a
> few days because I'm working on a module to support pseudo-locking.
> I'm half-way there (can do most of the bits to set a group into
> pseudo-locked mode ... about to work on the cleanup when the
> group is removed, the filesystem unmounted, or the module unloaded).

Updated version available at:

git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git

Branch: resctrl2_v65rc4

Some minor fixes to core code, also changes to support pseudo-locking
(core code for the "mode" file plus some new functions in the resource
structure to call into modules to support this).

-Tony
