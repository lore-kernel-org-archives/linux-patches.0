Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0451A72A
	for <patches@lists.linux.dev>; Fri, 12 Jan 2024 03:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="DlRS6rMC";
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="XPM/MIwE"
Received: by nautica.notk.org (Postfix, from userid 108)
	id 6992BC024; Fri, 12 Jan 2024 04:28:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1705030122; bh=sOf+lqfIzp8E71sKYf3rSI5oFCI5DnGWAw5lqIcnSvI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DlRS6rMC0VCc65tP+UxfLFUtv1ti5YOrnZQ+ylJlLJjXfQCo/j0xp3PhndVvXqqF4
	 18h+0VFmOcKMy+rJvFX3X6Af21GyPAWMCxxIBDBAQEWrHKMZFVquAdTB+pHZVBIzzW
	 eUifX75I8xWEi6Fy2lk8DCK1sTbCB/dcbbSSt1ACpncuJcyPKpADCakJqa7hUSoC6e
	 T/SRpoQITH/bWAfceYrXt6mzIyS4XLoaN53zfpVhN7rOqpTwqjFdjaelZoy/DQtit/
	 GVtFDTxi+kOx0MkZ3HXQ+CD95pIQLhZ0PqrDl8CaLLVqlWAEinMJUCn5i9mk2zf0nm
	 HGBK8AMfdYHqw==
X-Spam-Level: 
Received: from gaia (localhost [127.0.0.1])
	by nautica.notk.org (Postfix) with ESMTPS id 62DD6C01D;
	Fri, 12 Jan 2024 04:28:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1705030121; bh=sOf+lqfIzp8E71sKYf3rSI5oFCI5DnGWAw5lqIcnSvI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XPM/MIwEKjQNHY7040+XGrhxW/xxnC5pRGPQQHRVWOa8qmlvdJEoLuYF4y8aSQo26
	 Eanw9byvK6vn0ygMAktEw6o5+ejZ8B0H1v78hBiIHXMvlOuVci798iRAxpcQ0vOMQa
	 lEYoAMHbvxGAZkp04qXm5LYLnkLvCdS1la1kSAYIV7ik/lyspEcFtVcinXtyZMZhBX
	 9OwfiqFDCwdeVpITD+fTBX/7KjwGBb9nT9Qld0zYHu5jlOK067Fu1y1/2LN5DGLT/9
	 u3kU5+m2X+qGF2WcL0wAhk4U+fLnYdyZQpxeFgQflUhoIuwqzk0OsTgt26WjBeWG/i
	 fEbyU4SkF5+Nw==
Received: from localhost (gaia [local])
	by gaia (OpenSMTPD) with ESMTPA id f2592dda;
	Fri, 12 Jan 2024 03:28:33 +0000 (UTC)
Date: Fri, 12 Jan 2024 12:28:18 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.10 0/7] 5.10.207-rc1 review
Message-ID: <ZaCx0rLZHyBRsb1A@codewreck.org>
References: <20240111094700.222742213@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240111094700.222742213@linuxfoundation.org>

Greg Kroah-Hartman wrote on Thu, Jan 11, 2024 at 10:52:49AM +0100:
> This is the start of the stable review cycle for the 5.10.207 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 13 Jan 2024 09:46:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.207-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested 9d64f2ec9cf9 ("Linux 5.10.207-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>

-- 
Dominique Martinet | Asmadeus
