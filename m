Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E79D253932;
	Wed, 11 Feb 2026 13:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770817483; cv=none; b=acU850faULkgHfAFc0NFXb9rVfx2Mef2Kww4SWss5Hn933nuYCFFfMjYTMyoToLPxqCjBapyukQT3MU/YdZFUKtdeHrP6cWWwYAh/ozWdukcyunFzPm+Fy5yMcTdgaXTksBEmEmUP2YuGnFnCjcEb1aTBJ8lSF4A758AGp7FJmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770817483; c=relaxed/simple;
	bh=hulBqB6xRSC5vbtYkq/Hkei8Npxy0qfh/eF6cuH0pu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmPasE8D7WGBV8zUysT3Ug5BWkU/P1VV230ml6xYLr1OOqxEfvLWgozjCSCGsZJmhHwEj/V+z3stmgAliM5bF5IIRVb9ehPKSTDeQZXL26qr3mE5GKSMX6foCaiRQjoagYMzx8WYb7dXu6pRcuJaxfMJodJwPUh6s9jricHXQoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PCKn59Ec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PCKn59Ec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249BAC4CEF7;
	Wed, 11 Feb 2026 13:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770817482;
	bh=hulBqB6xRSC5vbtYkq/Hkei8Npxy0qfh/eF6cuH0pu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PCKn59EcMhh2pm7jCviSv3/9T2KeDxqkJwOoLla9aviZxABNbsalKg+x5PR8Yxhbz
	 0bVwsRCsHFMvoWJMxSn3HWdHVPi4JwRV8iHzBNtHxXtWnkPzbL2lhWmsTq1+LOnJqJ
	 pGZoLKwUQg0AdVuXyndgTc/0Hk1d18ja8FgnAmOZ94WMtoLPcF1eGyDk1FrMWtseaE
	 6/tHgEHwm000ZwdCOFw0fAyoe+n8LAUbbEpfGcsxqK8US7BJzbi5L7wAkv3mCUhBJJ
	 sv0LazjP2+zOcUuZBqXEvCeAvFwWIa63Qch4mNykEWq0jnCE33Og8p/fCwRrSLD3zj
	 AiMcD8zTe0Hdg==
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
Subject: Re: [PATCH 6.1 00/69] 6.1.163-rc1 review
Date: Wed, 11 Feb 2026 14:44:22 +0100
Message-ID: <20260211134422.10780-1-ojeda@kernel.org>
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 09 Feb 2026 15:23:28 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.163 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
