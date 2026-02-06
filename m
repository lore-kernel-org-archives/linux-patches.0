Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A892FE067;
	Fri,  6 Feb 2026 09:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770370196; cv=none; b=en7kAMiJUMK8SqWou7ovn767BlUiOXd2R5HoQIcCSljE1dKBKytqK9P1V+IHVVpo0xBn5NUYMwFEYlDBXBe6b2IcuDC6SEjrlzVlICZh/07VZ2IBYjhcOlenaxqrwRRB2pMIFtlpc9hETGT4aFeycVA8Uzers8EySL3U7tyqq2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770370196; c=relaxed/simple;
	bh=/Sv1X4ijszu+USMPjpet81fh7gNVu5PjahY2i9cGa34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQKVtVMPxQ3wV7Jt8aJ2If+Ye9whlMgbOMpRYqxn3RSO3mSoJxFOcBM9gpOH+a+RvqqUS6ceZeAbU4belwqiL1ybE9d+BM+LkR3jZYB57POfMaeYghkQ5sUsc57mia+E6CT+KMl+I6sDzn0ad9WnFTmOX/c+yaZvpBQu72HWLks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fjQpov3Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fjQpov3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF6EC19422;
	Fri,  6 Feb 2026 09:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770370196;
	bh=/Sv1X4ijszu+USMPjpet81fh7gNVu5PjahY2i9cGa34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjQpov3ZvJegvtlX05pPFmjo104qaetT1DfRrZd1y3QIaSdniaVnWoWW3vJtTCltP
	 HfTYDKp+Lr+nzzpuvE0Bo7f30r2dirtdkpseJMcAy44bZaBqbJ6BWOQywc8H4fks6u
	 vNFiqeVCRF3sXFAxKOJukgIiAU5aP3vplf09dx5ZFtzx95G5spxkeprgq8vOJiIKxV
	 OYiCAnJu50kSDgNnwEIJOgC06mAOr95zR7mS/HRiNUHHZgjrZScIMJ18XJlz/KOmo3
	 VtVuZbsF1ndQL5P5W113Gg1kvag0ZGj7OAbctNhg35mEh6z6/cLC+ZNAeDZXiVjKXb
	 JU+5/jlp1nkhA==
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
Subject: Re: [PATCH 6.12 00/87] 6.12.69-rc1 review
Date: Fri,  6 Feb 2026 10:29:46 +0100
Message-ID: <20260206092946.88671-1-ojeda@kernel.org>
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 04 Feb 2026 15:39:58 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.69 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
