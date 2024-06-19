Received: from submarine.notk.org (62-210-214-84.rev.poneytelecom.eu [62.210.214.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 913C8224D4
	for <patches@lists.linux.dev>; Wed, 19 Jun 2024 09:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718787923; cv=none; b=rPWwqCJiv33wiRJm3Sb6nT/yyJLiE+Xz8gutElvcrwvTMweSM1Vh2uMX4iy8fBKrAX2S+TwOssXvnnrEZK+kgAvPRWL++Ryho2RGBvDMJaGiXMKSe6ktpWunCd4RTyNhvWclpYKnb6cSExZnXEd0uOerKsEcH7Z9WYH0K0O2KbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718787923; c=relaxed/simple;
	bh=7cuqbtTO2T0xC2U3DuHtcBcLZQ67OxZjdSsIQFlgjkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ePuOYf5eeVntmwY38/E92Mb6A3xqsPl0Z242sfCZ9E38E3Qgg2cdKM4aDW69GJ86jHpjtalwcvyvSY4mFA1fsTPNKeAV6bWL6ZLh6IuwRt3uGXa5a7V/ZYWloQYf4Zl2XjZE0etZXE7iRmzxT+jWwLrTMvUSZLi1GpSUPzgn6sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=RzS3pVpY; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="RzS3pVpY"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id D708114C1E1;
	Wed, 19 Jun 2024 11:05:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1718787912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=le7+/07s5UJcLTEq6XBfMrFrXj/eObiEjeEWlhza6BU=;
	b=RzS3pVpYJ25rJpX7bJttqkAKIYoA0djgl5FhrbdhJhkKB7vBdmW+J/TYY7YvrLlMq/XM5F
	TcORMS9cYRgmpfHjevaVi05BWuHrAWVsLnV7RV0mSP+A6TTgytrk3APcdiOnAFzq2m0YCN
	6u3vZFBhpSJL94TjxcZhftP1SlSdKoKxQfv+D6e1h3Ayi8T8HyB0vwF3ry3fr4Qx+QyAVj
	xGCD+0rmTo/D1MNSL2LIn0QmEF0cJxOf5OyuNeF6ShwP9fOfyEnguW6s8ngSHQ5mgu8kB/
	eEd3oFHlaOxMGBDexFd2/VJMsT4s4yef/2jrJlmWKrbphJgIAkRlOrK2vlWK5w==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 8da32b40;
	Wed, 19 Jun 2024 09:05:01 +0000 (UTC)
Date: Wed, 19 Jun 2024 18:04:46 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/770] 5.10.220-rc1 review
Message-ID: <ZnKfLl8cdQR2iVK8@codewreck.org>
References: <20240618123407.280171066@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>

Greg Kroah-Hartman wrote on Tue, Jun 18, 2024 at 02:27:33PM +0200:
> This is the start of the stable review cycle for the 5.10.220 release.
> There are 770 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Jun 2024 12:32:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.220-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

(that's a lot of NFS/FS patches... I normally don't test NFS, but given
the content of this cycle I tested very basic client/server code by
exporting something mounting it and reading/writing to a file, so at
least it's not exploding immediately)


Tested 7927147b02fc ("Linux 5.10.220-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>

-- 
Dominique Martinet | Asmadeus
