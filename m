Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621023;
	b=uS5WPdzVRS9gnvjM8oVOFVFs0WfLJfsT7PXsadfODZdUI0dT84gV8O4f8ChAI6xCj7+6
	 nGN6BP9N+SWrgyfH+1mBhPU31fdLbBKm6CS9YDaRw96OeA1HqKXmld1ZVdrGVp4UDkCFh
	 4pJq0rwtBXefPYumhGRW/6d8A3etbV4U0SbvqnrttoqtJa4EIWpg+2UVcw72f9RQt6GLr
	 +CbvZ4vz5OD/5bFW4BAAgVSz1YiibdXBglMv/6khryP8ZVZwBAaYo6+RSfjHuquAZZkB2
	 ULR5tAa9xi5r1UNeZ6gVsiYKeTWqrLhuHBTbv0x3f7A/sHk33KcYUoecXcn3/nFWwGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621023;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=XknmS3WFriM9ON7O0XhdRopyHsB+3B42/3MNNAYS3rA=;
	b=JHHw+6h6aG0AcKakjDsO+znaa+nxspsOoSSdikPJB/VPyGrSXlohL8TlZkv3Umci/ZO9
	 i05Urss8wuxdg4DoxacR/U8uzdUZw9pOt5MP8GnbZnqcsDeTRMSVrhxzh8dL9Ob6fXLfP
	 7j50Cyg95j2GL1G1RcaICUfNLgsCbaqDnw3jWpWZa0EJn7KCr2BLg3xfL8Im4G5ajQ3RJ
	 5Uh3va4E7ge2g3llrRQITIW1SpDm7cgFp1flrD4gXYRUx2330eq1/y0VYTTzgicWPY4gD
	 2p4AI9kYBuvj0gYN3zg6oienPccWa4dIySkF1I2FG/alTBngZaeJsyjR5hw9Xk5impg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LyTJ0qc3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9F6606A32A;
	Wed, 25 Nov 2026 15:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LyTJ0qc3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E1F1F000D3;
	Wed, 25 Nov 2026 15:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795621023;
	bh=XknmS3WFriM9ON7O0XhdRopyHsB+3B42/3MNNAYS3rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LyTJ0qc3xkMiw1uuPfsXcdcGieUcmy/Mw2VqD4VSzpm/qMLnCWAeYnM7WYeGu78FR
	 NzG+yBpABw0NeJoW4NJaj8s2G180hU1JWISkO7/dSEriY35ZXjrEQYXPWTvB+/IDve
	 uUVvOXIEn+0c+ygAGEo8NiftYS0DbAS3stOeskN7bnqbUnn+gRucuRaGgh8+o/j7Zz
	 rjUJO4a+8L1OKlJzfeiS8LzXr9zoVbpX5Y4FGf+ZQ18PxdW/N2nscThdFldAJPS06l
	 q/MXTSSYxtN9O6oymsjFnLEh5f0eSMN6A2uuw2yCwgQOLQwLm+BKmU9d2BC9kLw+yp
	 GCqYZWqSCEgdg==
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
Subject: Re: [PATCH 6.18 000/990] 6.18.66-rc1 review
Date: Wed, 25 Nov 2026 07:36:54 -0800
Message-ID: <20261125153655.90669-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
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

On Wed, 25 Nov 2026 15:22:47 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.18.66 release.
> There are 990 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
