Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2AA1F7092;
	Mon, 21 Oct 2024 18:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729534022; cv=none; b=JYVR76SjnQt14JV88klC4gMDnEAReJ3pvM+AvpxW8Oo9INLWqQV/bRQNN30hPdpPJP+Lcp2uqS9zjIR0vS64/EYBtTRChLjefnKf43iaigYpHOOoMjgKwSPU2Z21/sYcJgyiCdV4wmqItCSPTeLUZHHEFAcNZ3OCgSnxTpMJgv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729534022; c=relaxed/simple;
	bh=N1P4SpvEisAZkX8uxkg3T/1fd9Nqz46XUppzU1JC4M8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HyAUKuMefW3el+72Nnz1X9XwHzYnH3nXPhI0/eQ3sESqm1aWGfMud1WB4HyD770ptq4TB11assEC0rHq9geAI6YW/BCL+5RNOCJDI0raGZyoU9W7c80Z9DHXa3xs/H+gpEsNIR9EZbw1Q/HBEEsmz3v9Zq9yMqNjBejNoy5PvUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V0o65PXO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V0o65PXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097C9C4CEC3;
	Mon, 21 Oct 2024 18:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729534022;
	bh=N1P4SpvEisAZkX8uxkg3T/1fd9Nqz46XUppzU1JC4M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V0o65PXOUpg9B4VAipUeeqSy295Ok+To5W/wIgIwnh9gDyUSUZW6qt9AW3Blw+HbP
	 uHI/m5A5xjhqP8g/eXyD1kuYO5tbLKo93TUOXglFnPa7Jr3BDWSH+tftQwAPt3GIFp
	 yrNp1a1QXfngAtu5NAdPvALatvRMxOZXePYLNg9OwIjPIRcGy4EfV8UYD/CmpoX0vD
	 LCs0aG76QQ6lpEjGXWxrG4yceg+G7c8+WRCqZt4E5Ty5seczwDl2/25YFs/lIIeEhp
	 s8cNlrZO2bQqRmEuQOxAr3LesKMWD5mpd71KhmQa/CaSmSojZ5DoqMceak1/WSbYx1
	 +dAS4O0lq8OZA==
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
	allen.lkml@gmail.com,
	broonie@kernel.org,
	damon@lists.linux.dev
Subject: Re: [PATCH 5.15 00/82] 5.15.169-rc1 review
Date: Mon, 21 Oct 2024 11:06:57 -0700
Message-Id: <20241021180657.14895-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Mon, 21 Oct 2024 12:24:41 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 5.15.169 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.169-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 4d74f086d8cf ("Linux 5.15.169-rc1")

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
