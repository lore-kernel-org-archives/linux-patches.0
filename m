Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E909729BDA3;
	Tue, 30 Dec 2025 12:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767096778; cv=none; b=MlgGvjzc6iAGX2YxRF3yGIJl/ULCGVVRpxQIqRMn/DQpXJRQ3fu+C16J983btdBpAIfrdKiLCRNrBZacCiS//6QjZFqPPL4Wg6wDBGkaW3U9xUoJsAXGYSwqr6/eEKZShASsFS1sdVK/Ocw0PsKeCwmA9pnGFwZySRcchuPyQME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767096778; c=relaxed/simple;
	bh=k3UX69wt7RZ+rwSI5mPa92pi9xvEH52PQ/iXLndCN7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mu9eNIrGeRzLQgSCSEh8k94Z6T/JyFOxrKiQjr9giahWSYU8EVOQvLl66OY5ZLTuy0Z3KhdxQfaJGLI0eIDSUk8MszH8y/N/V2DUK4GaYhw6+uTjOUCmLS+rt5aNEwokqXvo7FO2aol4KT98CKPsw7O/DbJwayPXOj++wO5Vc2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RgSq5MyM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RgSq5MyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B4FC4CEFB;
	Tue, 30 Dec 2025 12:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767096777;
	bh=k3UX69wt7RZ+rwSI5mPa92pi9xvEH52PQ/iXLndCN7s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RgSq5MyM2qte8hP6wfOiJbXNNVu4TSIIPrHvPtUUywmo3ygJFMAG8NZCogc3NhcQB
	 8PRXVHlMAsL3N7r4KkItAudKgPoff0L6kn4D6AC/a4IXPrGjU60UCNDmfdTSHRj1OD
	 r8L1R2PHx3kFG4YR6TjL4salpBDswOtxUBBUjbK8=
Date: Tue, 30 Dec 2025 13:12:54 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/430] 6.18.3-rc1 review
Message-ID: <2025123013-smilingly-vixen-783f@gregkh>
References: <20251229160724.139406961@linuxfoundation.org>
 <6acaaac9-f7bd-4696-859f-c0d491a0ea14@t-8ch.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6acaaac9-f7bd-4696-859f-c0d491a0ea14@t-8ch.de>

On Tue, Dec 30, 2025 at 12:58:08PM +0100, Thomas Weißschuh wrote:
> Hi Greg,
> 
> On 2025-12-29 17:06:42+0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.18.3 release.
> > There are 430 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 31 Dec 2025 16:06:10 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.3-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> > and the diffstat can be found below.
> 
> I am missing commit 4dbf066d965c ("leds: leds-cros_ec: Skip LEDs without
> color components"). This commit is in Linus' tree, has a stable tag and
> also I requested it's backport in [0].
> 
> Did I mess up or did it fall through the cracks?
> Any chance to get it included in the next batch of stable releases?

It's still pending, I have 200+ patches left to go through.  The big
-rc1 merge combined with the holidays caused the backup, sorry.
Hopefully will dig out from that during the beginning of January.

thanks,

greg k-h
