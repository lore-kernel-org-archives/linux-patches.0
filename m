Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2D127F01E;
	Tue, 14 Oct 2025 18:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760465081; cv=none; b=EX1P4fD8DXML11AFTUZGJCkk+oiMUYePeLJhb9nUZcNix+iagi3z8l2nBnlTS1ZKEnNqIE32Ifzvv/G4uoksVNtcCiGcyuVoPL89gvSazMTlTtJWh5BSDYsdYJ7UY+0TqccRHNJdcDi7y/RXHBg3+WERZiwTjS/IICUYw+R04+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760465081; c=relaxed/simple;
	bh=IqiskO3RSo2eB9VA4X4UEsFaK4m8tJb02yIF7nYMwQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2Jx3ihVHN736WSufWGC4KeFVyCJqMmyE1BjM1fjdrHfzWSdpQAqW6rXG5lIxxPbl8iw/jRK3gJjhVi9ev0cqet1MN9jjslz7SI+Tuiu9Fey5B5YyNLAboaAbXqIh6hSvFfu1ffTNKZCui3ahlsFzMT26dKbT32Yryo3yWIOcdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RCPVz/w2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RCPVz/w2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABA1C4CEE7;
	Tue, 14 Oct 2025 18:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760465080;
	bh=IqiskO3RSo2eB9VA4X4UEsFaK4m8tJb02yIF7nYMwQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCPVz/w2h2kokkBxtR3H0LIbtAmqXHwB2m1032o3TGXdQ5DweVTNbxkqW8mRfmZz1
	 KV4rW4V3M4lcnsC+yXHo3DGL3WqAxMaK+oB+s6VaR664EFVKW+uSfXnqKWARKkqLv4
	 ZzSwczE1tcOWHSF/OrzBfbHN6t2LN81YjXIO7y4mTjcyOEQBOQatb2icL/DDG8IXg1
	 Qslh97sdDFZMDdu6lcll9FxDlr/5ejFk2Cr5fc4YQB7cnGZDI4a7gOrI8p10pQR8iH
	 Y0MUR+5+PbdsfOyJQ5iCM88ORa/BaKbjWuwEn9Ftor1bfsVk+pFdp3+3hin1Qv7OpT
	 sKxErrDHTvi/A==
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
Subject: Re: [PATCH 6.6 000/196] 6.6.112-rc1 review
Date: Tue, 14 Oct 2025 20:04:31 +0200
Message-ID: <20251014180431.1256580-1-ojeda@kernel.org>
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 13 Oct 2025 16:43:11 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.112 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
