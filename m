Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B49530C359;
	Thu, 19 Feb 2026 12:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771505216; cv=none; b=h/5lXMuqiGOKBg+CJTWKrmMpAx8EnFjB7PjauhdyolhWQgOceONdPc63MX4DdY0GdBE6BV4wPCkkibBqbjq/LK6ldKFdE/OmjFVNC3+YdtIvCsXNuawx/U5kXty7xaUXnottYR9yBa9sk07hCqSVyPd3xdMYYUGHggwZ+oyjZbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771505216; c=relaxed/simple;
	bh=gi5KWdpzKGC15Hv3Vr33dnMizms5pt1oFYhL3oV+Me4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=roiL98JbGsA2cMoEWCrfAvAXvpLnqPj2MmJL+5xMJeh8w9q6ASw92F1fk3day4vB6tWDFf5P0tAOOLqkDfpkh83gtDW/dGkN4VtuASS3611wY1G15l6L4he/vQDjMdux7fUptcuXb2gWi5lhpL1V9tz46KdXqNBgV7+155DqzUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kIo4tUXj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kIo4tUXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025A7C116C6;
	Thu, 19 Feb 2026 12:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771505215;
	bh=gi5KWdpzKGC15Hv3Vr33dnMizms5pt1oFYhL3oV+Me4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kIo4tUXjP6XpHU0LQ/C3X8vfCbOJqit3wDKIfU7k6pubtfpKdHF5SW7vjAjsHuOZm
	 6rXRZh16rGTUpHeEBaglKETFgCXI3QFZxph7YHm6oJT5HWuJe39JpnOY9aABaplypM
	 O76OIRswjxwFWoNNt/M9LnEH5tpetEg0oiKE8foOpbC9VENqz4gtipzJwuYF8UtZ/j
	 yyD+xnKK7qSmlmlJgvy9ZPc6Ws++5NPa2VkayaOxilp59FD6b5ykOQzXWAarOpBK+w
	 94hhVDsDFwCqlcWdDfGx5M+QN9zAJG/mC/2CCn0gK8pN3cUmrYAAJGTWkqMSPOo0US
	 ROCMCW9nvCoyg==
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
Subject: Re: [PATCH 6.18 00/43] 6.18.13-rc1 review
Date: Thu, 19 Feb 2026 13:46:41 +0100
Message-ID: <20260219124641.29536-1-ojeda@kernel.org>
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
References: <20260217200006.470920131@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 17 Feb 2026 21:31:40 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.13 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
