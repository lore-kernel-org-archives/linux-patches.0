Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCF0D25E828
	for <patches@lists.linux.dev>; Mon,  7 Jul 2025 09:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751878993; cv=none; b=XIvn5IbBPJEpnVLg1Hp8s5SSI9QKfGyrDp6qi8k3X6C8TnGfkZGoo742emcXh8MxYD2nPYyrbN0XD0mInIAnp9ydDh5pSIIU/dmEBsqlvzvRwUn6FPplCgy9LDTd+Mi9y9l0aIaa21oJURSOQYS8gnFVGxzbS2U8Lb3QYtBjNeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751878993; c=relaxed/simple;
	bh=JoUNvgk0Indgh9IQjsCN1n80NHUme0ZNNFbwUw6oGJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AMNIjNzCbuRAFItQSsAExaTEv0tfJe0Sp8QtPOrbtdLtXsKttSlvTzhaZvCSLB1aUZ6/etpDd5jeqPDREAd8Trsx8W8/Yt2oNIo6TrkFZTQPsV0tJKpOm4dFtak2jAnUTZgmDoWfyUUisPJylO2xnFAduTNFwrXv1FpLOC0q5+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6EC8A168F;
	Mon,  7 Jul 2025 02:02:58 -0700 (PDT)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A8E2B3F694;
	Mon,  7 Jul 2025 02:03:10 -0700 (PDT)
Date: Mon, 7 Jul 2025 10:03:08 +0100
From: Leo Yan <leo.yan@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	James Clark <james.clark@linaro.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Anders Roxell <anders.roxell@linaro.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 6.6 000/139] 6.6.96-rc1 review
Message-ID: <20250707090308.GA2182465@e132581.arm.com>
References: <20250703143941.182414597@linuxfoundation.org>
 <CA+G9fYu=JdHJdZo0aO+kK-TBNMv3dy-cLyO7KF4RMB20KyDuAg@mail.gmail.com>
 <CA+G9fYv4UUmNpoJ77q7F5K20XGiNcO+ZfOzYNLQ=h7S3uTEc8g@mail.gmail.com>
 <2025070605-stuffy-pointy-fd64@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025070605-stuffy-pointy-fd64@gregkh>

On Sun, Jul 06, 2025 at 08:55:32AM +0200, Greg Kroah-Hartman wrote:

[...]

> > Bisection results pointing to,
> > 
> >     coresight: Only check bottom two claim bits
> >      [ Upstream commit a4e65842e1142aa18ef36113fbd81d614eaefe5a ]
> > 
> > The following patch needs to be back ported ?
> >    b36e78b216e6 ("ARM: 9354/1: ptrace: Use bitfield helpers")
> 
> Thanks, that makes sense, and is easier than me fixing this up by hand
> like I had tried to in one of the branches :)
> 
> Now queued up.

I built for the Arm target in my local environment and confirmed that
the build failure has been fixed on the linux-6.6.y branch.

Thanks for reporting and resolving the issue.

Leo
