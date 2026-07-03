Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F739C8EB;
	Fri,  3 Jul 2026 00:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783037758; cv=none; b=l95JpeVP5UKkNRUdKom74jXwOIbuNmb3tWeIpdozEhRcfaB4Htsdsuz1dQcXwsIe8CjSSDrJujwOEEsNhyJnjZfdDOr8e3PQJIJqGc0+1CbmmQ17AFpabxAxrNLMscxkXP/qN6ZfFz9ZufMsTusSlaAqK+UMP4taLq4cBWWlH7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783037758; c=relaxed/simple;
	bh=zJg35A6koDl4wONfZDExkhwfKrGCj/Yx7dNmDcf0fcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCJZ6YbaEJNQjHkBsxWrF4CynDBVjvFlaufQvfUgVb4xiO/us/ZoHOe8h5FIJv9T2zZsx4YFcMa2OYgs1VFXo9pns/krAV2tyvsFtWrg0b8ELPUPgclmd2rEFqpN9aITWSvk6POCMKIbjpS6PMiCgtmtMIyEsjQQrvKUuAlAJHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ak9bLBaa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ak9bLBaa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345B31F00A3A;
	Fri,  3 Jul 2026 00:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783037756;
	bh=5l6c9rHedxHWKbI/GYNxv/9iK5Y7e5jzABUhYqQ+mfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ak9bLBaa07/2n0r+V5Bf/fN6KyXp2cwbW00+8XjVcKBL/Sjvfn9y83o08B/9KebRP
	 n2z8eMWh4JJP2NgRrjmxHUGD0VQ31sprN+FF+U06r0HP2A7QAFoHW9N/HXqcl6HQAm
	 rMrn6MAvWlvHbh8iIC3RprJbvO9Zr3dhG1j7FbDbgd/QFR9Bk1ENjC+ekd4PpOA15E
	 yIoXvb8oCrcsppfbxSrIsjpKB88/+r3c8r0wbCtfMHuS/u3utRZHWSegzay3Q+kWKL
	 s5trVwT8VBUovrPnSEtr7ZxMCi3wAWx+LYk7/ZyPjDBQ2idp+gESzH7vUJsyDSP80u
	 KtDJVPAMVdwNQ==
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
Subject: Re: [PATCH 7.1 000/120] 7.1.3-rc1 review
Date: Fri,  3 Jul 2026 02:15:46 +0200
Message-ID: <20260703001546.13180-1-ojeda@kernel.org>
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 02 Jul 2026 18:19:56 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.3 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 04 Jul 2026 15:50:58 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

It would be nice to get this one in for 6.18 and 7.1:

  3fff4271809b ("rust: str: clean unused import for Rust >= 1.98")

Thanks!

Cheers,
Miguel
