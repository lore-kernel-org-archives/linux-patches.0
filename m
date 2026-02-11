Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D38B19006B;
	Wed, 11 Feb 2026 13:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770817527; cv=none; b=UcB+oOkblVceICvhrgnyCvXWGbYQ+q6kccs/CX1kfwq+vtpXnpXQLL/4Qvna9GPqNSt4sqwyh8SRizueAnXEg9zAp03WTm9taf02FK9M4MbiJ8AIvXeDqLcAcIYbjBc+ypI5pZFbjkfLODahMPxzXu91roJC1WFtMhXdtw+Wp14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770817527; c=relaxed/simple;
	bh=sgMWSY/8idjGe537TFWmxoIS2KpMGZbag8qTxlfguCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jmge34umprJEDCp9VnNyfgvnw+nj1S1x5okspkjo/zNayJ5UiseNuJmof/sG+L8n5Yuu5AVFq/+oA9k7bblP5s8mhrXi9ebTkjVhVU1qc+3h2NZ0pWKC/vYzRX69Je0bHZncpmc6Tv0G78/lcdvMNWpAensTiAF+z3VcyQyIZQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NGFVVN7Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NGFVVN7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBB3C4CEF7;
	Wed, 11 Feb 2026 13:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770817526;
	bh=sgMWSY/8idjGe537TFWmxoIS2KpMGZbag8qTxlfguCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NGFVVN7YLPahecBIzxjyVdxaYtyjBuBCaBYck8N6T331iQvKPByml0jj76X5FM0wz
	 XYe6bPHP6fOqeu4WKYN+ZR879waXVIOXH7zhHioI6b+N9T9HRTOwcaeF7pMhp4uKT+
	 9uAH33sNBfFdgKeuIhqNfy43G5gNfftxGv0CvkbjrHaRGYUjvhZV3zKic2jQKsh1tV
	 DdMzceycDF88U16xcQt9pEbkO0Sh5vBnccpjItqUS/j1LJfYUcJWD4FG7rGXuHRn3I
	 hHazcL8JmWsWH7aN7OILCyTCvMTazJ+mwl9Nt0SACQB6Ywx8IKsRRl9dv1jWm+1VKX
	 i9FMHfrCwXj+Q==
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
Subject: Re: [PATCH 6.12 000/113] 6.12.70-rc1 review
Date: Wed, 11 Feb 2026 14:45:15 +0100
Message-ID: <20260211134515.11087-1-ojeda@kernel.org>
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 09 Feb 2026 15:22:29 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.70 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
