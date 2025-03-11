Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41ED264601;
	Tue, 11 Mar 2025 19:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741721042; cv=none; b=KOb356+vo4ffdBVUYUxcjp5YA91Qeu/EKSiOeUVVBnjFb6a/Sz/CIf+ea5ILiPCKBRdABGzOoii7FjvUs3j0NNdTK617Had8QN8gKhwww+QLjEvbMSKd79lD1y9aPP/keRhNNXBusyN+fcfmiCFZOmCRODeyGfm2V97xyxqbluQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741721042; c=relaxed/simple;
	bh=k6QmueGzD8V+0Q2ywX1xqtRVF6wmq0BJj16YXfmVTgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/UexT8kcKvHrwnKznqVW8rK5d1lsmwLUoK2oCHCH6efs6reHPzPgPFLhdyT1MsH/AXP1N/O6Ahg2mNM0QDO2fVs00qEtbON3OW6fL6IGoC9cYZzKBtF8z1bZw8d1YllZFFne1Pw7GpeXahjuZZRmMPYZrlxbd1JmPMMB+DDhKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NPSZhie6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NPSZhie6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C85C4CEE9;
	Tue, 11 Mar 2025 19:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741721042;
	bh=k6QmueGzD8V+0Q2ywX1xqtRVF6wmq0BJj16YXfmVTgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NPSZhie6J8sbRyyqsuzG3NK1FWhHCSJuFEjnPBu1NnomqcMQqj3mrCXo3RtSWxfj+
	 /xOrpEIUY+qnZGL/vOD1+zGYvp2KLI9WSApPQPrIwAoDVWBf5vUp0a2L6ae9j1ywE/
	 XuerGkWVnRDc49Ro9HAOn39Fwm8SSlmHbNwP2A6OiK9Q5uQmemffiKaN1fgCSezQwW
	 TlU/EKwn3QrUOUy6D7nuq+WU7VER1h0hpazu+/+Hm6B10pP2XftB/WKa1v14jGpGrf
	 zcoAkO86OFk7gKOLCNJR2T2kXX+lE+YnduRv4NfyG4yL5ku9gZR2jtULuiD2AY3dwI
	 F0yFPInsS/iyg==
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
Subject: Re: [PATCH 6.13 000/197] 6.13.7-rc2 review
Date: Tue, 11 Mar 2025 20:23:49 +0100
Message-ID: <20250311192349.1814933-1-ojeda@kernel.org>
In-Reply-To: <20250311144241.070217339@linuxfoundation.org>
References: <20250311144241.070217339@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 11 Mar 2025 15:48:06 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.7 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 13 Mar 2025 14:41:52 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
