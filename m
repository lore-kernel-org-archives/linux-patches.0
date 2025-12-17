Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7982734DCCC;
	Wed, 17 Dec 2025 15:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765983869; cv=none; b=K67WVoUtiB9GLJEAQ8W32/ArD4srrzehjJRQXohwl6/7ndOQHQnH7ywtuz2BQUsKb9ocjd/xm5NrXpWzKlZvD6mk+s5o2f2JhQ2TdrsTLB1VnsOygidNMdahD2ZLhaEJhofboXD9b6eR+JIjWsVHen0Ai9T1tyXo8K45ygA+zfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765983869; c=relaxed/simple;
	bh=0LeiwP+e2I4USbHh0gSPvvPxU0i0f1yKMFfDjcf1CDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HRua7Sqt8RBA6s1lm8WJDTx2DKCJYcsnhbd/CfpZuDfICQ1DDUQQieb1luOnGXf0yjtz222trJJQWxe+PS1F8VqcZBH89m3AiQxgVssAdZ0WXuTHE7ysSRY6vozTMnfv7laaseC3XxnJAc1C66GuuZCnoCGdBAWI6iqm00312NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/43KpWB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/43KpWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5C3C113D0;
	Wed, 17 Dec 2025 15:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765983868;
	bh=0LeiwP+e2I4USbHh0gSPvvPxU0i0f1yKMFfDjcf1CDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X/43KpWBKOyHJeKKPTx3SX+J8BhthJa1e9GjZeUhZ1kBXW6adqSILn27wqZhIfhPA
	 Qa1WLpwLCMvMfalx2TEiBwwLJjOWt3cK84Z25nXPbItI1fhH50lyWHpDPCi/FNAMlA
	 qo++NMe97K8ZEJvTsoxaoiMja6c2U5DpmqR0M4fE=
Date: Wed, 17 Dec 2025 16:04:25 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.17 000/506] 6.17.13-rc2 review
Message-ID: <2025121746-hardcopy-curry-5e02@gregkh>
References: <20251216111947.723989795@linuxfoundation.org>
 <CAG=yYwnv+EsEhOSUFFFGQYm6MXzDFzPKq=pp+wk2J5rvLupoQQ@mail.gmail.com>
 <CAG=yYwkuq=WCGMqYcuWh5eHuVY5rUFWRtbZKgcUb1Eg1GxgM3w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG=yYwkuq=WCGMqYcuWh5eHuVY5rUFWRtbZKgcUb1Eg1GxgM3w@mail.gmail.com>

On Wed, Dec 17, 2025 at 08:24:15PM +0530, Jeffrin Thalakkottoor wrote:
> On Wed, Dec 17, 2025 at 1:09 PM Jeffrin Thalakkottoor
> <jeffrin@rajagiritech.edu.in> wrote:
> >
> > hello
> >
> > Compiled and booted  6.17.13-rc2+
> >
> > dmesg shows error...  file attached
> >
> > As per dmidecode command.
> > Version: AMD Ryzen 3 3250U with Radeon Graphics
> >
> > Processor Information
> >         Socket Designation: FP5
> >         Type: Central Processor
> >         Family: Zen
> >         Manufacturer: Advanced Micro Devices, Inc.
> >         ID: 81 0F 81 00 FF FB 8B 17
> >         Signature: Family 23, Model 24, Stepping 1
> >
> > Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
> 
> i  have done a  git bisect  and the log is attached.
> THANKS
> 
> 
> -- 
> software engineer
> rajagiri school of engineering and technology

> git bisect start
> # status: waiting for both good and bad commits
> # bad: [f89c72a532b507111acfe1b83ff4855dc6772043] Linux 6.17.13-rc2
> git bisect bad f89c72a532b507111acfe1b83ff4855dc6772043
> # status: waiting for good commit(s), bad commit known
> # good: [6fedb515e7f90986da3de36a35752e6dc2e0c911] Linux 6.17.12
> git bisect good 6fedb515e7f90986da3de36a35752e6dc2e0c911
> # good: [6fedb515e7f90986da3de36a35752e6dc2e0c911] Linux 6.17.12
> git bisect good 6fedb515e7f90986da3de36a35752e6dc2e0c911
> # good: [bef2390379e56d44e5fed5400bba2f6c2486cd6c] tracefs: fix a leak in eventfs_create_events_dir()
> git bisect good bef2390379e56d44e5fed5400bba2f6c2486cd6c
> # good: [16be45fa274beefba34a25da3551276b9fb48382] vhost: Fix kthread worker cgroup failure handling
> git bisect good 16be45fa274beefba34a25da3551276b9fb48382
> # good: [3e619964439334c23c079ff3986fd62d94d8c842] NFS: Initialise verifiers for visible dentries in _nfs4_open_and_get_state
> git bisect good 3e619964439334c23c079ff3986fd62d94d8c842
> # good: [9786c2e58c42de159067fa3ae7a5b1e029bdcab1] rtc: gamecube: Check the return value of ioremap()
> git bisect good 9786c2e58c42de159067fa3ae7a5b1e029bdcab1
> # good: [96b48878043620b06e74f5e435f0caf16105db8d] scsi: imm: Fix use-after-free bug caused by unfinished delayed work
> git bisect good 96b48878043620b06e74f5e435f0caf16105db8d
> # good: [299f05075dfe002156bbc46ba7da2a89357fe94f] usb: phy: Initialize struct usb_phy list_head
> git bisect good 299f05075dfe002156bbc46ba7da2a89357fe94f
> # good: [0ecfb458bae89e7cc2ceca578405a014a7090c33] ALSA: hda/realtek: Add match for ASUS Xbox Ally projects
> git bisect good 0ecfb458bae89e7cc2ceca578405a014a7090c33
> # good: [25b1100cb9ff0dcbd7263ab57fcede673be0ecc4] ALSA: hda: cs35l41: Fix NULL pointer dereference in cs35l41_hda_read_acpi()
> git bisect good 25b1100cb9ff0dcbd7263ab57fcede673be0ecc4
> # good: [5f0bc5d1d892e7bd28dab743c9e8dce2b6596fbc] ALSA: wavefront: Fix integer overflow in sample size validation
> git bisect good 5f0bc5d1d892e7bd28dab743c9e8dce2b6596fbc
> # first bad commit: [f89c72a532b507111acfe1b83ff4855dc6772043] Linux 6.17.13-rc2

So the change that sets the makefile is the bad commit?  I don't think
the testing went correct for some reason :(


