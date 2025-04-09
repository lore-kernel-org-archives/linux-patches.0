Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F31C268C79;
	Wed,  9 Apr 2025 15:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744213513; cv=none; b=jCgiz2nPPeHQRGOea4n9oD+zmqExiqtisFGf+/tchHHcntPjbUcIfZbPRxT4TkkOoZzoYWat1rrzn9tj3arsdwKzf+s7v6Zbzb/9PzcACi37EV3fj/7LogHWoHkHrxROz9cfYHyNcjp2h9tAZwaxc9NFGE6+HN2wND25wRDjibY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744213513; c=relaxed/simple;
	bh=0OKckvD/RfImEDYPVa/15KrNJv0EGDL5Cl/u2CUWsuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZ5LkSqIqrzk0PJdVwAbeRLBO4SP6IfYsr1UnsjSP64ehBab4ptfdCtlfvnKXk3WW4AtF/sJzfzLizvF0v3fBqpFCXGlfIUGznwPEZHWlAzhO2UC3kT78eMMIELBZC8UjEI2g8QaCoggE+RCRsmKArBQPX0Qy9pqyk19tF0pGnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=clyTy282; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="clyTy282"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F26C4CEE3;
	Wed,  9 Apr 2025 15:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744213512;
	bh=0OKckvD/RfImEDYPVa/15KrNJv0EGDL5Cl/u2CUWsuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=clyTy282Vc78iwjcvQ4i8P60IKgGlQRYgKCVOk2Tu0dZSlqMWHFAO7oe1KPfEFMmV
	 SyuG8pvwcdzwjwb0H13o2sm0q1NnXVxAf0c0RXfsSc7yaklA7gP2L8cg06p+peveqx
	 XH/8nBCZD9yiYbtD/0aFNXLfCjYhFC7Ycy9B8nC55nzOftXSGuh28IaEq0Ao/5uBHF
	 44IOH2lkZkCVXn9QUyihLw/1OC6Xj9GaYcEZq0UJB2Ga2o2abhLrSTt48UtRf7Nkrt
	 zY38aaujGKxPN1t0yURa5c/gnRpybyTgR3vYWPe5OkQKXTYT2zNQPxDvDGqf0eMpVT
	 I0EvlcIZzmK0A==
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
Subject: Re: [PATCH 6.13 000/502] 6.13.11-rc3 review
Date: Wed,  9 Apr 2025 17:44:50 +0200
Message-ID: <20250409154450.1233304-1-ojeda@kernel.org>
In-Reply-To: <20250409115907.324928010@linuxfoundation.org>
References: <20250409115907.324928010@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 09 Apr 2025 14:03:13 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.11 release.
> There are 502 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Apr 2025 11:58:07 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
