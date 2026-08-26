Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D473E8C77;
	Wed, 26 Aug 2026 12:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787747536; cv=none; b=bsYMVrkeIEtO2jl8xSzkrrnvGPWV7YfvE6PX1Lw3+bVCgXmVwSE3n7WCn3jgRNXZTpfRX+2o133IMPw4DZnFPsZ01yxADUIwBjye2HlPh/nX3hmTNVWSdoxnuJvDYjlRQORZoEMgD5IH4LDstI9ECMrib1h07ZisbNGykj34YDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787747536; c=relaxed/simple;
	bh=YBfQhWr3hGAdYxy1pQcxhGEO0oadaJmUJbTPa6EIUkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FU+XHT4+6gcyXnwG4GCCe9NZQn4xcfqRcxxRnIXWuI0oPaP43BaSc9G9as4pd6Hksp3Bov29tabUmnkZm46v8PTiQj0zxkw17CbVQOol1w5C3WR3f756/EFCr+x9d81Wf4xMkBl5M42sprUObTZto0Wk1HoHtcD5n0KXs9WijdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HjQHKwML; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HjQHKwML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9791F000E9;
	Wed, 26 Aug 2026 12:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787747534;
	bh=YqwwWf+vCPr5nOmUOVOahzY+I5cvuPJzT4QMqWM82tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HjQHKwMLORNV78ltW457mY3gcGa6vCCkfV/yO8DKl64vzn8PlNt/aij3AVFeJoSWK
	 BW48SKc0OVsxVCbOLp/8osNWQS4wXy2o8GUXuY6l5F+SIY9uWXxZa7SC5dtdDtlnbb
	 YTuPdIUI5tmGCZ4z9sRMphTGBDRB9SpUNrJci+Y4fRDpT5Sah8ok/IFEpW3JVNLbJ+
	 eA8mF4qJs78iDYMbOxTrRqgOCCwm7M2LbetiWpk5o55Kmf1yw1bVOhOqQv5KhPi1YN
	 BNPWf0lSZhRzywlZlIe0cpgSL1eT6X7HUzKXbfRj5fEWhtwebEM5vrBvm1FnVKbWx4
	 BY7ZOx+mL+R/g==
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
Subject: Re: [PATCH 7.2 00/82] 7.2.1-rc1 review
Date: Wed, 26 Aug 2026 14:32:06 +0200
Message-ID: <20260826123206.34789-1-ojeda@kernel.org>
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 25 Aug 2026 15:24:47 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.1 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
