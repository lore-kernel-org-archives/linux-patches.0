Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D007C
	for <patches@lists.linux.dev>; Tue,  1 Mar 2022 20:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E078C340EE;
	Tue,  1 Mar 2022 20:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1646165339;
	bh=X4HczuKsdoXT8V43BEGA2HkrMiFqgL9UaVeKPQ0TUdI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oO0DdgdjI0HR754EsbJX70T8tSVCyj6vzo4kQFWJ6Ov9e4/tvHLwdLre13jxBEAyP
	 xysA61vECAoSOwjxd9kLBy5uqd2YgOhhXT3+HbSKPpJXxpNMzu50rjRtSUdebH/0wz
	 wTbXLKRDylbanKDyJUr93XSUz7TLYoym+tmH2XNg=
Date: Tue, 1 Mar 2022 21:08:57 +0100
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
Subject: Re: [RFC 01/10] x86/microcode/intel: expose collect_cpu_info_early()
 for IFS
Message-ID: <Yh59WcIr06mK9aK2@kroah.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
 <20220301195457.21152-2-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301195457.21152-2-jithu.joseph@intel.com>

On Tue, Mar 01, 2022 at 11:54:48AM -0800, Jithu Joseph wrote:
> IFS uses a image provided by Intel that can be regarded as firmware.
> IFS image carries the Processor Signature such as family/model/stepping
> similar to what we find in the microcode header.
> 
> Expose collect_cpu_info_early() and cpu_signatures_match() for IFS image

If this is going to be a global symbol, how about
cpu_collect_info_early() to keep the correct prefix?

thanks,

greg k-h
