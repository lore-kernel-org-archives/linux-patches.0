Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795719785;
	b=2FIg+J0gvlRa9RJpl0rJhQVxIuKw6fJvw80RqqdJpeGgeWPyXrIjfZIx8UfHvefTKhm/
	 3nVv4VsWzFadyrWznXB0ZCGfJbA3Hov8lL4uvtoYhY2kVjCqhmZt51nPW/O+jmr33O0Cd
	 D4EUPmhE4tkRmFlXps3z/7T82SvaTaxntmYkP2Q6u0ZDf4eALGF37RS6NFH7j0TyZiKAj
	 fc3ch+2q78Xr9onwAQA8Hktb/U+V/XRW+81cFQaTtyxwEKAsggO6DeJZo68B3936BqPOf
	 o4HxbXy5hs9X9TKCAou8uWxjoNX6wccE5ISYzyoSkXG/FPeWbm11Ar+YVegNUWCO1BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795719785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=HmjQrWvxLls3MlEJQ5GdIn7aGxNBuBuEn/WzLZMf50Y=;
	b=BW9fh6F1enOq29+CWTNc1l9ItmrBtbHCoaDtUNyGRy5tmL11UvmBHbwBoxnELhhzStO4
	 YHGBmbphtU9sbMUe/KIe98BUO4INGmBYgCp76etkwtSee8yxvhKSLB2Ztu2NafQnDzl2X
	 QujXg2x/fNNSnpyguT4XybhLh/eIziKd1PD3n7NQyELHiPNwTSAMIWz0clmLGxtrDcjFh
	 J7Td1zzD3g3zwobh5fd1ua4NAAt7wTE0EjjyCvqeW7baAXQu1lg4I4AF5ZTpnrjWmsKGT
	 B1GMcAu9o+mVSt60yv3/km38hVoG67uOpJHpoKlHJ5KULN7e9XrIe+U+W1o+XA2feag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nea6AAhi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99021606A31C;
	Thu, 26 Nov 2026 19:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nea6AAhi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECC31F000CA;
	Thu, 26 Nov 2026 19:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795719785;
	bh=HmjQrWvxLls3MlEJQ5GdIn7aGxNBuBuEn/WzLZMf50Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nea6AAhiWTvR2A6x0svD1jM1joKlXq9GNmxtglkeaXQqdxPheAOXMtk9izTVvEzwS
	 F3ct8DHz6cwg3gDIaaFCC5PZqb7s15Z45zhVR+4GRTnCGRrW9n32f6DfmAkG5MQdFl
	 kXew8hh3jJP8g1o7mGqnIaXvkdG6yweCoo8fmxrSIB2DXjGHDS+rkIU6qfR0c8d0+S
	 BGWo23SAvNE8vBzVvdAFRXEOT4LQC7Ie3M+G8JAK43iqBCcxFcZM1wboURsx1fORPt
	 alDN/ThGGiRxjGvxVqSMgVbAlNKSsJ1HEIEU8LD26Q20y/ehiXN9A5dA4rbzLsPJtD
	 zngFYyWDVhQzQ==
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
Subject: Re: [PATCH 6.12 000/815] 6.12.120-rc2 review
Date: Thu, 26 Nov 2026 20:02:53 +0100
Message-ID: <20261126190253.95119-1-ojeda@kernel.org>
In-Reply-To: <20261126105709.009001842@linuxfoundation.org>
References: <20261126105709.009001842@linuxfoundation.org>
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

On Thu, 26 Nov 2026 11:58:31 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.120 release.
> There are 815 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 28 Nov 2026 10:55:59 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

I don't see anymore the NFS build error that Brett and KernelCI reported
in -rc1 (I saw it too on x86_64).

Thanks!

Cheers,
Miguel
