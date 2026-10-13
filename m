Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DEC47AF69;
	Tue, 13 Oct 2026 17:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791911036; cv=none; b=YWUa3Tfg0JL3BiMpuUZMhkNXpFuInD6bTnlxG3/eNERp4vye31UriW/H30ffdr8Cp7gb2tycX+a3D9Nh3VfuV5hWGrYYvmRT9yKSWC5LVYeIuGVjri/9m528EyFwQjV2jllMooOgFoYA4P9lfX3jC5CWKpHSD20gWzzZScGWfik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791911036; c=relaxed/simple;
	bh=l4me5eq9qvD4sA95K/mdLe/rdGBXH223D/ydDo5UTqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QeDUxACi63Mun1pTjYgyIFbyC9t9E2RROJhSZpICJ7BEYlz4AvpyNARNA262zrjaBfIZ5atKMFVjg3J4y3QxKoMRXwwfhzqmvbKyycdK4F4/vjrUaupKNV92078+F5XRfF5jfNAIgr75Ey2tArlXbAZiVKQ4Tq/78FsTX2AccDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FhuKe9I8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FhuKe9I8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972701F00893;
	Tue, 13 Oct 2026 17:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791911035;
	bh=IdoTl08jwxNFavbJ/t/Zy3Nw20nqZDIgGX6bK/w//rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FhuKe9I8vfsVThdx4aiGHURTiiMMpPo2mvOEy3E7cdkQoHjxaX4aJeO9C2SUvK5Z/
	 +vFz6u4h9M5waNfUZpgdqZEEiJJSefjRevvNIkL/DV8HMQl7dUj6izvVZP2X4Hashd
	 ov7AG8m3EKTTUnTvQgKy88xAXVYcHlS7uHGSyo1jp5FPs5ljbj2yoziRNx4qdtj93B
	 5koy18UCHjIH+ux+QzJT8Cqyfd3BcXh8rPmQi6eMu/8pYyNS1vnsML3rQEyzTiL4fE
	 R+r7AYg7Vblja9ljQwiTUIJHygeRhtu5m/j5Pu4N87vYsDLfbtXBzzy+Q4XbkF2vnc
	 ecZRCkVimcIOg==
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
Subject: Re: [PATCH 7.2 000/281] 7.2.11-rc1 review
Date: Tue, 13 Oct 2026 19:03:43 +0200
Message-ID: <20261013170343.22020-1-ojeda@kernel.org>
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 13 Oct 2026 13:35:16 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.11 release.
> There are 281 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 15 Oct 2026 11:28:22 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64; built-tested for loongarch64
and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

riscv64 fails (as mentioned in the patch).

Thanks!

Cheers,
Miguel
