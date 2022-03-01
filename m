Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B817C
	for <patches@lists.linux.dev>; Tue,  1 Mar 2022 20:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F7AC340EE;
	Tue,  1 Mar 2022 20:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1646165256;
	bh=ez0Ga+qrLNPRGbsUnZojh6Vpw51kNGa/3dB0KIpStPo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fTv7jbc+J6Z8Js8yc1O9GseqPIFoT92uZtpV7rzBPIQvy6Riq/UP4H3lzuAE28/vh
	 2Bdtlka4h/P5S6tsBBRLVIMLptI6yOvA7qLD+X/qRh2qLFDYXuVp3iaS/NiFS6gbPP
	 RvqRaBOr8dLNDV0nqLDPpPA9uc9xWsaF2END+rBQ=
Date: Tue, 1 Mar 2022 21:07:33 +0100
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
Subject: Re: [RFC 02/10] Documentation: In-Field Scan
Message-ID: <Yh59BT1O0Bw+mCAO@kroah.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
 <20220301195457.21152-3-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301195457.21152-3-jithu.joseph@intel.com>

On Tue, Mar 01, 2022 at 11:54:49AM -0800, Jithu Joseph wrote:
> From: Tony Luck <tony.luck@intel.com>
> 
> Add documentation for In-Field Scan (IFS). This documentation
> describes the basics of IFS, the loading IFS image, chunk
> authentication, running scan and how to check result via sysfs
> as well as tunable parameters.
> 
> The CORE_CAPABILITIES MSR enumerates whether IFS is supported.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Reviewed-by: Ashok Raj <ashok.raj@intel.com>

You did not sign off on this, yet you are forwarding it on for
acceptance.  You all know this is not ok, it shouldn't be up to me to
remind you of the rules of the DCO :(

greg k-h
