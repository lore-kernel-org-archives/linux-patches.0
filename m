Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB4E3A8FEA;
	Tue, 21 Apr 2026 09:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776765531; cv=none; b=nYy7vEITp4kVo7Z3oLqCSqqNVd/onwnzdyqWnyuk0ie1f7zxSimoDlJTc8MP+qd1/6BVCoIbxAgKEdAzNYn01+gnn/v21yPQOGNkxrm60At3r3DjWgIbdFCw2IrwTa9Pm7tlV8yt/Z6K1oPD9mjDkYGrqxVRNXZwkPPHLmYeKqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776765531; c=relaxed/simple;
	bh=Tsq1SH4wRGWaW6shCyBF9cxjiMaM2pGcEJjUycGIkHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFWgM9tl9MuRKlW9avi6fZLkaL0wyJZu19jiI0eaeXW8Vlrj8ANp5q0UUZqrbqN4D+a/vfzn8JMPjz2Z5wPTl51BMjmrccfaBmjyW3FJFQXe2XESexFPJYQdfVhlkZwA2yk/BgweRtjE1EUlR6EzYn2Hj8Gvu1zV3SElOCHOVzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cP3xKsVI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cP3xKsVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BA6C2BCB5;
	Tue, 21 Apr 2026 09:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776765530;
	bh=Tsq1SH4wRGWaW6shCyBF9cxjiMaM2pGcEJjUycGIkHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cP3xKsVIfM1kILDzW4ycKUXK9pvUGTHfseBrcSwd+2BIdsiGmWFM+P0KumzB72UI1
	 lOkEWUgX/r4+nhLTVFZbEjMoNH6v2xIfPRUU9YnXvACZ8pUCme0aEKoyIWxnN5L/wv
	 oM0epl8AYqBESabhGOuC/pYlp0IHdg8bZhbCD75w64NEUceMywaSHpWz1pPPziQMLk
	 UZD9/NZw6FNzHPB5s38EwvNa+54WGupllvRBZbi7hqz6g6l3BGSyJAhPl5UcQbg/Jt
	 6cSJOyasZ92wwBEQAHfhVIhs5j9r0q5XFpoE7gSE598t4XZdlexDJQkBZ6EOoKf+sE
	 9NpzFHHIujcQQ==
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
	Joel Fernandes <joelagnelf@nvidia.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Uladzislau Rezki <urezki@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	rcu@vger.kernel.org,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-um@lists.infradead.org
Subject: Re: [PATCH 6.18 000/198] 6.18.24-rc1 review
Date: Tue, 21 Apr 2026 11:55:49 +0200
Message-ID: <20260421095549.47476-1-ojeda@kernel.org>
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 20 Apr 2026 17:39:39 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.24 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Apr 2026 15:38:57 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

For UML (x86_64) I am seeing:

    In file included from arch/um/kernel/asm-offsets.c:3:
    In file included from ./arch/x86/um/shared/sysdep/kernel-offsets.h:5:
    In file included from ./include/linux/crypto.h:18:
    In file included from ./include/linux/slab.h:16:
    In file included from ./include/linux/gfp.h:7:
    In file included from ./include/linux/mmzone.h:1538:
    In file included from ./include/linux/memory_hotplug.h:7:
    In file included from ./include/linux/notifier.h:16:
    In file included from ./include/linux/srcu.h:59:
    ./include/linux/srcutiny.h:14:10: fatal error: 'linux/irq_work_types.h' file not found
       14 | #include <linux/irq_work_types.h>
          |          ^~~~~~~~~~~~~~~~~~~~~~~~
    1 error generated.

Caused by commit 95721c9fb3a1 ("srcu: Use irq_work to start GP in tiny
SRCU"). The header seems to simply not be there, i.e. either the
`#include` is changed or commit c809f081fe40 ("irqwork: Move data struct
to a types header") is backported.

Cc: Joel Fernandes <joelagnelf@nvidia.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Boqun Feng <boqun@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Zqiang <qiang.zhang@linux.dev>
Cc: rcu@vger.kernel.org

Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-um@lists.infradead.org

I hope that helps!

Cheers,
Miguel
