Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97A74242D84
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 06:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761632397; cv=none; b=aMO2l9PI8aV77tZ8Hv7NwEKusTjDTwiDpEMLY3bX9zTTVJRP3cVpsqq7LvukNZDmDuS0BS2EbL9QfZ4CIg98GsWN+Q6JvRmmhAKUvL5krgLqrzlPpEl3LYsyh2mxs37KLsdveQXM6yUGB9YL+3SPJqoKZjH16ydZLsR7hxmvbYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761632397; c=relaxed/simple;
	bh=DejdsmKsN0NFzRiBVCKoCr5a9sYfbptrXHTM+90BBHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D0Cg2XQq5wb5jHkx7CecFQC8/VDp3a4Y3ujvCr83g5xftzDkIqKo6SxNq7ZjKIjo82Z1A5wPKMCeIu/SzQm8p7yuhd/UJvB72xZ+4eECMl6zOVWhtiuwK9+HMeFokZC2IVwz8A7zNmWhHQX7TP60qPLSOo08kSikd+FoSQyvKuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=ITMEezh1; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="ITMEezh1"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id A6C1D14C2D3;
	Tue, 28 Oct 2025 07:19:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1761632386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mKzEgtDaLyRpFkXDixp5H/HD9goN8KMnXI0K1GofB8Y=;
	b=ITMEezh1FHKcNwh1o1Tkws4ZtphlBVxbljTkKannojiScyP0/9PClgKEDEEbnkuocTgzVW
	nBYiRCOERInE0bCM259+gKBU6PpE9ZzhNuh7G4+ZrSChH6BDTx+LOKUt8ZX+0VOWlMsWIx
	iqHonQ2hWTIuClBeQ/cKQiYQZYkaNrmMADybVwHcF0oxSoP7Ak68LonWKinZMQm/k/wCXL
	zChE9DNYT9vTteFe0mYexD3v9gpcAJUlX97gs9UnKPvCeUi8wpDPe/ASzb/msz5hN+hb7o
	Q0vwZT3piMYFNhIGOmesJ4PPtRbV8+7KkxOttBIvXshECNVDjwsC+u72BG5d7g==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id b76f4c67;
	Tue, 28 Oct 2025 06:19:38 +0000 (UTC)
Date: Tue, 28 Oct 2025 15:19:23 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.10 000/332] 5.10.246-rc1 review
Message-ID: <aQBgay-bX7MmMRbc@codewreck.org>
References: <20251027183524.611456697@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>

Greg Kroah-Hartman wrote on Mon, Oct 27, 2025 at 07:30:53PM +0100:
> This is the start of the stable review cycle for the 5.10.246 release.
> There are 332 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.246-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested 65dbbe3ff059 ("Linux 5.10.246-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
