Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015F71172A;
	Sat, 19 Apr 2025 14:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745074214; cv=none; b=IYVZV4trccd7zHBCusmtL8LE6AUlJ7C/9/wfGGYdE3GOjCJ6Q+Ru1xMmATuedrwgf7jQJNsC3+UExPdAtUbKJMB1t7b0rlfcVHwEAEh9IJPxJ4rwNkUCksr+JjtWKgxLuiTH6nTeJ4tXcVQ+e9JcVGEyIsixonVwGoCx0LjpWrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745074214; c=relaxed/simple;
	bh=A55ZDXiQcXNrc/DuylvOem1ZNAnMufIUbAAgwoSe7jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GwOZh4wzw6I4Rb8leD8c5rDzkwYAu2+NNIxXsv1OrydfdsM5pDon/fkCasfK5l4JvocUD87WJbBePYGVA+vvZUN9X/kkujSyWR8XVyrLkw/lmZx0hgsc4pDG+FzSjkdUBpErFqCwXksgxdPEvqWLhjl8eKGOFSXQL5CL+uAd01U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TTCYOBck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TTCYOBck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF38C4CEE7;
	Sat, 19 Apr 2025 14:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745074213;
	bh=A55ZDXiQcXNrc/DuylvOem1ZNAnMufIUbAAgwoSe7jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTCYOBckyIMH8anlEKUWeOO8ky+WvFdF7Bo1waBkXCjK41qVYljKU7u+IB8ya5GHS
	 Di3CUnMCPSvOB+uxcSWGjlOOsBCIc5LKmwSA+wkF2uVRDBdRuxzFtMzxs1ep8B/Evz
	 hvbh6xHdvqV6qR6rwXCKomBEKyb4nqCM7gi/diZNY9P2kTBAURUKeCngge/nkFtqfj
	 XaO713vhZN8X9HHa3x9W+J/sg80acjifkj6k7sdVZZiWFpaTw60yynY/eqXUyzPmrN
	 RZXll0Ksi6dA5wgmZT7XeiUdhjzZPvTRPVIIhsosw/pAwpaJXx4b1wzZoetkZpty/6
	 m+Cv0NE2bt63A==
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
Subject: Re: [PATCH 6.12 000/392] 6.12.24-rc2 review
Date: Sat, 19 Apr 2025 16:49:58 +0200
Message-ID: <20250419144958.3014830-1-ojeda@kernel.org>
In-Reply-To: <20250418110359.237869758@linuxfoundation.org>
References: <20250418110359.237869758@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 18 Apr 2025 13:05:08 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.24 release.
> There are 392 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 20 Apr 2025 11:02:42 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
