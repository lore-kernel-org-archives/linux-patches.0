Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2944323B5
	for <patches@lists.linux.dev>; Tue, 15 Mar 2022 15:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC64C340E8;
	Tue, 15 Mar 2022 15:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1647357993;
	bh=1qZvbzMNRKv0qve5g7XZi7lfN+NjMPizyZXg7d9qImM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2P+oJGeEKL480UE+3P8IkGKwHtbTrpp8jjvHca1milkij2fwwFx5bLc0iwI1KumeK
	 HYoouOQ04UG/98KISLGDoYiCxCxEv/f85Mn+4h2xN9o+n7sh1ATROmhV2M2VcqJ3jc
	 GLTTmsA0p7+AO6qOr4qKWpWPGpqmGBWYsb3I7bww=
Date: Tue, 15 Mar 2022 16:26:27 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Joseph, Jithu" <jithu.joseph@intel.com>,
	"hdegoede@redhat.com" <hdegoede@redhat.com>,
	"markgross@kernel.org" <markgross@kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>,
	"Raj, Ashok" <ashok.raj@intel.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Shankar, Ravi V" <ravi.v.shankar@intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [RFC 00/10] Introduce In Field Scan driver
Message-ID: <YjCwI4N00reBuIqA@kroah.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
 <Yh59rOIH24X+6GyI@kroah.com>
 <Yh5+om/Nr06V0+Qj@kroah.com>
 <Yi/Lb5laEki0JHft@agluck-desk3.sc.intel.com>
 <YjBBmEjbIaqTbVt+@kroah.com>
 <c4af81bd788e43dda915a1052af0be55@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4af81bd788e43dda915a1052af0be55@intel.com>

On Tue, Mar 15, 2022 at 02:59:03PM +0000, Luck, Tony wrote:
> >> This seems a novel use of uevent ... is it OK, or is is abuse?
> >
> > Don't create "novel" uses of uevents.  They are there to express a
> > change in state of a device so that userspace can then go and do
> > something with that information.  If that pattern fits here, wonderful.
> 
> Maybe Dan will chime in here to better explain his idea. I think for
> the case where the core test fails, there is a good match with uevent.
> The device (one CPU core) has changed state from "working" to
> "untrustworthy". Userspace can do things like: take the logical CPUs
> on that core offline, initiate a service call, or in a VMM cluster environment
> migrate work to a different node.

Again, I have no idea what you are doing at all with this driver, nor
what you want to do with it.

Start over please.

What is the hardware you have to support?

What is the expectation from userspace with regards to using the
hardware?

> > I doubt you can report "test results" via a uevent in a way that the
> > current uevent states and messages would properly convey, but hey, maybe
> > I'm wrong.
> 
> But here things get a bit sketchy. Reporting "pass", or "didn't complete the test"
> isn't a state change.  But it seems like a poor interface if there is no feedback
> that the test was run. Using different methods to report pass/fail/incomplete
> also seems user hostile.

We have an in-kernel "test" framework.  Yes, it's for kernel code, but
why not extend that to also include hardware tests?

thanks,

greg k-h
