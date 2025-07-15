Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F77C1547CC;
	Tue, 15 Jul 2025 21:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752614058; cv=none; b=k1LOOcBwMWfg97uoEH7vpuf/Sfsc3tn/Y4jwukMklh0VM39RI3sEZVNKjt6G79yc87ouCzHYHPhtwocczB0zzS2xG8oyPHKwRm0hAZcOU3h9PwGKLyNkyGVP4NSpwGP6EAL8194g3Yc2Ta538N8QhhI27UdIy7ZpsQGVh8k560Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752614058; c=relaxed/simple;
	bh=l1HDdk2Dga3BhQfnkBWQBmV6ZDOpZSctpamr3txkh2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrTQGQgILN0CM7T2dRWvd+eG/IbDnwuNUAx6ysawSzKIGR7SP5+zjOd7nWCoq4bDOuC3rlAAKWTXrTUF3+4gLPTxn+mc9v0siOMmP8Z5Pw9kVA0t4xvH9/N8nrlwzEfXsaQe0M6nmRnvxZyqCm6N2rF7stMS+SQmP03mKRZxKRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rZkijdek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rZkijdek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CAFEC4CEE3;
	Tue, 15 Jul 2025 21:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752614055;
	bh=l1HDdk2Dga3BhQfnkBWQBmV6ZDOpZSctpamr3txkh2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rZkijdek6Y8UYL9f5erlMjq3BZ6viH02X29W/wGjKKi+PcH7r9jMc0dzuK5xnyNHx
	 EEusc4vrLaNbMGzTKMm8vc9BBDotzOBUIqByhnO8IyJGLN8V/vPsLzdsMwc8St1uas
	 hvIPKlkvpBk98bXJpupzoLrOwsXFzTlzxvJuxd6lAcJk5X5chH9bC9H/rjtf6XKVT5
	 rU07fK7or3xJcgr9sBAjbUCOBXTLGJDBsyE/bpni1dCf3ruTzPV+vjlGMrjK8qZefS
	 Lo0IJqKKUnno44xw737+t6ZBTd/k1cfCWteoZjQ8hRIHQ6EfLhofnLoNTuXCurYpz9
	 01X22A3Gno98A==
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
Subject: Re: [PATCH 6.15 000/192] 6.15.7-rc1 review
Date: Tue, 15 Jul 2025 23:11:35 +0200
Message-ID: <20250715211135.2341473-1-ojeda@kernel.org>
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 15 Jul 2025 15:11:35 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.7 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Jul 2025 13:07:32 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
