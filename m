Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E763209;
	Mon,  8 Sep 2025 11:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757330984; cv=none; b=oxe0kZ3nlKpHwowtMBgeczUkzyk+EUY6ZhWK2vyZINS//7xMrs6LD8qd2bIkV/sWJBAch6EObqqDIqYO/Jw4YNZ8MNQGWLgw4XvZhcYtFHVqx+Wfl+Cche6O/VJ5Z+QEL5/AXYKCzKIYu2UM2Gu0khZGJZslj0j80cfCZ6MiyOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757330984; c=relaxed/simple;
	bh=irP3+oQ18wTbr4rYW2QKCfw/O4lQjgAAwBSuaobCyo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qty4EKmVmW9kPmxoBQt6xzDPOU9bn/bHQ6vZpQlM0Jzr2gZXRL7K9b417hodDGDh4pnNPvdXdl7yK0hUfjF64sTTcHpSS0ZYavbosJbcVrjnJeu75hCP6YBBp26C1ysmF0mScqAmGKmqtoQME42wLZZ2NZFAC9+jZm9iJeB7BX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mSqBGi79; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mSqBGi79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A86C4CEF1;
	Mon,  8 Sep 2025 11:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757330983;
	bh=irP3+oQ18wTbr4rYW2QKCfw/O4lQjgAAwBSuaobCyo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mSqBGi79FC1O2uwkLsThWIgdM//DRf7Ugq6wIgxHwd7KDFlvWF71QtmfzrCS4dweE
	 ZFIHcEoaghJRg6qknKT/DSVw37ITj7xbFciQWo0ex4iTJb2tvU5b/uHWSydXcctvhf
	 KbbdfOVyGoZ0FmuSC5Y5ocTdjyJ7iU2AGb/8RqvSwCotRe2hLaX6Vj/AjdvbUhnVuy
	 tzXNCk03WQNFqwwckoSJlUb0Ekx4O1UVUuNXBliV/495xSU06EpjAeoIm/sJQovpTG
	 QQ7IXWutT5z9fd1E3drd6SeP5RwhU8nijHtHmLC18QmyAudZ+pFPxoORFSPCrVnbeY
	 Jjd853IAZZfsQ==
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
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.12 000/175] 6.12.46-rc1 review
Date: Mon,  8 Sep 2025 13:29:29 +0200
Message-ID: <20250908112929.567658-1-ojeda@kernel.org>
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, 07 Sep 2025 21:56:35 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.46 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
