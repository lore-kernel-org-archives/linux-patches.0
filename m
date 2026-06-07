Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816144071ED;
	Sun,  7 Jun 2026 16:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780850041; cv=none; b=oRKQ9E6+rGJkBss0t+USYyr6NVogSkkb4MUe/mRo5YRygmASwROHkIcvVgapxB+enFjJlj4+AGOStGdeUp7mZk0SveC91rxzievCB6zT4BV+vOVwJflUTZHHnhNj+czFTUPzSc28NM3VW3ReJJokck2msR/7HQn3spuvfJr4KUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780850041; c=relaxed/simple;
	bh=eVqYxT+RPJwbeYXMXfjlfuDdCv+kXhIyxQ/IYyEtcPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OddcxxYFOuiIWh+iyTn1o/tyHfAfSl1RcO9CPQCwl2c3wOLi0fDtI68IuRngC3SoL5MPaYq9ZUU5EBskBHmN1oqiVWXNf5/Stk0wVghy7xBOuIPf24OWJ2vB02Y+r4EPlNJ3ToZLSBOnnU50U4ZUmUekKBZRfwJOGL9k7NUX6gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WUB979ZA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WUB979ZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56F91F00893;
	Sun,  7 Jun 2026 16:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780850040;
	bh=P81oSManlrucQyUTqKMugdh4rJCgFEWqPomST7seGVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WUB979ZAIniibUMPcr8jBT2k28tR5aHDhWsnqTq5BPez9hFRVmeqFey25kSFPDdzc
	 v3qrGAU/UU8+riEtbXwbUNDKJITp7GuNSKtsfWyR+DSj5mB55Nz5InDvGNoWjTqUbT
	 BtirO9SOWeHGEH9t0pWDMPkAz1NNC91I5kPx/kcA6LTg2jBFwbee1D+hUp8wTJZ33Q
	 iwsVOngmvRdLwC6gPWyDO5rdFNLFkCqh1r+NE76AJ44G7VWmJjDtA4dSGTGG/JQ52V
	 jsQgOGxkTKEfqyP1OBGGevhGPWloZY3tLp2gFB/u8H0gIwYvm7J/Cqaqge8FNuLNxT
	 FzTxrWsmVH1rQ==
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
Subject: Re: [PATCH 7.0 000/332] 7.0.12-rc1 review
Date: Sun,  7 Jun 2026 18:33:45 +0200
Message-ID: <20260607163345.88232-1-ojeda@kernel.org>
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, 07 Jun 2026 11:56:09 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.0.12 release.
> There are 332 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 09 Jun 2026 09:56:44 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

arm32 also builds fine.

Thanks!

Cheers,
Miguel
