Received: from submarine.notk.org (62-210-214-84.rev.poneytelecom.eu [62.210.214.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EFBD2C9A
	for <patches@lists.linux.dev>; Fri, 24 May 2024 00:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716512189; cv=none; b=eDg34FdlBcl4DnAn46b5TWeEBfpA5CEs8JlvLC3OsffTSh03t7kj0e4cKBWAudzBlfCvKaCxDGrhKil3LIg+35WS+9IycHLOeZ38QpTw4ur0VA2G0yGDzViRGSZuoZ6eWg+XCCEcU6iEKEtzIHDTFfFaZEjoKM8yIzWYRZV7U2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716512189; c=relaxed/simple;
	bh=5F1z1Woqll497cd46zyP+J5EAcA55tR8OXSbU/KNAac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yty1JAEthQPMp+Czy9B2aYpUyH41imBZlTbZWg3Rn1BYJ4Szu2GE/sZ14j/Gb5UNxrPni8E8dUN5vR22T/xFqd4P9YK+3n4hYPOnYsp3A6rlaaaDHuRpzVS955RUajwqFuikydD2egCJztdeXMswXMxWiZl98pfOKgUUdy4s21Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=b63FHAbG; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="b63FHAbG"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 4875B14C2DB;
	Fri, 24 May 2024 02:56:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1716512183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=10Rzt42s+HPACNX7hQ0Sh+1c1eQ91GOfo9jACwkRnOA=;
	b=b63FHAbGiS5pCrH8hcTwp0IyhAL3RM6UxNRm5LyOPkpaZ7+6TBjip82FKAnZZPDCvyWvtW
	ZSflcHDFZFPPv33AmFPdQe8rebTJnJNXUsOxCu0dpk+B7BBsIT6NUeGTcI48enDoOIrOoc
	EH2NhZjP0jkpmP7HzXgawVumenld1Z4FKcjfyHBnnVzBOQj8OfL8kZ0cord+NauvP2Qd3p
	iNJp6SqUoG58yTIDy9pOBfYL9d6aYRM8EonBqKY8yD56EyATI+1gaAcu/1/C5UxEwKAYkR
	JnPcVdNjrqW3s6ysz6pUZvlDwJrYY7Hn2lCm5jxg36n9K/wNInDJx83EiT13WQ==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 2d469f13;
	Fri, 24 May 2024 00:56:14 +0000 (UTC)
Date: Fri, 24 May 2024 09:55:59 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 00/15] 5.10.218-rc1 review
Message-ID: <Zk_lnyn3IAmRtP2X@codewreck.org>
References: <20240523130326.451548488@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240523130326.451548488@linuxfoundation.org>

Greg Kroah-Hartman wrote on Thu, May 23, 2024 at 03:12:42PM +0200:
> This is the start of the stable review cycle for the 5.10.218 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.218-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested bc8c5267b8b7 ("Linux 5.10.218-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>

--
Dominique Martinet | Asmadeus
