Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00303142E67;
	Mon, 17 Feb 2025 05:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739769603; cv=none; b=ibPhuGc5zGzZCmeZSqiEUyqSFZy6UZajiUJmRX1Fqcc6oDFsgX3sIhl+I4ZJvoWuc3z8HB7iDU6tjaCBlNlQ9IlrBwdpVPGhDmbyweRKbm1GAPnyLrCXm3Dh8eka07AGlqFcpo5mjPuMGet6l3ADALHPv+uvsG6VIdpF0aEOd8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739769603; c=relaxed/simple;
	bh=xm+v59XtBY4dL1hRvjBnE1/clDQaLUkMDIzo1Ggwx5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2VYWhR/qXU/TS9m69XHsAxscvFujQaG7/O0nCJl/0kKkpMLwBXvst4qCvHqw7hucuM18RqkvlRyaoZbcyQWc1P/QbLRwY036ISkAZXtvfqToYXSpWip3hgEDX7fvcKJi1zVw9wpBgK6exIYXHqqD9U2YJpucOpAROe+ZxCnq6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AAkSqTb7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AAkSqTb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD16C4CED1;
	Mon, 17 Feb 2025 05:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739769602;
	bh=xm+v59XtBY4dL1hRvjBnE1/clDQaLUkMDIzo1Ggwx5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AAkSqTb7AKmbIShFFrBsjpYWcQG3fkhWzks7sITk0WaVRChdSlI+osTAchP9WXYwG
	 Q2hEsiVs4HbMmfQODEkxuXgsx7Rn85rno4citHe9QXklzbYnRx/QhEFT4vOAtJ/546
	 EE3WEdNPVwLQOhUwLZS86xaHvOce+y5I5bNfy/HPI265hCnGrRKZX09gy7VYxZUdzX
	 opOF/FNbMCBTDst6V3IZ9Gv3bf5RjzLlz+2QJg5dIAKL4HTlLBbYb1fPTbx4hRUM2g
	 HtXecM+BCgPP79flsk+/vRKbGY2O25brqnCQzBaFKbb1NNTmxFgakFctzc40MdRRUd
	 /yPdSpt7NAx2w==
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
Subject: Re: [PATCH 6.12 000/418] 6.12.14-rc3 review
Date: Mon, 17 Feb 2025 06:19:43 +0100
Message-ID: <20250217051943.198051-1-ojeda@kernel.org>
In-Reply-To: <20250215075701.840225877@linuxfoundation.org>
References: <20250215075701.840225877@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 15 Feb 2025 08:58:57 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.14 release.
> There are 418 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
