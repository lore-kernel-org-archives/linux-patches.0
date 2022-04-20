Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940FB1866
	for <patches@lists.linux.dev>; Wed, 20 Apr 2022 19:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7826C385A1;
	Wed, 20 Apr 2022 19:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1650481498;
	bh=3TwvUFV0aw9LmXxpaVt1WobXYjRRbhKrWPYqHzWsKv4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X7jLxxtVlTztqVg3E8BIUuuDLZKMM2mTqRwnBiVXErc194bnvswjXEBu4V/EHgeHP
	 lzyz9hJhEA9hex7EsRngiu1T0KU677Hoq/3jgOQV3/+r0bxHXVAKpp9uVkCBC9kg8E
	 G4OV5/xcOVd8fTONZl9Nhl9pXMfbDmxy0pC78wzI=
Date: Wed, 20 Apr 2022 21:04:55 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	"markgross@kernel.org" <markgross@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, X86 ML <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Joseph, Jithu" <jithu.joseph@intel.com>,
	"Raj, Ashok" <ashok.raj@intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Doc Mailing List <linux-doc@vger.kernel.org>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: Re: [PATCH v3 03/11] platform/x86/intel/ifs: Create device for Intel
 IFS (In Field Scan)
Message-ID: <YmBZV3pUtKC2j0Ui@kroah.com>
References: <20220419163859.2228874-1-tony.luck@intel.com>
 <20220419163859.2228874-4-tony.luck@intel.com>
 <Yl7npfrVTPFEIivC@kroah.com>
 <CAPcyv4jzscs3Dg4QN0+XHRYdekBeqy1=dRX-mWCj1OXo8jS2vQ@mail.gmail.com>
 <Yl+66oyQhI0AkEDC@kroah.com>
 <YmAmebezoc8m6n2E@agluck-desk3.sc.intel.com>
 <YmBG44t4dYsUl4Aa@kroah.com>
 <578be5d8874f4942a58adf5f64c4e817@intel.com>
 <YmBLJf8JQkfSQGvA@kroah.com>
 <cf53a8fa1e4e4c6885810ee8e4785b79@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf53a8fa1e4e4c6885810ee8e4785b79@intel.com>

On Wed, Apr 20, 2022 at 06:08:20PM +0000, Luck, Tony wrote:
> >> Or is it ok for them all to sit at the top level of /sys/devices/virtual?
> >
> > How many do you have?
> >
> > And why is a directory needed for just one tiny driver type?
> 
> One today. Two tomorrow (internally ... next gen CPU).
> 
> Three eventually (That's how many are on the roadmap that I can see).

Then just use a misc device, it's simple and saves you a ton of code.
