Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367D120314;
	Thu,  4 Jan 2024 09:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJAu4taS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63901C433C8;
	Thu,  4 Jan 2024 09:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704360045;
	bh=yKuUpg1t9MISejbXe8mqkxSGHizsI/99jdcaRjNEj2o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qJAu4taSEytuM05qCHhKyrDpM0ynaU0wJHRHpP0Ha/0RNMF3q4kf/l6zLJfPwiGtw
	 7E/Mu8t1LE9dHD6i2IuWeEfuLOKiyTb+1AUaXg2qCAZcnEC7LAb/r8fYpHby3pdM9R
	 rtjmbF/ztG2Cn7Hd2DA/c6wjeZhvIaebhDA0BHHI=
Date: Thu, 4 Jan 2024 10:20:43 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: Re: [PATCH 6.1 086/100] platform/x86: p2sb: Allow p2sb_bar() calls
 during PCI device probe
Message-ID: <2024010438-myth-resupply-7a83@gregkh>
References: <20240103164856.169912722@linuxfoundation.org>
 <20240103164909.026702193@linuxfoundation.org>
 <ikeipirtlgca6durdso7md6khlyd5wwh4wl2jzlxkqr2utu4p4@ou2wcovon7jt>
 <2024010401-shell-easiness-47c9@gregkh>
 <djjzvybh5z5q5ojn3isltl6g32gpvhcilzfr3rznb5hlijjavm@z3itpol7wec7>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <djjzvybh5z5q5ojn3isltl6g32gpvhcilzfr3rznb5hlijjavm@z3itpol7wec7>

On Thu, Jan 04, 2024 at 09:11:41AM +0000, Shinichiro Kawasaki wrote:
> On Jan 04, 2024 / 09:58, Greg Kroah-Hartman wrote:
> > On Thu, Jan 04, 2024 at 08:54:48AM +0000, Shinichiro Kawasaki wrote:
> 
> ...
> 
> > > Greg, please drop this patch from 6.1-stable for now. Unfortunately, one issue
> > > has got reported [*].
> > > 
> > > [*] https://lore.kernel.org/platform-driver-x86/CABq1_vjfyp_B-f4LAL6pg394bP6nDFyvg110TOLHHb0x4aCPeg@mail.gmail.com/T/#u
> > 
> > What about 6.6.y, this is also queued up there too.
> 
> Please drop it from 6.6.y too.
> 
> > And when is this going to be reverted in Linus's tree?  6.7-rc8 has this
> > issue right now, right?
> 
> Yes. I agree that revert action is needed.

Please submit the revert and then we can apply that here as well, that's
easier to track properly.

thanks,

greg k-h
