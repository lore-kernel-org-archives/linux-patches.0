Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EC728E03;
	Thu,  4 Jan 2024 18:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YGO0DU2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C25C433C8;
	Thu,  4 Jan 2024 18:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704392443;
	bh=9pOYKccvXyXpmaPnCPMf+km7/Tm6rrflrvnJ3M30nzw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YGO0DU2zV5pZNb0c+G2n/hJSgBoCQ2oukQqktCmejPYiPIHksQ6yZkj8lnBlSuWpz
	 Uiw4fbqDWrhm7QZesXGwCQc/2TIudDHPE+yFfpiOieHY3zSjKTdZxzA+EA36bLjPMF
	 tsaeDbwipoRXg5Kb+yktauZOtM096Zjf26r2Z9mM=
Date: Thu, 4 Jan 2024 19:20:40 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 6.1 086/100] platform/x86: p2sb: Allow p2sb_bar() calls
 during PCI device probe
Message-ID: <2024010422-wanted-diabetes-8e0c@gregkh>
References: <20240103164856.169912722@linuxfoundation.org>
 <20240103164909.026702193@linuxfoundation.org>
 <ikeipirtlgca6durdso7md6khlyd5wwh4wl2jzlxkqr2utu4p4@ou2wcovon7jt>
 <2024010401-shell-easiness-47c9@gregkh>
 <djjzvybh5z5q5ojn3isltl6g32gpvhcilzfr3rznb5hlijjavm@z3itpol7wec7>
 <5f97aaa-2d8e-498b-18d1-88e048443dcc@linux.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5f97aaa-2d8e-498b-18d1-88e048443dcc@linux.intel.com>

On Thu, Jan 04, 2024 at 07:02:52PM +0200, Ilpo Järvinen wrote:
> On Thu, 4 Jan 2024, Shinichiro Kawasaki wrote:
> 
> > On Jan 04, 2024 / 09:58, Greg Kroah-Hartman wrote:
> > > On Thu, Jan 04, 2024 at 08:54:48AM +0000, Shinichiro Kawasaki wrote:
> > 
> > ...
> > 
> > > > Greg, please drop this patch from 6.1-stable for now. Unfortunately, one issue
> > > > has got reported [*].
> > > > 
> > > > [*] https://lore.kernel.org/platform-driver-x86/CABq1_vjfyp_B-f4LAL6pg394bP6nDFyvg110TOLHHb0x4aCPeg@mail.gmail.com/T/#u
> > > 
> > > What about 6.6.y, this is also queued up there too.
> > 
> > Please drop it from 6.6.y too.
> > 
> > > And when is this going to be reverted in Linus's tree?  6.7-rc8 has this
> > > issue right now, right?
> > 
> > Yes. I agree that revert action is needed.
> > 
> > Ilpo,
> > 
> > As I commented to the response to the bug report, fix does not look straight
> > forward to me. I guess fix discussion with x86 experts' will take some time
> > (Andy is now away...). I will post a revert patch later. May I ask you to handle
> > it?
> 
> I've applied the revert and made a PR out of it:
> 
> https://lore.kernel.org/platform-driver-x86/1a6657ef8475862e4fc282efe832fa86.=%3FUTF-8%3Fq%3FIlpo=20J=C3=A4rvinen%3F=%20%3Cilpo.jarvinen@linux.intel.com/T/#u
> 
> 
> I found it a bit disappointing to hear from Greg that patches can no 
> longer be dropped from stable-queue (it certainly used to be possible 
> earlier) but things are to be handled indirectly through commits in Linus' 
> tree.

They can be dropped, yes, but it's easier to add the follow-on revert so
that all of the scripts out there don't keep resending the original
change as part of the "hey, you missed this patch!" sweeps that people
run.

So taking both of them is better, right?  That also ensures that Linus's
tree is fixed up, which is key for everyone involved.

For stuff that is "this should not be in the stable tree at all", we
always drop those easily, that's never a problem.

thanks,

greg k-h
