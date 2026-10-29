Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793281798;
	b=paBsyc5jRCRlgkXeMv6IK0JZgg1DSZksk9vl9Mke5vLNeTeZl/WRHiLrSD21ZlSpg5Kl
	 npJsMAlGoCV7RhiJSM25j8lxoG+tW2X+pJBdeAxTduxT4avaXPIyAuQB/J5ICHOltfTUY
	 FZxBxFWpVo0RHQNdwFqSmVw5G2jvNtppKygNEg2J5gXHsQ78LEvqZ3FxgmnF0kt5LO7W6
	 nikJTjp7qMFfPIjplvY84uMbAqYkpaX3bOKa+Dsm4DmlBo8hlsEwLDN6p8xuBjOQjb6C8
	 HsrPmCse0C7Cf+NIrF9m5Nj5D3jZaEP+rR8ZBUd8BhBn474IROZxFu+b7UM1fvdTdVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793281798;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=8BRCU/3014dl6w8JH2vJu0UFBqarJhZ9vlp53baQPS8=;
	b=keKwPMeH6ME+aTx4AAkhMkdEJpQo6X2NmRQbU06F1NgOuDX1K9jVnmVuXrK0O7Wn8IiE
	 tJ6h3VT83YXSjUXavmpmohkP9o65Y5rWBRx42tVKrVgtnVHyoRmavgEC6T/KRMDNCV2Da
	 APIWfj9vvCbByNf312ih6BR8olKwRxirRXZYDaa0XhKNQ4tgdtcz+OZMd81s28z6YOBKT
	 gFBIj9AK66MQEwaYjxIIiPwYjXA3iR+v1OpK6u9Wz4rIzuwBxfM6V8pnJQ1PRNBopdPOn
	 7xQojO7nGYzb6RtU26HOzidsuAWxNbs2yTb2LyAS8alcPiTWFci19ZsDIplTSblKRjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N4tgxKFX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6569606A31E;
	Thu, 29 Oct 2026 13:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N4tgxKFX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435DD1F01829;
	Thu, 29 Oct 2026 13:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793281797;
	bh=8BRCU/3014dl6w8JH2vJu0UFBqarJhZ9vlp53baQPS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N4tgxKFXlkC757ihmsVrWJYvsXO3q6E63bqrSZ/+Pgxz3ndHZ1qGBjQPuJ4WUjKdY
	 n4mXJQQIkazPndLVo0Wqgn+c6BtvGJ/XrTpNix2B1HnX04yFGIoIr3uhP2za5wYe3G
	 7VaqUwP1stJLe7CSSMGg1aG0MzgG7A+Vd6GxT0MQst1qQturcyrIoc0k+1pwr+fYCI
	 Iuxw2CZDvWt5tePWVefg2tED79uNoRi3Gj+Fa3cVo65BzlrEEdsYuBVD3XEO+G1KaS
	 f7t1dVpTuBoSHYViVW1EbBLi9NszbAYCILMXay3eZCgM4og9x/l5feFUD2NwnO0h7E
	 yfJXy3pjawVNg==
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
Subject: Re: [PATCH 7.2 00/88] 7.2.14-rc1 review
Date: Thu, 29 Oct 2026 14:49:47 +0100
Message-ID: <20261029134947.26915-1-ojeda@kernel.org>
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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
>
> This is the start of the stable review cycle for the 7.2.14 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
