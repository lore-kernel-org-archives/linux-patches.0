Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33744379990;
	Fri, 26 Jun 2026 10:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782470284; cv=none; b=hkCCxi5XcdUhgyxPB3PJZAourT/womFQ+eDjJiCHkkOgWNwCzfgPEeKS4Pvkf4H1+MAd+nQsDePVbFtYeRaDoTc3vq+TQXIFjrr1vnsVyoKsMnPxcFkebgmze42h4XfofQpyuPCErCvBSUI9p3ENqvxHmbygjzzZ9ymGJZxA0wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782470284; c=relaxed/simple;
	bh=w2+vorRUkr7Us9UAT2hpzbdfVvJ1kth8bAjN40dOlCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNZWFaGgS2Fxi80aJI3xzGAWbENDaDaJnlxFTN+Nl7w9nI/6G2LvOdBlAIRKtXLHlALNyf5pejAcvsTxwPAgx2fG50fFyDcMDbHsoZq/fsC8KR1rkGH2M5UqZk6MhRvuF4GsXHlNr8y3jzzTDM2Wip6+3veabuguyM81DOaP8Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VWQdDSM8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VWQdDSM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA9A1F000E9;
	Fri, 26 Jun 2026 10:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782470279;
	bh=1pVJ6qJgF8wbJ3CGxmn+mkF8xzZ5fzZFXfjBDXSUrCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VWQdDSM8zVVcd6RnejWFPZF2exs7HkmiZ+UmQYEUVjNc13w2spQwl2srv4cZ0bVbW
	 HjFvxpLKdba0F0mqYjHT7N10jTCxVftoLSyrPQHnGfQKTAmkX4if9vCwUEB43fSlKM
	 wBm+3T6RpmHdyihNO55Hzy3/xZbh4zx4ggULsn+7oDK2kTnDe0LqVgUCC5EPJ1INq3
	 65TXdltRwW6q1w3XouyL7ETBx3WGCSaBZy8ngcj9orF8OVuofXLob58QTpX4pk9ehz
	 iU+Naphf3G+xH4p4AIwFIKwLxdce9L6B/tCfEFW1p9BS17R1ZPP6RfeYukTKpoCVhG
	 KXFQ2cYbDfuDw==
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
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 7.1 00/21] 7.1.2-rc1 review
Date: Fri, 26 Jun 2026 12:37:38 +0200
Message-ID: <20260626103738.731281-1-ojeda@kernel.org>
In-Reply-To: <20260625125613.243729608@linuxfoundation.org>
References: <20260625125613.243729608@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 25 Jun 2026 14:03:52 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.2 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jun 2026 12:54:50 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
