Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F762698AF
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 20:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745958491; cv=none; b=j1gzY/xHGXQxtSPcBvXnhJWFDufnx9YNw4w5O6s3+zdsgEj4Tqtt1o7vRVtbdp9bTISVEHoWNzT3zefSaUNRledw1fhZcpLe+IUZCoXfD7cDJYUH6C5VKJCjjIOoGq0PbFH+dBpGosnqfiEVnCn6UZHJBc2qMUdEw26dRdRuaUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745958491; c=relaxed/simple;
	bh=V5504nCr5YVY+aUVaTaQum/nWhvhVD1JVWfcTWd0F+o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S9+Im1GQtOz2Y3/K4KKOOQC10+N9RfqW+RSajayY2+LXUpE81w0Y/7BRYVFxGDQQx/NR7L3quYAukDZkUZgvlQpIAowM47ZbPYTn+rj39rWxYFS/QT7mFOxzfNthnDHvbNcWPRcdTvxldloyt68kPX7qL4ZLQpbAjb1YvuU4xkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cQQC5h66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cQQC5h66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5ADC4CEEA;
	Tue, 29 Apr 2025 20:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745958490;
	bh=V5504nCr5YVY+aUVaTaQum/nWhvhVD1JVWfcTWd0F+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQQC5h66yl9wAfWNZ0V92DQXp/qI5ztJpLg4a33RjISyuiU2JAMKNRtlcQQeiWpkK
	 ViYWKkutM3w5EJ/Z1PBeW1veqhXwIjgl1ZdUhDryve/SV6ZZ8PVjrngTtaHFncvZUd
	 a/0niFuWzQ3ibyMKlTRJk3GyEGCiEdBLG0j/fvhu1ghYiNrCLLE+LEoCRT+jqfw4dc
	 DWfzj6z2+3VsUJEh+n0BTmDp2ff/U/1gcLXaq84I1k/1LDRzrB9n9s4s4EfBC0E/Es
	 UB3k+tRLSq6kRk02/pcFK9krOie/x+T69D3NHoOu1/zynqPm94D47ZE/4fzkSqmMMA
	 NE9PS7VOfSZxg==
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	patches@lists.linux.dev
Subject: Re: [PATCH] arm: Add missing includes for mem_encrypt
Date: Tue, 29 Apr 2025 21:27:47 +0100
Message-Id: <174594001259.473241.3974467799211720649.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <0-v1-47aadfbd64cd+25795-arm_memenc_h_jgg@nvidia.com>
References: <0-v1-47aadfbd64cd+25795-arm_memenc_h_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 17 Apr 2025 13:26:16 -0300, Jason Gunthorpe wrote:
> Doing:
>  #include <linux/mem_encrypt.h>
> 
> Causes a bunch of compiler failures due to missing implicit includes that
> don't happen on x86:
> 
> ../arch/arm64/include/asm/rsi_cmds.h:117:2: error: call to undeclared library function 'memcpy' with type 'void *(void *, const void *, unsigned long)'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>   117 |         memcpy(&regs.a1, challenge, size);
> 
> [...]

Applied to arm64 (for-next/misc), thanks!

[1/1] arm: Add missing includes for mem_encrypt
      https://git.kernel.org/arm64/c/20125324c01d

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
