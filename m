Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A2724E4C4;
	Fri, 20 Mar 2026 00:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773968248; cv=none; b=o5WL8lqEE/SbkEUar7IF/cp1AvAWVFbkGG/ypbxzGVrp0MRb4VhM//qmhZO2TVRUOACE2K+GA0A5bsyrksSjrXYfZkPFC1QYhDy+ZEYuW/eB8ImX/LCSkoDW9NxA8AKqqdq8Wf1Ugr9QgiRVp0Lf5TV1e7CMiN4HlYI+0sH4V5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773968248; c=relaxed/simple;
	bh=W+9HJfJPf9wqFCI6oCCSaTyhBlCnoUFnn4yggbcrPKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXG9WwsqBGpq+OmaowxmpTiyHxGsyj+0iC8uX3Ss1k0RbqHNcddn9/k1R1e8PWqv/Z31mofMahQHGv+mvn3QLjICyGt9mEvjthnfI+n8vaDdF2XbGX60NYRU4exeCF/FNiT9GmhiFqR5Yjy6PybmgVt8diwx1dq595pDDtAxi/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vGv5Wgaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vGv5Wgaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758FBC19424;
	Fri, 20 Mar 2026 00:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773968248;
	bh=W+9HJfJPf9wqFCI6oCCSaTyhBlCnoUFnn4yggbcrPKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vGv5WgazTcd1qYIK2AbTYeUb81oyFzxTh2hUxvCMCKhvyiWkBFvqtdgZC+hMYlu/l
	 wjOLWEnR3i3d+LDfVHihpwGJHuFo9V2Pj29yYCXobcn2LXkhTuqagY68RKk3mRj3DX
	 JRpMLS7VXuh2bjVsfRmneEFeEtI6Jz0rJ/8QfEH7cF1kA8tVgECQcyOcFP+OOtPdd+
	 0HTDry5ZVWs8F4HfLVegxdkTkvY/ocjCUTBkUdiNw6mohe6Pl8JeOtBJwWncCxWcdJ
	 hOoPPDUStEYwDhmEkjJgygLgMl/OjvoKhDW3FGqDUrFcBIO93AEwt7HHUyVZx+5j/l
	 8zu3N0yHJ3cYA==
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
Subject: Re: [PATCH 6.19 000/379] 6.19.9-rc2 review
Date: Fri, 20 Mar 2026 01:54:39 +0100
Message-ID: <20260320005439.10312-1-ojeda@kernel.org>
In-Reply-To: <20260318122547.233850204@linuxfoundation.org>
References: <20260318122547.233850204@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 18 Mar 2026 13:28:05 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.9 release.
> There are 379 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Mar 2026 12:24:39 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
