Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF6A2EEE7E;
	Tue, 18 Aug 2026 23:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787096616; cv=none; b=T/ahcFX8G4t3D7JiHzZ0OABOSBXDsFfOKy2WYyO18n9jHuMfOALBycBoLxSslWfZC5V/9f2Vb4Jrtr5bjEgHOLsA/S/eshYjfqjY+6QCDAnFSARW8d2DfDhsaBVS15GktIxrD93NNEVpj1x5MFtnO83BjZlRHl3hfZ6ad30uDuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787096616; c=relaxed/simple;
	bh=hPjg13Qb5EykTrVXg6DJhnPWVqPDONWMo0UtvdfcX8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQHjHyRwzdyouf3quFnHUSNvtSNCuNgvK/FS/WgRYaQFiqP/kw70aVLwZu8s/9CGuk664cqxuQ/DkX03Mvt3Av35OECRdHhAtqnsvcwBVu4JMdeuOAeifP9F9kMmC+h2UNpf7qDaUg2Vcn/upAVM6Q4bBSb4wda4e0t61fXGsNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZMOlUeRu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZMOlUeRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4231F000E9;
	Tue, 18 Aug 2026 23:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787096614;
	bh=lb0Xa2Xxqb0BmGniYajw4FiemyYcfJPnaslC/9a0r10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZMOlUeRu9jMZ5CnFfyqMr/BqDxJEZEf94OkN0oJhvzYXDi0zRviYhXLmwfoVTRcZy
	 SBs6AQqMqIOkWGfeBZMk/1qJdFBORUpwTqRKdSrbklpJFX30eQWs/20bdXrfcrmwZX
	 p2AkPUy17xGLR2gQP/juLuxdswC5euY7vSApzLtRqk4uPZt4Ci8g5Kv+3Ttf9LtjdU
	 IxRHfAh+B6HUdnI2QnkoVvTznZQ/tkd6scjOfBusaMrITStbR2WWabozdXOtQq6JJB
	 93c1NXOk7eYZbLuJgdKsywEyvGWoRxXEOXr4yd9JQxbvMCmsLCRJ9GqkEFIMA1KqwM
	 NT8sRJvQWrRdw==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.1 000/609] 6.1.183-rc1 review
Date: Wed, 19 Aug 2026 01:42:39 +0200
Message-ID: <20260818234239.399159-1-ojeda@kernel.org>
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 17 Aug 2026 15:24:56 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.183 release.
> There are 609 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
