Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761EF171BF
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 15:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695051974; x=1726587974;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=1fHCLdwNFc+9WgKlHtruvN6B6ijVRNVQjqIxvdsKyPI=;
  b=TtYhuyRYpiNG86bJ/8PVG8TsPk7//oO9KXbJbGo89t9dD/HwwH/Ya/or
   zU5hzjd/xMnd3TmsMzY5HvzQnIgKr1C+37xfaBqfRfvvWpGWU2b0+/MzZ
   c0STutmwgjrrKjjWk92Vn7Qa9KhiR1eQ4EMJ27AzVa0RwpIjiET5L210w
   OE01y7n1Lw5fKM3GZ6paqMRKLUZM1t4S10K5lWnS2WGhXA4OLwW+5bMqg
   WzGrMDrQ9YZsv2DKUacHh93wD37CgdNa74/+187U9DC0S11CqIcNxdw9v
   VAY+k02yUC3pgFkNDKpyXrmsnV45k+GZ2MdoTKhb0K8XF67Yjor+CGjrb
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10837"; a="370011043"
X-IronPort-AV: E=Sophos;i="6.02,156,1688454000"; 
   d="scan'208";a="370011043"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2023 08:46:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10837"; a="869597607"
X-IronPort-AV: E=Sophos;i="6.02,156,1688454000"; 
   d="scan'208";a="869597607"
Received: from nprotaso-mobl1.ccr.corp.intel.com ([10.252.49.156])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2023 08:46:09 -0700
Date: Mon, 18 Sep 2023 18:46:06 +0300 (EEST)
From: =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: "Luck, Tony" <tony.luck@intel.com>
cc: "Joseph, Jithu" <jithu.joseph@intel.com>, 
    Hans de Goede <hdegoede@redhat.com>, 
    "markgross@kernel.org" <markgross@kernel.org>, 
    "tglx@linutronix.de" <tglx@linutronix.de>, 
    "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
    "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
    "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, 
    "rostedt@goodmis.org" <rostedt@goodmis.org>, 
    "Raj, Ashok" <ashok.raj@intel.com>, LKML <linux-kernel@vger.kernel.org>, 
    "platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>, 
    "patches@lists.linux.dev" <patches@lists.linux.dev>, 
    "Shankar, Ravi V" <ravi.v.shankar@intel.com>, 
    "Xu, Pengfei" <pengfei.xu@intel.com>
Subject: RE: [PATCH 03/10] platform/x86/intel/ifs: Image loading for new
 generations
In-Reply-To: <SJ1PR11MB6083A4237D928F180B6DB1E1FCFBA@SJ1PR11MB6083.namprd11.prod.outlook.com>
Message-ID: <56b486ce-2a6e-c4c7-8bc5-ceeb7119ba1@linux.intel.com>
References: <20230913183348.1349409-1-jithu.joseph@intel.com> <20230913183348.1349409-4-jithu.joseph@intel.com> <ba753b39-1819-35ff-1248-6ce2c2824ae9@linux.intel.com> <e084652a-91a0-0c16-7acb-d51a3d2f7ed5@intel.com> <10fe57c-c926-9de4-be84-21a0f8abab6d@linux.intel.com>
 <SJ1PR11MB6083A4237D928F180B6DB1E1FCFBA@SJ1PR11MB6083.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 18 Sep 2023, Luck, Tony wrote:

> > I think Tony's "proof" is pretty invalid. He doesn't differentiate
> > HW interface related bitfields from those which are not HW interface 
> > related (to the extent that in fact most of those bitfields likely are not 
> > HW interface related).
> 
> When I made that comment it was about a patch series that used
> bitfields to decode the subfields in Intel model specific MSRs.  I
> think that's true of use in this series too.

But your grep in [1] was not limited to such cases nor to HW interface 
related ones in general.

What I meant with your proof being invalid is that the argument against
bitfields have been related to using them with HW interfaces, not just 
generic use of the bitfields (even if there have been some performance 
issues in that area as well). Simply grepping through include/ directly is 
not going to tell anything if the bitfield in question is related to HW 
interfaces or not.

> I think most of these are for MSR decode. The one mentioned in
> this thread: "union ifs_scan_hashes_status_gen2 {" definitely is.
> 
> Are there any that are not for MSRs? I'd also claim "Intel
> specific" if there are some decoding parts of the Intel scan
> file format.

First of all, I already checked myself that the alignment is not 
incorrect so I don't find it as problematic as I thought it was (I did 
not even flag all bitfield addition in the patches, just the cases were u8 
was followed by u32 bitfield which I thought is not going to work because 
of something I read about this topic some time ago claimed if the type 
changes the bitfield does not carry over).

Since you replied, would you happen to have a pointer something that tells 
(in writing) how the bitfields in C are allocated in case of x86_64? I 
spent a bit of time trying to find something but came up nothing.


[1] https://lore.kernel.org/lkml/SJ1PR11MB6083EBD2D2826E0A247AF242FCD19@SJ1PR11MB6083.namprd11.prod.outlook.com/

-- 
 i.

