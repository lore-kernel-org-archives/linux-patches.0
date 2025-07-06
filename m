Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC2911CA9;
	Sun,  6 Jul 2025 06:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751781863; cv=none; b=EUjVlUhVGbfsSsmr44jdYeqcvQ4Bqa9b5Ht1SrhZMEuYzWvkeOCYuoa8hXRyOvDNE9wXbQ8PtyizdhUbm20MTVrMmAEYUkLJbZRkg1CA0mq2i/h7gkXi+USenfP2ZW6vxVdPKiLiCS6pzYGRremmXGz75FvrCxwE/eqBtlHSWQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751781863; c=relaxed/simple;
	bh=85017Hw7iOU6sd49uX9LUWL+lcBDkGyDsLXJtVbX6NY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oAdcZJDTdjmdaDZAoI+wl480c+56xiV7hnEn7UVxkY9PM7DnF/zHV7mRvs1BEz7lid0palIfQN0elTNfYObnrLhpzOR3InDDQ5cyZNX9l0uwiRn3EyHebonccT5l9Nag6A63bT/Fuo6RvQmFYRettEGgbNumPE4+nbHZoKd7MTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vR6oDqzw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vR6oDqzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B935C4CEED;
	Sun,  6 Jul 2025 06:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751781862;
	bh=85017Hw7iOU6sd49uX9LUWL+lcBDkGyDsLXJtVbX6NY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vR6oDqzwjcq13ag0MOn4K1NjuETVC188UugBhjYC2RGb5wu7kJ/f7j/ymzLTNQFOK
	 P0fsF5bn2JKavvj3XKa6yM37JmGvmDo73HeYhh+/NjvjSE7kZZj5l5w7BQdpAkfeyz
	 LFYQkxgu/lWuhag2NQL5g5DtI4MYAUoSoLKJrj9k=
Date: Sun, 6 Jul 2025 08:03:56 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/413] 6.12.35-rc2 review
Message-ID: <2025070613-escalate-action-761d@gregkh>
References: <20250624121426.466976226@linuxfoundation.org>
 <3037c3e6-558b-4824-8c78-a36990f4e4d6@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3037c3e6-558b-4824-8c78-a36990f4e4d6@roeck-us.net>

On Sat, Jul 05, 2025 at 12:37:52PM -0700, Guenter Roeck wrote:
> Hi Greg,
> 
> On Tue, Jun 24, 2025 at 01:29:53PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.12.35 release.
> > There are 413 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 26 Jun 2025 12:13:28 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Some subsequent fixes are missing:
> 
> > Tzung-Bi Shih <tzungbi@kernel.org>
> >     drm/i915/pmu: Fix build error with GCOV and AutoFDO enabled
> > 
> 
> Fixed by commit d02b2103a08b ("drm/i915: fix build error some more").

How did you check?  This is already in the queues for 6.6, 6.12, and
6.15.

> > Shyam Prasad N <sprasad@microsoft.com>
> >     cifs: do not disable interface polling on failure
> > 
> 
> Fixed by commit 3bbe46716092 ("smb: client: fix warning when reconnecting
> channel") in linux-next (not yet in mainline as of right now).

Not in a release yet.

> > Jens Axboe <axboe@kernel.dk>
> >     io_uring/kbuf: don't truncate end buffer for multiple buffer peeks
> > 
> 
> Fixed by commit 9a709b7e98e6 ("io_uring/net: mark iov as dynamically
> allocated even for single segments") and commit 178b8ff66ff8 ("io_uring/kbuf:
> flag partial buffer mappings").

Both are alread in 6.12 and 6.15 queues

> > Yong Wang <yongwang@nvidia.com>
> >     net: bridge: mcast: re-implement br_multicast_{enable, disable}_port functions
> > 
> 
> Fixed by commit 7544f3f5b0b5 ("bridge: mcast: Fix use-after-free during
> router port configuration").

Already in the 6.15 queue

> > Niklas Cassel <cassel@kernel.org>
> >     ata: ahci: Disallow LPM for ASUSPRO-D840SA motherboard
> > 
> 
> Fixed by commit 3e0809b1664b ("ata: ahci: Use correct DMI identifier
> for ASUSPRO-D840SA LPM quirk").

Already in the 6.12 and 6.15 queues.

> I assume the missing fixes will be queued in one of the next LTS releases.

They are going to be in THIS release, with one exception as noted above.
I think something went really wrong with your checking scripts :(

thanks,

greg k-h
