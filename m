Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07DF18002F;
	Tue,  9 Jul 2024 18:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720550574; cv=none; b=eVkyfkpbeq5VJcK4N+vuk/sHHSNnyBzXCRROfJpb5bKh7KkB9Bk7vux125IYbiwI03DU/GS3y40NdfsBHrNShQDi4lYbsHGjyCVCXCd8y/kxX4Me2WrYD5RF7FjNdPI9rylO7AMdjLLQJZKSCtDNEdEB8Y12GasabYqEZoK/5KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720550574; c=relaxed/simple;
	bh=x+oXLGiztMw5YowpjLtOSGsy2COFVSxTzFxYvmJo950=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IH74S9wvOiheLSv5ArwTo71YzmCGK4/uwTG3RoccyIFnV0cCY5uFUEacMEkdrqgm0swJN+Bv0c9CkK4KiurOURgI/U9RlqOX8R34Y+d8xRXKGp5yXqSiNEn2chyloJmTjwEF9iiSp9PDR4HxAcqrrTHVzTj7kKsIUfq8lU5Kg3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z9ZX60ng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z9ZX60ng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA135C3277B;
	Tue,  9 Jul 2024 18:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720550574;
	bh=x+oXLGiztMw5YowpjLtOSGsy2COFVSxTzFxYvmJo950=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z9ZX60ngFGY4jMmHI7zWihV2z4kNEV+ZUKvK1iGuFaaqhrbQQPzYTy0+60wGnrhf0
	 pV+aUsHZehy7o1YiGglo+lIKhxk8O/Kxe+PcXAk3uUAmxYfIT1VMBvz/JyPd6wTJil
	 CvLlA14BLzQT1+yMd5CUyuV6A/OP1F7ttFBC0AsBuHwZW6eYQ0HEwoqKvC4Hf9Q331
	 8BXwYQE5io1zBRsBfkfv5B8CS0oL3vlM/clCAuWjbea1rGJqSaWO087pQy6+w7Lt/b
	 s4EX+vJStwMv5sj3BX1g9ywZTWSnGvLAJ4gvS/JOOloCnwsG06c3XEFPGeb+z8YJjG
	 wR4HbAI0PXccQ==
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
Subject: Re: [PATCH 6.9 000/197] 6.9.9-rc1 review
Date: Tue,  9 Jul 2024 11:42:50 -0700
Message-Id: <20240709184250.702371-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Tue,  9 Jul 2024 13:07:34 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.9.9 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] 6ced42af8b2d ("Linux 6.9.9-rc1")

Thanks,
SJ

[...]

---

ok 6 selftests: damon: debugfs_duplicate_context_creation.sh
ok 7 selftests: damon: debugfs_rm_non_contexts.sh
ok 8 selftests: damon: debugfs_target_ids_read_before_terminate_race.sh
ok 9 selftests: damon: debugfs_target_ids_pid_leak.sh
ok 10 selftests: damon: sysfs.sh
ok 11 selftests: damon: sysfs_update_removed_scheme_dir.sh
ok 12 selftests: damon: sysfs_update_schemes_tried_regions_hang.py
ok 13 selftests: damon: sysfs_update_schemes_tried_regions_wss_estimation.py
ok 14 selftests: damon: damos_quota.py
ok 15 selftests: damon: damos_apply_interval.py
ok 16 selftests: damon: reclaim.sh
ok 17 selftests: damon: lru_sort.sh
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
