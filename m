Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01FB391E5F;
	Sat, 27 Jun 2026 09:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782550805; cv=none; b=GReIxVsP3TE/pMCFbBiK9PfOzr8J8PD2zai+VOi5cLEuzhLH8ezAJJ3ixSztmtoVe7OQoz4EFIYSpSTNOoZPQnknBszqfdBu3zpGHw9cyj3/IqWEcDyloYDzBEFFRrPpL0nUIhe8VxjXnyjXpOx392XMpKjKQbiR8uILuTGNcxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782550805; c=relaxed/simple;
	bh=LeEEq/73ZzS1pcfEF/wze7xCTUFQAcu4duKOW+MO+VQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uxXRMfDBumbPgAjyUM7NLbdjGixc/VN+PhI7mj0cHcl/C2VOcOjxzjSk+jL1dzVDhSUvB9bXFfA/4VfITCChp/nw1d+2PDOGYWE3lAJjgCIQUt/vZfyvwFp2VdJOQRav0v5EWjcx23BZGbFP56R0Lop3p+TgY5NFcHhu/kOlVBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PiVXrc9C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PiVXrc9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80B61F00A3D;
	Sat, 27 Jun 2026 09:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782550803;
	bh=dsV+qvRBuKDm/lOubp+3DnGinyqni0Q6vVqOoREpWq0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PiVXrc9CPalTuMf6qSeSj1ZeGN4ZxKo+Ohw58nt/zITDTgQzs0zMrQCBvWYoAz1T9
	 XdSz8e0vH/A/P5VhhfBqDhKxVVRyBv6HPOH4DVIZRjmGaxPHjjUdnlcNLYTomq0uoF
	 t4BfSxStKWgbRpSb26eFojgMfcVUKSfVCnmLP/ww=
Date: Sat, 27 Jun 2026 09:58:49 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Barry K. Nathan" <barryn@pobox.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.1 00/21] 7.1.2-rc1 review
Message-ID: <2026062719-unearth-zoology-778e@gregkh>
References: <20260625125613.243729608@linuxfoundation.org>
 <b7bd471b-e9da-4bfc-ad1d-24b378bd1e44@pobox.com>
 <aj7RmyBck8EkPn_s@google.com>
 <ab7df7bf-1b30-40c0-9463-a469abfa2bda@pobox.com>
 <aj7r1Eqt2SEnWsMZ@google.com>
 <626fc564-6f4b-430d-92f3-653981e3dcdd@pobox.com>
 <aj8WEfam__6fnNuM@google.com>
 <2b4c3bdb-5dcd-4834-9ee1-5a9a75ab4815@pobox.com>
 <aj8yGUwvPqiYk4hL@google.com>
 <8d8bb4ba-35fc-48f6-b77d-bd1cf56044c8@pobox.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d8bb4ba-35fc-48f6-b77d-bd1cf56044c8@pobox.com>

On Fri, Jun 26, 2026 at 10:20:35PM -0700, Barry K. Nathan wrote:
> On 6/26/26 7:15 PM, Dmitry Torokhov wrote:
> > On Fri, Jun 26, 2026 at 07:09:08PM -0700, Barry K. Nathan wrote:
> > > On 6/26/26 5:31 PM, Dmitry Torokhov wrote:
> > > > On Fri, Jun 26, 2026 at 03:23:12PM -0700, Barry K. Nathan wrote:
> > > > > On 6/26/26 2:17 PM, Dmitry Torokhov wrote:
> > > > > > On Fri, Jun 26, 2026 at 01:41:38PM -0700, Barry K. Nathan wrote:
> > > > > > > On 6/26/26 12:56 PM, Dmitry Torokhov wrote:
> > > > > > > > Hi Barry,
> > > > > > > > 
> > > > > > > > On Fri, Jun 26, 2026 at 10:56:21AM -0700, Barry K. Nathan wrote:
> > > > > > > > > (cc Dmitry Torokhov because this is related to two of your commits)
> > > > > > > > > 
> > > > > > > > > On 6/25/26 6:03 AM, Greg Kroah-Hartman wrote:
> > > > > > > > > > This is the start of the stable review cycle for the 7.1.2 release.
> > > > > > > > > > There are 21 patches in this series, all will be posted as a response
> > > > > > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > > > > > let me know.
> > > > > > > > > > 
> > > > > > > > > > Responses should be made by Sat, 27 Jun 2026 12:54:50 +0000.
> > > > > > > > > > Anything received after that time might be too late.
> > > > > > > > > > 
> > > > > > > > > > The whole patch series can be found in one patch at:
> > > > > > > > > > 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.2-rc1.gz
> > > > > > > > > > or in the git tree and branch at:
> > > > > > > > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> > > > > > > > > > and the diffstat can be found below.
> > > > > > > > > > 
> > > > > > > > > > thanks,
> > > > > > > > > > 
> > > > > > > > > > greg k-h
> > > > > > > > > > 
> > > > > > > > > Unfortunately, 7.1.2-rc1 breaks the Synaptics touchpad on my Lenovo
> > > > > > > > > ThinkPad T14 Gen 1 -- the pointer no longer moves when I touch the
> > > > > > > > > touchpad. Potentially relevant line from dmesg:
> > > > > > > > > 
> > > > > > > > > rmi4_f01 rmi4-00.fn01: found RMI device, manufacturer: Synaptics, product: TM3471-020, fw id: 3972349
> > > > > > > > > 
> > > > > > > > > > Dmitry Torokhov<dmitry.torokhov@gmail.com>
> > > > > > > > > >          Input: rmi4 - refactor register descriptor parsing
> > > > > > > > > > 
> > > > > > > > > > Dmitry Torokhov<dmitry.torokhov@gmail.com>
> > > > > > > > > >          Input: rmi4 - fix register descriptor address calculation
> > > > > > > > > > > Both of these patches seem bad in my testing. Either one, individually,
> > > > > > > > > causes the pointer to no longer move when I touch the touchpad. If I
> > > > > > > > > revert both of them, then my touchpad works again.
> > > > > > > > > 
> > > > > > > > > I have not yet tested 7.0.14-rc1 or 6.18.37-rc1. However, the problem
> > > > > > > > > also reproduces on current mainline as of this writing (commit
> > > > > > > > > 51cb1aa1250c36269474b8b6ca6b6319e170f5a5).
> > > > > > > > Could you please try applying this debug patch and send me dmesg?
> > > > > > > Sure, I applied the patch on top of mainline, and the dmesg output is
> > > > > > > below.
> > > > > > Thank you! So I messed up and "Input: rmi4 - fix register descriptor
> > > > > > address calculation" is totally wrong.
> > > > > > 
> > > > > > Can you please revert it (keeping the debug patch) and try booting again
> > > > > > and if the touchpad still does not work post the dmesg again.
> > > > > > 
> > > > > > Thanks!
> > > > > 
> > > > > I did the revert, while keeping the debug patch. With this kernel, the
> > > > > touchpad still doesn't work for me, so here's the new dmesg.
> > > > 
> > > > Thank you. It looks like the firmware is a bit sloppy and the new
> > > > tightened checks are tripping on it. Please try this patch:
> > > > 
> > > > 
> > > > Input: rmi4 - tolerate short register descriptor structure
> > > > 
> > > > From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > > > 
> > > > Some touchpads (e.g. ThinkPad T14 Gen 1) have buggy firmware that reports
> > > > a register descriptor structure size that is too small for the number of
> > > > registers it claims to have in the presence map. The remaining bytes in
> > > > the structure are 0, which with the new strict bounds checking causes the
> > > > parser to fail with -EIO, aborting the device probe.
> > > > 
> > > > Tolerate such short reads by dropping the remaining (unparseable or
> > > > 0-size) registers from the list instead of failing the probe,
> > > > preventing the driver from trying to use them.
> > > > 
> > > > Fixes: 0adb483fbf2d ("Input: rmi4 - refactor register descriptor parsing")
> > > > Reported-by: Barry K. Nathan <barryn@pobox.com>
> > > > Cc: stable@vger.kernel.org
> > > > Assisted-by: Antigravity:gemini-3.5-flash
> > > > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > > 
> > > Yes, this worked! To be clear, what I did (and what I'm successfully
> > > running now) is:
> > > 
> > > 1. Start with mainline as of commit 51cb1aa1250c36269474b8b6ca6b6319e170f5a5
> > > 2. Then revert a98518e72439fd42cbfe641c2896543cb088e3d1
> > >     ("Input: rmi4 - fix register descriptor address calculation")
> > > 3. Then apply the new patch
> > >     ("Input: rmi4 - tolerate short register descriptor structure")
> > > 
> > > If there's anything else I need to test or anything else you want me
> > > to try, please let me know. Thank you!
> > 
> > No, this is it. I will apply this to my tree and send it on to Linus.
> > 
> > Thanks.
> 
> That will take care of mainline, but there's still the issue of the
> upcoming stable kernel releases (6.18.37, 7.0.14, 7.1.2).
> 
> 
> For brevity in the rest of this email, I'll refer to these patches as
> patch A/B/C:
> 
> Patch A: "Input: rmi4 - fix register descriptor address calculation"
> Patch B: "Input: rmi4 - refactor register descriptor parsing"
> Patch C: "Input: rmi4 - tolerate short register descriptor structure"
> 
> 
> Perhaps the best way forward for the current stable cycle is to drop
> patches A and B from the stable-queue for now, to make sure these
> releases don't break any touchpads.
> 
> Once patch C lands in mainline, that will fix patch B. So, in a
> future stable release cycle, patch B could be added back to the
> stable-queue alongside patch C.

I'm just going to drop _all_ the rmi4 patches from the stable queues
right now.  When this gets sorted out, can someone email me the git ids
that should be applied here and I'll be glad to queue them up then.

thanks,

greg k-h
