Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9303976B1;
	Tue,  3 Mar 2026 21:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772573345; cv=none; b=cnUc27YV/08cUmD9eQisjwELYyFs3qjCXl/2y6GoyIHbfFBncqsfluaNv5kuWEBFdCfskTTdwbGrSRE8zTTQMqRYfspc3jyRRpk7i+mHnHcNw54RcuHSSK701h3ITypTPqB3lq2Fw3csC7VkLJdJVJ+ynHJjEkeSQPDQlujwzRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772573345; c=relaxed/simple;
	bh=FNBn99zWMFS1B2kLhsSR3zwwI8olzxkNE6/uFtUm40g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spWKtn1YC2U6LgpBmox0Ao6KuY0szgnUIe4b2Pd/AZkHRiEp8Q0ctKMwuhv+Pp3ZQmFV/RhTtoTAAEniH640m/7UQtEjrLBfy80Uilg8z/XzLimttxwx3P8vVq2Te3QxjnR8hEeY+3x6lF7r/WdzU0ynTi0b7Pt4jdSRswa8NTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GVjbeUJn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GVjbeUJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9D2C116C6;
	Tue,  3 Mar 2026 21:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772573345;
	bh=FNBn99zWMFS1B2kLhsSR3zwwI8olzxkNE6/uFtUm40g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GVjbeUJnv24/VOwev3lATGf2h/hRuZMw3U4abHi7EQHf3La8KDpV4Mts7mz+39HRV
	 BQKEEbsKPj9Wyg5Haz+QiJU18FpXLAMr4Uj50Wv5GRkWzrWaxsR5ixDCmqiIumLSiS
	 UNzR7BlA8BSSxsHZ+um0gyzkthLMb/qG3l4y9bAaMhF9/0iKc/ISGlf0+Ejs7Ls0vL
	 zLSz+aNqhOFD1bHHOkS7XKkLBg+tngoQHdU/IdbByRDPFVzUxt8dvUAyuhdNBc6SFw
	 ZAGv+UB9lCbTx7fGPwLhM7ygr9Qh5z3DAFwamgbH4VW93dE5wPlPDn2+EaZ3DC0QLp
	 OjK480LEq8j6Q==
From: Miguel Ojeda <ojeda@kernel.org>
To: sashal@kernel.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	gregkh@linuxfoundation.org,
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
Subject: Re: [PATCH 6.12 000/956] 6.12.75-rc2 review
Date: Tue,  3 Mar 2026 22:28:55 +0100
Message-ID: <20260303212855.109987-1-ojeda@kernel.org>
In-Reply-To: <20260302160918.2520730-1-sashal@kernel.org>
References: <20260302160918.2520730-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 02 Mar 2026 11:09:18 -0500 Sasha Levin <sashal@kernel.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.75 release.
> There are 956 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:09:04 PM UTC 2026.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
