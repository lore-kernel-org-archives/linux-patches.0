Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB8013AF2;
	Wed, 25 Mar 2026 00:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774397181; cv=none; b=Uey2JWkWZsDtPclgNEXfnkmCIKy6xOVQ5fS3MU092ybbf8ihfbZkS48YqO6M+bdCDFBWUOygfSGQGxWxNm37oplj34nT37xfR9PzGEJ543B/5BCqavhL6apd2yz9LVvkHedgw2rd4/bFMKaGyuBzvV+5hVzOeh3Vie5mhtpwWaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774397181; c=relaxed/simple;
	bh=rtx/GwBonszQDxGj5U68zVSgeG9wkjyz1r4pFqBJDzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPb+q/kEQ/SEUSbIdFZToYrUIVO25hW7arvUxDEN9Q27FYGgguIkSLW/xuXWCGepU+xcrIwKhh6CRXrPtyjPMyycYFDWkqEt2/tY1AunFdzi+usPrAa3XHEWcTd6jwALAiphFwYS/K2hAmjb9sa3rBL6QAaYjd9nXvERGBvFx2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cgnqMIBG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cgnqMIBG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07D9C19424;
	Wed, 25 Mar 2026 00:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774397181;
	bh=rtx/GwBonszQDxGj5U68zVSgeG9wkjyz1r4pFqBJDzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cgnqMIBGODpFq2uSjLZCU9kGYP5hgakFCtufWBBDXZJMR5yXo3y6qDhC86D4ix+MC
	 usstSyKIWKKX4ABgOJFVWYMB//aN/9e+03ARJLqztO2BLvEs0cuPrt8SDhyAMW8lC4
	 njQOo8aHZwdzAD6q2NO1zg0XyKoToEflj0X07fEg6hB5amkBuU5HEJPlE07t/7Flmk
	 ZUtvja6u8Tq1zJ6ARdE8uj+44a7CvNusitMnWprsJK3bMcwT5O7QRIbfv+0574rMkQ
	 VaH0Zkb7eWTKalkIV5XD9ePAk88f95wrf7FS1BDtv/jHKcOyjQ7hH72dDv96bkQF6w
	 NMwILWLhasA1A==
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
	Miguel Ojeda <ojeda@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Tianyang Zhang <zhangtianyang@loongson.cn>
Subject: Re: [PATCH 6.12 000/460] 6.12.78-rc1 review
Date: Wed, 25 Mar 2026 01:06:00 +0100
Message-ID: <20260325000600.57287-1-ojeda@kernel.org>
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 23 Mar 2026 14:39:56 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.78 release.
> There are 460 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

loongarch64 failed to build for me:

    arch/loongarch/kernel/machine_kexec.c:139:13: error: static declaration of 'machine_kexec_mask_interrupts' follows non-static declaration
      139 | static void machine_kexec_mask_interrupts(void)
          |             ^
    ./include/linux/irq.h:698:13: note: previous declaration is here
      698 | extern void machine_kexec_mask_interrupts(void);
          |             ^

The `static void machine_kexec_mask_interrupts(void)` for loongarch64
was not removed because it was adjusted in:

  429bf3f04c24 ("LoongArch: Add machine_kexec_mask_interrupts() implementation")

which is only in 6.12.

Cc: Huacai Chen <chenhuacai@loongson.cn>
Cc: Tianyang Zhang <zhangtianyang@loongson.cn>

I hope that helps!

Cheers,
Miguel
