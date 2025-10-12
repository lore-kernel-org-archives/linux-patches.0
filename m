Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849BF15A85A;
	Sun, 12 Oct 2025 09:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760261454; cv=none; b=dxzaZUI+dAixxc42VSOA6TcNXzHFIx/jJnmpQfWJ73rUwF88iLs3KmvQ+LyOvCqg9NFUpg/WAn1rAfAFBRIo9FzZQcqOqCwSqVQ52LNu/hRlZ/Plb4T+QSRbIG/5nOThDNGazmbqJKE+oaUh90etxrwFa5jSKSnfYc9IouO3IBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760261454; c=relaxed/simple;
	bh=G9YCG5n8HREVl7xKZQ7GLsP2lDoz+LbQ65wI+JJRjPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEbedfyvmc0vU/O9OehCYAfA+TuqArOXT6bEfFqeUgGnPjXr6JGf+VBamdMmtTK4n/USwsChVXQUFIkH2n19LP3Qcu8ENW5/2VNC7XBRNpaZTtCr9BaUXOgWfvanqrZ9QyBVs4cbEnms9Xp35a1oGP0Zji2G6P5y3Scp+WxHaLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jjWvMBOC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jjWvMBOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862C5C4CEE7;
	Sun, 12 Oct 2025 09:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760261454;
	bh=G9YCG5n8HREVl7xKZQ7GLsP2lDoz+LbQ65wI+JJRjPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jjWvMBOCKr2TaUJ0QrUr8OBDkxH6neI5rwHZNMxR5sIAg9IXdjh9Xksyi5wRivyCo
	 KOFeHWFi7tOWW9Qm3Vvi4T/Ee/nXIIk62FoyirC8hkHazD7X6jVIHx0C/C5rBGTCSE
	 eCuWgNLWm9NiE0GrTOQa1YUqBMZjuB5A/KNqAV9M7GolEzK0VO6LNBNDEeb19/D33k
	 fDHgb0ReTK/9og+ayz9GLwjQjKtbDzJZa9I2fCSoJ+W52cV+KBo5gohaNRhS7znD8m
	 wETeJk981w2EqhE0vbLGxaCfPg1Z77qThJTcin4f4RiCGMjCC0y9G+i6FuICVq8fPw
	 vUWmGNFZ9o70A==
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
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.12 00/35] 6.12.52-rc1 review
Date: Sun, 12 Oct 2025 11:30:43 +0200
Message-ID: <20251012093043.997888-1-ojeda@kernel.org>
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
References: <20251010131331.785281312@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 10 Oct 2025 15:16:02 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.52 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 12 Oct 2025 13:13:18 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
