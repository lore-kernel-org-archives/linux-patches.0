Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3185A3E95B7;
	Thu,  5 Feb 2026 13:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770299980; cv=none; b=bML64U523T6n2u40S+i6MXPKsKmAMC8lHD+X5m4LUAb4K2JstflE4vpd1lHo5KzAIQnjqtX+ws6Ur+Qh+IVPODsc9k4OETiIneHK3AKhWyRy+vCN2HL7wWhk5QkqnyMXKeKKvU3PgnAhfAuftyRDwV+VpODtlGjeXftwWZkH8A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770299980; c=relaxed/simple;
	bh=ZoZxGJKEcr+rDLNuV6CwT7p+enyxHKL6Ly9DF2grNc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CgTug+H5Sx2emYaIOUfgkUQ7tNmiO9MESY1d+BmUKxGWjzgS3GKWvNrsLzvvvqU7ijZJoHzhBglZwIhiCCUFxYi6QtdQsrxOBvcdrVu6SUFwLwCxySaKkzqRSYDlymbKlihOSeVr7vgwjb0A5F8RoKZ5JrTXLETljLJ+ZYAl6uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z70YqVEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z70YqVEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20937C4CEF7;
	Thu,  5 Feb 2026 13:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770299979;
	bh=ZoZxGJKEcr+rDLNuV6CwT7p+enyxHKL6Ly9DF2grNc8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z70YqVEzFyvGxPzb/SrIN8T0K2SQdwf7T264WU3xGPw2j1Py0FXx4oBWS63XTlL62
	 g0SvDjwzrNMUe98Xqmpm1XTMENDzr7Eo3d1F6tx+zOFqy2KTwZl7ubAyIrnu+keF6J
	 4XAJGmgaqdyAlDmKxjYRFe15uTPPCpQavcURiTg8=
Date: Thu, 5 Feb 2026 14:59:36 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Schneider <pschneider1968@googlemail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/280] 6.1.162-rc1 review
Message-ID: <2026020520-trustee-implement-f17d@gregkh>
References: <20260204143909.614719725@linuxfoundation.org>
 <25910fd9-ecc8-4119-9abc-2ab6baf5ce77@googlemail.com>
 <2026020510-ember-darkroom-37f6@gregkh>
 <2026020526-frisbee-coauthor-8ca3@gregkh>
 <8bb7a822-2643-4511-9c14-c3bc2d1bfb07@googlemail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bb7a822-2643-4511-9c14-c3bc2d1bfb07@googlemail.com>

On Thu, Feb 05, 2026 at 01:35:37PM +0100, Peter Schneider wrote:
> Hi Greg,
> 
> Am 05.02.2026 um 09:33 schrieb Greg Kroah-Hartman:
> > On Thu, Feb 05, 2026 at 09:31:30AM +0100, Greg Kroah-Hartman wrote:
> > > On Wed, Feb 04, 2026 at 11:17:38PM +0100, Peter Schneider wrote:
> > > > Hi Greg,
> > > > 
> > > > Am 04.02.2026 um 15:36 schrieb Greg Kroah-Hartman:
> > > > > This is the start of the stable review cycle for the 6.1.162 release.
> > > > > There are 280 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > > 
> > > > > Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> > > > > Anything received after that time might be too late.
> > > > 
> > > > It seems that this time, I cannot even build this RC. When I run "make
> > > > menuconfig" I get a big serious of warning and error messages; something
> > > > seems to be really messed up here...
> > > > 
> > > > 
> > > > root@linus:/usr/src/linux-stable-rc# vim .config
> > > > root@linus:/usr/src/linux-stable-rc# make menuconfig
> > > > scripts/kconfig/Makefile:215: Warnung: Das Musterrezept hat das Peer-Ziel „scripts/kconfig/mconf-bin“ nicht aktualisiert.
> > > >    HOSTCC  scripts/kconfig/mconf.o
> > > >    HOSTCC  scripts/kconfig/lxdialog/checklist.o
> > > >    HOSTCC  scripts/kconfig/lxdialog/inputbox.o
> > > >    HOSTCC  scripts/kconfig/lxdialog/menubox.o
> > > >    HOSTCC  scripts/kconfig/lxdialog/textbox.o
> > > >    HOSTCC  scripts/kconfig/lxdialog/util.o
> > > >    HOSTCC  scripts/kconfig/lxdialog/yesno.o
> > > >    HOSTLD  scripts/kconfig/mconf
> > > > /usr/bin/ld: scripts/kconfig/lxdialog/yesno.o: warning: relocation against `acs_map' in read-only section `.text'
> > > > /usr/bin/ld: scripts/kconfig/mconf.o: in function `show_help':
> > > > mconf.c:(.text+0xa1b): undefined reference to `stdscr'
> > > > /usr/bin/ld: mconf.c:(.text+0xa20): undefined reference to `getmaxx'
> > > > /usr/bin/ld: scripts/kconfig/lxdialog/checklist.o: in function `print_arrows':
> > > > checklist.c:(.text+0x2c): undefined reference to `wmove'
> > > 
> > > <snip>
> > > 
> > > Ick, yes, I can reproduce this myself here, something is odd.  Let me
> > > track it down...
> > 
> > Ok, found the offending commit, will push out a -rc2 in a bit with this
> > fixed, thanks for testing!
> > 
> > greg k-h
> 
> I was too tired yesterday evening to investigate my build error and poke
> around deeper, but today I looked into it again, and I found that when I
> revert the two kconfig patches in this RC
> 
> 7c177eca9e7af1f0a56171b7718a1b05aaa0f237 "kconfig: fix static linking of nconf"
> eb5defa1e8284b8b79653beadc92c273c170db7d "kconfig: refactor Makefile to reduce process forks"
> 
> then my build error goes away, the build succeeds and the produced kernel seems to work fine.

Yes, those are the commits I dropped, thanks for verifying.

greg k-h
