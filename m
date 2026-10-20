Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792507296;
	b=ng4/d7Z8rdDC0n6hK7DUtM7l1dAZyc8M3Dc2l5LUGJUclud9P1ibm+YXB6sdXErt7Qzo
	 PrYYHfnS5TAx6whMx9/tzmwtD5EA/E2hBxz66J23oUveoEOq5Vp5aFs1JWveJ1pJNJADI
	 zJpu33yjWiBStZpHrItiIEP6xPa8wv5sJ3Dh3u2aeXpkvYh4Dn+qqVvSvuyPpDkg2WXre
	 eqOdyz4kFhEwOmkobpaiEAg3A0PhCwrOWxnzpI6g6jnYcJy7dmYcycRlewWS5cRxTc//i
	 g3DgJIF4k+ODbw1aT8SWMyq2KuWTvg3cwxJyKuJnhb8B9/6qTYIYjjoGKjvnQVa8rWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792507296;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=u2R+vKwDQK40EH2xxgxsG9RudDTuTEMR/+RO0OXMR9I=;
	b=muC9wDKfxUeUNNC/8In2LVw/NsMHr3+OJx3VPJLbGDDZBDtclHxC8fs7U6Vk3vKXcKys
	 4NKLBUT1k45QsubL8Xo26EFGOnZgBQM95UhKDYxpTK+OHMyAbfj3sIpOA2w/V88lcq+Fm
	 cOdBXYXX34wzh1VsS9gdc2ptwSCiW3ddoItB9yN9HGq/dd1SL43h45YYmPmLot134Pur4
	 AxYg9XG6le5r8R10WTTyDbtbqrYFiUJ6oEik7IPa/09AY3//mc48Jf8qpTWvwzoBM0AX2
	 n6IAk3U7yPuVVhHK0Gkgr6YkEPgyLcryrkefCq4AuEhVBHsOgwvRDOcdQXdMAM9IyRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Sqs9pVvX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15416606A33D;
	Tue, 20 Oct 2026 14:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Sqs9pVvX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828C41F000C5;
	Tue, 20 Oct 2026 14:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792507295;
	bh=u2R+vKwDQK40EH2xxgxsG9RudDTuTEMR/+RO0OXMR9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sqs9pVvX5FbF15Ru/G3v0PTg4JqJJHMjtR1s4STZZFueQpv0DBUi1sDxYIbfHxDmV
	 LKcKiRNjz/hScOnrBAe64ONzM3BW178D/ePqk/E/d5i/FJy2npUdM1UJmWrTd8b7Cv
	 UKdS89l9nBR+ctGgof78zUkIflKkP0nP8HqCTyrGEl8/zkD7flKlhp29ibqjd7S9W5
	 UxmpaMZisduZfOpMbJVEOTLyaf7z5pfW1LHwLGPV7SqlulaBMdklo81vK4ZMVZRzRf
	 oqbK4gC4jnFTN9YwjLlI8c6anpJoo/YA+uxdjrN1cWnYJo8nPQOkyFk8bt2OsB30KT
	 cnbh/EM21B8Tg==
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
Subject: Re: [PATCH 6.12 000/858] 6.12.114-rc2 review
Date: Tue, 20 Oct 2026 16:40:17 +0200
Message-ID: <20261020144017.171634-1-ojeda@kernel.org>
In-Reply-To: <20261020075246.861837975@linuxfoundation.org>
References: <20261020075246.861837975@linuxfoundation.org>
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

On Tue, 20 Oct 2026 09:57:31 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.114 release.
> There are 858 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 Oct 2026 07:51:15 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
