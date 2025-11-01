Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487677E105;
	Sat,  1 Nov 2025 21:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762031779; cv=none; b=SkD566bUar9BMiyKyqcKV6BB2plL2VbO/z8VF93Uq9AN/kGmiyrCTI+EMWLYqru4BiojuekLA1fFdPYnGBYGxaohXb/lkb11ay2+IY7gMXA5/ks12Gq2F50QVmHfEOAo4Boq3QDuPTrVoaxQZKuM8AUFgk3z5mfvsqiH0FD53zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762031779; c=relaxed/simple;
	bh=3f5jGbLEPiTFaHNajvzVZqE9JxNvQ6mJRJ/Ahx3sHXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhD5n+0iikvZYsDnoc2ki5mivEsCo6AVq7+nyfiYhvnUCepZQx+dhyv/Erw5risw06XkafSndg3pqhOVvd8R5tZo/VM/jlEX3/9e8jC0HRuQC3yVgvqBMcg6cwDH1ZQexHhPEW1kHalVlI7RdW7PBOlpPzRZdjgAb0dMtoDXnR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CnWm/wx1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CnWm/wx1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FA4C4CEF1;
	Sat,  1 Nov 2025 21:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762031779;
	bh=3f5jGbLEPiTFaHNajvzVZqE9JxNvQ6mJRJ/Ahx3sHXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CnWm/wx1c672BzY+Fy5EmeXjxCYfb/bQExn5kCITKp+YEaVb71ua9hLzTzo8pJ7tQ
	 5geTPMBIWLKAnt9smpTNH8O2gMQJrEZB8HG3uqJrDsCcAjuiUpPq3rGhw031ByWeWL
	 X12zCmL372x/XmHak+vU42Do15jLD/RxidZ+XQ/tni1jULz2b5/hR1fJ3O1ZIKKVz4
	 qxS0Mo3dUWynrTn01YYSm+FXWbw5mA2RMTRKAFeso3U7gA38V6sp1OhHhe9JmTAEFw
	 HxP1XuQKAfn4e4YaNVtc5z5yqCPmEcXhMM+uHtPmidhupS5rYDke4RjQTkUlQxqBV1
	 CVpvLvze6A/ng==
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
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.17 00/35] 6.17.7-rc1 review
Date: Sat,  1 Nov 2025 22:16:07 +0100
Message-ID: <20251101211607.1121626-1-ojeda@kernel.org>
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
References: <20251031140043.564670400@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 31 Oct 2025 15:01:08 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.7 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 02 Nov 2025 14:00:34 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for arm and loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
