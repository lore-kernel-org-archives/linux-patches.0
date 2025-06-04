Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CC42472B4;
	Wed,  4 Jun 2025 08:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749024547; cv=none; b=pl4yBt2dHUqcDPG9a+786Ch8XySUsjWYAJjglmRzw5knKu2Rx/x8cHmM0aOQsbk+lKfcxoOlusNEZvOHp3XYCF1zBCyTE8vijD8r2Rn3PaO8rzzeXzRatmAnbJqVOCI1z69ujAIclKR9E2w+1AU7jeqZpSL8RTk+asMrMnCrUwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749024547; c=relaxed/simple;
	bh=qGh3pbRgNAKZP7UMu01RjTepLuZCO7P3GANf1dJsyps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KWyLySFtPr1ivQyUCQkXPwBPYFOISU5mjwzNMGQtT8vtVj34I7KnQLzpA8tacyRjc4nbK9EfMbVYr8UtutPbCDiIsERJUpIBv6OeqI6aOOeuS64i9iHgG3zimVNQl/uFMGgfxmQCgaPjLT5V4HihFes1gIwTDo10lOyfi5PZpGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lyKhvucs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lyKhvucs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E2FC4CEE7;
	Wed,  4 Jun 2025 08:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749024547;
	bh=qGh3pbRgNAKZP7UMu01RjTepLuZCO7P3GANf1dJsyps=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lyKhvucsVcbKTD31bZWi0XENE30zi2V8cMD2MFdZB2yzTf3JthNAuz1SQ328CrG7R
	 3U82UguPTil1PRFxblteWUzXsrOZyO8dyVtrz2q/rZWYemDVCUkBMRAHDJme8nVWIb
	 0oErXV9xLbAc5SNqOo9ghCJ43pZHo8RS5f7ow4bs=
Date: Wed, 4 Jun 2025 10:09:04 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.10 000/270] 5.10.238-rc1 review
Message-ID: <2025060406-dial-boxlike-7e57@gregkh>
References: <20250602134307.195171844@linuxfoundation.org>
 <6dd7aac1-4ca1-46c5-8a07-22a4851a9b34@sirena.org.uk>
 <2025060302-reflected-tarot-acfc@gregkh>
 <4ba58b4c-414d-480b-b02b-c1724f6761f9@sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ba58b4c-414d-480b-b02b-c1724f6761f9@sirena.org.uk>

On Tue, Jun 03, 2025 at 11:46:06AM +0100, Mark Brown wrote:
> On Tue, Jun 03, 2025 at 12:06:34PM +0200, Greg Kroah-Hartman wrote:
> > On Tue, Jun 03, 2025 at 10:45:34AM +0100, Mark Brown wrote:
> 
> > > This fails to boot with a NFS root on Raspberry Pi 3b+, due to
> > > 558a48d4fabd70213117ec20f476adff48f72365 ("net: phy: microchip: force
> > > IRQ polling mode for lan88xx") as was also a problem for other stables.
> 
> > Odd, I see it in the 5.15.y released tree, so did we get a fix for it
> > with a different commit or should it just be dropped entirely from the
> > 5.10.y queue?
> 
> There's a revert in the v5.15 tree as 2edc296e2107a003e383f87cdc7e29bddcb6b17e,
> IIRC it went it while I was on holiday so I didn't test the release it
> went into.

Ah, that makes sense.  All now dropped, thanks for warning me.

greg k-h
