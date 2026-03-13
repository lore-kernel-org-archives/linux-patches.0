Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2482C35F192;
	Fri, 13 Mar 2026 21:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773436806; cv=none; b=LN2HuaVnaBuMEd8HqIM/PqlJfcavq0hYyInpV84n4u1OHHc0IT1Fy8PILDwwyBoKDcZ9AjmV8oustAKy+8jvOQCfaN7JXwhHqrR+uUfWtgo88C90FIgdJBpEwP0vY4Gf+dSMA3DRysg5V1p0EnJm5VthvGu1VmOMRZT5vmWIEoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773436806; c=relaxed/simple;
	bh=Qnz2PJ5ZFY9Ad7ZBNgyMEzqRaeAiEVNsmjk69km6ZQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2hkU+bQG4YQ1etZZDAV9TbHjK74BRzGlhcEgsFVtvQfhezVV1O3+edps3tYPQM4ftJhqWAZvEkNITyKJLM81WlyFdWGOOPQRGSOpvbAvIlBpze8KSGZLPphRFEjNi84KjbK9yppuPS9YH7da0vUU/Rlkru0hGETPmbTw8Cc7H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YivqIXA4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YivqIXA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3709C19421;
	Fri, 13 Mar 2026 21:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773436805;
	bh=Qnz2PJ5ZFY9Ad7ZBNgyMEzqRaeAiEVNsmjk69km6ZQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YivqIXA4lATJybHZs2BdrxuJRyt+H2rrj3QdvlsykqWKgGQ2kfUw0aF69HzkA6ljw
	 Vt4q6eEucHNOa0D+fWv30fWoDlcK3KYpS53yESl1+5K2wGwEQlVnxww1mG9ycDAsOH
	 WsSFpLEJyf1iKO480jUpsjXna8Wlo7aJB+ztlE16IFMnfNS7zXGZfhQFnbcn6ygd0Q
	 eOm5s8q5SuBVwKky8PiqpHbPHGTeEI6uDQlFOenvIf8z6Fdp4dpUXR12w/rF3Yscmm
	 RhZK/h7ot2nKVrsol3jnDJeJ65uevdXnwf8NuE6PQFiZrIwTlMVQ2qlulj9QMOjMQ8
	 j7T3XdRrybTiA==
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
Subject: Re: [PATCH 6.19 00/13] 6.19.8-rc1 review
Date: Fri, 13 Mar 2026 22:19:56 +0100
Message-ID: <20260313211956.184457-1-ojeda@kernel.org>
In-Reply-To: <20260312200321.671986598@linuxfoundation.org>
References: <20260312200321.671986598@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 12 Mar 2026 21:03:32 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.8 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 13 Mar 2026 20:03:10 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
