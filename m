Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7512E7648;
	Sun,  1 Mar 2026 18:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772388706; cv=none; b=Wz1MeHKQli7oC9/6YcIywwgYH5y6IluQ1VkzfYztFUgUcqMk2DCSAFll2KCBc0lnBnW4pDb83Wt01so/5Q0FIUQOmokL+pyBkoubCmc9ybAZpijJpxpxzVSCx23X+YKDnLGEYiaDoT895VuTLaS2edEQqwvLvY9eVdA1iNMrmuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772388706; c=relaxed/simple;
	bh=Kck8406BQ0qtLhrNYjjHzrjjxJbbCMF8ZLHB8/xVcYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpndiFKa5DlN3onMz+A5a3qxtvE+fPZj9jwZeb5Fy3QpPZfvRo50/P2sfhy6DckrPbgnk+1SoaUdwJntW9zE2qUrxjOlAi1Y0hhBoWv9OGUfDEq0zyuobiBYfaGLkdKS+MhKDQp+TtpEs4pyTg50G6fGMwkm3UNtNlkCfy87Ans=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DdocsXfR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DdocsXfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4326DC116C6;
	Sun,  1 Mar 2026 18:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772388706;
	bh=Kck8406BQ0qtLhrNYjjHzrjjxJbbCMF8ZLHB8/xVcYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdocsXfRuV0bSF2X+s/oDG95GSyVboY94jA2v7CnE3IqQtvZ+eF085Mkn42fMmgtW
	 BCtRE/jDPOBlg3AFhUECxZEbAd6w8MezVcyNinBbmzrmVpkdVb6GLszMnv2EuBpnNm
	 bD0Pg2QcLDoZ1eC5QTbShlSDIS+9/UKxw2Xf6SIphBp4YgAmxYGwmUiddxdZIP1AIh
	 ML4LiMPKuVE7dYKOjBsyihXHa1+xnHkYkN8hG3lzgUUa+vBRrDwDBk52QE7pS11A8P
	 VzUxnNAcDGMfbatwgGcr4R5sDpVprutwCm/BliRJ66J5h1rbHTQvJwgwu04V/38B3I
	 7UHufe788OKzA==
From: Miguel Ojeda <ojeda@kernel.org>
To: sashal@kernel.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	gregkh@linuxfoundation.org,
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
Subject: Re: [PATCH 6.6 000/283] 6.6.128-rc1 review
Date: Sun,  1 Mar 2026 19:11:36 +0100
Message-ID: <20260301181136.176435-1-ojeda@kernel.org>
In-Reply-To: <20260228180659.1583364-1-sashal@kernel.org>
References: <20260228180659.1583364-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 28 Feb 2026 13:06:59 -0500 Sasha Levin <sashal@kernel.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.128 release.
> There are 283 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon Mar  2 06:06:54 PM UTC 2026.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
