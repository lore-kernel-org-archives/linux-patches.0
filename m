Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794660358;
	b=zSnXXCGnOpPE7iGLpcivMoPzg9d6+16HeW4BAu7V5nug+bQBe80YFt8R3xcbXH+0KnWL
	 miJT4VUeIrfRLhgxX0Myx6dsoVmLYtwwCj8atMAWasFuK08JcCfbknNpwAQ7b+8dLFWJ/
	 yo5rYmh9R5T35XmB/+WP54lhfO9G76/Ok4o5lcgR3cIRlJXXR4vDWkpwRxxGT1yQFV5jt
	 ZexOZfRREdlvntEbZVlmHa/E13Zo9dcwr+PIeCrsSbDaSi8Z0rBqbL7uJDXZMfXu8VQJ1
	 mN9M5Fp5uaVIp9IYnOK4fjYNEU+uRDz1HtIP6jwdK2F6G6vkmDUvDqXKO0NGNA9lIJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794660358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=lJm6O1l+2+nef1rFR0DXw+S4bSDJ6mFyNgYeSHA3MUE=;
	b=OlrUSJr8cHqyUL7ItiZOYvI5Zbq83rDbtK2SO53rLWz1ucygnT9yGbXVSaOLBXtfHuwW
	 ostGBGAGiaFoKBQmJi7/tI5r558eI7YXFhpnXYS2vOlHpVUS/GOhP3nJYw8kF7M/kAv72
	 Ssnam08PKp/L7YlBgvFOvhFn67qsMgLZUCIqe7hcYSn2sJo0Iot3PZK42E8uuZPAz+MNx
	 +VSoc7wAJ69vANArAXrEEjX42zoh+7jbhe96eiyCwxHQoR11Wx3tSO6wPCxmlqyEaxB6B
	 o+svZm1z7qvo+Oaox+W84QDPVAvMQCNkxgd5+o2sx+wzM7Qdl8Z83BZEY74aEkGEhYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z0CMBATD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B0B606A32D;
	Sat, 14 Nov 2026 12:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z0CMBATD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784C71F000C4;
	Sat, 14 Nov 2026 12:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794660357;
	bh=lJm6O1l+2+nef1rFR0DXw+S4bSDJ6mFyNgYeSHA3MUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z0CMBATDY7IW+0FJ85+7bR93J+Pnm4OVI3wt1/WuFbLl/YMAWhpfRciQDRpStjDnV
	 095ZkW5EGy2wp40YeVV99WR6RadljFBEqwAPHg0kK0DjfjT700EpuMaP17DgnQtqvl
	 llt7pcMH3EELBfw3n54lP8sIHHi5QERwxinsATrOwn626BaISNigHMynXzSaTaxx+9
	 WCxpGG7Z2MIHkKsREgEbxiwWXEdynobYEw3KrGqVFH8KRLmd1ucak65F+vU/HlFWkg
	 7hEG/Ns/QmQl7/SVAL49JBGZOQTrpcGrOVjlbsTw3O/F1ar8+TcTXun3I6/ZGeRRrN
	 bHHmNtqtn7FbA==
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
Subject: Re: [PATCH 6.18 000/686] 6.18.64-rc1 review
Date: Sat, 14 Nov 2026 13:45:47 +0100
Message-ID: <20261114124547.114207-1-ojeda@kernel.org>
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

On Fri, 13 Nov 2026 10:42:13 -0500 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.64 release.
> There are 686 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 Nov 2026 15:36:17 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

I noticed in UML the following, though:

  https://lore.kernel.org/stable/20261114003912.82206-1-ojeda@kernel.org/

Thanks!

Cheers,
Miguel
