Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792842943;
	b=Ch1Xz9p6AsEKtb7VKLmCWYCOzRJXKqCyNk9UI0lcr+OgPw1gzWs5bY1V7W+UkEGM7ZID
	 hZz2R3yH8WOdkAt22po2ENvj1tWKTTCP29LsiLDNm+2W8w+VviBczyDoomPfIoHgtRJqE
	 tdCJmed9YPAw5sgYSRBKKqsfAw+cDb2vCC1m2doBNs0KKZCQbaDWez7MZuhwzOBUiQ0UN
	 hwU5npkCeQEzBw3WbmTEtDk/AIL+/N6Lj89eE91yyBbbPjH6hnGjzp0DC8H5s7B/ZfsHg
	 o/dNJ1H+VeLw9Pqg4OCiTwn7TDutYplz/a590SevEj4jGdmKl60bVYN3kpC4jLgTiXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792842943;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=W37ouVhaxyHmy7R1XEKYwf9UbBfIvb5daU763UjOBv4=;
	b=p02K3QsjL5GJbmpK/DrAWOoHLPy/+hdkusIyAR/XcLMJjsKWcmWsZUEMPC00QGN9faZl
	 lJVpz/lmofc5R2eBwAvGWBnRHFClD3WKlAV2WDMSTUATIYjGz3+9eX+WRYHnh0TiPhmQF
	 QocEDwaHXH8eUZGplgmxFZ9mYRpa1hOxCsrYwuh5Nd3HSvACRsV6uPR1hcZO6oBlVLGJx
	 ads3W7E5kYBwFUM/cnU1mOtt8dS6QLexq0W3WLb7/a4m11f73qf6y6eWo8efjNlabWELx
	 Jsl8Ourn24M2jkUIeVXTeJnEYNXBToH2r0Lu4EUH+qO8ro7VLdShq77pRe3uJrZv72Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Sk4QEmr/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32362606A31A;
	Sat, 24 Oct 2026 11:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Sk4QEmr/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D4B1F01825;
	Sat, 24 Oct 2026 11:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792842942;
	bh=W37ouVhaxyHmy7R1XEKYwf9UbBfIvb5daU763UjOBv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sk4QEmr/ntVyL3EGJNheMCDewNGM5/V4vhpcWJTu/ybwZo52AWdrUfvjQCYWfCFG3
	 e4AlWI/SF0kS8Yw5bg9itrOa8USbpV5gM11CMrF/6V+agABZgfjsv9ds/ocbCufFBx
	 lj196l+qj62lfwnHb1bmmRRO0lKrAuzJyR6pCUIUya0gigXgRLPql3LfIVkf+Nuppi
	 PGyuZtSGjgcVi8hILc5LjfgYJvMTO2zjmc5jlnAG2w76et0CYmn1pHsrb65dNo2e3w
	 GJ6Z8npy8GgwyxcsGDuRSb3Wdb2HhAtCR3fG3Rh8C0buKghiNRuk8W1jFHLbcQZeEF
	 gKBKXp3uLObdw==
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
Subject: Re: [PATCH 6.18 000/193] 6.18.59-rc1 review
Date: Sat, 24 Oct 2026 13:55:31 +0200
Message-ID: <20261024115531.146853-1-ojeda@kernel.org>
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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
>
> This is the start of the stable review cycle for the 6.18.59 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 25 Oct 2026 16:36:50 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
