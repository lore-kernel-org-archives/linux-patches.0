Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8F118052;
	Mon, 23 Dec 2024 21:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734988543; cv=none; b=FT+fSS/JRZipBjHKyiwwZKGkRfm/LXAUR6BOWnBLc9GxVR6xm47tOwvw/A704a2xjw+0BsU0U728B8zZnv3tl9NhU51Eg6hNAc19tSAM6mF29g9ExEAP6cit1o9r+J5fkcjYit0SFiPzN1pkh8jxy1L+L8v4djdOR8fjwhA+bV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734988543; c=relaxed/simple;
	bh=elrXfmbX0HoJgJPoVs7C6J8IAGUQEtnKIciLBQ6IJC0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xx4LchWAo5FpMCNXXQ+J9iG7trIbdh7Ma8rQVVxbjV13YFIeEftEAduAidExlwreuzuCmg2K+/rYfi5og6tt3t9jFBokIZhW+MHTO5GnBpaASlWAmb+Oa7M4Hu5uxH3X4JKYIYuLIAMqL2n5IN8mifvXADs2NnmX9bwEFcN2R0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gHAWcZLz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gHAWcZLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93BBC4CED3;
	Mon, 23 Dec 2024 21:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734988542;
	bh=elrXfmbX0HoJgJPoVs7C6J8IAGUQEtnKIciLBQ6IJC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gHAWcZLzcp3wLl+vz7oG7RQQVjbE4lr5su56qmOGZNPeNOFkz6dEszEaR0wHNu4c/
	 OUWsBXaPO1GyseJViU2HV2aIFCt/4uvsOMfKHNHWvPT8XJ3+D6DGnQiETWyhYgrp9V
	 q+fJfpti6TeZ2jAwGVAOyNzS3OQ7KoizF6xmszZ15ngZuqw9CElnFRajk7fYkq1MY0
	 KpbeGFR9h0R+9cYrYyn4mEs8IYa/FvAG8tzW0yQvDiy2yQre90wxbGzpxejs3/GA9r
	 bx/fnYKrGmVoK14VHC0KPKys1P733KMRM9xce2wnY8xBFCMKGWceWGpTwEC01N2OTx
	 D5m+UXYVnPO5Q==
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
Subject: Re: [PATCH 6.6 000/116] 6.6.68-rc1 review
Date: Mon, 23 Dec 2024 13:15:41 -0800
Message-Id: <20241223211541.83351-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Mon, 23 Dec 2024 16:57:50 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.6.68 release.
> There are 116 patches in this series, all will be posted as a response
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
[2] 6a86252ba24f ("Linux 6.6.68-rc1")

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
ok 7 selftests: damon: debugfs_rm_non_contexts.sh
ok 8 selftests: damon: sysfs.sh
ok 9 selftests: damon: sysfs_update_removed_scheme_dir.sh
ok 10 selftests: damon: reclaim.sh
ok 11 selftests: damon: lru_sort.sh
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
