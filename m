Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B915B4350
	for <patches@lists.linux.dev>; Mon,  7 Mar 2022 21:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EBFC340F3;
	Mon,  7 Mar 2022 21:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1646688624;
	bh=25OEIosfzfLsgOqshpbBYPHXAtM3hYgfp1P/4yp+bJw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gE84yXIf2xfNZsellXdbqzUntaL74KJQdmB1VNVIGG9/YF8JBUx3R2Z6XGAUkBKw3
	 4Yop2fPzh6jUshBGTWunXWH06bEJ9G2DW+TQN1pSxpAMOFk6l08AU4Q5Cd6smMSVqv
	 W/4bqIAklo3xf70iYy35w1kM0f+rc3JPLrNQScno=
Date: Mon, 7 Mar 2022 22:30:21 +0100
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Joseph, Jithu" <jithu.joseph@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	"hdegoede@redhat.com" <hdegoede@redhat.com>,
	"markgross@kernel.org" <markgross@kernel.org>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"Raj, Ashok" <ashok.raj@intel.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>,
	"Shankar, Ravi V" <ravi.v.shankar@intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "bp@alien8.de" <bp@alien8.de>,
	"andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC 08/10] platform/x86/intel/ifs: Add IFS sysfs interface
Message-ID: <YiZ5bYPvssUFYGZj@kroah.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
 <20220301195457.21152-9-jithu.joseph@intel.com>
 <188492dc80c017375da76d444347b1d00c2031f6.camel@intel.com>
 <7b9c788e-21dc-eedc-a1b4-9c6877fa48fe@intel.com>
 <CAPcyv4h=qPFrP+mRqaZhkh5ZmYjuQawsqvf+-R036ZJVKBNK4Q@mail.gmail.com>
 <33d0e764-86d9-8504-17fa-14b31c87de4e@intel.com>
 <CAPcyv4g5bq9+u0iLjhpeJw8bkbCREUw60H2z_KfDz4hHCrKdFQ@mail.gmail.com>
 <7c620f8a-189e-5ac4-30fe-1fa14ba799ea@intel.com>
 <CAPcyv4iUuZ0aAWckWvwbxJJgt5tDJRpeonfE4DegWS6KPtJq8A@mail.gmail.com>
 <eab8177d-eb73-ec64-ec1f-4f2a51be8aee@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eab8177d-eb73-ec64-ec1f-4f2a51be8aee@intel.com>

On Mon, Mar 07, 2022 at 12:56:08PM -0800, Joseph, Jithu wrote:
> 
> 
> On 3/7/2022 12:25 PM, Dan Williams wrote:
> 
> > 
> > I am speaking of the state of the case where 2 threads are doing
> > run_test and polling for results. Unless you can guarantee that run2
> > does not start before the results of run1 have been collected then
> > they are lost in that scenario. No amount of kernel locking can
> > resolve that race to collect previous result which would not be a
> > problem in the first place if there was an atomic way to log test
> > results.
> 
> 
> Yes "status" shows the status of the latest run. You cannot get the status of the previous run.
> 
> Also some context on test frequency: Hardware has  strict rate limiting of tests.
> Every core can be tested only once in every 30 minutes. So it is pointless to test at high frequency.

What limits this, the kernel?
