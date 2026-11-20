Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795182808;
	b=vjeqU7YkrehBYrkwVbnJy5Z57mEP3b9u3z2NjjjTEKnYCjCSyp/zWm15Tu0KiksxN916
	 6AfjgG++9hJzdy0IZ/HC0Me5jmf9AyKWipSXoefG4EsMFboBNp2JygJpxy5kEIJvsaoo3
	 27BTgMmM/UgYrQmoNseOa93QxtjvOp0mEa+AT+ns5jqR0BZC2GUTQtzy2Sm8WrKqHLvFC
	 aKGcRf/0GAXEqNTYAQH+J0vkKw0p6zCXkdVMe4WKEpx+OGcA21qwL+o1PbLPDZJ8GblDN
	 CTBrqw9spjOaOGpNjuyDk2ZRaV1PVqLAex6ornT+3b+I2WEvIbW1NorI//nZBphs4wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795182808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=HFAffZmv0l/cnZsZp20NyZNbNASAUefyA9yE5CKUyOo=;
	b=EoONWghMXUg+v5roWiD07KusIA7MFdQxBBjoYTywreJn80g+UUmfukI2S+1+OB6lVkeZ
	 FvHB5kYY/2tA3Ge8PyybNS3VJS92WCynBWYtxk/wJwRhvpJca2ZGnQ+32uInG/7netnF+
	 IeUK9vOPQpyGjtGmEUX04LzsOrvlP9o+naHH78JrYpCT633OUIuQolhVJlSxcaL57K4aT
	 C6kMsoqvOAf+NZC/XuO9A8B4Q1W4dspYfHOYzsxUsmm9Z0/h1MXw/Cmy4o6CXkRcALnRt
	 gsmZJcQV7sKdBWu4ChFG1ZHoT03vT12fD+a0eN6imBMNJ9dhPNXbEvKZgPesVOhcPAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kw44yOjT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80118606A325;
	Fri, 20 Nov 2026 13:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kw44yOjT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861071F000CF;
	Fri, 20 Nov 2026 13:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795182808;
	bh=HFAffZmv0l/cnZsZp20NyZNbNASAUefyA9yE5CKUyOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kw44yOjTzyskG3u8a/QgY2xv+l0pWP1Po0ut5ne0TkR5D8Z1B9z0u7PXm5dZcErKI
	 gEfPRATFo8dw2SLak6a9Ue8ByIPhC6FHOF+WwJP8LXC4Pm3S5kSbcdz/7WVikol/3C
	 97PZrePNA8GuNjsakdWfxloQqOPQ/JtfL+Xx9khmtkWhMOmCs31+7NWVZN5XkVDonz
	 38CxmWzJPIvHKgMnMhQkyoaNxm9+clzdU+iuUiNNj4bwH3u0BDBSwv788d7nj8xyn+
	 GWoeVaSKEOsQ1nL6WfGqbCldcL9sXZGTCUm4ABtgnN93xJYiTgg4fsHhNCAwfNNNvZ
	 mN0Dxv0WH8+UA==
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
Subject: Re: [PATCH 6.6 0000/3308] 6.6.163-rc2 review
Date: Fri, 20 Nov 2026 14:53:17 +0100
Message-ID: <20261120135317.16555-1-ojeda@kernel.org>
In-Reply-To: <20261120055324.975889935@linuxfoundation.org>
References: <20261120055324.975889935@linuxfoundation.org>
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

On Fri, 20 Nov 2026 06:57:58 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.163 release.
> There are 3308 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
