Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E841B6144
	for <patches@lists.linux.dev>; Mon, 21 Mar 2022 21:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647897352; x=1679433352;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mGMqNGGnAAv9F4G2///ghFf3QxQGDyzRBcse/JeKnBw=;
  b=NvLmarV8H7iOLxrd6tv9Kkqkx6PXUd4Ndnef/JJ8xU/+Zk00pFsJT1os
   rx8YQQJYGrJGiXNgmz41pyOnOO03429RvnK4XCKB1Q2mLBMpvhT39B5G5
   cX2RPKpc4fjAEyPbWSWtep0Rw7FPlcvdZYCZtWQXaGSVJelDd23tlqfl1
   fSum8zJPObtVRKXjQHU7V4UCToiVgcRXW105CB1WlPB9x8SozEECEQua3
   ELq62tEsWH01uO+aiQtL5Jt7izTgVaAhtCcC5/6Fuy/jx6x2nHKDGHWaI
   3lx4yyDM9QqbwiozekRx7LQcFKIX9GyENgyF3uWoAXj+LZsqYdZgsiKXR
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10293"; a="257599144"
X-IronPort-AV: E=Sophos;i="5.90,199,1643702400"; 
   d="scan'208";a="257599144"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 14:15:52 -0700
X-IronPort-AV: E=Sophos;i="5.90,199,1643702400"; 
   d="scan'208";a="716644397"
Received: from agluck-desk3.sc.intel.com ([172.25.222.60])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 14:15:52 -0700
Date: Mon, 21 Mar 2022 14:15:50 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: "Joseph, Jithu" <jithu.joseph@intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"hdegoede@redhat.com" <hdegoede@redhat.com>,
	"markgross@kernel.org" <markgross@kernel.org>
Cc: "corbet@lwn.net" <corbet@lwn.net>, "Raj, Ashok" <ashok.raj@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>,
	"Shankar, Ravi V" <ravi.v.shankar@intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "bp@alien8.de" <bp@alien8.de>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC 08/10] platform/x86/intel/ifs: Add IFS sysfs interface
Message-ID: <YjjrBuVSWqLIoAaq@agluck-desk3.sc.intel.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
 <20220301195457.21152-9-jithu.joseph@intel.com>
 <188492dc80c017375da76d444347b1d00c2031f6.camel@intel.com>
 <7b9c788e-21dc-eedc-a1b4-9c6877fa48fe@intel.com>
 <52a16a3eb3f54ec88f7a841baa7000fd@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52a16a3eb3f54ec88f7a841baa7000fd@intel.com>

On Fri, Mar 04, 2022 at 09:01:03PM +0000, Luck, Tony wrote:
> >> You could just cut to the chase and do: sysfs_eq(buf, "1")
> >
> > Thanks will use this
> 
> $ git grep sysfs_eq
> $
> 
> I don't see this defined (or used) anywhere in the kernel. Is
> it spelled differently from how typed here?

Just to close out this thread ... the function name
that Dan was looking for was sysfs_streq().

-Tony
