Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792865911;
	b=42R7k8NkEiL16tCWigPAWYcNeUybSl4UwavPDlGe8XkXBXtYjdHTU8PkOoj1Gxi/mH2H
	 2UB+2KRsnGcwv+ru/V0uoEUZX2N4PSSSG/MH+GxNHV1ODWzYztnbThXefTYhjOvjgVzTT
	 ofvkwdsIqzENDmtMaTGiJKSVsfjxDHOi0SP0UjfHy8XjRUCy/3XoDhqiOiB44O3f+OZux
	 zWq3j8tefpMbrWkO627pTZltJbOJL7jmLIduqPyjC3MvuD00zCgdHcVGzG2MbbhGYDoLt
	 evNIBp+zaAeUaVxoUtUsM79hMUJiAlm19GLXkscQjRc4E0OLWquvp0J8s9xf32V8w5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792865911;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=373k1gR82V32fC4Kf8dqJHiKwthYsYvY1+g/4IFdzFI=;
	b=K+V+ELvCOGzlF/qfxXUx2UydiOpmBM77x1WAPzER8G/nESq3UwIVFkgFOfSk9cwsgyHw
	 zhE7j8PDpcPdDABFgR46T6/zKtFBIdVP2qo+RbBoSbxXh+OPBe1VNq2Es/wsaJW0yZoG1
	 AEE9Ehpc+1g3TcbXYyKCZEWCBK/zaQRDZP4VekLGblXqsYlr3k9gkn+noLytRU2KeiWMW
	 aMm6UWKO+6dQi9GhYRoXb5zJLKGSGKVhQtmftU6gdTfR6fuefP0LhVdq5bbwxhzKjYaEF
	 DKniTLXKLPDujhbyQsR27H/46LnwL5SDYcs++OfSXvbs/EXN1MxaFgLgIyb26UU9jFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DV9CNLF2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AD6606A31A;
	Sat, 24 Oct 2026 18:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DV9CNLF2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9051F01825;
	Sat, 24 Oct 2026 18:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792865910;
	bh=373k1gR82V32fC4Kf8dqJHiKwthYsYvY1+g/4IFdzFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DV9CNLF2FoR9cR//+mHRtxvii7qlFOS8MQDShexynsd2TwER5DoQuizEYD3cUBLWP
	 aSLnFb14cXcOJX0hKVWJ6g8twLOAMLUXRHemwr4rSkdjVTAbyY2kZqOei083WXpe9Z
	 vUJ+tnaZb4dri/PtTnUfqy6ed/oCOCrST9hXzzPXRk4LRIwKLhWMxXsnTcP1ADe2S/
	 8mMa8LAT5QCI/pJVTRFDeEdRfAPXqD09MywxYTOUfwgsA6xwiCapqYwqtbIA1VD5Gl
	 9CHGsQCHVPmYRLx7pJYPx0VrHOaLDIRa8OtLuUVLX5EUgK8SIm+unyTnp5/vbG5ojk
	 ytXbHaFai79Cw==
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
Subject: Re: [PATCH 6.18 000/193] 6.18.59-rc1 review
Date: Sat, 24 Oct 2026 11:18:21 -0700
Message-ID: <20261024181822.81958-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
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

On Fri, 23 Oct 2026 18:34:37 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.18.59 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 25 Oct 2026 16:36:50 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
