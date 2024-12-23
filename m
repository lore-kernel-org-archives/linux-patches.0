Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EF61B87CA;
	Mon, 23 Dec 2024 21:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734988492; cv=none; b=rz5YI9r6wQXzbJaCqS1eCAXkDY2Pzx9cZBvvrS8/UvUGjxQP/MIrrGBK6P0wSfN+uncjYzpx68/e+YxrVQ3zkboPjTJdmRmYAl6JGG1XdtVfF6O2xBdO8Zubs9wH7VjUULQIUWyN+yEAL3sHmCyL67lX6t0BoLdL78Q3qdLR9YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734988492; c=relaxed/simple;
	bh=BLeE5UrwETd595fCIdmxeSKbvpgoQJj7lZNti+Snccc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Vm1huwEqVcBCsAtdW40dDfOSne3Sex8Jl8HrvpVGv6+MAM9smN8zkC1R8Bv2oWwcC7S3B5WmpTG15r8weERZjdgw23FeoEN1RfoHDjOEzvThODKsDGk5VWKfSg1FNhyqMqT/6tOW2VpdzUXiKtRTdbWyu+G66iev3GUSJUkItRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uNQO6UNX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uNQO6UNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249F3C4CED3;
	Mon, 23 Dec 2024 21:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734988491;
	bh=BLeE5UrwETd595fCIdmxeSKbvpgoQJj7lZNti+Snccc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uNQO6UNXzuCY9kYkca9oqbR1b8ikCTXlVxDZkMjFhBKWGbwu0gTgkVrm3LSVNPSGZ
	 VC3+AaEdlnxcK9OqkqnVKCgkb8iwYVwTaCadh61o49HlZu/qCiFRGpD2/mPQp2vPLU
	 Id440WbP3D/loCYQtzjeKc1FTH0pYWjDQP7m5Bu+WO0ZH0H2xt6J/LHJte4z8vnWq0
	 nPkAyo+G8txd2ix2XVV7p3OaBYBJFirpXkj9JxT2JOZT2rBsvmKNLu5bS5ADnS697g
	 b9OucciqBZsrezHmMOzbM8A84l+EWDemDh1Nwaj/FSRraNx1GnivKvBPMq3pXMeigl
	 OkHo7NLJRjfng==
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
Subject: Re: [PATCH 6.1 00/83] 6.1.122-rc1 review
Date: Mon, 23 Dec 2024 13:14:46 -0800
Message-Id: <20241223211446.83285-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Mon, 23 Dec 2024 16:58:39 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.122 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Dec 2024 15:53:30 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 7823105d258c ("Linux 6.1.122-rc1")

Thanks,
SJ

[...]

---

# .config:1427:warning: override: reassigning to symbol CGROUPS
ok 15 selftests: damon-tests: build_nomemcg.sh
# kselftest dir '/home/damian/damon-tests-cont/linux/tools/testing/selftests/damon-tests' is in dirty state.
# the log is at '/home/damian/log'.
 [32m
ok 1 selftests: damon: debugfs_attrs.sh
ok 2 selftests: damon: debugfs_schemes.sh
ok 3 selftests: damon: debugfs_target_ids.sh
ok 4 selftests: damon: debugfs_empty_targets.sh
ok 5 selftests: damon: debugfs_huge_count_read_write.sh
ok 6 selftests: damon: debugfs_duplicate_context_creation.sh
ok 7 selftests: damon: sysfs.sh
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
