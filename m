Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9B3615217E
	for <patches@lists.linux.dev>; Fri, 12 Apr 2024 22:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712960597; cv=none; b=A3DDklyhSTihZXRj1pDsVgDichT5kwVLQ4laEzgO7JoNo1hecxwWJVaNoqwvMZ/QVoe2SDE5tdG/UgRdKnvuMx3xGd8vjyjuCzPehMYfrO/jV7edULQxKAna4zfZWaaSnG+cE7TojVKJnMXQgkQ3iCNTrBABEczq9r+yJ3+2suQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712960597; c=relaxed/simple;
	bh=4n1OXyfwu13le8UPrPwMIF139vUUr4+8aA60tri9Gns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CyMas41E8vY9uCj6RyABarNQre38rbA4jtwu2PW8Wv6rhzzeQyIAUjhYeHBUGFOM8yTgggbETtXaBxWatCQDOM45QF5MSvZswWFq3HBtpl3fQdrOwor38hy8+5Z36m5WZrAr7LtU9g9fGfietL3pJvcArXH50DcC3iMCy7aYE3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=WLNvcdlB; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="WLNvcdlB"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 5DC8F20EBE36; Fri, 12 Apr 2024 15:23:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5DC8F20EBE36
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1712960596;
	bh=+/20JeuZRqfr3ZIBdIbjmwL6Kf3bvTqGpXKebuStbNo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WLNvcdlBh7sqS3aTUUYGtIqpdQBJ4pedZMD++VEzbWcg22KPXD/IMJR/ayW5yNfs5
	 UALpFei0TfvHe8PTPBDxRoepfXTQMjA5YMC/pE/s+/01HdylwhI05c9moPVcxuSLRd
	 egAsnAUlRbwLSnQ751cCKggrkSYuqvftnhLn8rq4=
Date: Fri, 12 Apr 2024 15:23:16 -0700
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/83] 6.1.86-rc1 review
Message-ID: <20240412222316.GB6610@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240411095412.671665933@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Thu, Apr 11, 2024 at 11:56:32AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.86 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> Anything received after that time might be too late.

No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you. :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
