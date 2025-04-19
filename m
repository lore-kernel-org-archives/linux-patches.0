Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A511172A;
	Sat, 19 Apr 2025 14:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745074159; cv=none; b=oyLeIuzJ9YepPPyC8tmwZZZy6yp1tgx092GsNos0eehlcyzCtMTa1cC4hR1RuBkFtm7FJd5/l6HgSL18EaFq569P8vgx9Fp7K7RsCEXt305+MLgiluWzjYaKwoRE3B1jQ4Q4XkN9J1MspQKdV1EAfboAMJSI4fg5bYq1vkkS7AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745074159; c=relaxed/simple;
	bh=ioNnVlZlvGDS9LH+I3MFLiYQFAADvS2aas/MxFhiQkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0SlTDxJzturLQh71aX288VlxALn35fO8wVjf29PFSjWLDBBIdFuc0z5pmgTU6D2YDEaCvEHvTghFJ6L92QtGlwJ+zl+4yVbzcoQBCRs4NiuqCJNiJ1X7Qq5B4CT9rBk/2zCyS1S9b/pXRQgrP7o+EWN87kMHU4Dzderf3bJbwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XJDPX8B/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XJDPX8B/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE543C4CEE7;
	Sat, 19 Apr 2025 14:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745074158;
	bh=ioNnVlZlvGDS9LH+I3MFLiYQFAADvS2aas/MxFhiQkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJDPX8B/UHmczYkvYgqCVb7aAaRrT5WwkL/wRvvEdpxwUQKsQKdcRjgL5Qb6qjYeK
	 mu70STjbKapgcps/6TJgM1Mpfe/Sf+TlLaxT5qnlXR1wGv8/3L3pofqfcAyKg6PqXJ
	 Wc9Z0NOlYTjq6RHpWcxt7lJzZUX/LnZZHY7y8xuPqDavOFPq3TJokVYIaalSACn9JV
	 N+n/v/NovJBVq1vZf3J+flEPRtqBKqBhyJRWJ7AKYcEFBb/YYMRWNDW5/KkgvQiK+9
	 hPWNYqje3IN97mAOJx1+8zr1ESWR9Ouqmt5jb67lneADpr5PEprD8KU7SsQXc1w8Up
	 wqtuqHqXtN0+w==
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
Subject: Re: [PATCH 6.13 000/413] 6.13.12-rc2 review
Date: Sat, 19 Apr 2025 16:48:35 +0200
Message-ID: <20250419144835.3014680-1-ojeda@kernel.org>
In-Reply-To: <20250418110411.049004302@linuxfoundation.org>
References: <20250418110411.049004302@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 18 Apr 2025 13:05:17 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.12 release.
> There are 413 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 20 Apr 2025 11:02:49 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
