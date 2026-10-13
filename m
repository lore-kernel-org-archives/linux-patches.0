Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA1A4FDE56;
	Tue, 13 Oct 2026 12:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894572; cv=none; b=Q0NF6UzFWLK5MPSwxcoPCDsuZH5nh+63JXI6gNdN+m/r7Tti5QxQ1Qt5bVgNen5sRao4usEkvs5kN5Am9jetXoBAFUOpWWAI6CCu9+JW59CpbihCDJZlLx05CpNrp8ZXkVQIg8ONgm7isCclo6X+WRSJt9TpZFiukzQykIpH8uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894572; c=relaxed/simple;
	bh=ndtvuBl01aHrlG+8YUPnmC1kTMPPloL0I+ovbtGwwmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sMmxFOdz/Qxrrl3BFb3+2PbYpB5E4kyFjw1ykGKfA+6jVgTNbPKFyy/3ab6XMrr21DmNrsT4fRudrB1MTQHL54kRFzOeG10YnPIg2dFz1XP+Hc3EDVGRl6U1VI6uIa8ADjovwY7WXqATr2Oe4X+gX5HUVVoC9DCUfJpkIAM0NdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.210.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Date: Tue, 13 Oct 2026 12:29:12 +0000
From: Brett A C Sheffield <bacs@librecast.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/621] 6.18.57-rc1 review
Message-ID: <as4kGIjqjrKzu0O0@auntie.librecast.net>
References: <20261013112920.855194808@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>

On 2026-10-13 13:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.57 release.
> There are 621 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Oct 2026 11:28:22 +0000.
> Anything received after that time might be too late.

Build failing on amd64:

/usr/x86_64-pc-linux-gnu/binutils-bin/2.47/ld: vmlinux.o: in function `gss_krb5_get_mic_v2':
(.text+0xfc2762): undefined reference to `crypto_krb5_get_mic'
/usr/x86_64-pc-linux-gnu/binutils-bin/2.47/ld: vmlinux.o: in function `gss_krb5_verify_mic_v2':
(.text+0xfc293a): undefined reference to `crypto_krb5_verify_mic'
/usr/x86_64-pc-linux-gnu/binutils-bin/2.47/ld: vmlinux.o: in function `gss_krb5_aead_encrypt':
(.text+0xfc47a1): undefined reference to `crypto_krb5_encrypt'
/usr/x86_64-pc-linux-gnu/binutils-bin/2.47/ld: vmlinux.o: in function `gss_krb5_aead_decrypt':
(.text+0xfc48f8): undefined reference to `crypto_krb5_decrypt'
make[2]: *** [scripts/Makefile.vmlinux:72: vmlinux.unstripped] Error 1
make[1]: *** [/usr/src/linux-stable-rc/Makefile:1272: vmlinux] Error 2
make: *** [Makefile:248: __sub-make] Error 2


