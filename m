Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B46430BA4;
	Sun,  1 Mar 2026 18:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772388883; cv=none; b=CHJlvLQ2mYu+gvB9v54YeeR1pcBuDVVKLHtoxIRKrVzeyC89KslwTQwIoNjDV6xhcjeJtsTDxYlqhWE0zRW9Gb7TCjhaiUPSK0hK53bBlAneQxAniModAVXVyI4f0njVUVMTiNR3JxMwQeuz8n5mvKYwDWHFeJERQeWBwN+S+wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772388883; c=relaxed/simple;
	bh=gOxLAVKqgvcTml/GU7xRyDrFwe59jBdA6ufFcXyIrMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2mQbIAlkG6mlll7hPtXN59BMyZLA/pvyIF2j6u1WLHSCWtQ3GPmknU6CGg3nYeimCCqjHw0smycy/0euo+oSpruBxJksK+VMKdh+eYHd8TcszpbfuSFXAfLGpzPsi7PdpHLc7YIqFBzdQnj5LGuzgSi2D3N7Nbff5HUeeGZ2RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lr5NCMl0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lr5NCMl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C4EC116C6;
	Sun,  1 Mar 2026 18:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772388882;
	bh=gOxLAVKqgvcTml/GU7xRyDrFwe59jBdA6ufFcXyIrMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lr5NCMl0EOrdLLzBZABfv1YGqHnUjQ/6h8qoYENaQ9MXPqjcnEtKA205EHcrHsOxd
	 rXVgTcTUEXT5pCuJJR2WVjzD3QxsrhGEZDDzWdZWSkwyQRNLIQl3Xf+6dmTEjV/egQ
	 kjjEDqRgJ8WBcEL0hokn/It9Fb1YQrPPJkPA8AhXUSctW8vJZlAeCDauJYW9gOwdTq
	 MKyjb7nhd+H4mXQtqx9iWG2Ey0XwmD6UxugnD4BqonnOiSyABj8/D1gRoAS+Dd+Dvd
	 vOLlTt2xemRwiZEIKF3KKgIwBngK02hmD5zkPi4nEl2dUblYeCK7vE5bfOKBSj8eCW
	 VV+vfwFB25bWw==
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
Subject: Re: [PATCH 6.12 000/385] 6.12.75-rc1 review
Date: Sun,  1 Mar 2026 19:14:33 +0100
Message-ID: <20260301181433.176830-1-ojeda@kernel.org>
In-Reply-To: <20260228180001.1567994-1-sashal@kernel.org>
References: <20260228180001.1567994-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 28 Feb 2026 13:00:01 -0500 Sasha Levin <sashal@kernel.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.75 release.
> There are 385 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon Mar  2 05:59:55 PM UTC 2026.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
