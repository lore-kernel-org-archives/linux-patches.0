Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61230155382;
	Wed, 18 Jun 2025 05:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750225333; cv=none; b=nJVKM9tmGOx4G6AwU+Ww3XvZwspLlcclsixz3ylI55z5VYbsJKXPKPrazzCnBpklb95/AzZWEbtlRrqQ7QfTLdAC63ldMMoUsRrT3gOsk/P3kGvyGqHeEr3+7xOXGzGYZu0tY4+AP5trmslIKJcb6tTUrwsZfvdcg0Ep1KDWlvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750225333; c=relaxed/simple;
	bh=OtuSUIPkuDfD+m/LFZSpCE5C0F4fUZi6lEJGSacNoEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VSVyQnDTNc9pElbr004VBJ9B5P5YQohH27K6QsvN2CI0n+obOuTUJCj70S+F/wZxevzcABdo9dYpmlyOKPLE11hL/Wbs9EeG6S9NFHiIooBdJLQPi4+EuiRaRfuNYTJL/7xLJKO7W34uZDPQpjgVkQpFbuQq9LGfiGDhASez4fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uq/SPm2q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uq/SPm2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69479C4CEE7;
	Wed, 18 Jun 2025 05:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750225332;
	bh=OtuSUIPkuDfD+m/LFZSpCE5C0F4fUZi6lEJGSacNoEU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uq/SPm2qjo+ZZi2ErBZ0be/ltUASToUVv/GOVUmbaJd1z5pIxao/j+QYwbO8zbADT
	 sI9xZAPee2wef6mHyWWImgJ6pkOLyclopmrKn1uc27Fqy5p/hkdCDL9sj7OMzQwHPu
	 /T1z262dWNLzeIBBn5zIB2Iz+8vYrybrzTrPmHzo=
Date: Wed, 18 Jun 2025 07:42:08 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ronald Warsow <rwarsow@gmx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
Message-ID: <2025061848-clinic-revered-e216@gregkh>
References: <20250617152451.485330293@linuxfoundation.org>
 <f2b87714-0ef6-4210-9b30-86b4c79d1ed8@gmx.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2b87714-0ef6-4210-9b30-86b4c79d1ed8@gmx.de>

On Tue, Jun 17, 2025 at 08:27:03PM +0200, Ronald Warsow wrote:
> Hi Greg
> 
> Kernel panic here on x86_64 (RKL, Intel 11th Gen. CPU)
> 
> all others kernels were okay. nothing was changed in my compile config.
> 
> Tested-by: Ronald Warsow <rwarsow@gmx.de>

Any chance you can use 'git bisect' to find the offending commit?

thanks,

greg k-h
