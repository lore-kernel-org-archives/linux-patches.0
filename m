Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF381872
	for <patches@lists.linux.dev>; Sun, 10 Jul 2022 17:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B801C341CB;
	Sun, 10 Jul 2022 17:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1657472444;
	bh=RXJPWzKEvNojmH6onaoi2IawBje3FDYFyUPoyxcvX3g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vo3v6YBmJb/xIPtHLys+IlTgkyML3/SX7IM0k0SQShVMSCC9ZbGsXYY68Ao39DoBS
	 QWCGs2RLyOXNp/jIJR5JUBRcFQGhSFwRrNtxR1usoSfSEB+hOJfYTUzwSt+IZQ+6ia
	 KUztzlfWfxGrZAi4QVfRNF1KtYFxIGYGwcIGF4iI=
Date: Sun, 10 Jul 2022 19:00:41 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Jithu Joseph <jithu.joseph@intel.com>
Cc: hdegoede@redhat.com, markgross@kernel.org, ashok.raj@intel.com,
	tony.luck@intel.com, ravi.v.shankar@intel.com,
	linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v2] platform/x86/intel/ifs: Allow non-default names for
 IFS image
Message-ID: <YssFueUGqzq2WLHa@kroah.com>
References: <20220710160011.995800-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220710160011.995800-1-jithu.joseph@intel.com>

On Sun, Jul 10, 2022 at 09:00:11AM -0700, Jithu Joseph wrote:
> Existing implementation limits IFS images to be loaded only from
> a default file-name /lib/firmware/intel/ifs/ff-mm-ss.scan.
> 
> But there are situations where there may be multiple scan files
> that can be run on a particular system stored in /lib/firmware/intel/ifs
> 
> E.g.
> 1. Because test contents are larger than the memory reserved for IFS by BIOS
> 2. To provide increased test coverage
> 3. Custom test files to debug certain specific issues in the field
> 
> Renaming each of these to ff-mm-ss.scan and then loading might be
> possible in some environments. But on systems where /lib is read-only
> this is not a practical solution.
> 
> Modify the semantics of the driver file
> /sys/devices/virtual/misc/intel_ifs_0/reload such that,
> it interprets the input as the filename to be loaded.
> 
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
> ---

Also note that this does not follow the required Intel rules for
submitting kernel patches.  Why the rush and circumventing of the normal
process that we have in place for good reasons?

greg k-h
