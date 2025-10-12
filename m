Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA73259CBD;
	Sun, 12 Oct 2025 09:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760262176; cv=none; b=O+kvKNHC9sns8dBZr6ZC23IgPcno45sD7uNumusGMKmpXqEbcbsDmfEdGiemEVQDYYFteHkDqWctw1eUnhWqW3NsMi7Paj7A7docYc+v1o+5B3lQFu+5Hg7JtD1vdnFKxxV3+MNdz9y00FvMQQLn42naj8eNEKJaevzOeV7sNGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760262176; c=relaxed/simple;
	bh=eXbz3xcm2kvi4Ssphk3RGsiJ37NS013VUnXfooBPvfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbYEJ28XFhY6er32L3TbBoNPJdUfIkXLV3tYbZH46s3wJ2JbMmgsS4oH2WpuVzV/D0GCe7wOjOT0mINhQ8WbrxNRJK6pn6LMPzzP3I15PZfoVyjuxY2cO9fQbDLi7s5G8aVCfcNafcg3/AKl6KjEiMJpXmrm5d+GkS1HQ56lcAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t6oclDvx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t6oclDvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B5AC4CEE7;
	Sun, 12 Oct 2025 09:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760262175;
	bh=eXbz3xcm2kvi4Ssphk3RGsiJ37NS013VUnXfooBPvfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6oclDvxMpT43LDW9K9UTD3Ztko2fsPICYJQkTfbVwcK+LqOgtKXY5sEoNwRFOZR0
	 zjYNtFhRKQMVJNOhXw/j2BXgFfYU3tVSV6EhtOQ1Pyr+Vt8CCdLOdu4EqqEe85cgf4
	 iJSb2NtXbotxigZKMC3mDWQSGVpC0P2C4JYxmDNDY2ojDaam6+zuzPR2uRDf1TckEJ
	 LT0bFlfsStxEWPBtQT/ADulG4S1CviNp428pCQSv4+aOlTcaa36bJK8pDln2A7+Fow
	 sc0TlQwFp2+sQRUp7V6A63ZH3LW8VLdimO+yEqECJ2SO2u2yKW3HVmmM6lkgMJYM08
	 bpQfeeXQgGGYw==
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
Subject: Re: [PATCH 6.17 00/26] 6.17.2-rc1 review
Date: Sun, 12 Oct 2025 11:42:44 +0200
Message-ID: <20251012094244.999162-1-ojeda@kernel.org>
In-Reply-To: <20251010131331.204964167@linuxfoundation.org>
References: <20251010131331.204964167@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 10 Oct 2025 15:15:55 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.2 release.
> There are 26 patches in this series, all will be posted as a response
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
