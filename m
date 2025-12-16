Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670D334D3A0;
	Tue, 16 Dec 2025 12:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888743; cv=none; b=bHRru1JhstkKY9p4SyMbFs49aHqePUGvIghnpWGovnFfF/ZkU3O4HV1dLqE3cGwuHL0cWNq1g4ZpS2qANY47f0ljkCljGB7hanNmCzSgsn+BFqbbLgae66N3qeXX41wKuZezwCMPAILUb065yH96PC1mjcqayvkhvoVCf4EAtvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888743; c=relaxed/simple;
	bh=4v8J+MsXAvzInMD17ouUz84hTnO8xCWYFLR/SD473+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aqRlSz+MJIsiEF4OCc3w3O72Tv8IvkSTgCgvT2tx0zAOcZXI6+9lsKgi/8EYE9VY9hMHHppwG3nTn3NCe/mU+XceZC4jA6ExKkn6hGYAMoygI5GjHCzKof7nKwnG6BEjMtixO9f4bButWajbAz8EKZGVpJPKHGWpYjD67Er9uWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VbfrHo8O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VbfrHo8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5F3C4CEF1;
	Tue, 16 Dec 2025 12:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888743;
	bh=4v8J+MsXAvzInMD17ouUz84hTnO8xCWYFLR/SD473+A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VbfrHo8O9c2Is0Xj4zr8SOc653uNpOepPiEELhYdPjXy5y7I1DrGS5BI9Gmbna0/I
	 e1Hj/eh9t2/LXQT6y7dz8hA23sevLBEO4RHKSXRmWrHEaft/T5oXbD/v5gLNRp2c7w
	 BKUpDy1wAbyeY+vUSMay+5Pww0NfBFlB5NVnrbdI=
Date: Tue, 16 Dec 2025 13:17:48 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Brett A C Sheffield <bacs@librecast.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.17 000/507] 6.17.13-rc1 review
Message-ID: <2025121634-lurk-angular-5d99@gregkh>
References: <20251216111345.522190956@linuxfoundation.org>
 <aUFMIK_av7G3aKui@auntie>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUFMIK_av7G3aKui@auntie>

On Tue, Dec 16, 2025 at 12:10:08PM +0000, Brett A C Sheffield wrote:
> On 2025-12-16 12:07, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.17.13 release.
> > There are 507 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 18 Dec 2025 11:12:22 +0000.
> > Anything received after that time might be too late.
> 
> git has 6.17.13-rc2 not rc1 ?

Yes, -rc2 is now out, I forgot to drop a patch for -rc1.

thanks,

greg k-h
