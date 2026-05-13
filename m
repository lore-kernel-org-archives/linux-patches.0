Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0A53DDDAA
	for <patches@lists.linux.dev>; Wed, 13 May 2026 08:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778660998; cv=none; b=ltJEqvoqHHvdpJMlFBJ0yWnKcBlzmBXt+uHBclWIwMbimTKWKxc4ubOCu3th9uzVOexnHl2dEDHWgXZsETVd29BiHxz3dmvByUbqwfGUXZLTg1ggQV1mher4gOSmTeCSE9tclkO/uBUiTmRTEc8VqB2aMRdjUCNTthPaYQHuXb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778660998; c=relaxed/simple;
	bh=31h9T40fs7vU5oO4snU4Vlx6cbKvxV+4E1y4a4A/Hk4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LZRcXhvDdCvYsylNqb+kTSGlVtajBSUVHZwCGXBP9p4QwqrAhYuZ1NXfxwKrxGl792JGnOGdVFuzMq0o2qOTW50dPdhLvPRa9UjVQVbormOxK/wS9Kn3lauHMsZD8+JKgU4EFWCyS5x9aGrXWJRy6YK8jguVzYDngnrCOUltV6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=O7vokJjZ; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="O7vokJjZ"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 496451F92A;
	Wed, 13 May 2026 10:29:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1778660981;
	bh=NYhSgtcHduwxvLt6lEIFjp2FrLWiSVCuZMS6xMTcGWI=; h=From:To:Subject;
	b=O7vokJjZY8CNNpPAJTNaydPOpl+3MAuT7Moh4TJ082EjHloHVxZeGSoONO9DMx/AZ
	 jizTmVVOg+bt/2UIZ6bg47aKRtuPDcuiYaEM/76amVLuY8w0gZYZ0fMmXVUSy9AMwW
	 YRgerhYoD7ZIOjH7YI6r/r1j6Y6yUhrg/MVz6PacJ6rELCCFDNYmBxMVng21225fxr
	 u/Mu9wR/F1+X/Ap5yaIGgmjW0kKERDCcOvrmBzaHSzLVKSmbvJ3Wz7A160ljJ6dMFH
	 1uqAzu7Oja5HnblwlxrcQFEUnKvxHX/RmqpMF29XH9EZjCyOBWsRJq7Hq2op0oc+A7
	 bC6KmvhrgBqjw==
Date: Wed, 13 May 2026 10:29:37 +0200
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
Subject: Re: [PATCH 6.12 000/206] 6.12.88-rc1 review
Message-ID: <20260513082937.GA59302@francesco-nb>
References: <20260512173932.810559588@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>

On Tue, May 12, 2026 at 07:37:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.88 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

