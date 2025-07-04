Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9B41A0BFD;
	Fri,  4 Jul 2025 23:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751673161; cv=none; b=S3o8DLkMe6iVZBS4fXvUNfqKfusgjUC/a0BnLxiPPeGqfSDtmttmqI8BusyGmwh2k7jJ9zpCmpYTc753tNPlPTHkQWFJQoYGef0fjPzmRYaK/gf5xsreLILW1DOFSA+UrlkaHA6IlwaOsS7jDvuPKnwDTsunJzA9TActSn3xLk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751673161; c=relaxed/simple;
	bh=zl68+y8A3XaAPWVcQHppKw5TUgcWcJC1o59Hc4Brnk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZ5t4siDN/8HvpCQRl8fM5emjz8nl1+HBQUQsrQpIyWytazWDjE5utVbhAD/SbDA5sTbpb4ZuYFmO7WcHLYg8NgEIX23oAzb71hKvlFoYxUE33ECE5c4PheQs145tWvyNMu8v2sXC51SwzYr8q8HmV4QuEbQAzxbJqD3Wcv8tCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dKTgo1dJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dKTgo1dJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B72C4CEE3;
	Fri,  4 Jul 2025 23:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751673161;
	bh=zl68+y8A3XaAPWVcQHppKw5TUgcWcJC1o59Hc4Brnk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKTgo1dJlZ86O9KDuLKgWneVDZcnliuS31wGWLH2XmsFP05Cj0SRGP58Ridqt47Ic
	 2a/OOPEfi4z9/yOutR00tuzW6iaW8d4p7yASygm/Zr6Z44brcBVZCJE8Q4xngsSqvh
	 zAvl6QybgfGJO9uPinD8gt1ZpR57zgu4L7WzyH/0ujs0iTHKCvOC7xskCXj7XnTkL4
	 0Nx+ASNuz7+Bn2k/0JQRj/aR5tCgdBPdIKwRd+wMcA//I488HybOH3KUC1M7Ni/dd7
	 9QLl9HWsUlLJgOphcgij00UlH65gtiqD9ios/8PKTUTIn5b1doYKsFFJof6o5euRp3
	 kXThSnmpAr9nA==
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
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc1 review
Date: Sat,  5 Jul 2025 01:52:29 +0200
Message-ID: <20250704235229.335965-1-ojeda@kernel.org>
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 03 Jul 2025 16:38:40 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.5 release.
> There are 263 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
