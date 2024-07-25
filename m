Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA77DF6C;
	Thu, 25 Jul 2024 23:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721949759; cv=none; b=lM5i3yWQu6XC58solHU5XkmJ1KnFiop+lqgBa1Al7T2QlGN9mIWwy6I/SMlO1aLcnuj/ZgGOkFn6GvgaB5E6vqOAZCLX50wm3MmPbz2N2umqy15qvYdLxQidZgVIK5XGxlL5sO5xrrPDlADiBnighWV2ctcjPBmL5mxd4hdWROU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721949759; c=relaxed/simple;
	bh=ZFmsfS0oXZjICCb2pSBCQBxJ4LZguSfGlPeNg3gGps0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bJ3Bw1RPaSGblECT2quMrbeMq6NWsx994p49wvtA7ApQVZImqLooFdYqrvnSWBrQ5kq+w75Kh98ZulXXoXZKzKcq1oL12dSqU7m5zNdJXGkpBFvF3uPTjWm0cpqAtw7zjR68XduhRq1nAqAdW3sUbPufp3vYZC6pfofwZaEtz/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=epYiUko8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="epYiUko8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF16BC116B1;
	Thu, 25 Jul 2024 23:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721949759;
	bh=ZFmsfS0oXZjICCb2pSBCQBxJ4LZguSfGlPeNg3gGps0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=epYiUko8x+JncIQ0wz+GUMsIthSS82t7IKW+WLSSoAeLr0c+rVoVWcxh8Z9cy8s1n
	 1A4wBqgHKinc2FlPMDgD+2cBByyYZPeBdBWC4SFPUgMqaATQepbPGdByvwUGtHzY8u
	 U6EPtMVQ3lk9ir3CLZhzupjfzw3Mq9rBHQ2vav+0u2e4O3vqv84lLQb48Y4UkTbb6i
	 frSdV92pwlyXhBR4tz81h4I9LeWresMpvZXosFie3DM/qsYZZyOcVpOOeQifhOw3B2
	 SLUxWL78a6TRBoA4huZSaOId/wphbRtBAdsTJYCK364UfPH4qM/7MV4D3LabY+MxNu
	 D4gqWgwBed9GA==
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
Subject: Re: [PATCH 6.9 00/29] 6.9.12-rc1 review
Date: Thu, 25 Jul 2024 16:22:35 -0700
Message-Id: <20240725232235.29819-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240725142731.678993846@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Thu, 25 Jul 2024 16:37:10 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.9.12 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] 692f6ed6607e ("Linux 6.9.12-rc1")

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
