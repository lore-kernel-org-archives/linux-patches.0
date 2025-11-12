Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D24328B73;
	Wed, 12 Nov 2025 12:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762952244; cv=none; b=m8wq+CXo6PQo4zFmRDIOBh8QYsYhIWLUaVwYLnj0PmNuTPFXzBuD5WgfjnYXOZ3Ss5Ahaqi1ZJJKJA82zwAEmozdPbAcVHxuf8TBU3MXAj5V5Dif9zeX7L+sxoeHBi1mSx16Bs8pGy0axVWj4FCW7+L/tz3fXUtQnG2VCfqQqcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762952244; c=relaxed/simple;
	bh=dhaRUvSmwrrEzm722nO20RVYYV4MggIRD2VI3fVuqZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KP+6GJ2SCfoWVL5Xdw6t+0motHOG2m682Tm1um3Zz9c/yPD9VP7+g0dXN0mAcvobW3fR4XBm2unAL4yecP6daS+aVAPev0YKHrFuzno9tirE5rGlKlr1ah2Dlq03ujceoMS976beulnrvDCXPG3Fhu1jWT++tjxDT+FU8Re9n/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yhclw4Yu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yhclw4Yu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB7AC4CEF7;
	Wed, 12 Nov 2025 12:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762952243;
	bh=dhaRUvSmwrrEzm722nO20RVYYV4MggIRD2VI3fVuqZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yhclw4Yulib9HPJdsVXRTo2PjHbGxKyTz3/CGA5hj+pD0w/fJYSELChR4ncOmumLu
	 VM1/IehXOQhrA3lxW7cov3XPl6v3DJfNpPe6RjruevdBxoiYP/0LU4dPWkYPtPbQrd
	 Auuo7prOklr1RBL4aWBffMFjmikrLdsi9iOww/Oa1/EilavKfiJz1Mu8X8nrnA+z2M
	 OqLAEvbhxUAd52ysU2PrHxmgRc3J95MBmiFnUHsFralSEluJSSKLHMDW+PD0YqlcEE
	 DketIBIru5A7fV7BbHXN3c9wnOtlfAWrja+io8Y5/ZLS7hmxyC3FXu/Zs85CeheEOC
	 an4AWWopUt9XA==
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
Subject: Re: [PATCH 6.17 000/849] 6.17.8-rc1 review
Date: Wed, 12 Nov 2025 13:57:09 +0100
Message-ID: <20251112125709.142950-1-ojeda@kernel.org>
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 11 Nov 2025 09:32:50 +0900 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.8 release.
> There are 849 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 13 Nov 2025 00:43:57 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for arm and loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
