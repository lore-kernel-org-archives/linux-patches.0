Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94613C0A09;
	Wed, 26 Aug 2026 11:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787745388; cv=none; b=cTNMwyk0Lnoj+kpS0yYioTrLZeo0/LbkYcDzlmqsbeN3Rwbnb540yNZfMUTBbnFydBIqApk+KyVinJymz0XB+1siwj85aMqXUNp8FL4u33ovF0P62HteBY7sQCpSAZXI6Xv25Bg0mjGTWjKsKYvNTIJXIMzwMj45mrzlO7nzJPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787745388; c=relaxed/simple;
	bh=9w/jZSnjUACbtpe6yjmEz+X/NWaYn3lLTxDFc5jRt0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7NoXkakn4tVLJurG0UqhDYqBsDKjrZ3CO5sBeB6X+YEKK0gQnqDzYyRnWXj7IZnyvvEkpvcDBlby19Q5vKusAiUAs7cWnOTrKtOBl8FXnG0JM9Z0cHV9clMIglM3zu84ohLNdNsP7wTz0f7jHm3XBGYzfNfKVzwtWm/piQ9Cv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WDgLMb3D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WDgLMb3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8C51F000E9;
	Wed, 26 Aug 2026 11:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787745387;
	bh=5ZIPEgIMPSBeTXeuJztLTCGtIsPuAewxlNL8VztE2M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WDgLMb3DtsKgcjsRY/3wAkrv+14QpWGXsMZxMDgK1uo2Q7MbG7ENpWJ/r0VmijNXJ
	 a+jS/6LVRxTbc3f+qZYvZ3DZBg2u7CuwrCMV5ZycOjNcNnwWpKHbLqUgdDKUDYrdZa
	 jVIe8rURglgEGeOgYIEXWJtluInlXXS1F3CZE+O7yL59DzsjlsVASDDMRAAfxMHi2d
	 JR1HhIQIYVd161vTMfiwHnqzeGXaRUcsTFk1nHnLyJyjSTTEiOeMdSFXGxFWnZ62k8
	 1l3GOvz/hQ8e5pQAe0ZqLfFIT3MPQ2mKZ2KHqcqRj6VpzciRJ7NlkbjvrXY9ohV/Ag
	 tLz20MX1WZcgg==
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
Subject: Re: [PATCH 6.12 00/77] 6.12.106-rc1 review
Date: Wed, 26 Aug 2026 13:56:15 +0200
Message-ID: <20260826115615.30574-1-ojeda@kernel.org>
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 25 Aug 2026 15:25:22 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.106 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
