Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6A51BF33F;
	Wed,  9 Apr 2025 17:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744218143; cv=none; b=LAdXoBS5lKcX7dM5TuswLPs+xW7eFCTYtRxYOBnxXe49pk11ceRoARjwU0AL00X+XiQBHYnkGJWTeyqTXBMT1iwFusLCkj0vRbItVBiBpWFqYDrpgF8vPH7DQvqwwQRf1Ya46FZbdUca89zUMUCgbi+S8DQU5WVkVpnWltPNKXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744218143; c=relaxed/simple;
	bh=/u41XI6uvihLXf7P4x6bd9qPEqdbmFcdJO7teKWxRJA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I+lXzgxuxBWoCArLbH7ADpIfBJikA4wmwly36+j/svVl/ktbYrn2seQbk7S+Xhq9tZcfZr2WgoqgbAQST+6+zFIzQnOJUMGxXiDa0d9vtMc+PaL1V5IJ72lpEZaCkLC59U8LoUV5qJRw4fUqNVNekU/SM3wZUC/6mdtVW7eTwBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nldhErR1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nldhErR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E29C4CEE2;
	Wed,  9 Apr 2025 17:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744218143;
	bh=/u41XI6uvihLXf7P4x6bd9qPEqdbmFcdJO7teKWxRJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nldhErR1u9KnUEp9PQ3CkE8M+vwYOhwB4jTVbQDZoPYUJmwhbNelZDKw3a/KlTRev
	 JvN0TcrIxN2RRS+akdaTgKOiRDhDqBIDovCBBIZntw/B0O9tnkW4eAuP6djo5sB0Nb
	 18q01bffZ9Nu0+BbTB06F/gijtrTMfug7sZmADVS66Q9hmK+ACyWs50fkJHEEMI8OC
	 HxR4h3Z+6Xa/dqJa+rGgH2YlfkTbeStZhpPg6OUUwN2SgMe95CtzdJT4TLvRXn5H2y
	 BLbctFwt7Xd3gbhhuLknTJ5NmmOGjQWQILmQwTdglDTmUTYwzFaS3xOkrL0SFFmIX7
	 bQLv6b+gRUI6A==
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
Subject: Re: [PATCH 6.14 000/726] 6.14.2-rc4 review
Date: Wed,  9 Apr 2025 10:02:21 -0700
Message-Id: <20250409170221.23509-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250409115934.968141886@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Wed,  9 Apr 2025 14:03:36 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.14.2 release.
> There are 726 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Apr 2025 11:58:08 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 2cc38486a844 ("Linux 6.14.2-rc4")

Thanks,
SJ

[...]

---

 [32m
ok 1 selftests: damon: sysfs.sh
ok 2 selftests: damon: sysfs_update_schemes_tried_regions_wss_estimation.py
ok 3 selftests: damon: damos_quota.py
ok 4 selftests: damon: damos_quota_goal.py
ok 5 selftests: damon: damos_apply_interval.py
ok 6 selftests: damon: damos_tried_regions.py
ok 7 selftests: damon: damon_nr_regions.py
ok 8 selftests: damon: reclaim.sh
ok 9 selftests: damon: lru_sort.sh
ok 10 selftests: damon: sysfs_update_removed_scheme_dir.sh
ok 11 selftests: damon: sysfs_update_schemes_tried_regions_hang.py
ok 1 selftests: damon-tests: kunit.sh
ok 2 selftests: damon-tests: huge_count_read_write.sh # SKIP
ok 3 selftests: damon-tests: buffer_overflow.sh
ok 4 selftests: damon-tests: rm_contexts.sh # SKIP
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
