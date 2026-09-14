Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14DB37B023;
	Mon, 14 Sep 2026 05:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789363231; cv=none; b=HFTpjFWtmqP/akGit+MQjtoma9TPgMCoRN/djJwOZ342iBMyz/AGjTLUqXgAeIvsgAZHMoGEwU2HQKBBoZFdAc8phMDlYTv98OtkJrl4ppwUq/9eDaJ5uUQu5gbQGPqiLmGis+3J0lANOUTZS2ahAlITqTkHQxpL7QZZHFLLsgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789363231; c=relaxed/simple;
	bh=2UJMZAgtU3srhJATYzjx5htnHwSb4KAtuU7pFRCvAv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMUqoqp6fVSxI29V/X4pbaCts5Y26N8TtEtzrXvSUPsPl0l4Doga1QAseNseuV7eWVGgxXAQ9rT8n775jIqYYymgHH/LJaAQ6QXfXC+o4OdEWhoGW+mBM/F9FSawFEtuBPoKiu7ANjr4LtuHk7rI8j96vS7nI1OLqJYjCHeNzEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aUoMN6VI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aUoMN6VI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ADC31F00893;
	Mon, 14 Sep 2026 05:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789363229;
	bh=OMHj4KBtsq2csuh/+aAZoDHUaJT5fpuNxuBbrJWKY3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aUoMN6VIa+UxLY6uMmukUsFFETRHKwkOaiwQN5Wf/LOR3jLWP93xTGEtXHb2tPXpV
	 Z4Wv0oa6eXauVx6sjjH5b4NpwFgzH6avtBfnhi9Zz4ZVV6n3eRBcdSl1T+RIEPa5wU
	 CNGlNDgJGFaV8SVgyP1OeW/8+NoNSto29OAE/CL0S65IdyTD92i2qX/URF9Wz4kHJL
	 iWxsNtgSerM9068qd/5EjmDrFcPe1luP5ESvGJZLJIacK+VPjxYp1v3JNQKqtD3KhN
	 lX7W6PLKzeV/UdHtxyI6pI9ZcqhvMIFaXXLKcULTBpYnn5SGrisLQpH9PvO+wSRHY3
	 MXWw17hxt1dvQ==
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
Subject: Re: [PATCH 7.2 0000/1815] 7.2.6-rc1 review
Date: Mon, 14 Sep 2026 07:20:15 +0200
Message-ID: <20260914052015.11371-1-ojeda@kernel.org>
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 12 Sep 2026 08:29:10 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.6 release.
> There are 1815 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
