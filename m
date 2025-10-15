Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8277311966;
	Wed, 15 Oct 2025 08:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760517729; cv=none; b=B/mWtmOkiTLIB7kL478p+CDI5hliXTw4I1QMn0T1dx9t68hijZvau3SD5FszslgNk3IMerW4jAojKXav+Htu4v3S4hjGz7CxwY9ErEQagVtIP1HsaQnCrU3ebab1SEKRT32BT0et+uR+B7Gcitg3j/JdAM5KBax/IN51WRFZbFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760517729; c=relaxed/simple;
	bh=fV/RBD9YP50aumeHVRIkO30zj7FKxJUNbhb9CN7QNxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WRSNy47KLUynzolPsK8+VBLNbbYTnLgdw1kh4JAfzrzBwKZYukQ5ruNbtvT0Jq/4B9/wIsNKibxCHt1OFq55fba1ZVwmN3hauZBRH7DQVmMe4EDOfJTlVYwPYBBK+VgnAIcEm04P/LHmC7Gf+MNgQyvCnjInW5QeVXy0XDZ+AqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qd4j6WAd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qd4j6WAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8286C4CEF8;
	Wed, 15 Oct 2025 08:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760517725;
	bh=fV/RBD9YP50aumeHVRIkO30zj7FKxJUNbhb9CN7QNxs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qd4j6WAdTQ6yNehh2rdErjKmkXKpaRAcpQD6NSZ1mhdFH4h90UkwQpl7RdznKemWq
	 znuTSasG67c4MTdTNUpN8Z9qavIOpR12av5QUAPz7QR1fGmCl9mVrP6ctURbpAZ54I
	 0ekR3tXbcxc3d3sbkF2G/y24RMi44LOOq7cT+z34=
Date: Wed, 15 Oct 2025 10:42:02 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6.1 000/196] 6.1.156-rc1 review
Message-ID: <2025101540-suffix-paralyses-41b7@gregkh>
References: <20251013144314.549284796@linuxfoundation.org>
 <4ad822af-297a-4de0-b676-6963760a8384@rnnvmail201.nvidia.com>
 <046f08cb-0610-48c9-af24-4804367df177@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <046f08cb-0610-48c9-af24-4804367df177@nvidia.com>

On Tue, Oct 14, 2025 at 02:11:33PM +0100, Jon Hunter wrote:
> Hi Greg,
> 
> On 14/10/2025 14:09, Jon Hunter wrote:
> > On Mon, 13 Oct 2025 16:42:53 +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.1.156 release.
> > > There are 196 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.156-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Failures detected for Tegra ...
> > 
> > Test results for stable-v6.1:
> >      10 builds:	10 pass, 0 fail
> >      28 boots:	28 pass, 0 fail
> >      119 tests:	118 pass, 1 fail
> > 
> > Linux version:	6.1.156-rc1-gb9f52894e35f
> > Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
> >                  tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
> >                  tegra194-p3509-0000+p3668-0000, tegra20-ventana,
> >                  tegra210-p2371-2180, tegra210-p3450-0000,
> >                  tegra30-cardhu-a04
> > 
> > Test failures:	tegra194-p2972-0000: boot.py
> 
> 
> A new kernel warning is observed for this update which is ...
> 
>  ERR KERN Early cacheinfo failed, ret = -22
> 
> Bisect is pointing to this commit ...
> 
> # first bad commit: [988121168f4a3211c7f5e561c24bb0bbe8504565]
> arch_topology: Build cacheinfo from primary CPU

Thanks for the info, I'll go drop this whole series from the tree now,
and report this to the submitter and cc: you on it.

greg k-h
