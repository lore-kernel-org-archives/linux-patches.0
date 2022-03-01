Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A807C
	for <patches@lists.linux.dev>; Tue,  1 Mar 2022 20:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBDBC340EF;
	Tue,  1 Mar 2022 20:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1646165669;
	bh=hafwu17uRhikdH2rke2Tn6mbfT8wORbeL9okzdEuuII=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wkScooPhM3Fmf3bfroQnCr4dHpjk38eACrIrd11bmRmSi+YI84dXcc2f5Xmk0H79c
	 GI4wfieobByW1LaQtcL+I96Duo2c+tXBrBo8kH5ck70EQbDpuikzqiQJuaa9YsBVMU
	 00zbkQ47nd7Y2o7EY5FD1UOTa2dLMN3nkrRGCWK0=
Date: Tue, 1 Mar 2022 21:14:26 +0100
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
Message-ID: <Yh5+om/Nr06V0+Qj@kroah.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
 <Yh59rOIH24X+6GyI@kroah.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh59rOIH24X+6GyI@kroah.com>

On Tue, Mar 01, 2022 at 09:10:20PM +0100, Greg KH wrote:
> On Tue, Mar 01, 2022 at 11:54:47AM -0800, Jithu Joseph wrote:
> > Note to Maintainers:
> > Requesting x86 Maintainers to take a look at patch01 as it
> > touches arch/x86 portion of the kernel. Also would like to guide them
> > to patch07 which sets up hotplug notifiers and creates kthreads.
> > 
> > Patch 2/10 - Adds Documentation. Requesting Documentation maintainer to review it.
> > 
> > Requesting Greg KH to review the sysfs changes added by patch08.
> 
> "RFC" means you are not comfortable submitting the changes yet, so you
> don't need my review at this point in time.  Become confident in your
> changes before asking for others to review the code please.

Hint, it needs work, sysfs_emit() for one thing, lack of reference
counting on your cpu objects is another...
