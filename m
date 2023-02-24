Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2C93C26
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 10:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E734C433D2;
	Fri, 24 Feb 2023 10:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677234340;
	bh=f7SaBfdngDgajRsbNPj8EA2H/Baaamydt3TxzBPUZ2Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Obac7XcEXWVVFt0OU/f96u0NRhgy4BFVa7RDVDJQkzAzNGChuwM8CECOij34AEBD4
	 nR61KlzdTuhqMVwsfp8mBbJVUu7Gc91cDRB5uKXhgSA0NaHucab38Q+y6QiqsL2wx5
	 x5IigCPKBRxv1hDk9gFzHGIcEXMTtQOp7YJ4N+6U=
Date: Fri, 24 Feb 2023 11:25:37 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nathan Chancellor <nathan@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc2 review
Message-ID: <Y/iQoRDIRYRNu/34@kroah.com>
References: <20230223141542.672463796@linuxfoundation.org>
 <adc1b0b7-f837-fbb4-332b-4ce18fc55709@roeck-us.net>
 <Y/eVSi4ZTcOmPBTv@kroah.com>
 <cfd03ee0-b47a-644d-4364-79601025f35f@roeck-us.net>
 <CAHk-=whCG1zudvDsqdFo89pHARvDv4=r6vaZ8GWc_Q9amxBM6Q@mail.gmail.com>
 <Y/fC3d3RqoeawG0Y@dev-arch.thelio-3990X>
 <CAHk-=whkNnShBugM01Kzcypkp+f-uHeBWuAgtUiMpiSZuW+QDQ@mail.gmail.com>
 <Y/fZbQEEPBNZQ2w7@kroah.com>
 <CAHk-=whiuJH_DYQZw1hPtibDQZcNy8QYf1cZJCsezuPobSXCKw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whiuJH_DYQZw1hPtibDQZcNy8QYf1cZJCsezuPobSXCKw@mail.gmail.com>

On Thu, Feb 23, 2023 at 01:39:42PM -0800, Linus Torvalds wrote:
> On Thu, Feb 23, 2023 at 1:24 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > Quilt should be depending on patch here, I think it's something in my
> > set of "turn this series of patches into a mbox, split the mbox up into
> > patches" sequence that is causing the problem.
> 
> Well, it might also be that quilt just re-generates the patch with
> 'diff', and then in the process loses the information again.
> 
> We can happily continue to support the "we lost the executable bit",
> since it sounds like Nathan is willing to cook up a patch.
> 
> I'm just too lazy and personally unaffected to care (and too busy with
> merges - excuses, excuses).

Ok, I figured it out.  git is doing the right thing, my scripts are
doing the right thing, patch is doing the right thing, but quilt is
not looking at the permissions on the file at all when refreshing a
patch that has been applied to a tree.

This might be a configuration setting on my end for quilt, or a bug in
quilt, I'll try to track this down, but in the meantime, I've fixed up
the stable queue of patches and pushed out a -rc3 with this hopefully
all fixed up.

thanks,

greg k-h
