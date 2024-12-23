Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B7818052;
	Mon, 23 Dec 2024 21:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734988595; cv=none; b=kYFCbKMJLmjLlZIumhL9U3ZDab8cZzp6E6a9xOhd2zXLlz49HUkoDaj+ABQGt9MfKyrr41VItEeiH9/HLO1u7q1VyhYi+MB7m5R6jKahtNfZLZt5hp1lVoHpvcSJJM/L3zLazHzEl7ibY7o0NmIJ35ocd8YJ9T45p8SsuqpdlwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734988595; c=relaxed/simple;
	bh=IGOP9yfvBIBFaHDDSesTRcJaNBTU4ih+/wDcw+v9VPM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TrUwQHFCKzQUFoXZpUBGfdtTN6AIzxXIAKUusOQ/jqwlSgOJwz0eY1Qawya4zkv6kz4QknJEr7enq1CYZg1/vwXekaX6Nvjtfr4Ws0BmVHXNksf7bRAgDqKg10/5rS06SkW1aVobPhN7iVZ5xb9qbSPPQ1F0zQ3AAgHRSuVtHD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cb22Tg8o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cb22Tg8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0362C4CED3;
	Mon, 23 Dec 2024 21:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734988595;
	bh=IGOP9yfvBIBFaHDDSesTRcJaNBTU4ih+/wDcw+v9VPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cb22Tg8o4aBGMm01/F3u3fJuVCwQ+nG2IdoVp6UScjM6VcEf+Stq6QbJ4GPBWkX3q
	 O3B+GZkCqzyDh7RUvyrkNLwsm9gIKagM4IadcYyAToRbR98JzTnObuXidZmBE/JoDs
	 XsnehTvXSypZItoGvSmb3Z6+boEoFJdfOvfiQQ3bynfIto53fp5TQQoBHrblc76d7q
	 gquFyrNU9uGMRYPA27raPzX5AaZGBbEgWrG+UkhnhNWka0F5+53n+nulPRzO6XT/Rp
	 zYXlG2ZwFDcj8Bg54Ow/mk6OjgKmVckgbhX8hs+O5VEdO/TKKhwnUFvVtKT5o5oT2g
	 a14lHW5jA0gSA==
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
Subject: Re: [PATCH 6.12 000/160] 6.12.7-rc1 review
Date: Mon, 23 Dec 2024 13:16:33 -0800
Message-Id: <20241223211633.83422-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Mon, 23 Dec 2024 16:56:51 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.12.7 release.
> There are 160 patches in this series, all will be posted as a response
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
[2] c157915828d8 ("Linux 6.12.7-rc1")

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
