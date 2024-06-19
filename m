Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AD2612EB;
	Wed, 19 Jun 2024 17:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718816781; cv=none; b=ak8Ul0HTo9DmkIDbLITdsGBFHbvTExS+jubJCApoNQ9hY0hQCjPaH3CTzKaHWv4atpYX4Z5OupOXtajyNurhaXz4uWHtRKQ9IB/6yQkX+jQ6hXpRqepPZC/I8AMLfJdV8Dj3bbcfd6+Tt7jJotLPT+Kr89rknsk3vtC1VNf1zhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718816781; c=relaxed/simple;
	bh=u+cx7JBJWKrkSWj+QVeN9WXGGXWkCQ+1NHqZd+FwIpA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aUM+XOJn1ZHv8VW+7muzwWjY1Lhxmz4HjmKRvS5iWFceP2sJRTkL35Y+FJM8nlxojnXHzbzmuKvPQ8sDVfN/QP8bJDIgwYampQTGyTWA2H/nx/OKb/T4KJtAoeilUgBpVgfVhB1inMfBpcL1hpIjAZ5rgx+lP5K6k5Tjb9u/8fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d9aYHk5V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d9aYHk5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F0AC2BBFC;
	Wed, 19 Jun 2024 17:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718816781;
	bh=u+cx7JBJWKrkSWj+QVeN9WXGGXWkCQ+1NHqZd+FwIpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9aYHk5Vjowguvu0aJ6HiySDXlgS5E1fiUXs/JU8oVy43Gu3c0ihVSAOT7nUp5hYM
	 pHwCkQDPHgmfG/lE9jn+rbr/uO8LAKpC9r96EcYiBENTRTW6+hPaTh0Dwuil+Z6vbA
	 UveV28WwrDhziU3LNDgnOLmzk5k45ZarbXVdHuwCxU1KQcY+gVJ/YAbNpseZ4QeA76
	 tHTHeMwCAl+yhh4S0fLnAzUZ087hcqbb0pybnR/atowlPCp2jlLrd5zXMfSE1qXN+q
	 K3Eg0bcs3oRwUBlK9frg64CU8tQ/zTasMw8oXLInHOnPQ191OcvPUaIgVJrfMaDXyg
	 So1Tal9gcyQSA==
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
Subject: Re: [PATCH 6.1 000/217] 6.1.95-rc1 review
Date: Wed, 19 Jun 2024 10:06:17 -0700
Message-Id: <20240619170617.108938-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,


On Wed, 19 Jun 2024 14:54:03 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.95 release.
> There are 217 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Jun 2024 12:55:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.95-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] 7035314997c8 ("Linux 6.1.95-rc1")

Thanks,
SJ

[...]

---

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
ok 11 selftests: damon-tests: build_arm64.sh
ok 12 selftests: damon-tests: build_m68k.sh
ok 13 selftests: damon-tests: build_i386_idle_flag.sh
ok 14 selftests: damon-tests: build_i386_highpte.sh
ok 15 selftests: damon-tests: build_nomemcg.sh
 [33m
 [92mPASS [39m
