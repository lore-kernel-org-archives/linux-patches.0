Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792944520;
	b=nXOEbp95XpsTKHDjIii6v9dC8lDYj4SZagoIEVJeYPshHHfKhopCPJMCY8HbgjhBTTiQ
	 WGyAtJB5q1XB1bipd38/7FhaDFPMuHkEL7VbtdaJ4yMUQsrjugfml51LkRBWV2AOldDSz
	 nB0hwOZF00+5L9P0z4d6M5Fs+7cNyZBK4CXK1AMOgYhR6eezsjHoMYApkupEoXesgFyIF
	 EW5qC/9Nu5YpzDvOVSpDq0+GQVLfGkc14YWub4yarboWr8FbfzSbqDCmV2z3xME+sJKGT
	 gmBOaRjLAEAlEBk4haNoyfaKi1BTwhV1bVA3pX/cGT2gG6Nguve+sXHPF67sPVCXaqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792944520;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=JBXzhfT8V0978kAevsyXqXeYtrnNORzSezR6NgNowAI=;
	b=kbZsCVGrlXK/yFd9nl6kymYhBoqN7LeUArj87djOm72lTbhon0mjbIrW5rp+mxtyFMJc
	 c7ENGpgv8vgAq+8tlj4Oy8DapFt3ZgdKg0/9VRtiRMJN7mhSMEUASYHA7ERFMH2kRi3xR
	 iZMqz5/IHqtUFCc8qxztc0UXTgxch4ZJk4HfjTuYdPviYmWlJC7JHeYimiUE7Q57+oN2y
	 szbwPC9X1shEOWT/ac4NOkx+8IdwW8dYLsneK7jHccJLsPAEw5boq+JswGeaIxUm2xIbl
	 ZfSluP5eXMN8afwe2gF338x8/0ighFsTDwnCnbb8kJdb4aUyAdjauL0xe82U54hyMCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="bIKvPO/q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D87606A31A;
	Sun, 25 Oct 2026 16:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bIKvPO/q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DFF1F01825;
	Sun, 25 Oct 2026 16:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792944520;
	bh=JBXzhfT8V0978kAevsyXqXeYtrnNORzSezR6NgNowAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bIKvPO/qq8YD8PZ1m1sDlUvseHev5qkZ6C81hjrJQEHOmO1ifjwLWxv6EcGtB9F9V
	 iYP1FIQw9B08d+DyYQcrl5TyYOlRzfMAIsskdMYotdLADgzp3iMX1gzXXB5lk+vpa2
	 Xuxhdfevoa2r4yj2b/ipdgCmy8SEN4n7uFiUD8Owbc7n6AfnWzFb5Igfsr6TtSzPiX
	 19VWlwni5f+IUQpcABo/hmEWtL3iD5V9CMaD8UwJGEYlYF9XEpi+B9hq7B3N2B3TyC
	 5bTH0+W47CJ4J75qZMKspzJcUL1hpdmgyTue3RfjGAf8iUT7nkFLwC5PanyO2vYVmW
	 83KdWV6k3Rijw==
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
Subject: Re: [PATCH 7.2 000/231] 7.2.13-rc3 review
Date: Sun, 25 Oct 2026 09:08:26 -0700
Message-ID: <20261025160827.151148-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261025125805.309934791@linuxfoundation.org>
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

Hello,

On Sun, 25 Oct 2026 13:58:45 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 7.2.13 release.
> There are 231 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 27 Oct 2026 12:57:40 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
