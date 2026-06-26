Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735211A3160;
	Fri, 26 Jun 2026 10:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782471284; cv=none; b=RRiB3bpnW+gYgNSHC9evOA6rfsYh/dMFgTVaYFH4NJrHCtfodLVze4WsDUb4l6kjWyI1xgKxEhJ+7Ra17zG2N5rablQvo8CJ0LVjNb0YRpvAVQNfygjMKIz+NZfZxEJspZHiiOw/MhFI9gCzkKU49lRocJtqR6nik1EL18QGCqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782471284; c=relaxed/simple;
	bh=m38eR28kfXr0cfXv77H+KJ+YjtyUQMtyjDrsUuZSb/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fznh+AULcI0vSNfa/ELR3jUFkSNmzASc7U1zG8TWX8vVBnw+bxU4hGKUQiBwxFb3g6dr3oHuMOXkXSfVcRQ4T+FIC+Gh2FKerY8uhMhC8G7+77iDZWxJNUc9c9oLzU6VBiY1RREUumeZlm1JM+NekPbgXZ+0NtuB1ZMgOdcQM7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YzANUB1a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YzANUB1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5891F00A3A;
	Fri, 26 Jun 2026 10:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782471283;
	bh=ZqMejLOAB1lQtPADZ7tJuXQq1qqhcSX1bAKtC6GZsxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YzANUB1auHmxtaoHNF4JP0nLlanwZNyD79FcL97ZiqwBkRy+9z9g8UsfH7kT0MCe/
	 IG2GVwg3xrmz/picdtWJLGsjM0DYDzv1XclG1M4xLohvtHN41CILqy6x8Zkil7ZZgq
	 g2wFpQE4wYz40Iq8vrQhm9r19vSNBWTe6eBRMICi029t1Du4iG4URoSg7MTPcr1JiE
	 e6ThV/A09MSktUx8ArY+OTD9cqngFLuYzn004VKr/D/3m7EBpVTRFMP1bdoAQHmUPg
	 pC92/XHZoM/rDPRY6aTOghLDFZ051Q2TX4V0RyWhpYuArWpmkod+NTF8fjaFDGk7YT
	 lT/pBbEK0SOsw==
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
Subject: Re: [PATCH 7.0 00/49] 7.0.14-rc1 review
Date: Fri, 26 Jun 2026 12:54:32 +0200
Message-ID: <20260626105432.733250-1-ojeda@kernel.org>
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 25 Jun 2026 14:03:12 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.0.14 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jun 2026 12:54:50 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
