Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795719889;
	b=Hd5kNPqokN4a+b8JQEi6/t6jwQHPcRKBwywmkv/5Q90PbNGHsXI9nPSLq1wM8WHTIa5G
	 r62sFMi7et124YNeDKLBdHWOyAN5a67hiXy/YjGkiMdetMwR6CbjajxVTR6qdOLl7RzvB
	 hRg8RJzi9d9CfhnkYkBb8j47QET2cB5qxi25+GVpH1TtnLZS4ybVF6OUtbO2lY5kcKYCi
	 2nsY9asKuy+Qqrw2hxRb+t2/kBzaL1uRmdxnH8Rpo7vOikLh526pf4udM5GZr3O3t2LbJ
	 GKNA3YsY0ux36KILIBZQjBNu3v53BsMi4UbtTEwLrlZc5MeVncMRtiEwIXI714tIOkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795719889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=1ctk+fL6PfkLhV/dsGiKFfYsEV93GnfIM2lI38MnYwI=;
	b=RMwP211eC4VmV/zfuzQjqDlV6/6rTOs0mglcOE5scQMuh+LviuNjd0lT1+mP10Im8NG2
	 jPbG2EjhuY9v+62NFZ2vzyF068jd8zpMKmyNvVKe9sdcB0J+af8q63OTAARq1roKFKx4p
	 BhXGm4cDi5iT17wlKAwpW8azA7aiRU8kxfGt3DAnxGSmYAVtXdLOmtcg8wQcfA5MOfbpL
	 O0Aq1rNpabQjizQ944sBHnBg5Or+q0l+HDT1s+bl7+XhSMXI9PfVdzwNuHcK5TNr0JGuI
	 Wv/NBu1U8GJ/qN+yANPm3FFgGBkqpKMfyRHBJASBo6YpJ7GpdAnBf0STgmSnpzsYDCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ELPyyP7h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92971606A327;
	Thu, 26 Nov 2026 19:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ELPyyP7h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0875D1F000E0;
	Thu, 26 Nov 2026 19:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795719889;
	bh=1ctk+fL6PfkLhV/dsGiKFfYsEV93GnfIM2lI38MnYwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ELPyyP7hVMh0/g3BN0EPouCpHxSVlPg2qC8KK5w339Xge6VbncRU1rFYEx2q/3Um5
	 D7v3tWoLPh3WeRjOlAIGdUQVnKmhlEOjtu3986HOcsuEidSOe2MGWF8eRDFmvxX6Dg
	 Z14MX/Ln0cyD14UGzdenen71u6x1P+CZxhbmtuhhgmDrhhz91g3+LqGxaeTaYHGdrl
	 XTIAAdQQ8Ab0VQKbgs3+kSN9s5tvGuKYuwFtiGzpiVS/YP6eIUTPvM+i5ot29Bi4rm
	 GP0+9l82scEc93XAS5wF/Pc8FDyN4wKH1mraexD8DezKYgszG1RRblPxGWgWFFJ6/p
	 IIbZCpHnolt7g==
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
Subject: Re: [PATCH 6.18 000/990] 6.18.66-rc2 review
Date: Thu, 26 Nov 2026 20:04:37 +0100
Message-ID: <20261126190437.95251-1-ojeda@kernel.org>
In-Reply-To: <20261126105725.767748294@linuxfoundation.org>
References: <20261126105725.767748294@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 26 Nov 2026 11:58:43 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.66 release.
> There are 990 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 28 Nov 2026 10:55:59 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

I don't see Peter's `offset_readdir` warning in my QEMU boots, though
they use a minimal userspace.

Thanks!

Cheers,
Miguel
