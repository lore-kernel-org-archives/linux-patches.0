Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEE2F9D9;
	Thu, 31 Jul 2025 19:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753988450; cv=none; b=t0buavlazZujVSzVa4hCH/sDMhdDs+7IwXJ0VorNTK1+hNCPb29NUyDUZTXa4CcJv+yYJhd017wAduffWL/bR0mQSslbcf/1YVRdNedFbwZ03/9EocoKrVMLqakrjmmsMI1/p73ltnWeU2VB8KSgQ5WMQnCVh9AWe/z2kL2HPLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753988450; c=relaxed/simple;
	bh=fPnuRIOhrTGnvPmgeXUOaZ6Rf2rtLst6Xb5E/yFrBd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EtYRwpUxzy9xNH5E3lg6baASW1T2A7Gu98IojR+0zLFS81/Vnqi1g3iD2ImdHh90TDtl31NPg2fGMP+Piu10TzCsHFKyb861IzsrvZMR1QOU2gojwlfo9zorGVq0D30kyxGgqS1YFWGgSJs3iSvxg322aI8ombTrcD1TIpdek+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q9Arp3wD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q9Arp3wD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE7BC4CEF7;
	Thu, 31 Jul 2025 19:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753988450;
	bh=fPnuRIOhrTGnvPmgeXUOaZ6Rf2rtLst6Xb5E/yFrBd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q9Arp3wDkdwC4uXD6h5LWs0+bMguAW7cQ2niaQVckmZoUVcmmFZioBrrOQ2G8PeAt
	 JthF8qFVifJBZRI3A4L//W1JV8cdpDPNAld5z8Y3jQJB1TJw/+FTVzcnYab7sKvT0w
	 glywWf7MQFcHgRC55G2/kVRe6NXwMJRmZZ2gSgzSKn/kUpzc3/1z8cJVxNE8WHd670
	 O/KundlxCJWfksDOtzLYX0imA1L2DYDyMwJdeykEC7sng9ZgLeX8wy454LEOK1FqLH
	 3D4SjHsgbU2ALzUxaYNsG+qqqD0gRP721xej+1g9lsauKtWskQoBZrdosxZocGulFw
	 U9X9wR0AzG72g==
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
Subject: Re: [PATCH 6.15 00/92] 6.15.9-rc1 review
Date: Thu, 31 Jul 2025 21:00:39 +0200
Message-ID: <20250731190039.244720-1-ojeda@kernel.org>
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 30 Jul 2025 11:35:08 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.9 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 01 Aug 2025 09:32:07 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
