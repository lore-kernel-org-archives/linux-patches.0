Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D217A58222;
	Thu, 25 Jul 2024 23:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721949808; cv=none; b=enWBi1tEyKAi8689rFkX8oxMWSKIeYVXU8uSWKj2xm5sUBNijXdtcm8VkHI25yuttueR3bMKe/T5R8maEnw9aRFp65+iKvcQWry7nJwHyyDP6qK8DxYf9Oz642vJPeIvyhJFq4FildBq26tloqhLVwZ2n7/hWgPJHkahEYyZFOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721949808; c=relaxed/simple;
	bh=IYyxznzUGGYZnqWFQMdDA5t63Bwvu6XAlIrLmsjtK4U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=stpxDasngiolQpUJGD9Lhfc5YqLl2mZnTIYiO6HwR4oGRFQejOvVwnbSq+ufwiFHIAW/jfxrcTlC5th7CL3DGw3etrGKZcRZ/y09pq3Jtg7fxmtK6uxEeeOxAHrmoAl+VIHacyl8XwCehD34vlUt5O/AcAJBY63vLRGyuGRutMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GYY3RLvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GYY3RLvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8BF1C116B1;
	Thu, 25 Jul 2024 23:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721949808;
	bh=IYyxznzUGGYZnqWFQMdDA5t63Bwvu6XAlIrLmsjtK4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GYY3RLvEN9TyPbABvaA9EIBO3rQSMaFqpswzxNdhdUq3CPLwDU+bTgo0qppu58Fp8
	 4tMXUcQbUi8gTJAeIYA5I5zTDaCkf6cL4BeUYvCY0VPje5VYgXh+XlUS70yUFGKyf5
	 o2an142Gsr3QLcMEOJUro0grBTNvrhNDigf0QJiNBUKUjNsGQL1ZtEry/M4KHzmi34
	 wZ4Ft8GoEyQXcg6kZXhrvPOVhhPS/BqjkPfjcXK+cNtkMFO7tYnlUpUbMKf0eDBu6j
	 46I3zfosvCPY6dk0DXUxgzZdgclN03FhFg06y6GDzSf3hIJ3lIYlN3YGbCS1Dv5mkW
	 DY5uMn6y531Ow==
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
Subject: Re: [PATCH 6.10 00/29] 6.10.2-rc1 review
Date: Thu, 25 Jul 2024 16:23:24 -0700
Message-Id: <20240725232324.29951-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240725142731.814288796@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Thu, 25 Jul 2024 16:36:16 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.10.2 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] bdc32598d900 ("Linux 6.10.2-rc1")

Thanks,
SJ

[...]

---

ok 7 selftests: damon: damos_quota_goal.py
ok 8 selftests: damon: damos_apply_interval.py
ok 9 selftests: damon: reclaim.sh
ok 10 selftests: damon: lru_sort.sh
ok 11 selftests: damon: debugfs_empty_targets.sh
ok 12 selftests: damon: debugfs_huge_count_read_write.sh
ok 13 selftests: damon: debugfs_duplicate_context_creation.sh
ok 14 selftests: damon: debugfs_rm_non_contexts.sh
ok 15 selftests: damon: debugfs_target_ids_read_before_terminate_race.sh
ok 16 selftests: damon: debugfs_target_ids_pid_leak.sh
ok 17 selftests: damon: sysfs_update_removed_scheme_dir.sh
ok 18 selftests: damon: sysfs_update_schemes_tried_regions_hang.py
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
