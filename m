Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375021361
	for <patches@lists.linux.dev>; Thu, 28 Apr 2022 15:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49115C385A0;
	Thu, 28 Apr 2022 15:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1651161503;
	bh=fNIBVIIk0IE04HDM8urQy+y3K51vcAq0tBXsH7r/KlQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xV3DlqLd5CF6A5IRnd8nm1k3Euxw82wHgOc+3SlRnN7kkm571vrYUFI95BS0Mp/1U
	 U4Xw+ay7hOT3eYIr2vlsUCISx3fxBLzaKOVRpIOlp/QJSjeWFy0nwYplaE4pxgAYxZ
	 HvT05IKr5pmGm8a6kOIAGyxPRRTspWNsRSjkMjIU=
Date: Thu, 28 Apr 2022 17:58:20 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Luck <tony.luck@intel.com>
Cc: hdegoede@redhat.com, markgross@kernel.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, corbet@lwn.net,
	andriy.shevchenko@linux.intel.com, jithu.joseph@intel.com,
	ashok.raj@intel.com, rostedt@goodmis.org, dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
	ravi.v.shankar@intel.com
Subject: Re: [PATCH v5 00/10] Introduce In Field Scan driver
Message-ID: <Ymq5nH/A9c88wIM/@kroah.com>
References: <20220422200219.2843823-1-tony.luck@intel.com>
 <20220428153849.295779-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428153849.295779-1-tony.luck@intel.com>

On Thu, Apr 28, 2022 at 08:38:39AM -0700, Tony Luck wrote:
> Hopefully this is close enough to done to begin discussion on which
> maintainer tree will take this series.
> 
> Choices:
> 1) Hans/Mark take it into the platform-drivers tree
>    Needs an Ack from x86 maintainers on parts 1 & 2
> 2) X86 maintainers take it into TIP
>    Needs Ack from Hans/Mark on parts 2-10
> 
> TL;DR this driver loads scan test files that can check whether silicon
> in a CPU core is still running correctly. It is expected that these tests
> would be run several times per day to catch problems as silicon ages.

Much nicer and simpler as compared to the first version submitted,
thanks for sticking with it.  The diff seems about 1/3 smaller from the
first version sent out, peer-review works :)

Reviewed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

