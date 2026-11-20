Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.194.8.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795164549;
	b=u4Cj3G00xq3EM/7rbe9qT0iUE688R88W6jq6vXHKorT/D9sSgB5+4X/e3L0jQFUB+6LI
	 m7esr6KLO+WXNeaMmjMNwV/xHW0RbdNwKtFE8WGxNsdNgXfy2XAxctXH/pirRRSzum5Yh
	 uSHEYOYL++g43aqfiCyfm5o6w2g1C9UAZENL9i8tlFKQXTvSmrGanHn1iRRhyObRHx1R3
	 90JtCXPzIXcDD3/2Nzum8tkAVIsnq4WnRScv8SkHs348hyJWleEYvIblUQIiSlxCXZt4E
	 FYY0C0e93AjTnjI55RVDvVyPQ+uBEGDHRgUeL4JhjlRAMqX0mKXrnmblsP9BAxQW9fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795164549;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=TgNRGTkiSsPhM0kbYSECshrWZcnJhmnC2kdNSG+ZJio=;
	b=LIrGHrJm9LAQY9My3M4g1LgN+4HkCLwL/NE/9MX/fFu9KWJVt2sdK0zOj5nI26WgtVSo
	 DHDwVUqb6dSPzK86yT/l9yVmjPMWog2iOdPDdJOjchDDdbIMn9y49bV/Y603cCntxAKJ6
	 B2LcLFiO92aeAyCkYcfLAwLJL/VnWOD4sXGkNJlRDbAHmWGhGVSkFbjSJdlCodD6+xqRa
	 NaZSLf2KNRTpIKNK0CJcJcncp339V0YE99mVBknaIp6S872exqO17dC5zwoe+gNZ+TypB
	 uMyB1vRLwzxrY4SHywSpmRE9pY/mcn0RSAblA5L8EnhtL0OZsjG0kdxo5UUul3DJzIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=dolcini.it;
	spf=pass smtp.mailfrom=dolcini.it;
	dkim=pass header.d=dolcini.it header.i=@dolcini.it header.a=rsa-sha256 header.s=default header.b=HGGUvL9k;
	arc=none smtp.remote-ip=217.194.8.81
Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07793606A337
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 08:49:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07793606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=dolcini.it header.i=@dolcini.it header.a=rsa-sha256 header.s=default header.b=HGGUvL9k
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 4ABC61F916;
	Fri, 20 Nov 2026 09:48:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1795164538;
	bh=TgNRGTkiSsPhM0kbYSECshrWZcnJhmnC2kdNSG+ZJio=; h=From:To:Subject;
	b=HGGUvL9kps/7z/rtUC2hLEVlEO7wPoPJ5jW170O9BeDheuJ7NY1ejOgGf+YioV89a
	 hCV73ng86yc4/W5nxjIZQHyoznr0g6QtRgfsKFZbixJDvWO3muPIML9+4iPSN1npSw
	 x3ZmZQisvUdQoEZiFrQXs1Xbl9x2jZcMVkgEzf0+hbNrjIfb75CJ31nwxaGWvcnXCW
	 Y2jY8SRRSUBBo5ktxA9sMAMaZ9pzHMbsNgnGh2h4LW1agQ7420cCJ/iTguB4uSgmz8
	 fgX++uCgTFJNWZTn1MKRz2yxFTm47HirUe+w3RL/cab7VZhc5PvfmJFXiPdNhTN2s5
	 8ONe050TdZ09g==
Date: Fri, 20 Nov 2026 09:48:52 +0100
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
Subject: Re: [PATCH 6.18 0000/2144] 6.18.65-rc2 review
Message-ID: <20261120084852.GA41768@francesco-nb>
References: <20261120055114.182757740@linuxfoundation.org>
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
In-Reply-To: <20261120055114.182757740@linuxfoundation.org>

On Fri, Nov 20, 2026 at 06:58:10AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.65 release.
> There are 2144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

