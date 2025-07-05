Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E86219E0;
	Sat,  5 Jul 2025 00:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751673827; cv=none; b=hdodFfAzSoqrguNkTsi+Ks7o/d6pEkthyHOhnztEE0ktpvE/IK/ZIlqYtMiTIb/IEoYBHOzo/jzhB+BnLbVG0RT6eOIqEYJSiMaznlsgByzJP0VTKRDyst9S6quEOQgcgGW6QS8NWB4krzwSOyeW6EZjalkisjH2+jquuH7PPGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751673827; c=relaxed/simple;
	bh=y/vfOed2M8zK3BCqotb5LJU+AwOFUZQKBaTSpJbDeQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhKdfQr+fULlHABYjyGqJoFjkJh97ryFCSchULUoP9pdmFknD4w83BcI19iIul8gwvn6n+BAnfQW8ohVeH0gxKi3c5jgdJDWTCps9Y/ExQ32oxtWFA0rWNnPpZhRshSx3b9zCqsGrnHj4fsKWL/j55rnrLRo9vHzv66sDJFCGD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qIvA3M41; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qIvA3M41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B1CC4CEEF;
	Sat,  5 Jul 2025 00:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751673826;
	bh=y/vfOed2M8zK3BCqotb5LJU+AwOFUZQKBaTSpJbDeQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIvA3M417CRwp+bAylReOjcS6kf3BW3sfLUO7irwB2A5sMLYnzUr9R0mEMjElvH5N
	 SFk32hvuCkOlBRJwSCYGkdGZpu4ITke5HkKTy8wPkb1dyc4yH5ptuYW0km7OK3BBmc
	 T0ak4Apzj3ekXX0CUXT5xAUrdHvxCFNrC9jdx/L37+CITxhr3WW64l2lNUkv+asLtf
	 rb98hCXPSGTWW987BDKQMijMTdMVbDaUJQF3GjJyMGV12/IB4zcMP4rEEQ+Wugfj/Z
	 sviJqpoj5Fw0JSlLBFjUYzEtB0/v+d8toZBySkC2JqDycunlye2KpqHagnrvbwGiP6
	 wAHECNNHmMYYQ==
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
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc2 review
Date: Sat,  5 Jul 2025 02:03:34 +0200
Message-ID: <20250705000334.337124-1-ojeda@kernel.org>
In-Reply-To: <20250704125604.759558342@linuxfoundation.org>
References: <20250704125604.759558342@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 04 Jul 2025 16:44:42 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.5 release.
> There are 263 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 06 Jul 2025 12:55:09 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
