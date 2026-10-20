Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792497407;
	b=o4neKVHl6qZYn2xnkGkpZY+zWjLEaYCSUynt830ILbFXMKXe3L1Oha1tsbpkvSuvy9YE
	 DIg2SwhiNjdhKQDpmQYAUBA06LCbAgC1uPFO652p9JzF0/2GGSoDJsT3NU10AQ1ndnWXM
	 MfnFitC8UqNZ7+ihISeNXWnKZemxT5olnwRRVF0TGq6vaqhr19lIHbGjgI+HDJTz+r8Ig
	 GX/QSAXCZ3oH+EekNql/V3fR4XBo0uXnv2u2RaTcBCOzwwsv9hIVVmV2iw8rL2WGreSml
	 eoqYeLpTi3K9lSsq+2LAoYLu/0uIkAb0NZ7t1e5DCXpVthp/jtxvjC+EvxYjf1IoRPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792497407;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=AnYShNUahAQmuqa/646k2QFlXkn3SLpXlnUOlUd1CBc=;
	b=WGPAKW6ENNF02PGyzk6PW6HCAIg+Iox5KUu5FJjSS9CW72Zmfx6HPliQcl7Cv+JajOwV
	 1+YSTItWA0n1Xif+6bf1lzLUK8kDGUCoBMjdNfH/05NO+1r3uvLd5bZF+H9CVnndir36/
	 FFfGvO4cQkjCTZqoslFa+9rcnjD3p+16C4JNmolxpr5t0JJ/+12J6eJCmvjYIN9RdEyKe
	 j9SQ7J2HZ1MpDn32xE/Jfdoie58p0de7+3Xn5+4tfbOz5pXwLGJAp0vyX0MX9YXanmWNc
	 0lIcV2dhyRj0lt2UvQAONbx1/ycYDj/NSJmTqVvhku3BfKlojIGWwGwImr94GH+v60A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N35xXt1a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0F3606A319;
	Tue, 20 Oct 2026 11:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N35xXt1a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD9D1F000C7;
	Tue, 20 Oct 2026 11:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792497406;
	bh=AnYShNUahAQmuqa/646k2QFlXkn3SLpXlnUOlUd1CBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N35xXt1afphS3stLuquEs23YypKSn5+9HuStb73a/LxSvMSubTUmKPnwnNV5uldLl
	 3lyI1DczwVOj3W1VcBEKG2RAvJJohK00C9uqN7lJM9EZULCisxUydhlXOHAETbxKNO
	 D2vpJF1+fl0q3Wv756kzDFycrQOR/wVerUuoqhlHu6dFywY9azwlbdTWOxSn4J0Oo+
	 ZzBB2TGlkYdh+8TkLbuSHw+lv/2uDgsJzVWDYK5Fdvd+Xxxdrodaja3Qwlu7Ycg5r2
	 6WSpte6LiTmauLkGSawQP9p7N1L08VUXYLu7j3IHHWQ1v8Xb4tRGr3gAv8mUt4i9pl
	 M9TBHP7KPoiug==
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
Subject: Re: [PATCH 6.6 0000/1651] 6.6.160-rc2 review
Date: Tue, 20 Oct 2026 13:56:31 +0200
Message-ID: <20261020115631.168035-1-ojeda@kernel.org>
In-Reply-To: <20261020075535.084584701@linuxfoundation.org>
References: <20261020075535.084584701@linuxfoundation.org>
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

On Tue, 20 Oct 2026 09:57:46 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.160 release.
> There are 1651 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 Oct 2026 07:53:04 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
