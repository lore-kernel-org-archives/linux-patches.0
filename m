Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7D420898C;
	Fri, 18 Apr 2025 20:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745007474; cv=none; b=fD7h4d6FLAffDOe5xcd3ee0F9Zobb+N1Wf5BW2mZn2bsxJed1hK0+CRA+4WbF1V3AIg4cv9cIg4Rz35wuDdoLTHREdv7sQazb2Z/zoug4GEx3mEQYQQU1OvJihE8YFc44ZseIgvqrFxA7kxQwO9GrR8X6gdWBn/e5/81o4UIXvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745007474; c=relaxed/simple;
	bh=naeVwZjvomuqzHFCDJ0oSw/0ZAOz8mXkDk4L2C4zMGE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R035YBbPMbxEr67/vOajCq3ceIMFgjM1VaFSpSlvP2nGkTOzmSxtq0YknJcVBF3Z6+KHJ8nksTKqP7Pzw9lVSH9RHVYS9/gjSUYLBIUkgG60P3s9kAu8xrEZSxF5AzQUFUdoKw8VSoKjfTVww75CQcj3mLs0YVEehzu9+MqpmIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OayTh5Yj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OayTh5Yj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A960C4CEE2;
	Fri, 18 Apr 2025 20:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745007472;
	bh=naeVwZjvomuqzHFCDJ0oSw/0ZAOz8mXkDk4L2C4zMGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OayTh5YjAx/gfa5lkvQNrrFeyQdlATlaqqADc7P0SF83RAC2ZZFLyqd+x9RFloI4w
	 1NsHBvNcDgLUIyTWC71oq0LupzqR5g+jGJK/VY7mDlEbB05tXeDQ2nEWSctREonJnr
	 CFpYnnu8DsWuLfRArvoplFX2sQEF3aQVvu7SQMKBdiNA18FEs7g8Gd545tr3Ih5X5I
	 16MgEmHK6zOiGxUKg/xZFV75o48HacYpD8xEH2+T2KaYvTyfiW/4cqCZ9X5qoM2Vjg
	 MS+dXExcYaj4rRkbF8lCGvi5PfKeFCsKH6supfbkegOis4gjVB9MUeosekCgJEr31g
	 5A6VMU6C1KqPg==
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
Subject: Re: [PATCH 6.13 000/413] 6.13.12-rc2 review
Date: Fri, 18 Apr 2025 13:17:49 -0700
Message-Id: <20250418201750.69045-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250418110411.049004302@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Fri, 18 Apr 2025 13:05:17 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.13.12 release.
> There are 413 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 20 Apr 2025 11:02:49 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] dc7115a5e746 ("Linux 6.13.12-rc2")

Thanks,
SJ

[...]

---

ok 9 selftests: damon: damos_tried_regions.py
ok 10 selftests: damon: damon_nr_regions.py
ok 11 selftests: damon: reclaim.sh
ok 12 selftests: damon: lru_sort.sh
ok 13 selftests: damon: debugfs_empty_targets.sh
ok 14 selftests: damon: debugfs_huge_count_read_write.sh
ok 15 selftests: damon: debugfs_duplicate_context_creation.sh
ok 16 selftests: damon: debugfs_rm_non_contexts.sh
ok 17 selftests: damon: debugfs_target_ids_read_before_terminate_race.sh
ok 18 selftests: damon: debugfs_target_ids_pid_leak.sh
ok 19 selftests: damon: sysfs_update_removed_scheme_dir.sh
ok 20 selftests: damon: sysfs_update_schemes_tried_regions_hang.py
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
