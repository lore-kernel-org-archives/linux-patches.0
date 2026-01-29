Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6254C34EF13;
	Thu, 29 Jan 2026 20:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769719142; cv=none; b=Wdq/fztM2g+MD/yNGV3FjN5WvtX1b2UUpfczBbzjR+eX6td6Pvcpt8hktInD39l41ePQZdViW4+oGWlX0WyHM0d8nQyLKOcCuYxPc4yMeoaKIUvqExkOODqra59hOjWDEhdY5WVtPsFt7EDCiHrmDmQ2aWQ4YjVkh1c1ELqu+TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769719142; c=relaxed/simple;
	bh=fnnoqB2EEpjl2NQJe2k7g/OVf6+1YZXhRuIbiiAbTp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNt3yZvxD6rnMg1/DvHSKlJxf4ZzcGakCTD/DNVOup79muLLesBR0cnBWrmLJaWjfzsQu47xBFaSIgEJHuZMN0Y9uIyCfJrvRWutWs4JFCmxnLM2D+Wtsv6jPgU5gpdlPN1a6qGtTbYXysVqqknljZG1BDBzocU55UCpzXWUKxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NMdD6PCy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NMdD6PCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B499C4CEF7;
	Thu, 29 Jan 2026 20:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769719142;
	bh=fnnoqB2EEpjl2NQJe2k7g/OVf6+1YZXhRuIbiiAbTp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMdD6PCyyZcv6Qd+YLIUFHo3Wh5LJcg5/5gUF7R9+y2p9Y+EYAfivhz8cUb6Pdp+V
	 l+dTFTlJUeOSFvf5sbPOpRmKS8dhQOYZ1rRg/h98Ay/DLE4EuIj0gx0A6+YQGonT7E
	 ZJ8trGMMrBcfmZ4yGUMztn6ONfLCY7P2n3/xvOKOmWF//NWfWne3SHJ4T0eQXKJnAI
	 wun/LmvdaJtoBSkN4CzSxXn/806Lea8/dy1KJcYx2AKrIpvVUwC2sn8mNn9Y+BeyZF
	 aRfEoc2zWeisJXRWAsRJxvXluVxMhzj/cRt/Y6N/4ToMo3yctzajhCAubrLId+A9MU
	 XyZgQAvGsbJLQ==
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
Subject: Re: [PATCH 6.12 000/169] 6.12.68-rc1 review
Date: Thu, 29 Jan 2026 21:38:50 +0100
Message-ID: <20260129203850.46166-1-ojeda@kernel.org>
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 28 Jan 2026 16:21:23 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.68 release.
> There are 169 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Jan 2026 14:53:02 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
