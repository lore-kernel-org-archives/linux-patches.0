Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5961C385D97;
	Sat, 18 Jul 2026 14:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784383910; cv=none; b=gK8z6pJo3iGFFTSg6eW0lTc44T4D2rKdGiL99Srg+OUzXdPY6EQ37jt0ia5NMMUKzHvSu/2+/V8aV/qhSKKcj0rhC4QfGHfBDBgMl+HgrCiuNmtkOeLbYXpd9Blqdkbqd8jwaFLDwc5IyMPZZ+x42bWndUgsyKIUf6bn+1OVmpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784383910; c=relaxed/simple;
	bh=erAc4HFvyvv/O6FdqjEfKgP67aqIhjzlmL/bje4xYQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVIsPitSPP2yZ9uNcN4mQss0cBiy5VrTOkmUrfBDwsQJEJTA4GqbTKse7xIAo+NFoPSo9KMmQdAFtv1gR3SUz4TUtP7YY+8YGPxfmf18lx6iXxet0iqVFta3bk2z6fFFzrJxVaENwjR+KVEL5FLk0yOxe+FYnIacNpm+exKC2zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B2phgvnU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B2phgvnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0991F000E9;
	Sat, 18 Jul 2026 14:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784383908;
	bh=gIDt1r93beiDShx7BRFm57xEWD75yxWybQQfRhTyHWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B2phgvnUaHOBkwP58pA/Nn4nfBRMXK7dA5EpqowpdF3i0pDgKJFXL/6OWpF3B+wdd
	 efzqYIkXF9dnavIyUS9nQU/uZyriymPulHTYEI62rFj4kWsqWlbHPb7K85PAsMHuva
	 zGs4WIVAS5xyGbXC0GhHugw0b8FUSEezUIZwovzB/lRanLDtqe365b4RGPWmdOh6e5
	 i4QFy3p15fM7cfae5gQ5hPXlFOyECvnwH2oSkq4F7gOcTMZDoOIrqdoJVy0CD0JSAQ
	 PHzSNP3L27bibVd2c7FhviqsB9EkKvYfT2gdauYd2uY/iey/UjXFxVsl/PQZcBfV80
	 PVPwH9s6fYSKQ==
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
Subject: Re: [PATCH 7.1 000/533] 7.1.4-rc2 review
Date: Sat, 18 Jul 2026 16:11:38 +0200
Message-ID: <20260718141138.84184-1-ojeda@kernel.org>
In-Reply-To: <20260717101912.682013354@linuxfoundation.org>
References: <20260717101912.682013354@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 17 Jul 2026 12:41:50 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.4 release.
> There are 533 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 19 Jul 2026 10:18:26 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
