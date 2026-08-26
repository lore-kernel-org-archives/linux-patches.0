Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761761990A7;
	Wed, 26 Aug 2026 11:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787745217; cv=none; b=leL/udrOPqsB6PUJa1n4fHmzXwCGEGFXKAXprFtZwtSvG8SmydS22FbHYTxqS144xMFsnb/n6A4XG9Lj78OX83cZARrhF4zvD5SGp5/LjA3Y9Rvv1sQRjJB31haTfwL7iyCAg0j09Ks8EOEzT9hP2Zfr2hhkBkvSomGNZ5Qo4Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787745217; c=relaxed/simple;
	bh=s+D7baRlDOM8iPtjvvdOIpypR5wnhXNZDujp85MNIlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ib+Z/P3bdNj6OPAr7HW77uNE4AiC2XLoEC5EoFOxk88XLHLMjzcEYIaXohcvYNv42V0yNIoVXfKVpmYiw1mi2iV0/S1FNLPrTN4h035Srw87zQw8Ru+PB8wDe9OqsLTwZRd6DvXhRSx+CWsz12fKtu/+GWrcqrzcCtz8/blkleE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hSUr6mGk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hSUr6mGk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951011F000E9;
	Wed, 26 Aug 2026 11:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787745216;
	bh=SZYLk3mDBhuVACUJI7xR0jKFB7wnW9oKOZ5d2BiBhxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hSUr6mGkIhaWQ61QcKKyysOkFnUgSRooaSi8xZgXSD18D7iBg92xxq8XPW2+wNuSV
	 z7wTfPJvyg1/bF+EwJJRqF18CQ21XKz6OpefgTXBd8N221IT12dRbX4DTSb8hQj2fW
	 ZC4/RvVNFqbpQSRRMqfC6dV69B/8CWTNNWPqUF9esrPSSbQYLDCxyepZR9YhPXWEu/
	 je3gn7iHNa6X640LEAf/Pbo1P1PG2XyVVEgO+PeCkUQ3jpjLWXz6Z7ik8Vj9+os4+5
	 RsVtO3SzourWFQHRzaPw/veZEQ6QE6qn6QEPE7Aov8cbA7VIf4aEKmMSoIThpBEGqZ
	 Uy+4UIV7A+t7Q==
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
Subject: Re: [PATCH 6.6 00/87] 6.6.154-rc1 review
Date: Wed, 26 Aug 2026 13:53:27 +0200
Message-ID: <20260826115327.29946-1-ojeda@kernel.org>
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 25 Aug 2026 15:25:23 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.154 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

I don't have the Pavel's reported build error on my config.

Thanks!

Cheers,
Miguel
