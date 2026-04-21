Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B083B4E99;
	Tue, 21 Apr 2026 11:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776769886; cv=none; b=Tb0Kaca7dx+nIvoqA1MVJ6DW/lfuDvJLcSvEhqZu+Nu31lMPamLZtfsFSDB/5Nj6hXCA6IqKaBgVOP7FDTSBxEqZfjTiywqM805/Q4B07aa7vp6SXK6keBO+sTp+G8NnqiqoGNCcvbnOjsAmA8zsqeoAVn5xfrGz54QfHv8Nl5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776769886; c=relaxed/simple;
	bh=EUCP/+wIyjuuFsUEyg5Q933mW+t/e6mkILgKhGl+IIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kEVtg1i2bqQtqqQLntuUm3mA0X7mqXOpX/KfSGU5Ml3KmPScFpX0ufEb2/NndMe3Hbc2qbQKTs0GR0ZDBDFLtRfxxhBNraV0f9gZL6Em8XHU3uRWRfmd4A3VFZQzPq1qEKUVBgaqQKhgA90LgCrCGdjxfeKPX5qTGNcaVzdXZ4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mbTl5fZm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mbTl5fZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE79C2BCB0;
	Tue, 21 Apr 2026 11:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776769885;
	bh=EUCP/+wIyjuuFsUEyg5Q933mW+t/e6mkILgKhGl+IIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mbTl5fZmFcBU5tYSBryBs6wfkQxkyJwj6zyC9pv83aHjCcgTKfCMDZvGFMkDuU5A8
	 FEnCZSkBSXWx7s41ioY+4hZWiFYS3HyvH2KUpE0J4zHqjwCFVAikqd9ls4kf0p93uV
	 BZak5ObgHRI9Gxu2aKoK1xpo0pjI/eK1Qi77TQPVg+lHlyGT76wc8+TYtiUNgglqnP
	 reWN6chojkAvkicTb3bYEJxcMTmtW9mRJU6A5qRwtb8+SSE7sxmag/RuUnPPB0+fFX
	 z3j1boww3uG48U2bRYLly9Jab3TxwKWU/BzeGfn1EE0uhf0439miKf5/fwkDNvksIU
	 k956mzhJQQp0A==
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
	linux-um@lists.infradead.org,
	Benno Lossin <lossin@kernel.org>,
	Gary Guo <gary@garyguo.net>
Subject: Re: [PATCH 6.12 000/162] 6.12.83-rc1 review
Date: Tue, 21 Apr 2026 13:11:11 +0200
Message-ID: <20260421111111.57059-1-ojeda@kernel.org>
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 20 Apr 2026 17:40:32 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.83 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Apr 2026 15:38:55 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

For UML (x86_64), I am also seeing the same issue as for 6.18.y:

    ./include/linux/srcutiny.h:14:10: fatal error: 'linux/irq_work_types.h' file not found
       14 | #include <linux/irq_work_types.h>
          |          ^~~~~~~~~~~~~~~~~~~~~~~~

Please see the details at:

    https://lore.kernel.org/stable/20260421095549.47476-1-ojeda@kernel.org/

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

We also still have the many missing safety comments Clippy warnings we
recently discussed:

    warning: unsafe block missing a safety comment
        --> rust/kernel/init/macros.rs:1015:25

Benno/Gary: I am tempted to just `#![allow(...)]` them for now (but if
you plan to add the comments soon, please let me know!).

Cc: Benno Lossin <lossin@kernel.org>
Cc: Gary Guo <gary@garyguo.net>

Thanks!

Cheers,
Miguel
