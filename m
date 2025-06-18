Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE3C25A33A;
	Wed, 18 Jun 2025 12:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750250725; cv=none; b=KRiuvL+JcD2aMLfi9QhBxJDuiDYNI1dxI01EISmiLMhpFINHXqrROFxOiwMes8MSc4GZYyfZs3WVbmvqsp/e64dgv6T5/z9Jan318BH+NeanGXByMZYEaw9+rq3+OU+sOw6QTVZiwlx83hD+gDTkEejk1StOlvGIKehlcI71KVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750250725; c=relaxed/simple;
	bh=DM3rNcJAKz3yvzj/ybKxZZwG/X40zLIdFabrB8O/0Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCya1cDe8NgbBc8HTFCKEZGyseyoqioCH2dzBvBp64G/YH60b7OWNWHn1K08/x0wnYwe7pwc8LW38xoQrfp8FDaN6MgfgGjKGzywjjhVg7mNj0KOifwFCOLknfzNGywSAOMod6+AA3D81tpT2UL34p3mFmxWbnyms9sLVl1G1+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tZX2z1cq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tZX2z1cq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E67C4CEE7;
	Wed, 18 Jun 2025 12:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750250724;
	bh=DM3rNcJAKz3yvzj/ybKxZZwG/X40zLIdFabrB8O/0Qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tZX2z1cquuV9zBbZwQyGzhjUh/XqB4rMWKa+lym4lIo/yQp/vZOHz4hyl7lVablyt
	 ihHHJtB7abz7sADgKYIGoDn9G19YtTmdCGxpZ3XE1ppj6Bn3GUczBMHt7bQUDcLtBw
	 F0LBt0MIdHif/QlTFwYUSTm8zGKcfturjv8dpD4unn/Q8k8fT4Fzd8DXQ9ybyjwq/c
	 MW1n0eelsJysVau6pYAK6H9jFUXafZRZ0OdPFus5P/EpVag4Gkrmm7Dxktm+Z/i/Uj
	 bxgxpRhAeRnTjY5Yu7Ldud1kM2OEK1GPzbjJmkKSPAClpKz0x7YyUMOfMl5kecHfa6
	 fSkRFOhpiDt4g==
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
Subject: Re: [PATCH 6.6 000/356] 6.6.94-rc1 review
Date: Wed, 18 Jun 2025 14:45:12 +0200
Message-ID: <20250618124512.1918299-1-ojeda@kernel.org>
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 17 Jun 2025 17:21:55 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.94 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Jun 2025 15:22:33 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
