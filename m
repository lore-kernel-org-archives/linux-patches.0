Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DBC55887;
	Thu,  6 Mar 2025 01:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741223475; cv=none; b=Kr8dKrPUI4wfLTtMf+v/6QzOJI4PhkrGMUT6V2Fw6hsFgDmBAo3p+LG7kuDQdD44Z7LzQ7RIjC7gDZq3ozW6U03JyEtO/4CmdKb8qe4Ev82SveRY2rmL7Kcr9CcFKfaGqQbOqyoFnMjXYGVQyHaUjYes5zDhz9B7LCBZ+g+nukE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741223475; c=relaxed/simple;
	bh=nhNgSN7fSWvASe3DYMAgtFqWaPYCy8XHF9BRnLA2/0w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mBwtqsb8Zb6J2hyENfkTTSRAyZ59sLQGC/jemBjkjC45qZF4eRECcugwNI8Gt52Bh9yAmp9zSSIfWtzCkoVm8PBJsz6rxDg69md7l5YQRiZRMpQ0hgJq05ERj9Jewg8hSEHT0u26jCOqZtLnvEeaq3fAwGTwuoQU+Q2YZ4ZtwVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dcfyWHV4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dcfyWHV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70798C4CED1;
	Thu,  6 Mar 2025 01:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741223473;
	bh=nhNgSN7fSWvASe3DYMAgtFqWaPYCy8XHF9BRnLA2/0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dcfyWHV4Njkaoch4pwUKGQQ/+N4/mhKeRYvgKIJy0bWpp0xvmn5614gnMdaoxaFnJ
	 HW5ZrEq/jOp4Ji1SJ09Y+MhXAMj8K0Wnlg5TvMMp6j6oSJG2J7XXkKx6jVhFYmsFmo
	 rDdy62TzP77sPlxOY/3vWE9PLFzKtHPiAHapmENn9nkksV99De9/gTriJCQ214l+C2
	 Uy5tejxMGgRiVHaE9EKP+F3Hv7aafpS8oJuA8XHMSV4k6WhgFAkum/4fU9NH5JEyU7
	 yq1kKamRXvb9J7/h4BYZfmCU8ySge5FR0SPXHQlnHP9vlpzE8ref8uk1N8qUgT1+Go
	 uIgDKAadGmZuA==
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
Subject: Re: [PATCH 6.12 000/150] 6.12.18-rc1 review
Date: Wed,  5 Mar 2025 17:11:11 -0800
Message-Id: <20250306011111.138928-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Wed,  5 Mar 2025 18:47:09 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.12.18 release.
> There are 150 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Mar 2025 17:44:26 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 43639cc57b22 ("Linux 6.12.18-rc1")

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
