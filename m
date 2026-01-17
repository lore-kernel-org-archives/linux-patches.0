Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B5413C8EA;
	Sat, 17 Jan 2026 14:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768660528; cv=none; b=h6gICLzmcVZebtsPNmdIxiucoUmnKCACv8cGaLKxTIuqeA3gA+R9WRCCmmWMFBRmwfqGyZgwow2VuEETqIMUkr2nZs5YRbpCuDrHEdeOtaqWYEbjb4qrIExYBw/4SzIDdBvoQMI2ah5GfdTnQN+L6sHGvoyHNg3VumerM+GX7Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768660528; c=relaxed/simple;
	bh=GZumiLnXRu0rCQf7o51GkvnFoX3ryiGO5R7OXFExrRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7QdLUY6BnORNGrxkpxIkEvQ/w1ZY+LHs/h6sWUmmfPD9UiyXl0N5UebZ9BPFAU505VROkP1kLPAeNUxIpgjvwE0osWlnREvTNaSMy+spZ4/WBSQlKt+ccFz0I2VghqiiuHpoYkCgspfCkqyBq1lrPZylrGPVWFuC0OcatLniK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ifqGjvQX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ifqGjvQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF9EC4CEF7;
	Sat, 17 Jan 2026 14:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768660528;
	bh=GZumiLnXRu0rCQf7o51GkvnFoX3ryiGO5R7OXFExrRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ifqGjvQXMC3IjlUWH/WeEWj4rx/GGENNy5pPbnW7ERWknk/X3KGfUsMogLyZXsNvN
	 xn/bLSbUhMAeZuPSewmiG9nG97bdu7R72bUJBxIemWdFDUEqs7e3bVcluoTVQySEGD
	 5fVNYtsv0EfgOc4afeWOrgcBl6j0xY3gMs9UJXb7fToDQcbMjwXs4EQzRHzerBgX4N
	 w+6HvQ9+S8+A50S1ZumhGyGhcGb2lK+Tcl6rIzKrW/2PZbFpZt4Q1dUMvaVi/Y9QsA
	 Ib4XxVQkDQBj8A2KucdkRqfkCqNXuflamFArx3HttKwIRiC8pKuSVfblNAZcIL/utW
	 HquIx0fh/P5Hg==
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
Subject: Re: [PATCH 6.1 00/72] 6.1.161-rc1 review
Date: Sat, 17 Jan 2026 15:35:12 +0100
Message-ID: <20260117143512.170635-1-ojeda@kernel.org>
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 15 Jan 2026 17:48:10 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.161 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
