Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6967A
	for <patches@lists.linux.dev>; Wed,  2 Mar 2022 15:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F70C004E1;
	Wed,  2 Mar 2022 15:33:14 +0000 (UTC)
Date: Wed, 2 Mar 2022 10:33:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jithu Joseph <jithu.joseph@intel.com>, hdegoede@redhat.com,
 markgross@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, corbet@lwn.net,
 andriy.shevchenko@linux.intel.com, ashok.raj@intel.com,
 tony.luck@intel.com, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 patches@lists.linux.dev, ravi.v.shankar@intel.com
Subject: Re: [RFC 00/10] Introduce In Field Scan driver
Message-ID: <20220302103313.3bacd10b@gandalf.local.home>
In-Reply-To: <Yh59rOIH24X+6GyI@kroah.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
	<Yh59rOIH24X+6GyI@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 1 Mar 2022 21:10:20 +0100
Greg KH <gregkh@linuxfoundation.org> wrote:

> "RFC" means you are not comfortable submitting the changes yet, so you
> don't need my review at this point in time.  Become confident in your
> changes before asking for others to review the code please.

I guess you and I have a different understanding of RFC (Request for
Comments). As to me, comments are a form of review.

In other words, RFC to me means the review is "does this design look like
it will work", and we should be reviewing the design and overview of the
patches. Not the nitty gritty details (like missed error handling, unless
the design will prevent it). Although, you could add those comments in a
review.

When I post RFCs, it's not that I'm not comfortable submitting the change,
it's because I want to know if what I'm doing makes sense, and I might be
missing something that will make this effort in vain.

What ever happen to the "Submit early, submit often" mantra?

-- Steve
