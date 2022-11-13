Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD2E6FDF
	for <patches@lists.linux.dev>; Sun, 13 Nov 2022 21:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668376318; x=1699912318;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Vwi5xI+ZgoQ66Zhsx8mRj2liZIMevDJUF4Ly/3/uLCg=;
  b=C5JNhKyyIGIdqAA/Iqe+ewtaZccMU66DtlIkfqSkcpi0VZP99dxg5TNg
   pRg0le28hf0hpGvJEBE21ntI3rCDCePNMBuurEpJDtECp2D6CO52uYZFp
   WhgyNtR45vLizYUGC6wpNLTtG0y/DO4MxdOWMbVPB/ShAmJsILdFXpS5s
   8HRJRMbRld85TyRQ8Eq3p5+6xDtlemAR33FnY1ZqpEZON/fk8xWR3gWeM
   syXUyUKpIiusi1UOz8aYW4s7BCfpLi6oSDm8rw/7PiDLCnkWSuLfI8bib
   fwdpE6AVf56sMur2n6aUPRpzMgq5jMa1G9RyYoJjPTe9Z5DsvZDOQI6MC
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="311849139"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="311849139"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2022 13:51:57 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="780702723"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="780702723"
Received: from perwin-mobl.amr.corp.intel.com (HELO tjmaciei-mobl5.localnet) ([10.212.163.208])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2022 13:51:56 -0800
From: Thiago Macieira <thiago.macieira@intel.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, Borislav Petkov <bp@alien8.de>
Cc: "Luck, Tony" <tony.luck@intel.com>, "Joseph, Jithu" <jithu.joseph@intel.com>, "hdegoede@redhat.com" <hdegoede@redhat.com>, "markgross@kernel.org" <markgross@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "Raj, Ashok" <ashok.raj@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>, "patches@lists.linux.dev" <patches@lists.linux.dev>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, "Jimenez Gonzalez, Athenas" <athenas.jimenez.gonzalez@intel.com>, "Mehta, Sohil" <sohil.mehta@intel.com>
Subject: Re: [PATCH v2 12/14] platform/x86/intel/ifs: Add current_batch sysfs entry
Date: Sun, 13 Nov 2022 13:51:56 -0800
Message-ID: <2537334.Lt9SDvczpP@tjmaciei-mobl5>
Organization: Intel Corporation
In-Reply-To: <Y3DZmKYV+8HBtZ+Q@zn.tnic>
References: <20221021203413.1220137-1-jithu.joseph@intel.com> <Y3CevK2zhAmiUyG9@kroah.com> <Y3DZmKYV+8HBtZ+Q@zn.tnic>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Sunday, 13 November 2022 03:48:40 PST Borislav Petkov wrote:
> > You can't do it with a three-line shell script, but we're not
> > expecting that shell scripts are the means to use this feature in the
> > first place.
> 
> I consider it a serious design mistake of having to have a *special*
> tool. A special tool is *always* a burden. You need to build it, supply
> it, make sure it is installable on the target system and so on.
> 
> And I'm telling you this with my Linux distributor hat on. It is always
> a pain - trust me.
> 
[cut]
> IOW, I really think that designing our interfaces with user friendliness
> in mind should be of much more higher importance. And requiring the user
> to remember or figure out anything she doesn't really need to, in order
> to run the test is a burden.

We agree that it should be operable without a tool. If nothing else, we will 
run into situations where we need to debug what's happening and the tool is 
not going to work for those conditions. Having a direct access to the API 
right there in /sys is great and is one of the things that Linux excels at and 
differentiates itself from the competition with.

However, I am saying that we shouldn't have to go out of our way to make the 
extreme corner case easy if it comes to the detriment of the 99% case.

Anyway, we can update the tool to print "%02x-%02x-%02x-%02x.%s" instead of 
"%d". That's trivial to us. I just don't think it's a worthwhile change, 
because four of the five placeholders there are enforced by the kernel and 
therefore the kernel must check them again (maybe it does so anyway when it 
opens and validates the file).

What REALLY matters to me is that the current_batch file be readable and I can 
get the last batch that was loaded, in a well-known format. Without this, we 
go from "inconvenience" to "major design change, must talk to customers and 
customers must adapt their workloads". Please help me out here.

-- 
Thiago Macieira - thiago.macieira (AT) intel.com
  Cloud Software Architect - Intel DCAI Cloud Engineering



