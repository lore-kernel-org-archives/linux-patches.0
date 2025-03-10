Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6650C29D0B;
	Mon, 10 Mar 2025 19:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741633521; cv=none; b=s/AzNaI+j7DxpUcUDdf8asBhUZ4ag2IfiKBE2Se70ex0tz3NuQTrpBX7ipWjarF60zUnT4SPtn2Qw9QSOxs0RoAE7FdqF+N2u3J6hrNL4geqDYIfZsO3X9souxZxckMa6fq86QpR+TPvR44TxCo/7YMgC26exFsBg0eBUNhBumM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741633521; c=relaxed/simple;
	bh=V1OUjrO0yAyFZOmA1VC++LFMqBcBQwip6iIh0CCnBtI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DWUzwaU3m9x4PUlvA5yDG9TaX2UgMD1zufNUCGx6yosJfn/nmxf/FzAiS4/mYXSgtG+7d/pDNYQ99ZH3vwwBjOhiGacUQ+BI4roR0ieLmJM47yOVOts9bVjDrJ3z5g/Y47CTYMHrKW4nOn3BAqIepLp74xne+7yeTb38DZDBFD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qzn7Lkdq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qzn7Lkdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5EAC4CEE5;
	Mon, 10 Mar 2025 19:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741633520;
	bh=V1OUjrO0yAyFZOmA1VC++LFMqBcBQwip6iIh0CCnBtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qzn7LkdqltwE/8euywK4ufSJQBx+urhdlEI2Rwz9XA2ye+K6i/aaI5x/Padm/3bHZ
	 Y8UadL8IXc2Y8hZoHGR3SFPh6LbRf9nte++WVNTn8k4hZg082R4DatLc6e4uzTDXo3
	 QEvoImt3/GWuTjQ618GrJlh3GkIs5IChyQjhQ2/TjmEBubhHE7nxF15OFKZ0cMOxY0
	 cdEBtzCcnpLbvGQ+tywkfJ7qylBQUrzrb0YYMq3kqiBkfyCQQ6mBsd1fgZns/oXHR4
	 BHXv0c6Fr75qJT53K7yTLZfrPHjx4fposy/xBN+8nAN2HZieI97/i1ytgecqwEcmdj
	 g5KhpBT5gBaGw==
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
Subject: Re: [PATCH 6.13 000/207] 6.13.7-rc1 review
Date: Mon, 10 Mar 2025 12:05:17 -0700
Message-Id: <20250310190517.656635-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Mon, 10 Mar 2025 18:03:13 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.13.7 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] e41b0f8a619f ("Linux 6.13.7-rc1")

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
