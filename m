Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795299693;
	b=duUvOVlJhtQJcgIcVD358tgpWvTAGwhrzwTIyYNWhS/27Gsf1KWPAb3zkPRe4SyJ3oDa
	 vJT3b/nYRlUAUGrz1RCQL/zJG6QPvyNXF1SpkcFtzRJ10vslSurqxIMpUJCaCy1CZ/kpd
	 fE9LulACkvaJvusP80A1t2LA3DCjCSqZK9cgc6e8h2EGMunTJniozwLL3/0Pz3Z3HiyEi
	 e1Rolzc1V9s7McWpCNcd5IRiPrP3T5bjGm8PD1WL24mCeOHMU0hJpZtROAoZVXDnWDD3G
	 mCnOpNqozl+fVYwr6VWFz7w1DmLuHdvtutDSC9CdXq40687S+hfwMzZWHw7KWzXMovg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795299693;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=1EcF3LMocDRvsmnC+cSjzDN10kgi6C75QFp+aAmDtYs=;
	b=Tp4+t8YkaWYi+m1ke1se5kNizANBDFTDfOgwouzwpEfJEiJMdQJaY+vSGPZoscbt+B+c
	 6j5itFwWkGB3v50ijnCvtnL2gb+QvVd2ZvqhX5DrMLz6spkhSkGLwfFk8AQMMpbq2lzWP
	 QYea+THB5YesbqRmFxP6mR4izjWRl5SG0tmROsx7xuPfwbwqwir3Wcczf9W9m9RxtQOeu
	 n2Z7V7hhwr4KmdYcVo5CR7/T4p72l2FoTp0Em7cZtt1pigYIQ9vrp950rAkITy7L4iw7U
	 0m1yP4kfbGCwnxrBVxrGdw3V2gMGiQoStPrx5vi9jRnWnHwZNsPiqQ7/4Y2OwrDU0hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VK7u3vWa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46959606A320;
	Sat, 21 Nov 2026 22:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VK7u3vWa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F391F000C4;
	Sat, 21 Nov 2026 22:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795299693;
	bh=1EcF3LMocDRvsmnC+cSjzDN10kgi6C75QFp+aAmDtYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VK7u3vWaqh5yLiqOAdsLOrb4+STXbW2k1RH+xX912yMHKZuOxhRFw28We+uTr8V7r
	 ysYxW1wvTya/dD8H0bNum5eiu5II7+mWoCfLPbZO6U1JJZwVGZHXAAAYTk4kewGMo7
	 86Q3LZrEiUGYyN7tNdCw0fKDk1ymIW2rhbX/2s6TSMFZ1c2uk+U/DTxE1+XUReMouK
	 fjij/LPgiiE+Q03DidIdsb28qUy22r0LIfquywNDFoCDxygI1aiaIz60C7wBwRu+gd
	 cOGzCcL7K6n7S3HzwA7ik8YVC6nZPeN68RdTkFdhpnlO2uC7o7MfwMtUegN7b3skre
	 be1ZCjDpZKB3g==
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
Subject: Re: [PATCH 6.12 0000/1736] 6.12.119-rc2 review
Date: Sat, 21 Nov 2026 14:21:24 -0800
Message-ID: <20261121222125.135886-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261120054951.366579794@linuxfoundation.org>
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

On Fri, 20 Nov 2026 06:57:42 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.12.119 release.
> There are 1736 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
