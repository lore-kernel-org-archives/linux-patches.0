Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9462F3E;
	Thu, 10 Jul 2025 04:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752122649; cv=none; b=QBoEz8igAX5wpriJKi7hSj6+7jpzjCf/VbsVepVbrHG4IKwrjbp24TqedmDi+CX9ma5t9wlKiRhg7keaEQRnEk6nWDWTQLJdqRKX4ivAKR1YDzGP461CqM/1Fi09dnJJepspTaYAHQhVGiCRhOBhYPeEZgvslRWboo6dcp46oNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752122649; c=relaxed/simple;
	bh=TYbbqqLjQwYroRgBxpSuJ3dRjNYqWP2lP7EfVvjLEr8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dr4gOUjQw6uAtItMbgqoIs2CaPN+IOVP8z7uLNBTd4nWCNopAPiBvjHSOBV/2Bw9ApoK/feJytlGXo2TLNe7axkyRseC/O8AWjcCd0SpfzvbwIcm3e3n8xmmrqNLSa/SzXsEfcdP9YYCp+Gepy7x+BV1riInRbsRZnX78uOLIwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M9MAz4a0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M9MAz4a0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB0FC4CEE3;
	Thu, 10 Jul 2025 04:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752122648;
	bh=TYbbqqLjQwYroRgBxpSuJ3dRjNYqWP2lP7EfVvjLEr8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M9MAz4a0zM/qE2II6Jl+FTmPbxdevUZgbmiU0j8vCB/8BqzMLl9LOIRudvuun5Bkg
	 GZlJpoZSZ5Bvc3uj6bV3inD2dYcUYdHgwyTjYzK6MMyTmyNXsthjVXilgFAEIf8dEl
	 NkPb4pYIkATADDtWgFGkki9IPJebaQpcv7z5nqLw=
Date: Thu, 10 Jul 2025 06:44:05 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexandru Stan <ams@frame.work>
Cc: Christian Heusel <christian@heusel.eu>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, linux@frame.work
Subject: Re: [PATCH 6.15 000/178] 6.15.6-rc1 review
Message-ID: <2025071046-wipe-viewing-4a9d@gregkh>
References: <20250708162236.549307806@linuxfoundation.org>
 <75a83214-9cc4-4420-9c0c-69d1e871ceff@heusel.eu>
 <2025070909-outmatch-malt-f9b7@gregkh>
 <CAORQ5J5my3cd-nb=6wJ68s8wJ5BPi+JSu1Mo7JdHiLTD+XnB6Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAORQ5J5my3cd-nb=6wJ68s8wJ5BPi+JSu1Mo7JdHiLTD+XnB6Q@mail.gmail.com>

On Wed, Jul 09, 2025 at 02:29:31PM -0700, Alexandru Stan wrote:
> Hey Greg,
> 
> On Wed, Jul 9, 2025 at 10:20 AM Christian Heusel <christian@heusel.eu> wrote:
> > on the Framework Desktop I'm getting a new regression / error message
> > within dmesg on 6.15.6-rc1 which was not present in previous versions of
> > the stable kernel series:
> 
> I debugged with Christian a little bit, turns out that particular
> device ("arch-external") had a PD/UCSI firmware bug (which we have
> fixed since). Perhaps the new kernel just exposed some more of the
> broken firmware behavior. It does not reproduce with newer firmware.
> I think we can safely ignore it for now.

Wonderful, thanks for the update and glad it's fixed.

greg k-h
