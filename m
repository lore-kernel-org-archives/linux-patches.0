Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20BA10788;
	Sun, 16 Jun 2024 14:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718548120; cv=none; b=Ztj7PsCjOVgB5V5P8a68l4KmTd/s/J58S/PnMpzKKTmOtw/XSmRKp9LGV9tg7BjqUMylfceO7s8TlAzuDgcGc1Rmrhf6Mhwn46XsVcY9Ze6qSmGUIRHpgtQYVzggvFn40nT3yj6bYkie728dkZnf9rwIZpKiHaFO2z240KfYB/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718548120; c=relaxed/simple;
	bh=X/rvn4piIgG759CplA6igXzUX4KeiK/suYHmrsIcIPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gZgUv6kOKvd8om9m45S3NKqb1J5wIEv3yGiILgDGoo3sSqR3u57T6402MmAHbRsAmMGbC1NKF1jRtYqURO79wO4szAX1ihJw7vgqQs4x3xHOmAxNZYCcPe+1qioCf23RVbzU/VI7LNOkd3G3FN99j6JniK/Cd5FbZ4Za1TlVbDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2XPS74Yr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2XPS74Yr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5370C2BBFC;
	Sun, 16 Jun 2024 14:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718548119;
	bh=X/rvn4piIgG759CplA6igXzUX4KeiK/suYHmrsIcIPY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2XPS74YrLHxMe2Vikl2KOdAGJUOGj79OS2GrkfXo+/iISSUUPba8CIus+PxJY6dNM
	 rWJBOt4dMrJpwFjW8+y54+HhTmzwQ2CX8w04/fcianjTHGM10ZnDVdWSIxv/xW0VgI
	 +4pS7+3CHswyteoArUxdbIbpwN79gEwkAXpaTtuY=
Date: Sun, 16 Jun 2024 16:28:36 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.15 000/402] 5.15.161-rc1 review
Message-ID: <2024061620-snowfield-renovator-a9bd@gregkh>
References: <20240613113302.116811394@linuxfoundation.org>
 <866c06f9-7981-4f76-88c9-930068cb6c21@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <866c06f9-7981-4f76-88c9-930068cb6c21@gmail.com>

On Sun, Jun 16, 2024 at 01:56:17PM +0100, Florian Fainelli wrote:
> 
> 
> On 6/13/2024 12:29 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.161 release.
> > There are 402 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.161-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Same perf build failure as already reported by Harshit.

I dropped all perf changes from this tree for the release so all should
be good now.

thanks,

greg k-h
