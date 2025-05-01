Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AA51EB9E8;
	Thu,  1 May 2025 16:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746118456; cv=none; b=g8KHyqmRMBZqnqPHT/SiGG3MIK2s/KC38Z3710wuuwmyZWaqZw41CK4VKDA2gSyQWWNEL04eIKKevgoV45v6UNUwwmHglXwXMo1/H2Vm2ErTNg6iipeDIsbiR7Qb2A49sU85Kvh3lmzPCEpk3PmOkA6xbTGl5FGT+Yn2xf9cbLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746118456; c=relaxed/simple;
	bh=Po7MfUbHnxOioexoPPJU0FyruKTIR8Y+TUMMi5UN7kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWcDb9A3GG3sE8cSXoB+qXOc9gAdTbBgRv952/nK9kfQ6tmpD/1lcj+LvNrwn8hWmtOn7Nw4S5X7qH3YhQXwvO5Fgojv7Khw8FbsmsUK8tPYVsuEZJ2C5Gr7y0noWGwk1emtrBLbaS8I4iLUs7z0IphmIFPgjP31n636O69xH5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WxEfeMBp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WxEfeMBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2921EC4CEE3;
	Thu,  1 May 2025 16:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746118455;
	bh=Po7MfUbHnxOioexoPPJU0FyruKTIR8Y+TUMMi5UN7kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WxEfeMBps3TDKi22pwZ24P+11ro+wChF7rraLYK6zgGE3MyDNOamjFere6h1wt9OK
	 6MskWADUkZ4uaFm4ajeWVZimdyzpchtlOjlkFteLrXQ60kDtS4AifSns2rZjt310bb
	 ie3/JdlvAF9NLM9vfgYMqCW5ToxUmUx849tloWdpUKL1vqcyqVc1Yv017OnophYY2G
	 mkx6usm74mkghjJeQYkX8wCiL31R+GrrsS/2pxvocvpM4Jh5N3a21PUPPOwFFOMt0Z
	 ytEcWrGOCmMUXhxYjxnh1jHgTxVnd3D0GEjhbObG0qKlJR3xxZhw/b5NtXYo150cPy
	 y+ohNa2TU2veA==
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
Subject: Re: [PATCH 6.6 000/196] 6.6.89-rc2 review
Date: Thu,  1 May 2025 18:54:05 +0200
Message-ID: <20250501165405.1125083-1-ojeda@kernel.org>
In-Reply-To: <20250501081437.703410892@linuxfoundation.org>
References: <20250501081437.703410892@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 01 May 2025 10:18:13 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.89 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 03 May 2025 08:13:56 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
