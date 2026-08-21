Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEED246D096;
	Fri, 21 Aug 2026 09:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787305966; cv=none; b=KQH2LI/o+97lhxOXoopjU0b22gD8yknrVt0Au0Ag/+rargEoADIalDzHHOS9Wn2khDpwjOJEWEz+mIYm6W7nSqidd6RCk5WbDg+hcmVvUgE67+aL3VuN9MboyyW7DgQgkrFdET1MBVMePC6pwHja2vnLf3NryLzPFc7UJmCkaWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787305966; c=relaxed/simple;
	bh=Xm+hEKiCTuC9xHM/UFG3eE+ygmLDkGSTcPQdWeGp2+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCsNY0tLDc8hz/arfmb0Poe24CKSmsc0zxzxQ38kB/1BjHvPWc6aCiUZrd2xJeLLLjNM0gUO1mtmmwskGNq/WTKmv4atPMKNOveS5qDR4LAmjD8W4P+0qrJiHToW+6DVuMX+hiLSU05epiLKYf9PG0C63SI9LWKfi5odnUvfaL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lglXDjXW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lglXDjXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1D11F000E9;
	Fri, 21 Aug 2026 09:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787305956;
	bh=j1jwvRf6df2h+bMvh6MO1WMfZYoNIejPe9TLicQivJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lglXDjXWS4L4Y+/LdshKYSaX4qjcDFmiFSqriW62z+LwSN61ce4VbEOucuQP0sRXV
	 +1ptJgekyefLR8Q98ECoq7IskDLg7goeFIGuPBuqtF13YE3bCXYKiJtOk2TOt6xbMf
	 YjV1q7a7W09w1tI6wy5zgAIK9UaL1ECAsb4vglWbUem+6JbVnYv8WPdyY+VgRecBOs
	 Bat9fjzWAPs8McFc3vgfwpX2i5bAb4upA9vGvwoWVTN4snRm8FsYb3aqey+s6HP1kw
	 kqzFKzFdnvb99c/Iw/g01lQNKxcH+UweTqwqO9o5o8aqIJwa8ygiwEgL9R8jdguU87
	 iMtqMyop1wm6A==
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
Subject: Re: [PATCH 6.18 000/217] 6.18.46-rc1 review
Date: Fri, 21 Aug 2026 11:52:27 +0200
Message-ID: <20260821095227.130278-1-ojeda@kernel.org>
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 20 Aug 2026 16:52:48 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.46 release.
> There are 217 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
