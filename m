Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7442DF13F;
	Fri, 10 Apr 2026 03:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775790389; cv=none; b=G1ZI8tGsDxkTnYMvxERbhfjZdIC3jbxsV/ULcsfBPzLoHXW2+2TICWVDWNaKEmyJs7Yx1n0Or1owuOka47ngpr2t9RyJF+eUuwsxqR1kXIFTwh6VxRQnY5fEBW4fp/gIAdIEbUdRFLY/B+0xQzcGIkDkSoDFX+JQlIySBGWO5I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775790389; c=relaxed/simple;
	bh=Tf8vCgldFUBRr9Xt5B+9qq6kfVEzE04QacFG7bCoGFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lv3NfJM3URlHcvMl+3jhaXGb6bj8PVySMhLDY78bd9dOdrY57KEFCOclGBnJBprsVK4N5yPjYmHkAPyxxQBtB0J0Dh7eQx4SS4Z64M26leFRyR1JKgP4mukwPZny8HFjpc0SVdknXdHFl1kjuOm/rZkpc45mkYS6vJk5/SflQHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l1oJ2TKm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l1oJ2TKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF09AC4CEF7;
	Fri, 10 Apr 2026 03:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775790389;
	bh=Tf8vCgldFUBRr9Xt5B+9qq6kfVEzE04QacFG7bCoGFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1oJ2TKmq0qshfhrFhFWA40LRRNBn8qvWLYrIqsxmR9ww82hBGV29HIOjOp6Ru/Zf
	 HSs3rnxcHa+KntGbTXym6NkG81piXT64XWSqjln+Nf4UdG7s2ZgM4yZrud9Jpay25O
	 PgG9FtyXm+xByp6FNWuaIDCEGZygzfnuBQhUnJdTquT3tm89KlmLyPK8yD4gFEr4C5
	 /HiV1N3avL7oLXur714EyF4DmDq8x7PbQY0qdxPBS8P4TGOPoPYx2RqK2zU0hvNJ0w
	 HPjNIhkkqXeVyHVk53/wxGJVzBE6TIxe34PnxIAahuDCtRt2DBs2v68z2gd1PujvKj
	 A5RHL4aI4zh3g==
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
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	loongarch@lists.linux.dev,
	Benno Lossin <lossin@kernel.org>
Subject: Re: [PATCH 6.12 000/241] 6.12.81-rc2 review
Date: Fri, 10 Apr 2026 05:06:03 +0200
Message-ID: <20260410030603.70733-1-ojeda@kernel.org>
In-Reply-To: <20260409091733.126574279@linuxfoundation.org>
References: <20260409091733.126574279@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 09 Apr 2026 11:25:21 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.81 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 11 Apr 2026 09:16:49 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>


In loongarch64 I am seeing:

    arch/loongarch/mm/tlb.c:292:19: error: use of undeclared identifier 'exception_handlers'; did you mean 'exception_table'?
      292 |                 vec_sz = sizeof(exception_handlers);
          |                                 ^~~~~~~~~~~~~~~~~~
          |                                 exception_table
    ./arch/loongarch/include/asm/exception.h:9:14: note: 'exception_table' declared here
        9 | extern void *exception_table[];
          |              ^
    arch/loongarch/mm/tlb.c:292:18: error: invalid application of 'sizeof' to an incomplete type 'void *[]'
      292 |                 vec_sz = sizeof(exception_handlers);
          |                                ^~~~~~~~~~~~~~~~~~~~

Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: loongarch@lists.linux.dev


And then the many missing safety comments Clippy warnings we expected,
i.e. the ones that we discussed recently, e.g.:

    warning: unsafe block missing a safety comment
        --> rust/kernel/init/macros.rs:1015:25

Cc: Benno Lossin <lossin@kernel.org>

I hope this helps!


Cheers,
Miguel
