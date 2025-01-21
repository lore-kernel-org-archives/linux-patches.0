Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC351B6CFD;
	Tue, 21 Jan 2025 23:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737503122; cv=none; b=ehON1p1kyiJXIJNxBrXgSHQXPiBk8SZt8XSPlGMUrQhNsvHq6JsKxkINbk+FcxI6kyh07TBGQ2uAsKSSw6wCxESoPcK1RjZkNwOO1OFqAuMdeXr9gC9W5HtWNPinMxwQe/uMp/gQv5NmZB71LhO33F1PMMflLcy3IEL2modXrOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737503122; c=relaxed/simple;
	bh=9Bdryr/LV0/aEmJ2jCfkeUZvK3m4huztlyg/6CT476s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sbyMzO5OuqQJ/L4xN+XWOeMj4uJkurPaYzfIHiIiltY+FYcRrCBu3a7wSi7SjdgF86mPBaBVfyY2GQKOYPTdMEwsLecrV8rR3Tt8y3JSvWWYpzOwNJwCcHaZ5UARb52S9xpW7m/aBwUceQU0d63ZC6gSGNxT7tf1JsomWdwiCc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ENwLi2GS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ENwLi2GS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A7EC4CEDF;
	Tue, 21 Jan 2025 23:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737503122;
	bh=9Bdryr/LV0/aEmJ2jCfkeUZvK3m4huztlyg/6CT476s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ENwLi2GSBgj7VjpX2YcIF4XhiUK0+3sO/v8pYaURUV7sOoBZqcZgcdctMt695x4di
	 HvF8mufiFs4f9AxGRCRzLEpV9BdEMW6PaxAgKbHIzjYSTJ2zmFswX6cYI3qM7xkriB
	 jIQ7ijgRO498yI31AE3f16+8haO2BvtSR3aUSZ56tOPBG5B+aM1BvXIVpQPPPulh49
	 7TUIGsuwW2Ubo2pn5hMQ5SSqkBFDUYcdumvwXnl9/jUtrQ+/FM1dgowpbiiSt3S9Z0
	 lfZdPuL3SXlH0kn+oxQrJcflRY6kA+1zJ1+QQE1PCKkEjSHmAfm1DBiHSD5CC78/qA
	 nDd8xUkadAjsA==
From: SeongJae Park <sj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@denx.de,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	damon@lists.linux.dev
Subject: Re: [PATCH 5.15 000/127] 5.15.177-rc1 review
Date: Tue, 21 Jan 2025 15:45:19 -0800
Message-Id: <20250121234519.46087-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Tue, 21 Jan 2025 18:51:12 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 5.15.177 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] c77b3036a1a3 ("Linux 5.15.177-rc1")

Thanks,
SJ

[...]

---

ok 1 selftests: damon: debugfs_attrs.sh
ok 1 selftests: damon-tests: kunit.sh
ok 2 selftests: damon-tests: huge_count_read_write.sh
ok 3 selftests: damon-tests: buffer_overflow.sh
ok 4 selftests: damon-tests: rm_contexts.sh
ok 5 selftests: damon-tests: record_null_deref.sh
ok 6 selftests: damon-tests: dbgfs_target_ids_read_before_terminate_race.sh
ok 7 selftests: damon-tests: dbgfs_target_ids_pid_leak.sh
ok 8 selftests: damon-tests: damo_tests.sh
ok 9 selftests: damon-tests: masim-record.sh
ok 10 selftests: damon-tests: build_i386.sh
ok 11 selftests: damon-tests: build_arm64.sh # SKIP
ok 12 selftests: damon-tests: build_m68k.sh # SKIP
ok 13 selftests: damon-tests: build_i386_idle_flag.sh
ok 14 selftests: damon-tests: build_i386_highpte.sh
ok 15 selftests: damon-tests: build_nomemcg.sh
 [33m
 [92mPASS [39m
