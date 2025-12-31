Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11E141754;
	Wed, 31 Dec 2025 01:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767143394; cv=none; b=dOFMB2/dggG/cZVj9hh7o/V4qCnko2HyyV52zw5qKT7EXqqHSbPEuZVBeR99ncXJAmXp33UiUM7xGHLqD3QM4l3yr44wRr28A8PY5SNvWnauFocWtFiJZKjIxFEaSulXw6ypq+MeVFLYgQRnSZ8u65A99eApuKNRZc1AqMXjt3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767143394; c=relaxed/simple;
	bh=2D20Csq8Kq0j5ry5UL1P9kR7YyPe+ntTwWzaRC/s9VU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XOPzS1vJRLX6rpANUO8NoGZfpMz5/3a0KYCoaFcrSQu6QzTDXykC7VyNcohNk/vdrM8UR76+XYQolFolfxekUGgxIsQKxGcXDaD5Qs18GJTNPl0jMFxMBVaxLnvoh2obia453dfkMiceAbvRHs7qnJIuwyKrb23FO2JySjvm5jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dCD9s4LG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dCD9s4LG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD74C116C6;
	Wed, 31 Dec 2025 01:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767143393;
	bh=2D20Csq8Kq0j5ry5UL1P9kR7YyPe+ntTwWzaRC/s9VU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dCD9s4LGUfk3vzYIwxoU2xzkZ2F7sJyLR195WQe9hAPqgjf8n36u5dPeYKuCMG6Cq
	 zEODkY0/3HUZd4T+zIzM27lDtIDE9QkGaaPKL3R/QnbapYzSYF6NPPqyedZLiKM/+M
	 1FNbW1RcgvBzRzPhMZmO9CF8A2sExHezTEWgSG8qWzOZrpj0OXHuH6t68S3PYIVxDl
	 Cz0U2tiIwrIdkQ+jo2HK9cloUaY6etmvExshq5Zo0flhXWgP+E/slrK0IGRnP5k0+o
	 usJ4I+LGXhj+K2gBDaakmCFwn2yanP3pvECl3JpGfxgJ2tKGqnB+I6u7zkr8N6fTjI
	 +IJoAIineeYwQ==
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
Subject: Re: [PATCH 6.18 000/430] 6.18.3-rc1 review
Date: Wed, 31 Dec 2025 02:09:32 +0100
Message-ID: <20251231010932.91680-1-ojeda@kernel.org>
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 29 Dec 2025 17:06:42 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.3 release.
> There are 430 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 31 Dec 2025 16:06:10 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for arm and loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

For arm32, it is possible to get build errors if one tries to build Nova
so I sent a backport request for consideration:

    https://lore.kernel.org/stable/CANiq72=ti75ex_M_ALcLiSMbfv6D=KA9+VejQhMm4hYERC=_dA@mail.gmail.com/

(And for completeness/future reference: for UML, which I build-test as
well but so far do not report here, there are a few `rustdoc` issues
which will get resolved with:

    https://lore.kernel.org/rust-for-linux/CANiq72nScSLkB0ix6Rw=SfpqDirx_GgcCzgHLucKd0d=s5aZ0w@mail.gmail.com/

)

Thanks!

Cheers,
Miguel
