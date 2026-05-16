Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A3F78F3A;
	Sat, 16 May 2026 02:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778897086; cv=none; b=IDUfNn1crA1T6Fzuo0tHc/vc/9QPfjzIy4DC46k2EkCdSBpm289ebvcADs35bq2vQuaR9rmuk7enV7XH/+N0Yy4VwY4Cr+Ps9uRvJ9iDjeqOw7rkLMCgn5xV3A+Y+TLKvoTHjlw1r0qryhh/6QgUrpWcNq4R6dzSKzJw8UQdi1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778897086; c=relaxed/simple;
	bh=4GgJhxCCdzcx/DNgf6atnOuUTlp/TqU3pwox6GiqoNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CyVwztTPIJLy2Uzd2W+r5bL//KcYqB14D7KcbGt3XCJx1ByKtnkWd8YYH/J9ewt8oZOzrjlf5Qs3Nxj4Byf0nN8rq7K+k0+x8aFWk3z1q67263RFHO5U+Agw0TYJfjPpN1t2JesqPsjVvV8V6fUE2NZIYVOmSYzxJyGrMexBw1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g1BJdUr1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g1BJdUr1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C307C2BCB0;
	Sat, 16 May 2026 02:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778897086;
	bh=4GgJhxCCdzcx/DNgf6atnOuUTlp/TqU3pwox6GiqoNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g1BJdUr14RSyyqtIz8hCNuRkzaTkOsOBbJ+el5BX0Oubsos3sLma0XbETkxf+IjKP
	 zJo5uXQjNFMaix/8BGvsMLlBykUV328ckIpPz4Z60LC3hNKMG07KQ1Ov2kP+j4Wq2k
	 dRSIUcsK576ZjtId9CfUP91RtSywSUx0nS9goFlDHs6owCeiWFlysg18rjByue5/hp
	 VvMWGZWr3/ZCGTAv4zTwFjjWByn7acQospFoAotz/tIH4OG0sFTJQFt+cYD26Zg1XC
	 z3nH/phyUv8AHu5wCzkOjgtBRMKCmt6w2Wa41TgFLumA1KMfKuGhpKN9btI29dXmMU
	 EJ353VsIvtO/A==
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
	Miguel Ojeda <ojeda@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	linux-input@vger.kernel.org,
	Johan Hovold <johan@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH 6.18 000/188] 6.18.32-rc1 review
Date: Sat, 16 May 2026 04:04:30 +0200
Message-ID: <20260516020430.110135-1-ojeda@kernel.org>
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 15 May 2026 17:46:57 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.32 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 17 May 2026 15:46:37 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Via arm32 I see:

    drivers/hid/hid-core.c:2050:29: error: format specifies type 'long' but the argument has type 'size_t' (aka 'unsigned int') [-Werror,-Wformat]
     2049 |                 hid_warn_ratelimited(hid, "Event data for report %d is incorrect (%d vs %ld)\n",
          |                                                                                         ~~~
          |                                                                                         %zu
     2050 |                                      report->id, csize, bsize);
          |                                                         ^~~~~

It is also reproducible in mainline, though. Cc'ing a few folks...

Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <bentiss@kernel.org>
Cc: linux-input@vger.kernel.org
Cc: Johan Hovold <johan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nathan Chancellor <nathan@kernel.org>

Thanks!

Cheers,
Miguel
