Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E94344DB1;
	Thu, 23 Jul 2026 11:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784805897; cv=none; b=EJo/ksc6byTBb/tTSzB8kwVwhdlcUcEpokYEAvQbk1JnyBXGrY7mTH5vkp3iKJ6aMi1gf3CiFBlon590HyOM7sbRtZNPJ78W4AbaSdHOmjDxRSyHWd9qIXTSB/n8BOuFQFF7FLPCONGkC8i3ABimieDQkiWg27ikv4ibAT7eebw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784805897; c=relaxed/simple;
	bh=y/EDKmUN11qXdhCJo00WezmkgPsYjxgLMgJsyB111oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0hdqNcecYGNOX9I4hKax6TpUP+EdP3lCLO0wDDsg/jvM0CISUyE7sKvLMHj+F+06D55qi9gJsEvN9+2gnUnqkprq9GDbDgdm7UE2kUdl2/d0vG5k1mafkcRTaiW4W+BKmy4oQUq/I/7JYQoIHvdqSzYRFcETj7CqdmGBRsyYzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CTQwJxL/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CTQwJxL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2131F000E9;
	Thu, 23 Jul 2026 11:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784805895;
	bh=Jj49oTNsXPLNCBcADQuFvRlXELqkAeSkZo1b8+OOXrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CTQwJxL/qBqIfy1oT+aBhtbSIjuWJOMTGDhkasHZXbX5tyDP3mX3Tes6Xh+Mpa50E
	 lzuJ0KTuXaDZJb9K94DGccUyZVvylQwdEyBuekupILHyd4sDRY2ypjt6lifDSOTIBa
	 T0B59cGfGVRWY+0BaHeETqe3sHkqCzxibMLVvDr6EjgEmvt1sbvchhXvPiOqZ10LK9
	 AZZLV3ZZ3cj3Xg8pkSj/GJdWh4CBAn3qRxpn7YOYN98ka91GOqvVZtmdwjV/dIJXzX
	 MQQ9nEYd1TAkqxnyk3kuFhBiSo2eKYM+DcpWRlzLx7hfQslK5H3Wcs78tbiJK1PxyL
	 14kDW9Yya9aLA==
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
Subject: Re: [PATCH 6.12 0000/1202] 6.12.97-rc2 review
Date: Thu, 23 Jul 2026 13:24:44 +0200
Message-ID: <20260723112444.28131-1-ojeda@kernel.org>
In-Reply-To: <20260722142834.868902312@linuxfoundation.org>
References: <20260722142834.868902312@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 22 Jul 2026 16:31:38 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.97 release.
> There are 1202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 24 Jul 2026 14:26:57 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Same applies for -rc1.

Thanks!

Cheers,
Miguel
