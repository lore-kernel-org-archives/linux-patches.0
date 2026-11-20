Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.194.8.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795170725;
	b=jWsEKSsDD4cdqLzSroNLeBA+902a+nb7cwV/Xi1S8xfbUc49FhwtEfh27+0W7/tDRmH/
	 jMnYGwUcDaMxmSPm6PW57fulQpgHb7xMTeY4FI9B6kGiEFW+yt0dzjcxYvPxEWt3LK2O1
	 JDn3tpIiRHj6Z8xspG+c3SmLDquP2EhsvycNCpEt5WFxF2fFI3qFOCai/ii4WT9WgsFpx
	 AynXYA03Kuz8XM746x/RXbYnrx2tNw1mZFKup390ueIfVErzZlgZQbaneLfEkFnO23A7v
	 FviCqyEBUJoOwkG9pkSBXkhjYmvHFNDx73eM23wJEwYkKLFlx0QshodBsdGlp5OhJWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795170725;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=1LPDA2fCPhySycfbvn9IXhVWQeuIzUpOeftXOxOm5Bw=;
	b=XWm42S0gou0NMQFcI868VS/zs4OF7j4aY9RkptiRqV9uJVaCQfkloX+aTMBNplE5Jbjv
	 NhPgznI5A6Fbngy09BqqW2tIQAW2lHWKWpHW+Hq0BkqqE012mg4dBMBOm0UwvN+qG59J8
	 cD9K4ocLYtfvjAqFx90unnkWLLxEg4pVPblasPXixTkaJPN4i2XJtx9TqSPo5CiOv+SBy
	 HFGVasnW8La2wlpeV4Q7xxKltv29VcnwxnocfBnp2TobfpnRBBRZS73DojnnYY4FOJpON
	 KROD8SoKYLvvbkw3psMDtc3XxX+3TS4BMeknSdY+2EzD4QwFG3+5tEi4sPTVfOlY9OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=dolcini.it;
	spf=pass smtp.mailfrom=dolcini.it;
	dkim=pass header.d=dolcini.it header.i=@dolcini.it header.a=rsa-sha256 header.s=default header.b=PGCCyEe3;
	arc=none smtp.remote-ip=217.194.8.81
Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CFA606A320
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 10:32:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41CFA606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=dolcini.it header.i=@dolcini.it header.a=rsa-sha256 header.s=default header.b=PGCCyEe3
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id DFBB21F8F8;
	Fri, 20 Nov 2026 11:32:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1795170722;
	bh=1LPDA2fCPhySycfbvn9IXhVWQeuIzUpOeftXOxOm5Bw=; h=From:To:Subject;
	b=PGCCyEe3IvQgVY+TuufF9SeOQmahjME7Pkg+ltHFWCOtJ9TtLgf+W4ZeuUma4Rdif
	 UfbmRcsssgPZFbAuucb6OEjyI+a3S/HmG5E4vyl+da73BbjVfwJBUwOKWuMk5Z1KSS
	 +irgbGxsuJxnBBlcKrqMcSMZ2oPtkqDljkxCTod9LyLo3eukrkQ9mXGXUPLEQit5v3
	 Cuxf/pLam17mumy+IPl+NuVxkRXknhMfd4GGpAzo0OB7C9Uq37E1s/zI3dDgc7mm65
	 qCpyrd9pxp6lm15W4MuF0uD4wK2Lw8xEJ9amhzX8kWoWSvQDDujH5J6FOirVvw1gTo
	 9YBBjYSRk5CQw==
Date: Fri, 20 Nov 2026 11:31:58 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.6 0000/3308] 6.6.163-rc2 review
Message-ID: <20261120103158.GA73481@francesco-nb>
References: <20261120055324.975889935@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120055324.975889935@linuxfoundation.org>

On Fri, Nov 20, 2026 at 06:57:58AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.163 release.
> There are 3308 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

