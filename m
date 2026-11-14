Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794660474;
	b=JLK9hfmjHCNKYvfO7N0gmXmhSdJSkmwWY8ddTRTD529ujx/3AppquLanvHTiyrJaK6eM
	 PoVqy4/D4rrQqCASgMSinnSYj9FC87Wj1DKNDElKfmuAAU8ihoCFDhRdGvCoFy2uGFT88
	 f0xaDpl2fg3jBgSmU3NJoPQ//jlvoL87/yp8NQWcZeKmX+ZLc6MxbFZR3cQ2Zvs89RF0P
	 PlQLGlvUEtg55EXL8B68RAe9QYAkq8RuYBB6u6oGSzieWOccKp6KS/6gg7oqASnA498c8
	 etuXxQzvF3DY0d7Yf+KRMlv+rdZUYzUoTAA4wfUMUB8tPJSK8cCETp099b9uV0FZZJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794660474;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=hFIUN2HO4UdWlq9ef7jMaiMb9F6qBVRxjF+QPdOWjgk=;
	b=kEgbRZkyYJJo/GKz2a9LjaA8YAY7n/MeTwPGH6hWdtAa1DI77T2v2qHVctI/S8YeaX0d
	 cK1kBNJcz6w54Pkpm2V3fxrH0E5NeVEqtgzMSCsluDtOudDy0WrMWF+aGdIQW6KKimXAo
	 +oBYXxQsOouLOh1f6WgLJealchFlPAROg/B2I754zIjkLEOpnHa4s0LQVfl/7ce/lxwUE
	 4A2R1D+7u3ziLFHD7uRyQk7OmKdXEgA06/ncqUNGQmgUEMgtgtSk92p35qOVEWMRxwCKj
	 ZjKMcmy3rnMc6YVaVAxWXeuIY5paWr3RUJBPY8bdQ+DvaTBOtGbbltAcTCZoIR9/ILQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="XHxXO/BO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD1E606A323;
	Sat, 14 Nov 2026 12:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XHxXO/BO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985BA1F000C4;
	Sat, 14 Nov 2026 12:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794660474;
	bh=hFIUN2HO4UdWlq9ef7jMaiMb9F6qBVRxjF+QPdOWjgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XHxXO/BOeCOYsF+UPdmcw9EHaIV7ga4jY+kt7sG5KJX+eE86Ycf5xEJZZFu8nQbTb
	 +4vQhYyt7IAKEY2ZR/piOOPbFm9XFwOHHoQLDIfxQP2IOwm8hrsdZIt1cS+CWeFypK
	 OkKwTTan8KBxM1qw4Gc5tEfmn7FcnhuUJs54XTmGkqzDpoGZP62RvGJLlo7VTxSHD1
	 ARrp6ucr0Yf/7QHu1YVkWWuod0J6nemFv2sFNF7boCZCWjD4YYgUBLhLCIRccJevxz
	 aVlL7dQOLDYp65p+lgEb/vk7ut/xy3NqDiWDY6g/PqGCGcq8rv7CU7Do29L+NMYVEd
	 TXTesGzHPtB8w==
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
Subject: Re: [PATCH 6.12 000/670] 6.12.118-rc1 review
Date: Sat, 14 Nov 2026 13:47:43 +0100
Message-ID: <20261114124743.114465-1-ojeda@kernel.org>
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

On Fri, 13 Nov 2026 10:42:44 -0500 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.118 release.
> There are 670 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Nov 2026 15:36:17 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
