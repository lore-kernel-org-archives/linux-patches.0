Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BA7171668;
	Tue, 25 Jun 2024 15:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719327853; cv=none; b=VO/n4UG6X7I64IbaLd0Zba9ykmkaoBpbx1Q8E372+kk0QHkDHG1xWtCjDA/Q+ve65VU/mP+G/cSBdxLJTP5C48+El9IEY7JRSwHyN71D7Wzpo4gVuVl0sDkTDr7k+Sdkf2OC4wsEKYuQPRMmwhAlOfKHemUj0o48wzw/UA+vVIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719327853; c=relaxed/simple;
	bh=JCvd4rZMOaaN102kR77kI64aSz22B2UiXs5usMz1fmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cpKzEXBDKlHGSBlHalmXbcJZBT1uvbMmfncchHT49CCJriKup+iu0BmvZ+RQirZqphSJ2nn+SIwiSZSehrUctdxZ5P+ldJ2DOnGLGFGoOlj8DdN7BKTrpMeq//ZQeel8HaDWhr8+4WTavofRxgvXtZAu2GLpVogiHtsR5hB8FkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EC7JKyaV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EC7JKyaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECECC32781;
	Tue, 25 Jun 2024 15:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719327852;
	bh=JCvd4rZMOaaN102kR77kI64aSz22B2UiXs5usMz1fmM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EC7JKyaV6zPO+6SOr+lxepS4w7pdtnBhuh4K7zl3YEa3Ni+Tbyu5JPN8BWCvf0CGg
	 lCFDESG71WlabGvggULEKmMZl0tjSRejyMg0WquPCyn+BfwMGYggClqLLE0D4gqTTJ
	 tyzMDr8xxE8DU8vH6R/PWy/HToCQTFhmN94XIHZI=
Date: Tue, 25 Jun 2024 17:04:10 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>, chuck.lever@oracle.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/770] 5.10.220-rc1 review
Message-ID: <2024062543-magnifier-licking-ab9e@gregkh>
References: <20240618123407.280171066@linuxfoundation.org>
 <e8c38e1c-1f9a-47e2-bdf5-55a5c6a4d4ec@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8c38e1c-1f9a-47e2-bdf5-55a5c6a4d4ec@roeck-us.net>

On Tue, Jun 25, 2024 at 07:48:00AM -0700, Guenter Roeck wrote:
> On 6/18/24 05:27, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.220 release.
> > There are 770 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 20 Jun 2024 12:32:00 +0000.
> > Anything received after that time might be too late.
> > 
> 
> [ ... ]
> > Chuck Lever <chuck.lever@oracle.com>
> >      SUNRPC: Prepare for xdr_stream-style decoding on the server-side
> > 
> The ChromeOS patches robot reports a number of fixes for the patches
> applied in 5.5.220. This is one example, later fixed with commit
> 90bfc37b5ab9 ("SUNRPC: Fix svcxdr_init_decode's end-of-buffer
> calculation"), but there are more. Are those fixes going to be
> applied in a subsequent release of v5.10.y, was there a reason to
> not include them, or did they get lost ?

I saw this as well, but when I tried to apply a few, they didn't, so I
was guessing that Chuck had merged them together into the series.

I'll defer to Chuck on this, this release was all his :)

thanks,

greg k-h
