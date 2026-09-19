Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3A81AC45D;
	Sat, 19 Sep 2026 12:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789820306; cv=none; b=K9S4rydx8OU3FY1ubYX3g4dUPb8virKvkGnAS7oZK/jIiG2k8TJAHuaqIyHJ2G041JDACB8WgIqD1JBK2kNNZv8mkZhkXO3/jfq6gtr0H1OBpGnLkNPcnnuFL2aW0FdxPVCyMaJuQ8+SxlWPyAM4DBpdKBojZ3/QL7y+YaAB/0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789820306; c=relaxed/simple;
	bh=NeVNZfR0A4e5YuF2meqYktz3FNEuX0YNerHqJP/cImI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qn1bDmifx+YVX238TmGrf26dLoVifUFKD9Wx419c3zfssZf5xzwyLcNLXNj7PEbYreo29eCaoX4ydlqg0plfd62xUyue1iZrTbT5/MbCRrwQ4p+c3QvHyKzrZ57/LBUI5AIIDZSXFW7GzDwU1hQ3P8IZoIrR3XjHvMcjSVS8RlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=buDwRhvV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="buDwRhvV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCF61F000FF;
	Sat, 19 Sep 2026 12:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789820305;
	bh=RRmsfDe7kABvI7NYSvu9KbsRWTvTO1MiyAdgvMDw6Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=buDwRhvVkEPUh1VNcOAV8R92+tQxgIDCYKwMKd4z4JEm1CclM5PHHW83t+7ahx56L
	 G9nyiQ7gJrQyIlqSEEN+ASQ+imIbRI/JhFth66nCZ30/hRNC9Io9d+Izj8dz5Rb+bE
	 4UaCvVUy6qTqc2vxjavKaHRlDfUxJedqlnWqWwhYWqNXBIBSC/E9AO0N3/APPJOFZe
	 WUXleDPGe48CBHJ23QWy7P3sjnvfwWBXnaNd3K+1jqogyYczhlHxrG0HybBFqG3rn2
	 BonddK4WdSbNJom4j4gMovFdFTYq8FatP3Y+v1o0tn3JIvvkmfA7y4LZtwycelIPDx
	 jvWdCknGLWp5Q==
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
Subject: Re: [PATCH 6.12 0000/1102] 6.12.111-rc1 review
Date: Sat, 19 Sep 2026 13:18:02 +0100
Message-ID: <20260919121802.14038-1-ojeda@kernel.org>
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 17 Sep 2026 15:59:03 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.111 release.
> There are 1102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 19 Sep 2026 15:13:49 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

I am also seeing the `gather_bootmem_prealloc()` issue.

Thanks!

Cheers,
Miguel
