Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6065331986C;
	Thu, 18 Dec 2025 11:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766057908; cv=none; b=aOnPCSXJ3DgC7zak0efbRfQrVxnfXVDfecMiJwxXBNtXcKo1GOw7Xu+XM8Vo37IRRbWDvjCEFUX2JTNrSpHr06/8PRKv2i/et5iFtg/dL5dwMFFgL17ygsk3d169K8yEFaWCWJKPSgfKgwFYcK64CWPF84tWEz+dzIgSFT4RJnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766057908; c=relaxed/simple;
	bh=yHqmtSCcycea5hP6Wq6y+hxz1wMxs1n6NwXVqG+4uFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=delsHbVrk5E7ftP0LqklMCF80+DrdoX+L97G1p1jm6bSKnnv1moM1K6z6MlpmjUo4dfRnkvOYSpicLjtPYO/okKW6Y+DO2JGcFJTZq//X1bs9ID06JNj9nLKR/c+57SHYcwYLYeomnnnOCTxnLIdWCLTqAkrm3ZzA6E7AynaUxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gzy4le77; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gzy4le77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C65C116B1;
	Thu, 18 Dec 2025 11:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766057907;
	bh=yHqmtSCcycea5hP6Wq6y+hxz1wMxs1n6NwXVqG+4uFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gzy4le77QekN+8o/RiaiPFux51AClVo2n3ax2U5HvgsjEjA2ytBOlghxhAv/2YyjJ
	 KPkqDY6yaJpm3cmNu8LAIABg6CLud8rwRwywRQiKZKt01HqD4eEA2bmJiDbRRotWg7
	 JgqEpu2o1BJJfc+lko9F1kqVuvflvcTZg7qNu8SUq+NtymAMI8zkR/aFRZZ8vceuIl
	 R8EDksKiKVRkHjL61Ie3TB2Gz7ed2zN6OR8FAWquUaJDtk/mP4abwUu8iMRHSHHlBE
	 W45RY4zfAPee00hOIu6T3UhwYNbgT2mn6lVgWPLBCeLH2LhXtRSjbHTUvuko19Nwu4
	 /tIE/14TzbkdA==
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
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.12 000/354] 6.12.63-rc1 review
Date: Thu, 18 Dec 2025 12:36:39 +0100
Message-ID: <20251218113639.72199-1-ojeda@kernel.org>
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 16 Dec 2025 12:09:27 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.63 release.
> There are 354 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Dec 2025 11:12:22 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
