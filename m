Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBB62FAF
	for <patches@lists.linux.dev>; Wed, 16 Mar 2022 08:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8213CC340E9;
	Wed, 16 Mar 2022 08:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1647418163;
	bh=9MeOuZ7Yb5TifZzFGIEaV3LSES97K18572IADr0rgLw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ds4oKayjlDznyeIMcJbkfh4rTkv1b4It02XA8am1nY113Xy4U/FEyNmAreeBKRikd
	 0YzEDewn6u91E4uZxR3Gj4Kcl2amkC0qh4XGWeEWrU+d7UpanofIwKmelRTgMWBcgu
	 m0hpfVhCYrZpDtSU52Y4BbaI7lrs8Bl6n+ko7J9k=
Date: Wed, 16 Mar 2022 09:09:19 +0100
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
Message-ID: <YjGbL2HzksucTn0h@kroah.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
 <Yh59rOIH24X+6GyI@kroah.com>
 <Yh5+om/Nr06V0+Qj@kroah.com>
 <Yi/Lb5laEki0JHft@agluck-desk3.sc.intel.com>
 <YjBBmEjbIaqTbVt+@kroah.com>
 <c4af81bd788e43dda915a1052af0be55@intel.com>
 <YjCwI4N00reBuIqA@kroah.com>
 <de895b9617aa412e95fdd14fcad285fa@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de895b9617aa412e95fdd14fcad285fa@intel.com>

On Tue, Mar 15, 2022 at 04:10:59PM +0000, Luck, Tony wrote:
> > Again, I have no idea what you are doing at all with this driver, nor
> > what you want to do with it.
> >
> > Start over please.
> 
> TL;DR is that silicon ages and some things break that don't have parity/ECC checks.
> So systems start behaving erratically. If you are lucky they crash. If you are less lucky
> they give incorrect results.
> 
> There's a paper (and even a movie 11 minutes) that describe the research by
> Google on this.
> https://sigops.org/s/conferences/hotos/2021/papers/hotos21-s01-hochschild.pdf  
> (https://www.youtube.com/watch?v=QMF3rqhjYuM)    

Both you and Dan are assuming that I actually care about this hardware
and driver enough to read a presentation or watch a video about it.
Sorry, but that's not happening :)

I'm saying these questions as you all need to be asking yourself that,
and figuring out what the proper api is.  That's not my job here.  I was
just pointing out the problems in your original submission that you all
should have caught before sending it out...

good luck!

greg k-h
