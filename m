Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79A5CA6F;
	Wed, 19 Aug 2026 00:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098389; cv=none; b=YMINt2VBbSj4rEAt69a3DghRgk52oLAXSJDKlRYL8aNm2bCaDztHeOaTBnc6l1NdKgluBmgRUl2Du3lGY4L2ihFOqtpfxmDzYTK5TAQ2W3CF1pbYYH/5Anx7u2OncA67H1/aGE2J+llsIb6890PuxMF8PFIuuVuxKLScI3PY6GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098389; c=relaxed/simple;
	bh=rmY9qC2XshNeLlNzzw2KT8JMOmtBOGsx7/7u8Ex4YJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0lHAXxRDVX+1fTCHhWoo5oK3iqqSQ5J6uBl1iKbkK7AiWoYDzAfLooGh4bapqJ+vPaLO3Yo1GGPXARC+yDRRaBl1RAhlkpJbGZkQ/TmhbdwHlqOLolNY0s24RaBj29hApxeGS9GS2Q3CqxDQhAGp7Sm23fI6Wb6eU4SnGnqrhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P6ziXzin; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P6ziXzin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F8A1F000E9;
	Wed, 19 Aug 2026 00:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098388;
	bh=lkcnCfSu2DsgQu+MpOkqNweY70/HtuU7Q4x9Sdc2JSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P6ziXzinCHhtYo0swH2Y110GJnMz4hshoSGc8REsMLti4U/b9PjDxIkOkAT4ESHa3
	 +woWkm8nhHbCNSsAmzH+RTyD+6Fi4brML6vnL4AOscmGvFY7SED/dBo5StCDeC4HTq
	 Ozkcz7B9b8P0IHcq7zPsuLtVg0I6+U3p+UOnM78AT8bNqLvAKzyKuwV362HabUZoa0
	 WsP8y1DWmPwAs8+eIqILLfC0A0cJP+wFkq7s4CqiEZdNP7ztajFg2OShY6xAdnUWu6
	 qXGr66DbLJ0Dyovaa4UnC/hkBJwg59E1n3jisFGu+oa6hjIBafGu09+2Mnbg8H5pqj
	 DmAohrd7EslkA==
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
Subject: Re: [PATCH 7.1 000/271] 7.1.9-rc1 review
Date: Wed, 19 Aug 2026 02:12:59 +0200
Message-ID: <20260819001259.402266-1-ojeda@kernel.org>
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 17 Aug 2026 15:28:45 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.9 release.
> There are 271 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
