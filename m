Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794247338;
	b=5UUJkkCuSKEpW9rtR2zfgC41GLhZ3JIXS1ygwwOd74iiCTZvXzBq1xMKkpLjgwGvF06G
	 ZE9k9i03eev+BKdqkNs9oBt/ak0Z9jQqg3NrTwScM+VmjDsr8eIAVxYX0orLWCYXUky/7
	 bhffwqjK4SoE6kWkIGyW2xEIrSk6dNLo2xDdCjmnP53NAQj/4o//9KgwDGPItFm38vkeS
	 +HN8557gHsl/67or3ON4Vew2QGJ5V1qsdXgeQGDpcSQVNrPZMx87qM2kno3L2/sVIJGI1
	 C9nGrHUMlcJqYbwsXB8ZCQlfwYWadN7uW3sZQ3qT8FHZ9ceVkMWlhbI3DLSsCNVaufw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794247338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=yefN13qKn7cHBxXTB3+WOf8D0NdfFELlnIRgX37ptCs=;
	b=Y6K7aqaNGSN3wVfpjjiunaFEPhyZPj4N97BZbZ6YpfieyV0OiCdxdAF3VtF/lVovD57k
	 bRR6vyBfKzpBeRRTVQcNuCw4yiIR7ZDTq/qA6stNoN55chKr22AgIZq8kM2z1m89+ffy1
	 kxDGKpPYejPxtS/buPY7RjVxpcle+RNLPEaNeDs8J+Q3hDH3/NMFppRDXgaEAOBolVbxE
	 olyZX/wAoLhADIxpTTBDlXKYZl4TNifmQAe79k/Zkol0Jhbp5UkPU2LCwAInNh3Am/n7I
	 x7M1eaUAGfSWSsJ2HLPkewMPhEhguJSQJiajI61RWCjC+N/ceF3ckqQVr6aLUsevziw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="ewxSO0/U";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB37606A31C;
	Mon,  9 Nov 2026 18:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ewxSO0/U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C891F008A3;
	Mon,  9 Nov 2026 18:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794247337;
	bh=yefN13qKn7cHBxXTB3+WOf8D0NdfFELlnIRgX37ptCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ewxSO0/Ub17VE2yrembD890C4Ax1TshJMw+iVLp0MXH1MsgyR/XOtoOspnuHYew5R
	 UIdszN785+zKpqMQR/OiOOhwCES/XwloG/u5vOnw3mm06RoCEVjPz4YV45BAgGxSTn
	 WOjr7ggUVl8ovA9q8/BAVja+cBJwhB5x4iVIofv7aZxsoW0JnK0COhZcbzBy+37nO1
	 aJWJsyD2RJ0q18HFn4fwXxH8wYR6Pi4RzBk+eCjkITo6LNxOFEf1CQWxfSQmmtAX7t
	 RFoakL1igUW2Og2ob+8eEyffGUO1+WMfW6y6p5gE1u0VH4jGIhoKr+WHv/FQYP4Shn
	 0LDDAF57WmAxw==
From: Sasha Levin <sashal@kernel.org>
To: Pavel Machek <pavel@nabladev.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Jon Hunter <jonathanh@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 0000/1536] 6.12.117-rc1 review
Date: Mon,  9 Nov 2026 13:02:12 -0500
Message-ID: <20261109130001.imx-cfi-612-drop@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <avGXNkyWQfNqN46v@duo.ucw.cz>
References: <20261107134957.653319350@linuxfoundation.org> <avGXNkyWQfNqN46v@duo.ucw.cz>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Nov 09, 2026 at 10:49:42AM +0100, Pavel Machek wrote:
> I see build problems in -cip testing:
> 
> arch/arm/mach-imx/pm-imx6.c: In function 'imx6q_suspend_init':
> arch/arm/mach-imx/pm-imx6.c:589:17: error: implicit declaration of function 'cfi_get_func_hash' [-Wimplicit-function-declaration]

"ARM: imx: Fix suspend/resume crash with Clang CFI" (upstream 242757d109bd) was
already dropped from the 6.12 queue on 11-08 (stable-queue commit 39e32a361d),
after 6.12.117-rc1 had been generated, so it will not be in the 6.12 release.

Thanks for the report.

-- 
Thanks,
Sasha
