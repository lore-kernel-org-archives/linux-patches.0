Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A75387361;
	Thu, 15 Oct 2026 06:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792045224; cv=none; b=Z3C5Zj47Z9pdaPY9yH1zNf4WmR3wKfedbOxJmsPlCwQdsjsN20PFHMVPje0DiYByA3GQnmlcaEizZ1nv9VAEJJKvZwE8Yad9DfEeVPV2tS9pbjQhV5uqsabjH6MdrroArupuXCspjO9688Bksrtsj7fJ2PGBbLty9PgNF+tRVyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792045224; c=relaxed/simple;
	bh=mId7PmPZbLri7LYdcIrRIUWRHXEHGUvfCJR6EcV9HhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfDKD737+hUa9mOLC7JxzDRmlHZMY0/ATMDdXy7wiYgeJBKh5o7BcRE91kbct5Ny+ehoIk4A+mnRAwxxqm7yCRANYpEydWvcDGQUhyxQcAGGlQKmbV9vOTiXGn5GxN29NSgzKmOL+Nsi3LKQzZnC0rQFZZJjxnm5ulna2Zv3ZWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AwZTZ+Gl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AwZTZ+Gl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239DB1F000C5;
	Thu, 15 Oct 2026 06:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792045219;
	bh=1j1SOrkEAmUUCPqJHLNA4Z2pRqtlnI8fPwoYU2j4lh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AwZTZ+GlM50LSynITTunT3e/z/h46t+SqFj6QxEqgQl6bdgmz8WLDkMCbGs5z7wRS
	 43TRL873SM7hOJ/hdNVf6cMwwovlPReZ5fuU0G7bG0+zAQ3lkaOkCs64h/3RUPSuE4
	 WB5LcFJcgIJkgcHyEvrb7xDp557tRnDkv0iaVgQYtzFv97xcMVVxAhSTgcz4EFzw1i
	 yHtXRaJzcpKiKIfusvPfc0FHyK9OqhabGJ/e7Gmi+UeL+TEInqRyhCgY2OSn0Lvd9i
	 QpCNsUxJq1tFkS1cFM8o6+IUxVjgnmuMZRQQSgQGz7MWG1aBweoeMCRt7UwXXi6Bqx
	 0Zpu5CYUByYPQ==
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
Subject: Re: [PATCH 6.12 000/505] 6.12.113-rc2 review
Date: Thu, 15 Oct 2026 08:20:09 +0200
Message-ID: <20261015062009.35867-1-ojeda@kernel.org>
In-Reply-To: <20261014123803.944920639@linuxfoundation.org>
References: <20261014123803.944920639@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 14 Oct 2026 14:50:30 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.113 release.
> There are 505 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 16 Oct 2026 12:37:19 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
