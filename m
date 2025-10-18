Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9FD1DE8B5;
	Sat, 18 Oct 2025 16:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760803624; cv=none; b=gQPF+RZGv7RHRLiR1Mj2dUucqYObO4w0T/ptexG3KVhEsdH9lK9P9UCdHczdz7vYcHzWwCrHtfo0nglhNoDQSvVOk0CQdN5qOodkXVsb6+Art4jmhuCopoQxeolGMzOke+fPjC0RckWcIwuj5VcMYBNwxXNVKbNmZObXbyyH1z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760803624; c=relaxed/simple;
	bh=gVem6GftEAwbylYezmSz+yAKvswpYXVuUfm9fcHzXkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BoAA/bJSWRQlMx1N9V5iQpsvjPVWXC4798XLVCsfXmr6uSprhwzArJ0VZeAdIs+x9wsm9hLvoiIz4oID/zxPYPSfdWBcGj6tKtSfdHcn7aSKK81LIv2jQWSNSRRRF3JpzdrPnaR+z1J5Au2Urc067BHQe1ikfwrNYf0LW4+UQjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DMMe8hPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DMMe8hPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5746C4CEF8;
	Sat, 18 Oct 2025 16:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760803624;
	bh=gVem6GftEAwbylYezmSz+yAKvswpYXVuUfm9fcHzXkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DMMe8hPeUJwIfy2Tf7K0Kq4fJvyUGU2cilbDzW0Nv9KaCY4mVLeFoWXnCRYhrfZqS
	 tbBt8e6sNBtlBXgID+Q01rv0x1JfsGUIQAEoxOPD1kDF1FrUKFjTnASbNQ4lxcsdD9
	 bGXceviBKfHeuQzulWabDBaE8oJndEpOmgbzSzBRQw3FE/NOBvFKF63Aiy0ld9oPr0
	 LdXYA/6XDz+ybj2iS9ZEmpzPsljYbMSzviXMPGr3sZ9yMe7vUx/1Y3kISGCgGsVZ/H
	 bbgz1yOA7nnpRwNzvdSJsKbS4WP5VcJz1DE3cAmi2yj67S+EL2YfMycPfaTtAe6jTJ
	 bMumCp4M5laLA==
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
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.1 000/168] 6.1.157-rc1 review
Date: Sat, 18 Oct 2025 18:06:54 +0200
Message-ID: <20251018160654.1548901-1-ojeda@kernel.org>
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 17 Oct 2025 16:51:19 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.157 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
