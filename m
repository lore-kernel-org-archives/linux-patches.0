Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795188222;
	b=suEtXrFgLq3PzWBXDHoP4knvG96EH/XiD20gB+5+5yhmINvEMHqqj9Mg1UWZE1f+Ur4V
	 f5Mfox2/MrF+3qJGj+pS3RybgZpNM2GNDzmG1drjq/2ohcfoTH23PDtirQqsgNmPCrt3w
	 JcX/bg/IhoJR056Ac3EgkMYpxm76Hcw+LvPnWH1o/sde5SBcrToR3nDaVuqwx9mlEPPKo
	 +foZu526vBTOnczDCXa5IGaUMsQNFpQVr2tIHZc6HS72D0OSI78DwlqGrr40uEXWiUqju
	 KDm+mnQ3qcvoHk9Bst/m8lKmG3Z5WZp/F/sm28/TfxLAbjC08Y9WEGphMnwHInLHsGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795188222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=abI0MkN9ofZZx1hBCem6C++Lk9GXWtlv3oo41rsU6AM=;
	b=sHzdUHS+b+qC9FbHwjPNzBXv2IVrm/WtwR6Wzp/9RD2K0eD22US23dk0oR3iw9SqbgDN
	 y+bcz55pfLXfNS29KLlw5yvlxDn2ro6oXFe6lPHG6ft2RhbLZ+7gVaJwdjs5+Dbf8Y7cx
	 3Dx4Jo43lUXmrNkmvKkZT4RHJHJz9BM3iA/4m79LXQBErqQqCYscY+uVCf8WY1WAnwImJ
	 bgOY+6O0oATUjlna7Ex1Sgm110l9w8XX8rllumRLd+YYTTgfvJ6mQdZBT7D+jAWGH7VSe
	 hjQAfCSf9mNKXiLGbJgLiUnA2hx+iGytyWzHeZHNn093odiAkv5gQ/fi9PgyUgdscIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eBmOQQ6T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0084B606A326;
	Fri, 20 Nov 2026 15:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eBmOQQ6T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87B21F000C6;
	Fri, 20 Nov 2026 15:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795188221;
	bh=abI0MkN9ofZZx1hBCem6C++Lk9GXWtlv3oo41rsU6AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eBmOQQ6T+4hWjxOqsco6Kf57dE/XlEnhEaqP8yLDl/37khHypOVVE6y7KmeRXytYi
	 aTALH20jtwKdUzbWeQjNI4r0SnaL4iKGdVp7SESC3P/lypB8dubhLOQytgc4uoAB70
	 MnHk3htQibrHtn/V81WdfiJMh5opyiskBpJB5uwUQAS94h1UVoDnZQu29uveQaIHJ3
	 zr3Ik+d5dF40mhzjpgFf/603cY+/2v6t6hCUg9IFF2GZPFi16QBIbhkdbLYuqXwiV7
	 q0oxcogZuXtQS2HPmA9b/IFx72hjstV20XyCBkA9qhmXC3bfg75y41zayd9a99Qp6B
	 NbGgDTbLZRulg==
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
Subject: Re: [PATCH 7.3 0000/2642] 7.3.6-rc2 review
Date: Fri, 20 Nov 2026 16:23:31 +0100
Message-ID: <20261120152331.24002-1-ojeda@kernel.org>
In-Reply-To: <20261120055248.913352689@linuxfoundation.org>
References: <20261120055248.913352689@linuxfoundation.org>
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

On Fri, 20 Nov 2026 06:58:20 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.3.6 release.
> There are 2642 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

I don't see anymore the pin-init errors reported by Thorsten and Jiri in
-rc1.

Thanks!

Cheers,
Miguel
