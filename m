Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5174363B9;
	Fri, 17 Jul 2026 00:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784249277; cv=none; b=i6OGb1rbzFniSp1xA5/rxyHGbVpGtPuM+On3HRPrQAKMKi3pYlKeeXD7OErTSwwswO3cZd3+2a1Km6CEuOJ6Q2/r0EYmv4cHP/3cpjElLrrD6xYD15ZxD9bmED1AcOQFrsUape2sj5V+1wfkihj+kvQoWMud+riar8ZcZBa4/0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784249277; c=relaxed/simple;
	bh=EQXEOQC0cuVVagSCzOZ1ZaotDMk6SnYEtuVz+ift27s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTc6g/L+0656GWdsyjszL4JJz3u3Kj4oZ3TCHHc7eYAP7F/YQ1FFs0Iy+MDkyufeEYpmw7a/IKqDh9XhTc5xAl3LSu7GSN8o9eB7KIadSUAa1J6WE6JrVQrba13s0+d7zbIuJ5QPoSeCVIPKHfJlCGmALRIJL5UcBAJCH5XssQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bnR4g/lb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bnR4g/lb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D06F1F000E9;
	Fri, 17 Jul 2026 00:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784249275;
	bh=GYSWJd8UeOFdE1w+h71X9xJp2/mCnu5EoOrvBVX2vTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bnR4g/lb0RSoxC8eGprzH27B3pNBIslVA8folhZOd6dnCwxuz6f7R7a6uwsmbO9Jo
	 RVKIq8bt0sJvwawTOZFaCv8ZG642/uKstorF0wiP8o95bLundb+tycje5cSh99JgX5
	 nddsPiu6KoDDIc2op0QdX1e8ns1i2zKNyjVSTaBRG2u0ggS7UqC2WY3wJB67Nh0892
	 DI/vqbpxtQx+q8npNa5kl7Hi4Knzi7CG2fjmfSgdwMhx62D09V6vFxcCQ1SlySqKDB
	 qJUL4F7svHzJ3D7tU3oa5YvPTtQpFJ7nRU3utFVkEKcG/TYDgl4B2oR2PR7xHAJrQY
	 3OoYmjiPr3NFw==
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
Subject: Re: [PATCH 6.12 000/349] 6.12.96-rc1 review
Date: Fri, 17 Jul 2026 02:47:43 +0200
Message-ID: <20260717004743.134309-1-ojeda@kernel.org>
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 16 Jul 2026 15:28:54 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.96 release.
> There are 349 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Jul 2026 13:30:01 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
