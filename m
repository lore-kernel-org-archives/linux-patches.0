Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA65551D518;
	Tue, 13 Oct 2026 17:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791911154; cv=none; b=seVXf1aIcYuXFsoeGrR71mMi0R6dgRsjnFQpXmRmGaUKYfJ0/AGfyi2o9dsC6u23Bk9LxgT8IxPeAQ7AwUfRLG2/S8lS5lNOtIhEc5Dhsl00zE8G7C7YQexbpzHxFpdH/fDfuG50kztBHJhOp6tSC0VwqKIA/oxMKuwRYtDLJZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791911154; c=relaxed/simple;
	bh=PXCsB4Yph6IGfnLMQ7rwd4ClhE7Ln77YlJ+Jc/LJNs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qSZlJFkDOXE+pPwKqmv+irXap/v0Vh0DD0Q7KYUJYQhO3gVmcGhnCbMhsLiPmeOOhIelBdd5xEPT/F3FkEyJS61b5LMezevNx5QjCUp/fG2bzKh0IELB86baXPtrfuJm47K9DaGba26cq+RLbhxebXWhX5azyjOBEkj7HZ3Z/U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=in9NWXjI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="in9NWXjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B15F1F00893;
	Tue, 13 Oct 2026 17:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791911153;
	bh=5r+r1svYPaJp7l9SwRQeTZMaxLko3mZb0MGrpWmU0Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=in9NWXjIcjQe6e3GTBR6ivKZPLKOED0l8S7KxXs8e/zFZE3R5AGTs+554SML5+Odn
	 QvgdPgsMNtt+k/iu3DL47Jkxwj0JyHGdoffbaehKRX7mlJZKOxWkCBnE2/KR3NZq9N
	 3/dRlpv2lGa1ZMMf7cQWRnBGFwK5f8IwN9byFQcR4WbHNNTCJaUANAzNTHFapKzIxT
	 0sl1XISmN3IUCvEMp9EmjctITZQif8xcUy5dYc8dhiXjK5wLXVv1T4CSQpVBNb/HDi
	 e8+NoOhQvHeH3INVIjFIH9ZpLfPrSRFOtw1GVDiyU/8tMurgB9nMOLXtkcCgywNwRq
	 snxIciP/JRCFw==
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
Subject: Re: [PATCH 6.12 000/497] 6.12.113-rc1 review
Date: Tue, 13 Oct 2026 19:05:42 +0200
Message-ID: <20261013170542.22292-1-ojeda@kernel.org>
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 13 Oct 2026 13:32:47 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.113 release.
> There are 497 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Oct 2026 11:28:22 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
