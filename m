Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA4C7C
	for <patches@lists.linux.dev>; Tue,  1 Mar 2022 20:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D510EC340EE;
	Tue,  1 Mar 2022 20:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1646165423;
	bh=iSz+1Jq1TRsqn7zsNd7DSMNhVrLmnEmVmRqFnva9bns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fmjiQ8CkZRl9HDR2pm9PKcYJsfrqnihIFsfd/T5+Vnka/p+iRf4L9aUWsuMIOpqGv
	 OjxEkDJP14ETzU7tRq3G/o/ILpaRGEa1vvw51LochdXHpwbP7wf+Ef5XZ7D2Iqd478
	 tMzswBDsSP+ztK8O0DDLee9IEgIPApMnnpE/i+sk=
Date: Tue, 1 Mar 2022 21:10:20 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Jithu Joseph <jithu.joseph@intel.com>
Cc: hdegoede@redhat.com, markgross@kernel.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, corbet@lwn.net,
	andriy.shevchenko@linux.intel.com, ashok.raj@intel.com,
	tony.luck@intel.com, rostedt@goodmis.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
	ravi.v.shankar@intel.com
Subject: Re: [RFC 00/10] Introduce In Field Scan driver
Message-ID: <Yh59rOIH24X+6GyI@kroah.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301195457.21152-1-jithu.joseph@intel.com>

On Tue, Mar 01, 2022 at 11:54:47AM -0800, Jithu Joseph wrote:
> Note to Maintainers:
> Requesting x86 Maintainers to take a look at patch01 as it
> touches arch/x86 portion of the kernel. Also would like to guide them
> to patch07 which sets up hotplug notifiers and creates kthreads.
> 
> Patch 2/10 - Adds Documentation. Requesting Documentation maintainer to review it.
> 
> Requesting Greg KH to review the sysfs changes added by patch08.

"RFC" means you are not comfortable submitting the changes yet, so you
don't need my review at this point in time.  Become confident in your
changes before asking for others to review the code please.

thanks,

greg k-h
