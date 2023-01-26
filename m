Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7009A1FAC
	for <patches@lists.linux.dev>; Thu, 26 Jan 2023 08:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83998C4339B;
	Thu, 26 Jan 2023 08:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674723409;
	bh=kJ7nQE5ExMaBGeClvMRs34aIi0GSqcAjrdfop9Obtc8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oNqEt78qw/qcdF8Qt906SQsuWsHl7f5XSGeNsQlsc9HP1HxEFv5uH2VTWnoR1uskS
	 dErZsHGUvdyCz5xdTWie73JkTNhnX1l06I05VJwi9Krwni/0ikmBsIznL6eXu+baJ1
	 6pieRgG0PCEqGyXGcXpLdfxtPHrPDDm0YE/TNHig=
Date: Thu, 26 Jan 2023 09:56:46 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/37] 4.19.271-rc1 review
Message-ID: <Y9JATg2I/lpTbZkx@kroah.com>
References: <20230122150219.557984692@linuxfoundation.org>
 <Y8/YOf8ewgbqOd4o@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8/YOf8ewgbqOd4o@duo.ucw.cz>

On Tue, Jan 24, 2023 at 02:08:09PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.271 release.
> > There are 37 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> This one makes sense for 5.10, but we don't have followup patches in
> 4.19, so we don't need this:
> 
> > Mathias Nyman <mathias.nyman@linux.intel.com>
> >     xhci: Add a flag to disable USB3 lpm on a xhci root port level.

Probably, care to send a revert?

> Plus, we have patch in 5.10 which we probably need in 4.19/4.14:
> 
> |0c7428f0d 8ccc99 o: 5.10| net/ulp: use consistent error code when  blocking ULP

I do not know what this means, please provide a working sha1 and submit
it for inclusion normally.

thanks,

greg k-h
