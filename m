Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9229E46D570;
	Tue,  1 Sep 2026 22:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788302041; cv=none; b=VFq4hWL6aHxPEa++DYX6hee727bbyOTD7krppGfPqpOJVJ+kaaS4M/T8HrR3PFAngDJSfQF+QLriuf/lIfDDfTMGFEZMbf44DIWw4BBk7aK6GuJv2OVtwtmyH2rhAAIiKSrktcWU4YZQ0jGZ8uJ0pPplkH3PotKUKF17fAOjCaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788302041; c=relaxed/simple;
	bh=CK9QugsfVWlODOR3i1ZQvCkqbxtgFZDxrf9xZuOXspE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpKIgoXgz5QMsRqOD85jSn0sEl+ZnK22zpQDLR23r1hhPh9E5ubAr7hbhNq86UUwVWlzpaE1VI9pLPMEZNhdm8PbPYJ9omWH36VpwBvQ8RAakGjxMZxdWZYX5w37io4FqMNU0N/+HspBy1tseaTAf/j6s8jpR99CUvEQ/oYgN8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m1icMuZo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m1icMuZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF0B1F000E9;
	Tue,  1 Sep 2026 22:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788302037;
	bh=JWlKuopyTcckGtg9jBUM/eoxF9vcLclt3gLWdh0alIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m1icMuZooEHnDdg/hB25TuqXTcC7aq41CIC6pKuRA67s2Kt1nObp/KNiYMiah0bX4
	 YDF6e8bKJwYwybkHlcZrxdJQTqVJcUmMInY8mnSCLp7M0RTkIBfSm1r1Cw7GCBgVeB
	 0isGkCN/dF5vBMTPLCwA2L6Gnwbk7cGW/LRZjKXADMHaUk33WIURl2lsJl/AMM6IKc
	 l0Fw0w1ZXUF3LOaZTsKMPeZETl7XZPJZQuQffY8XZ1wImlo2Jf+9o3XOOnPy57Pl0h
	 kANkgs1QDdt0imUlLKVncCPi7nBnIvQdOCQkBuCSNd6qz12wg0AM+aMeUFNiciFBPx
	 2efOxsRQMAzow==
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
Subject: Re: [PATCH 6.18 00/83] 6.18.49-rc1 review
Date: Wed,  2 Sep 2026 00:33:48 +0200
Message-ID: <20260901223348.61877-1-ojeda@kernel.org>
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 31 Aug 2026 15:33:36 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.49 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
