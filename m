Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DAC1D89E3;
	Thu,  1 May 2025 07:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746085938; cv=none; b=NgSrYotWZDwQkADSmY0LRiLpWdO0D9mwtAz6tau+wlP8Qy5LBtmCKh5GCeBu2EaJJhNV+2qhJdUxzFS7mr71O1kq83lvD5RYdmcKesPSWpIxwXRlL7YUJhKchzisZXsowFWrgzyPkYMNrJ4riePQwUD0LtSPNoqAmyxJesjco0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746085938; c=relaxed/simple;
	bh=izlfaK1RNQxEYzP8Zd0NG4A9sGlEsEUuEPRhVTxZof4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jLqUtlYXTdWgpNOfWyTzVWVltyRxTwqi7jUoDyukAB8jpdY3Eb87Zj1aMxOZOKmiT7GqmhKTyp/1oyB+TMUa9uhoTieSSvwueilO3nUB0jWnjOSVFfSkvtOSb2zv3GShTPizIsWqOAT5Zil3XgbV6UK88IdClrc2gskAVNNHoaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XPAPcku4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XPAPcku4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81035C4CEE3;
	Thu,  1 May 2025 07:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746085938;
	bh=izlfaK1RNQxEYzP8Zd0NG4A9sGlEsEUuEPRhVTxZof4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XPAPcku4K99G3AWbOuL5gAw5Og8AZPeXtYEz1rZTNolwRbHFA8uNiE1WG8U3BNwuB
	 SM7rRHY/For/nWBNfaIiZlA+qWxQp3B7qUrKmxCxdZw2FYaVq7KnHW+4cztD1WaDec
	 osskfBBXmvaYYuxiJalPNCs1shvwvnm39mw0KG7s=
Date: Thu, 1 May 2025 09:52:15 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 000/167] 6.1.136-rc1 review
Message-ID: <2025050157-various-octane-094c@gregkh>
References: <20250429161051.743239894@linuxfoundation.org>
 <aBKrKvYpCKWcoOGI@finisterre.sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBKrKvYpCKWcoOGI@finisterre.sirena.org.uk>

On Thu, May 01, 2025 at 07:58:50AM +0900, Mark Brown wrote:
> On Tue, Apr 29, 2025 at 06:41:48PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.136 release.
> > There are 167 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> This breaks NFS boot on the Raspberry Pi 3+, the same issue appears in
> 5.15.  We don't appear to get any incoming traffic:
> 
>   Begin: Waiting up to 180 secs for any network device to become available ... done.
>   IP-Config: enxb827eb57f534 hardware address b8:27:eb:57:f5:34 mt[   16.127316] lan78xx 1-1.1.1:1.0 enxb827eb57f534: Link is Down
>   u 1500 DHCP
>   [   16.840932] brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
>   IP-Config: no response after 2 secs - giving up
>   IP-Config: enxb827eb57f534 hardware address b8:27:eb:57:f5:34 mtu 1500 DHCP
> 
> There was a similar issue in mainline last release, I can't remember the
> exact fix though.
> 
> A bisect identifies "net: phy: microchip: force IRQ polling mode for
> lan88xx" as the problematic commit.
> 
> # bad: [c77e7bf5aa741c165e37394b3adb82bcb3cd9918] Linux 5.15.181-rc1
> # good: [f7347f4005727f3155551c0550f4deb9c40b56c2] Linux 5.15.180
> git bisect start 'c77e7bf5aa741c165e37394b3adb82bcb3cd9918' 'f7347f4005727f3155551c0550f4deb9c40b56c2'
> # test job: [c77e7bf5aa741c165e37394b3adb82bcb3cd9918] https://lava.sirena.org.uk/scheduler/job/1340356
> # bad: [c77e7bf5aa741c165e37394b3adb82bcb3cd9918] Linux 5.15.181-rc1
> git bisect bad c77e7bf5aa741c165e37394b3adb82bcb3cd9918
> # test job: [9599afaa6d1a303c39918a477f76fe8cc9534115] https://lava.sirena.org.uk/scheduler/job/1340569
> # good: [9599afaa6d1a303c39918a477f76fe8cc9534115] KVM: arm64: Always start with clearing SVE flag on load
> git bisect good 9599afaa6d1a303c39918a477f76fe8cc9534115
> # test job: [714307f60a32bfc44a0767e9b0fc66a841d2b8f6] https://lava.sirena.org.uk/scheduler/job/1340691
> # good: [714307f60a32bfc44a0767e9b0fc66a841d2b8f6] kmsan: disable strscpy() optimization under KMSAN
> git bisect good 714307f60a32bfc44a0767e9b0fc66a841d2b8f6
> # test job: [db8fb490436bd100da815da4e775b51b01e42df2] https://lava.sirena.org.uk/scheduler/job/1341008
> # bad: [db8fb490436bd100da815da4e775b51b01e42df2] s390/sclp: Add check for get_zeroed_page()
> git bisect bad db8fb490436bd100da815da4e775b51b01e42df2
> # test job: [4757e8122001124752d7854bec726a61c60ae36a] https://lava.sirena.org.uk/scheduler/job/1341258
> # bad: [4757e8122001124752d7854bec726a61c60ae36a] USB: storage: quirk for ADATA Portable HDD CH94
> git bisect bad 4757e8122001124752d7854bec726a61c60ae36a
> # test job: [1f079f1c5fcf13295fc1b583268cc53c80492cfb] https://lava.sirena.org.uk/scheduler/job/1341360
> # good: [1f079f1c5fcf13295fc1b583268cc53c80492cfb] tipc: fix NULL pointer dereference in tipc_mon_reinit_self()
> git bisect good 1f079f1c5fcf13295fc1b583268cc53c80492cfb
> # test job: [cee5176a98accc550585680213f71d1d307a2e9a] https://lava.sirena.org.uk/scheduler/job/1341449
> # good: [cee5176a98accc550585680213f71d1d307a2e9a] virtio_console: fix missing byte order handling for cols and rows
> git bisect good cee5176a98accc550585680213f71d1d307a2e9a
> # test job: [5e9fff164f2e60ade9282ee30ad3293eb6312f0e] https://lava.sirena.org.uk/scheduler/job/1341692
> # bad: [5e9fff164f2e60ade9282ee30ad3293eb6312f0e] drm/amd/display: Fix gpu reset in multidisplay config
> git bisect bad 5e9fff164f2e60ade9282ee30ad3293eb6312f0e
> # test job: [ecc30d7f041daf7de7d0d554ebeeaec1a0870e53] https://lava.sirena.org.uk/scheduler/job/1341795
> # bad: [ecc30d7f041daf7de7d0d554ebeeaec1a0870e53] net: phy: microchip: force IRQ polling mode for lan88xx
> git bisect bad ecc30d7f041daf7de7d0d554ebeeaec1a0870e53
> # test job: [40dc7515d0b13057d576610a8dd23ccb42d4259f] https://lava.sirena.org.uk/scheduler/job/1341924
> # good: [40dc7515d0b13057d576610a8dd23ccb42d4259f] net: selftests: initialize TCP header and skb payload with zero
> git bisect good 40dc7515d0b13057d576610a8dd23ccb42d4259f
> # first bad commit: [ecc30d7f041daf7de7d0d554ebeeaec1a0870e53] net: phy: microchip: force IRQ polling mode for lan88xx

Thanks for the bisection, I'll go drop this from 5.15.y and 6.1.y now.

greg k-h
