Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B2838A70A;
	Wed, 17 Jun 2026 10:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781693558; cv=none; b=LUZQzyUnYcs8HV7it93aNnvM6Uea6PEGtWcZ+DNXHOBFC1zZjBoI8Abu3EAzZN6JXFdmJHWa3srUfIfl8vno7aKb+EP38DG+fTkxxVTdaD6uHEGlUBc3u7sqtKquRyvjh0UOHZVxeyAD4K23ARTujvDgfmU1zgOJEEsa8W/KhzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781693558; c=relaxed/simple;
	bh=RzyRnT+ZdGYv8bl8mIGHHM0FXc9NpkE4ljb9Ulg+sPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PwpcQhAYVvLpNt8HJM7Ls5S6sRRcIQsSE1mdUam2OZc5FBeTnRmb6LeO0zq9oZYfEzO1O+aWUBENHhVLIf2SjndJmCGeWGErn9Np+mAJI6vsctFkeWlWXvTcIs4Db1LQ5j/4/dRHjpvOgJd+F65J+pS4A9T5wYPMzfGqh0AM7Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V6Smc0vS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V6Smc0vS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC61A1F000E9;
	Wed, 17 Jun 2026 10:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781693557;
	bh=JZbqZkhOUyoGmziemqJI68Q1d31jAqXsJS2bmYS07Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V6Smc0vSQ3yi2/gOE1t21X4E9plY3brvOYc4sauTy0VS0I8Bc4jQJqj7egk+3/6g4
	 vPOyiASec3QFFQWv2EaRhKuCC6VGgklr8ELnUefRU9TIjTI2cMCUtzn0gRh4F4BvjX
	 SfnL7ncz4R5ATdIFpxKJ1kIYAWMGUj0vaOL/GgKDd90eizPzfcvcL6ai1emaS9wO+8
	 tLQVxJlZx/K0qxQhg/6aqF9UT9bLIrMc19fsLCJOUDYWdnZTLw1QxRBUGNEIbSE9EU
	 aYmcObPRbIfP7AXm8khvNMHSdKSpmXrx6lZTE+RXpeYk4phH3O7CunwEWT8JqRzbHc
	 F5hMR6z+35XCQ==
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
Subject: Re: [PATCH 7.1 0/8] 7.1.1-rc1 review
Date: Wed, 17 Jun 2026 12:52:24 +0200
Message-ID: <20260617105224.64682-1-ojeda@kernel.org>
In-Reply-To: <20260616145523.335696673@linuxfoundation.org>
References: <20260616145523.335696673@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 16 Jun 2026 20:28:45 +0530 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.1 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Jun 2026 14:55:16 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

arm32 looks fine in a couple build tests apart from the known `rustdoc`
1.85.0-only issue. UML looks OK in build testing apart from its known
warnings.

Thanks!

Cheers,
Miguel
