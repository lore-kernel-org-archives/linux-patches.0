Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90057DA6C;
	Wed,  9 Apr 2025 02:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744165988; cv=none; b=T0q2DaOxHxhruSa5toC+Ldc+KcMbzN5jOlCJ9HigvTPpNfUIPi7Ln74MeGx6bS28hbbiSiYyC+T51dWJrYGD1kht6oHn26/5GOTlkculdilgnBjkPvYemO06961jE/8S8o3rPhL8/GHo66NXc/QJnEOOomHLi4n3NzVt7K1kYhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744165988; c=relaxed/simple;
	bh=wAk+PdHN2S7CGB528X6cqziEvvrh4na/F7Q81dYFCn0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AOCTNa+hRVb0kTtk9vmPaxhy9eBShsEAZ3rSl5V5e5UwrxEn4OdD8/L74TG0XcRRSL+vlqxxwioCJXorb787f3DSIxkbKtMAsHUx/qyDYsVtU8CEGEh9TXUTmOLaa40IEiRW5YsFlFSrcsJD/Kr3gm6kCx0wImVoCnDuqyNXNJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hjuRHpXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hjuRHpXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA32C4CEE5;
	Wed,  9 Apr 2025 02:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744165987;
	bh=wAk+PdHN2S7CGB528X6cqziEvvrh4na/F7Q81dYFCn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hjuRHpXWxzKWgJapgfWjo0zSUCZsQb8Ox37o40n/+swDPM9inFDys5nNREni8sGyh
	 2FQl+VXFnbVAr4zKRJN4O76q9ZHEo8me2TO6Cy/xwJyVTeZ/MoUjuN/rKDqah+/Hrc
	 l2QVLz+8lptAd9pqILotp+dSZPCLfSTIYyEVpiFclI5LOk4vxxdAG7ZcsITU7Uho3F
	 XaqI1qrATg0wlyJpbmkB8/YHId/UQHWPUdhp45FwJRpgR4qltYyonfYsXk4OryhN9l
	 4hQGx5xFRJ11lYHqLNnUZsF8gVCqV69Lb+dbibqmfrkFBpQnoqwkdCA+TMaYMoJViJ
	 LpOA65F02hPIw==
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
Subject: Re: [PATCH 6.13 000/500] 6.13.11-rc2 review
Date: Tue,  8 Apr 2025 19:33:04 -0700
Message-Id: <20250409023304.70192-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250408154123.083425991@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Tue,  8 Apr 2025 17:54:00 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.13.11 release.
> There are 500 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Apr 2025 15:40:28 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 45ef829b9715 ("Linux 6.13.11-rc2")

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
