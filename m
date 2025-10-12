Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821FE257835;
	Sun, 12 Oct 2025 09:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760261771; cv=none; b=i/kDDTSS7OOwx5Kp6Xz63tvOS0IJjAxTDHWCzL/S2WZHNjW9f5YMtS1KkVGnkBgLWupi3G358lqG3Z4lc3CyWgncruVyHND1FGEGqGFmWvxXVSZwkaZBXOTOoFH0pbZiyG9knfQWi42fAFY51OOXkXq/SDGEeZDHY/1a6K53z7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760261771; c=relaxed/simple;
	bh=lT8dXl2OHQdoyls/7ZAdocD3D+q/jleayrMH5gDAgbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tXFJ93YfzqkgMQaXFpZaR2vLoDyDav1jhIXqq7TM07NxmfuxYm5KCFtH1CFxA2Vj8QhyyhxARL0yuVgtvxgkB5E0IBW1tB+F+yaOzSG+c8Et/Ht8gARV9HSAHpLxHOKRJRBENTLOhSODunhgAAIQEr6sEnpa6oWQv8Gd0Rt2i+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I2gKVLJ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I2gKVLJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96160C4CEE7;
	Sun, 12 Oct 2025 09:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760261770;
	bh=lT8dXl2OHQdoyls/7ZAdocD3D+q/jleayrMH5gDAgbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2gKVLJ9Is5hLZCPS+SFvMkL+PP2acakq7YeE1uL436ipjyJNbxqlyTNeH6JAMxIS
	 wyW84SRBZyLy+syvaQmQYD/Rh3M0+Gn+2PEor+RHwWrjORWrrESfjcTHR/ZLL7Fvek
	 67hH+/EktUURtfbCFMdrRN2rciuq3VM6fTL1njqgm6xgZCqdWG7IG4wKQ/cwZ1Bojy
	 TS+4lQzWcc/lH6exytlFgsikX70Aaj1VEw1GXQSqB6HsyniOlqQ8EH9FguUgK32uvh
	 JcpOLHM1wYKzQgT2Paoc2moCrBFhSzcjaRVDirjMxtP2bEn0/aDOCWOnJR6Oq9B9yH
	 Ktfy3zBjaAwtg==
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
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.16 00/41] 6.16.12-rc1 review
Date: Sun, 12 Oct 2025 11:35:13 +0200
Message-ID: <20251012093513.998332-1-ojeda@kernel.org>
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 10 Oct 2025 15:15:48 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.12 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 12 Oct 2025 13:13:18 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for arm and loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
