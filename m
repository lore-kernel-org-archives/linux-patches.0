Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7D714A91;
	Sat, 22 Nov 2025 23:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763855004; cv=none; b=UU6MKF/AMX91tWvijO3Zf8l1E64bzt5Npj1BAv0JetDllz1wwn2n6QPElvYwguCIySVE38nSwbl9aeVCiKRqypS/cr1I8d2JkTp6YT4NOfRcHzZSOfndDVENDtGQFQvVr6Gie5uGZkedKG4SZ4usZvJGyvVMKxLHVryzgmAm8oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763855004; c=relaxed/simple;
	bh=FB+VMzqIG6Iz6ZEYgCkyyf5WDM30uveNDqF+Io/OmhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ssfk2iLkcZPKXR3SX9gmEmvv5NyUc7FuOrKAY07xP5fhzIGEO4l5lVDkSYfvv1PWG85gtPtTigKVkOU1+Y00hFxBzDy5FApOWbTqk9XwYgETUrUwn3kA2NWQlnCXib/35+2blFBlLVVC9troiSaryCcNhWKm/E+SNvh1fyFCQ/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vq57djrd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vq57djrd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8277C4CEF5;
	Sat, 22 Nov 2025 23:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763855002;
	bh=FB+VMzqIG6Iz6ZEYgCkyyf5WDM30uveNDqF+Io/OmhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vq57djrdnW8S/Y894r5atxYN5YPAdSJTZBf2M0JL0WSwrgCwGPNATlDGFrV45HSsA
	 icJ49IdrOasBr4ejpJ5pl+aY2atCqNgHVNEGfV6TKdZL6qAUEO8mixm/kteMFcA+7u
	 I0vBFqsytp5/7XoMU0JU80AEKAq48Z1Lk5o2ZsdXaeB7HhzKkpjrISP0B2uAtg8vS3
	 1hUNq0TupghMxuXnbRY/LH8ZDWmDwW04gcHF6DcrrVLtoIEx52ysLmHiw/ZNYOmwvF
	 mADaoo9CK3INHhVdw4JUcJQaqUzkgzk5GZgjzyy21HOo6nAcOVI5b3MsH+7iz7tYgD
	 kQDyQcZBbNmOQ==
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
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.17 000/244] 6.17.9-rc2 review
Date: Sun, 23 Nov 2025 00:43:10 +0100
Message-ID: <20251122234310.1723959-1-ojeda@kernel.org>
In-Reply-To: <20251121160640.254872094@linuxfoundation.org>
References: <20251121160640.254872094@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 21 Nov 2025 17:07:19 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.9 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Nov 2025 16:05:54 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for arm and loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
