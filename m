Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466121F03CC;
	Tue, 21 Jan 2025 23:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737503302; cv=none; b=FCD+9PabmpysWi6ojnWs4lRnU2CZntTLvBwAr/58PrvTrbsPkU5YxWDoaIRI3ScBNJ7AkdJjLQ4yc1Dp/0jl6OuBGtK/0XY7AZvT0jzYIlGS5ZLmw7vV0kyRnOanF42wZhlsLatqT6JiUqRcWZWP2r5FtnbwERAa+9jaXGeweh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737503302; c=relaxed/simple;
	bh=vU1kbUF6HQu/ec4JJjDageLe13K0/9FfxPwt8iGBOn0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Un7H7M1KGrcVMytui7pdB6gIRLIAa0i+M2L9D6o4tkjjGC9EzV7X9gLydpuzmOkSDhHioiAPDfI6jdC4anjQn2dj20ZkGY5zOM9sguhmO31LLjfSzuFVYqoJstgHYtLbXa4zkCg3wrAhbp6oNFe4o1ofK1VxdY/mW8gKpm8Hh9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bjDmI6UK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bjDmI6UK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84ED0C4CEDF;
	Tue, 21 Jan 2025 23:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737503301;
	bh=vU1kbUF6HQu/ec4JJjDageLe13K0/9FfxPwt8iGBOn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjDmI6UKy0T+kFEXwWbr1HSIdDa7QL3slqdd9G7fgVLyHJhnbAS6QgR8GE8omM/Hw
	 6dX1DoJT716FlYLjfmkjfjWzOQgHPK9aHcnrCJkq3QwDiQ9PrmQ+vLttpvxmuWeI9J
	 ttZQ4crB/1XVHnecb9a9/Xsd/4g5mlT3aTYxoLM9H9+gcO4icd/+afcAjU+m3nlspS
	 8BBn8sir+3oR8e/H6N+OEIHWMnM817Vje006KvthS6QeDaDbSvEN5zIH88dgbUPOEf
	 iUwbPcOrXGaJYnzFBmYoprmwK02WrorFrREI341A8TDs3kXIgUUf3/TbIqjm56Grme
	 5BhTK2BylL9KA==
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
Subject: Re: [PATCH 6.12 000/122] 6.12.11-rc1 review
Date: Tue, 21 Jan 2025 15:48:18 -0800
Message-Id: <20250121234818.46289-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Tue, 21 Jan 2025 18:50:48 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.12.11 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] f6b51ed03daa ("Linux 6.12.11-rc1")

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
