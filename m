Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE42187859;
	Thu, 10 Oct 2024 11:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728559347; cv=none; b=mK/Kqg3dpjv6jvDzSRV7jPjtKeqME9Jiq/NRUmmjuyoo74sAZvCizXlfOG1GOAMQQ7nVr8WW4ERDzA3LrnChmwzGEc6ewDDhcQy+FD1whjzT93cjWSRB6rtmZbOsggeLAkSmSJFIEPR6Rdj719GmPr+S4pwzBHtdxGTgcOWixu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728559347; c=relaxed/simple;
	bh=zb/sK7vdopk5pWKEaozXvIMoyy0gv3b/LLnVXReUieM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9iuFO4bFS/nON4TSSYqpqDv/nkul8i+Z2PFAs1mFxqhsuGNyIZxSX59XX9HT0BztgU+3n4sQT0FZg94LzMUyd83ELTKg9XeyjUkt8o0T6exFNrrXTS6PwQd2o4r4C0+7gDjVnvpPqm0uorl/+RIH6M4evs6aBk4oLeKCT8zEc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R9lOGrIc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R9lOGrIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3962C4CEC5;
	Thu, 10 Oct 2024 11:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728559347;
	bh=zb/sK7vdopk5pWKEaozXvIMoyy0gv3b/LLnVXReUieM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9lOGrIc573Or0MzEM8BxCCgoRQVjYySPoQalQvgL3qH1O4SfwER+k1cSrKXW/J8O
	 OXBmH/jHbvLgMEQ1H6vbAC9rEqCNlFZRIiukROhgEAz8ZBEz8rHnrcKzFUjGwPBLoe
	 Yq58StIOWGXYzULu23l/nqGJB+hc7cJNqIAPheM9f8kuSTz4XwD857DuP+vw0niaHf
	 zoC4H5izokIEe8v5kboNVXcV2lpC/EpxkGKeBBO9gtIGeRm891X9gO/8ivRZW5MNBu
	 sZn66qFobz0G3NylOS0N4ySPh27h3wavBu013SklPPZoL/9xm4JcI+YZ5XyBD9UKDG
	 J2lcdMbaSPbsQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	allen.lkml@gmail.com,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
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
Subject: Re: [PATCH 6.11 000/558] 6.11.3-rc1 review
Date: Thu, 10 Oct 2024 13:22:10 +0200
Message-ID: <20241010112210.120135-1-ojeda@kernel.org>
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 08 Oct 2024 14:00:30 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.11.3 release.
> There are 558 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
