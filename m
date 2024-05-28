Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C2432C60;
	Tue, 28 May 2024 16:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716912462; cv=none; b=JppBAakpgDYwQd5C+7RBSn98wW7gr3sB8m7gW23ASbHAZpJ+86Q5XTWneUnVhiWQXt6W/1Cv00A1ZauE5Kt9TSK5I1d8e24ml6Pn3aVlbi1vbdIaY3ZqjZfnC36/eWOt0Appv9n3Ln0+JqNycsrmrMJMVUwbqn9LmHp7WW5GYpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716912462; c=relaxed/simple;
	bh=Q+IekMb7tPeVQnEW/7jHYeBEQI/kIPHsO9HA/BJAa74=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LyV8IAhGL97S+D4k0WQqCCmjV9LGCkaKtLGav2m5HVqnh9T4raPLkl8JoOvCdFN2mYlr2rtLB4jIccat2iotWBkKyPlFr6aMLXWHSHeJnPHwEijGwMJiuR5gXSDpvQ+mwVqowSbtmCkxyRzcwichbi+4ew1XfdCDNWEloLMlJJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VoFPj+6s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VoFPj+6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA44C4AF0A;
	Tue, 28 May 2024 16:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716912461;
	bh=Q+IekMb7tPeVQnEW/7jHYeBEQI/kIPHsO9HA/BJAa74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VoFPj+6sFW65SbAYuwm1Id58CW52j/KHpZwr7ueDdh0Zp+P/olwtiPF/ZMG4d+iBA
	 sIaEGthiJyoTwTHYVu9k/5fvAltKNfHszSz3VNr0AnEolkWgxKWtsx5MyyLmRsvc4A
	 1Es5DCpoLTAOe9/oMjjXz+IZoDqNyA4AZq/ZNcdI+C1PSLzdH1t+jFeVn6j1lD+v3m
	 PQEZktnhP9wP8dIWRCZOArLeqrPmfq6NtAn2U4J2OUAN/6nrQDmgSOX/jIejiShOy3
	 3baRA7DtAuAQi7WElfBRX8miTbK3u+udeZhSSQ01wCSawqCw+Sq9DeAIFO6oVLwEhR
	 rO7xirRNA0J5g==
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
Subject: Re: [PATCH 6.8 000/493] 6.8.12-rc1 review
Date: Tue, 28 May 2024 09:07:36 -0700
Message-Id: <20240528160737.150649-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Mon, 27 May 2024 20:50:02 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.8.12 release.
> There are 493 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 May 2024 18:53:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] 5a8ebc9c48a6 ("Linux 6.8.12-rc1")

Thanks,
SJ

[...]

---

ok 2 selftests: damon: debugfs_schemes.sh
ok 3 selftests: damon: debugfs_target_ids.sh
ok 4 selftests: damon: debugfs_empty_targets.sh
ok 5 selftests: damon: debugfs_huge_count_read_write.sh
ok 6 selftests: damon: debugfs_duplicate_context_creation.sh
ok 7 selftests: damon: debugfs_rm_non_contexts.sh
ok 8 selftests: damon: sysfs.sh
ok 9 selftests: damon: sysfs_update_removed_scheme_dir.sh
ok 10 selftests: damon: sysfs_update_schemes_tried_regions_hang.py
ok 11 selftests: damon: sysfs_update_schemes_tried_regions_wss_estimation.py
ok 12 selftests: damon: reclaim.sh
ok 13 selftests: damon: lru_sort.sh
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
