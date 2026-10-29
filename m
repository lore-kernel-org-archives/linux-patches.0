Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793285032;
	b=XQe+fYtw8nmSwAV3wwVV5Bpr1POcT7vSWz4rugafMsjLgYSI5rJ1LRg67rM0+Fuk9zK2
	 r5tUxg+95aerB/qQpQogvro7yi+w3lSOctMxSG0MJRqQFA7CBlQJPpfiZMfn1QyiUObqf
	 JIY3JcOV4NVqM73/HckrdYTY3gkkBcUjh3F4YikOVwUFji7orOIv67Gowi4RzoW+hm+AU
	 dwNdGvqGklIculyufqafdgndta2xVGDcL5k6IbYZ2SUeNL1bgHpb1mVa5ImsFfG5RZU/S
	 nRXMA2f1llvc1ypDm+cbqKx+XR03SqveE4h1zP7LS/3Yi4PvSLLsuj1XZOEDyiQK0jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793285032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ka/xmmZ0YFIDwYTA4etAO3IAbZmH65bWwwuojBT4xf0=;
	b=rprUePJUZXoT2bhuEzUklkVJ1qfqZU/nA5bpG/5UwUB0XG0nnSoHy6IfALLzHzh9iUWn
	 7gOC/B4EOQroXCacJy54f3BH0pjLyJXLhDrlVr1l1sWqw8EKAJHDocuS1KcWKqXI1NJ1g
	 jnJMXNQBo5ccXqc4Z2WOWKrDT+QLDE1/oDFWa2bin8EM8GaSHAtP1anv1OIRGrsBeOpeC
	 we7/DV0mSTPn2AmxS3TlCT7+gPxkIFAzKOImEYvoCWnRX34izc0P6RygIF3HnHpYQvWTO
	 XD6PIJZGSMph/Qa+icwthZySoeZu1MwDEeuZOoVAN0U/wzGjpPbwmIVYpsI3aEw4/pA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HkOTXPiN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8490606A31C;
	Thu, 29 Oct 2026 14:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HkOTXPiN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEA11F01828;
	Thu, 29 Oct 2026 14:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793285031;
	bh=ka/xmmZ0YFIDwYTA4etAO3IAbZmH65bWwwuojBT4xf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HkOTXPiNQ54YEloIOdrxOGEQvq+DDt4ThzYz0hJbVaXJIi5TUEDGCSOoZH8woFeOU
	 taY5nv21+1pdhmxHwUZzq9HcW8h2ITgKXlEAdp4okhEVjRPGyfw4Nezzqct+x9kakh
	 pH3LogAQnTOq/JVSIXy5zXb4lTU9gNRJh7Vh0TIyx6UWTVl4YuG8cPiwsrNf86WKx/
	 OsUEttBMnlwZPOJP2AVzJ9FxbOOhtUprXU4thFhzBC7byGYmgHoKV2OqogzydUlVl9
	 uxebsSYquXXo0trdC7kYF6i9XBimKIyeCc6z9L/7LJtBVr4MV79PA/LBGOAOhHvoeK
	 zgNvRJK3D5fJw==
From: SJ Park <sj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.2 00/88] 7.2.14-rc1 review
Date: Thu, 29 Oct 2026 07:43:43 -0700
Message-ID: <20261029144344.149920-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: 
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

On Wed, 28 Oct 2026 17:59:08 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 7.2.14 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
