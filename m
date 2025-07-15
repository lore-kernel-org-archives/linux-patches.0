Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C20277C96;
	Tue, 15 Jul 2025 17:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752599028; cv=none; b=pPS3m75ATSppH8H4YoYHITyLQ5XuDdheIgB93xe6CaJ87LOWxhyhGjVywGEGkr4VGKmJBIhnybPmdUQI4SMhTh1gSny/p77Nfy61MzQAYUladP0DRE7rQfmohR8a5Gu9mY/xWJ8VWD1J8zO8dAE349ndK+1NWQKgCL1zNMwBy2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752599028; c=relaxed/simple;
	bh=OQxHzRlxhjv5rvvApia8hA5rWTUOVfbgYba4MOohpmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MdhK6WCeNheS1csqlBC+eZWpDJ4jYqu2KxGQQPHfKK+XdsSJtMCpf657q35xiI6Axd7v8v9/1laqkK29/vysS9s6vcKeh3x0xiENOBeO5FlNXCddtlb6fkzOHmQ45e3fO/66y654F4ogsRrXsB8x6Y7EQBhYYksqKFbF3xUSA7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LO2HDSwz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LO2HDSwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A339C4CEE3;
	Tue, 15 Jul 2025 17:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752599027;
	bh=OQxHzRlxhjv5rvvApia8hA5rWTUOVfbgYba4MOohpmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LO2HDSwzzWxrS2RiDyTPogxxJMKbzlR9mCuQY4R68xllweIpFrR0VcDZuUvxGfCDs
	 S3ZjDyNymMcXL/CGA71Bb9CcsHmEXF9AA37j7wdL83TspiS++dv6PhEmTu/rx+v54A
	 mSq6XLrx6QWGC0Ivp0puONpeqeYHwGgnUDMcoU+zHfdkX/pEj10Plgahlz7oYSDLZU
	 tPgXwldpHVB++wu3Nm1qAfr8v3ArSxiSviR8Uz0vIWhTRKgRAbnMiIyUOQqHM2ar9n
	 qARImubRwfiRKlusrWlwTb6pJ26w8GtkwVRfJnyqQ5FeJiWEE2ScVJtemJkJG34tEo
	 siVNTgu5TozTw==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
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
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.12 000/163] 6.12.39-rc1 review
Date: Tue, 15 Jul 2025 19:03:34 +0200
Message-ID: <20250715170334.2137109-1-ojeda@kernel.org>
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 15 Jul 2025 15:11:08 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.39 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Jul 2025 13:07:32 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
