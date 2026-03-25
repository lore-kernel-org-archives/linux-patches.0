Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4B718AFE;
	Wed, 25 Mar 2026 01:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774400653; cv=none; b=RaC1NqGBLcjtDCi9IGuyAR5TsfAAzYusSWlazuHYPu3EvgJzG/cZGY+3jk5RBScgb02hqfjj0XOCJd8F/BU1oOn7sR1pY72ugob5MB/E+ZpiA7D8S+WF9xh7IqAvxrVXB/tuHvjREd2K6bNFFW4urjwQzZ+dY+DwhM9TL+yL9yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774400653; c=relaxed/simple;
	bh=xuio0iUNCd9Dsa7TTkNCacQ8OxsZcaqyEFOvTKUEK6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttqVBsRW1OKWCJVNHjJzwdeWqTHs2Gdo2qQtgWjP+Am1mf+IElmF9FxgtqpIIeXaDPtcP64A4/xsceTQC184l7lMEToFf9TZbtGz00t++TRMavKSCM6u1CxWR47L3lnL6d0g1ux2kwRGanWDjNzAo1nAHkCbDQMv3+ZaY/HZwdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N+IXTww2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N+IXTww2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B7AC19424;
	Wed, 25 Mar 2026 01:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774400652;
	bh=xuio0iUNCd9Dsa7TTkNCacQ8OxsZcaqyEFOvTKUEK6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+IXTww2TQ6aT0wzvLKu3u2se94ZDbvY9MgeE8OZ/jn6e3j/Wgp8Y+DZNoOr7GRKJ
	 Rz0KgBmWU8vuOpjZf+xalWcZ4/unyUJAKlIsQ+bCAP1vRgxlwgSJSuxyRS5xmjauvq
	 gxgwPnswNQnKs+TLKkywzsgN6X3+jOkuU6dsDxdBa1hL+/E0l1TW7JBPn7XsQL+qE3
	 9Ctk/M+DkzLcPVDfowZ5GxDIrx5iEHhNsmww7j0NBpCixDeuEKH4NSY+115Cvy4fQx
	 cbUeBsTbznRc00Da62Hj0py6zFCXymI73KJoMa27lzFxg9GYXj8QcsCJOcQUOVdcbt
	 4EmnvPD2x68Mg==
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
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-um@lists.infradead.org
Subject: Re: [PATCH 6.18 000/212] 6.18.20-rc1 review
Date: Wed, 25 Mar 2026 02:04:01 +0100
Message-ID: <20260325010401.62938-1-ojeda@kernel.org>
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 23 Mar 2026 14:43:41 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.20 release.
> There are 212 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

For UML, I am seeing:

    In file included from kernel/fork.c:108:
    In file included from ./include/linux/unwind_deferred.h:6:
    In file included from ./include/linux/unwind_user.h:6:
    ./arch/x86/include/asm/unwind_user.h:23:12: error: no member named 'flags' in 'struct pt_regs'
       23 |         if (regs->flags & X86_VM_MASK)
          |             ~~~~  ^
    ./arch/x86/include/asm/unwind_user.h:23:20: error: use of undeclared identifier 'X86_VM_MASK'
       23 |         if (regs->flags & X86_VM_MASK)
          |                           ^
    ./arch/x86/include/asm/unwind_user.h:26:7: error: call to undeclared function 'user_64bit_mode'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
       26 |         if (!user_64bit_mode(regs))
          |              ^

We probably need at least:

  aa7387e79a5c ("unwind_user/x86: Fix arch=um build")

Or perhaps the split of the guards added later.

Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>

Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-um@lists.infradead.org

I hope that helps!

Cheers,
Miguel
