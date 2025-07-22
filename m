Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C5D6F06B;
	Tue, 22 Jul 2025 21:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753220508; cv=none; b=JzklUiK1vDIoklHMbQxJMLvU86YBgmVXuGkCT+028PxSk1OcbNOzX9gbIi6WrLtgO5/IR3O+eiwv9ndT22KNxG4S3R2c3tNT+o6bMwW4niOyW6ktXt5b/pVQd8ttzawlT+0vmwTgTltlHIUZ3+Rm0s4hrppttU3MHS96oRR56Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753220508; c=relaxed/simple;
	bh=KJfSeVZZSGPu0dZ9TGDmSrsNruA4KWsaNNimkALiR1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6hGXVKpz1/1vICEvG+SK+vYcy6xACdv9wvfnCs5yHBn14bmLrxD+Fw0RyYsMHjUr2Oq/TlDHuuv04NJHp6TJukV2IZvK6cz2SvUwWaSBWfJtJJWpIJ3mD2QNe2i7BO7V74WlZuWyDy3sz3jkaRQYnhuxWkCZg1Z8t7kVLhjMrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rx31rOdt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rx31rOdt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B29C4CEEB;
	Tue, 22 Jul 2025 21:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753220507;
	bh=KJfSeVZZSGPu0dZ9TGDmSrsNruA4KWsaNNimkALiR1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rx31rOdt8/XsT+8zFGp6GxmtzOL49zRvEjLiJYVABl5v6LJoFuiEvDcILuVMXDK1f
	 hftaVlfo2beWmqn+1mc7xf3OOLzakku8slhI2rC9IKf56Q/knZVV+h81vvgbvBFv9I
	 CF83dXWCMjmQOUVvlpzk4QrFW8W11kDOwgU7ksld9UOnC/JIUJu+Gd+F0hShm9Mn97
	 93CwYvJhUlrhcHmmj9LSNYAo+C3VBWcGRXP0g45fKYo7LXmgIVE8OJgecWWhAF6sz5
	 +KpPDscHsQ7YUgoYbky8R02aiEPAeIGUoOb7ldjvIqp4h1aJUJ3V3fYz+vO0tN9pbn
	 6GhwC0TNzVx8w==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
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
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.12 000/158] 6.12.40-rc1 review
Date: Tue, 22 Jul 2025 23:41:26 +0200
Message-ID: <20250722214126.1676425-1-ojeda@kernel.org>
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 22 Jul 2025 15:43:04 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.40 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 24 Jul 2025 13:43:10 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
