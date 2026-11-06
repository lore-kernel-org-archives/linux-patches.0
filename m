Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793949972;
	b=TpdiSBLewbSO3Nq6zXZC0TnaGFNrWRMPw9HpFl6osPhjZHfeJezk1ju+CxuTNRWNZfUD
	 Df4uqFvpVRWfDbkPzURE1K7fCKbf9ASln021zpRGe4PQW5CqokQPbTxFNwW6Km0CYkftg
	 LoQbLjqlfiNF6Nt9Ftv19sYbHYP3mrw4KclbwfgazkTWm9A2IQpcMasn09Sfg2OP1f87x
	 cNNuZ3F4WvM3B0/IEbZGtjL+chqOjDJ0XzHnCxnnQNsfQgn9LMCzgC9rnAjiJVeVBI6Iy
	 1z3OyLETB9n7dEtDR6IWAqNNh4JnFn24vyCqdRjIhQ7oxVQSu8ttgRDOfehmH1btW5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793949972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=yDXzD4LpNs0QWYrDFXSMyqQ3Gk4yqaMPN5IR5YNQq6Q=;
	b=V2uwr9phyGdo+WOpvrmI1LKMlXjWBSoDg66ca0sZt41eaPvd922+sAomHZs8QMarHKet
	 mdW49mMj8N/bnQrYRvajiI0glfTNaHwLqbHak49uFfsLDB4w3bZ2qJOE2mX9LD2Ct+/NZ
	 cs/UffYjt7gg4ePI+eE3F8K5jP0cMXb5usK33yDV3nVqoNvxoJhGSpoN3W9/dH3RR7qbt
	 auDvy4fJDHl1+biyHuj3BVuHDOwh6rH8Wj7pcuz/UFw7VU+ULW/d52RfUapA8CYQ+YKsQ
	 ZAnH1G25xOFJrc4pIngGuTvmAHD2/37WSzAJsX0fKDdMl2PtBsX0JpiE2xQnVwyaWlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DcULH+Uo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A99606A336;
	Fri,  6 Nov 2026 07:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DcULH+Uo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E599F1F0089F;
	Fri,  6 Nov 2026 07:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793949971;
	bh=yDXzD4LpNs0QWYrDFXSMyqQ3Gk4yqaMPN5IR5YNQq6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DcULH+Uol8sp6/KVDXkGVE/rUznUzWIRD29mucp1hxUOYyLf6luqdzGhhBhGy+upS
	 MA9pehoP7Z98vltYiG87FMojRQDtZZMebKX3e99/caEWwZXUX8jl5VNNiLDTxpUBzn
	 dKhIE06MQ6oXILJPPywRKdOZ1NZaIm4ayv+dbI1JSxPt76D+F1Me+qlf+2u2YDa2AH
	 FzK1QWApo0gSly334rnGQLnfIaF/CmiVpHA3pfLTM5enFWJwgnldM15mdavUuBjIxF
	 1MIy38J2qcCrya+r52JZoy2WtVJMvDeAqfRuBq5QXtgUMSS3zFabEhq871sYjlFV9s
	 ifCaJGiaROpiQ==
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
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.18 0000/1005] 6.18.61-rc1 review
Date: Fri,  6 Nov 2026 08:25:52 +0100
Message-ID: <20261106072552.90943-1-ojeda@kernel.org>
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

On Wed, 04 Nov 2026 15:55:33 -0500 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.61 release.
> There are 1005 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Nov 2026 21:07:23 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

I replied individually about a few things I noticed in bitmap,
loongarch64 and UML:

  https://lore.kernel.org/stable/20261106070543.89122-1-ojeda@kernel.org/
  https://lore.kernel.org/stable/20261106070701.89282-1-ojeda@kernel.org/
  https://lore.kernel.org/stable/20261106071743.90363-1-ojeda@kernel.org/

[ Cc'ing Konstantin: I guess this may have been mentioned before, in
  which case I am sorry for the noise, but just in case: public-inbox
  or Lore seems to have a maximum of 1000 emails in a thread (?), which
  given the size of the recent stable releases, it makes it a bit hard
  to see here the reports etc.:

    https://lore.kernel.org/stable/20261104211043.516122098@linuxfoundation.org/

  ]

Thanks!

Cheers,
Miguel
