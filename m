Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D08825B69D;
	Tue, 20 May 2025 19:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747769182; cv=none; b=ndqqP4mMCDRfkMAXCvbvRdZa/a0LOaoOfJ1yMJj5RFitVFTmZBgtMlcnkJU1PWtFLVXCQ+d+yotTGRuA8hTnRb3TQ4dpA06Jz/pUB9iqernn88BMASaoVfNPIp68IZQswQAtLqzYpMdabTiCqy9Kh7gcwbR/Yo1fIGQ/CqkX37o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747769182; c=relaxed/simple;
	bh=EEKZPw1F6ZjbLWINaDq5GKXqD8bK0kWe1R+5RT1/KqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjeAIbsb3Ya+GP1QQs0xzS5VLTd2znthAMphyc52M+thLbnenzuu7OPT9Xi4PLpGOZpJmbdHry7BaZ1gIawKrIrmnXSf5RLrtDgCZzeCFyZOdLKaAJ+65G39j91JJDV8BXvGZ+LsnKWpDKp1uSrXo376cUH6L4IrJ1687S7UHpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U3aog9tW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U3aog9tW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398DAC4CEE9;
	Tue, 20 May 2025 19:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747769178;
	bh=EEKZPw1F6ZjbLWINaDq5GKXqD8bK0kWe1R+5RT1/KqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3aog9tWd6bXcpGT5UjgeE56/ORLeuQCgSDubATJky9aRmIJCSfs7g6Y/J7sB8E0U
	 LL8KSsBHkoRdkCIhpHSk8XgM+gAa+redCwTOybiNAItJ7WzL2sEs1DXJ3UcpFj3mpi
	 GgBD+JW91HR5goyqakmbtLoxWwjME/cAxP8RJSwJmXj/Uer4fU6e0wE3hZRvSDYhhq
	 USSbf5hm1ycuNh3BrIjay2BpbYiWGq/3/xQJLwhACab98CetJ0aYy0Efw4JJkssYqK
	 ggl8xHj4yj1BJAYcDPrwRmL6djFe9acBtpHL0G+46SL6Pwsk5nYW52VO5c9zbnKTAW
	 h02oXqRaHAwrw==
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
Subject: Re: [PATCH 6.14 000/145] 6.14.8-rc1 review
Date: Tue, 20 May 2025 21:26:03 +0200
Message-ID: <20250520192603.890440-1-ojeda@kernel.org>
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 20 May 2025 15:49:30 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.14.8 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
