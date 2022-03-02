Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205385ED6
	for <patches@lists.linux.dev>; Wed,  2 Mar 2022 20:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646252986; x=1677788986;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sDxMd+01s5O5G8NWb6aH17UKo9j/qfU5AprOjkIrVzQ=;
  b=g9/XFkiBeI1z0V9NFG5uZLlyapxI7pokT+sLRhdTEUNlx3AzYsVw+1nk
   ahQeFzQm7q1CPEo3uGrqRjs3K/bh+deKs4QRjPdXXMLKVOdlpe6l5XLbF
   YAhY2xoP2UmD7j4oo1zqrLOe7wMAE2m68gU76u/8K+Y1LgQz0XRCw7XIr
   wHoN7tQ/oaF0xLPHI4Lg+golN7tHrmD80YctJCp7mHW9EtttpjK8FOoRl
   lwTPd7Cl9xX5JJHVb5pXMrCJcewavc9FcgrMJfaAimPa5wBeWMyVjxPzQ
   feIdu1DZWQk9OwvHY1L9HlS/hGRVzq89p/0Jt/JuG/FNYKYbT1i5K45+s
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="240916040"
X-IronPort-AV: E=Sophos;i="5.90,150,1643702400"; 
   d="scan'208";a="240916040"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 12:29:45 -0800
X-IronPort-AV: E=Sophos;i="5.90,150,1643702400"; 
   d="scan'208";a="630534019"
Received: from agluck-desk3.sc.intel.com ([172.25.222.60])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 12:29:44 -0800
Date: Wed, 2 Mar 2022 12:29:43 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Andy Lutomirski <luto@kernel.org>
Cc: Jithu Joseph <jithu.joseph@intel.com>, hdegoede@redhat.com,
	markgross@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Raj Ashok <ashok.raj@intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org, platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	"Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: Re: [RFC 00/10] Introduce In Field Scan driver
Message-ID: <Yh/Tt50Y8ubGNwS6@agluck-desk3.sc.intel.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
 <1b793ead-a47c-4719-b7b5-cba7d49633f2@www.fastmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b793ead-a47c-4719-b7b5-cba7d49633f2@www.fastmail.com>

On Wed, Mar 02, 2022 at 05:59:59AM -0800, Andy Lutomirski wrote:
> > /sys/devices/system/cpu/ifs/reload
> >   Writing "1" to this file will reload the tests from
> >   /lib/firmware/intel/ifs/{ff-mm-ss}.scan
> 
> IMO this interface is wrong.  /lib/firmware is for firmware (or
> ucode, etc) files that should be provided by a distribution and loaded,
> as needed, by a driver so the hardware can function.  This is not at
> all what IFS does. For IFS, an administrator wants to run a specific
> test, and the test blob is part of the instruction to run the test.
> The distribution should not be involved, and this should work even on
> systems where /lib/firmware is immutable.

"so the hardware can function"

Data center customers want to know which aging systems in their
data centers are not functioning correctly. So this is not just
a random test that people might run when they suspect they have
a problem. It is expected that every core will run this test
periodically (period dependent on paranoia level of the system
owner ... maybe daily ... perhaps even more often).

This is so that the data centre can function.

> 
> So either the blob should be written to a file in sysfs or it should
> be supplied by write or ioctl to a device node.

I don't see the drive to create a new mechanism for the kernel
to load from a file when the firmware loader already exists.

If the problem is just immuatbility of /lib ... then make
an immutable symlink from /lib/firmware/intel/ifs to some
other place in the file system (which is what some OS
vendors already do for microcode).

-Tony
