Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BBC4A0C;
	Thu, 16 May 2024 16:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715877668; cv=none; b=dffTfN5ah7t3ge8Pij75O0bJJnwkAlNLyJchsw1YGur9XUmpzBuk1C5Z+ruPWUS0m7XIju5xoLHc5rTR0XmBy4voV6NWE5c8oY3Xh4IaKyQfCXaTtt+o+Qc9iLwNxe+1kiPW70q8aPeYebqmJQU2OVgsc2LRSGz415mBFjO3CMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715877668; c=relaxed/simple;
	bh=KTDWJ71QgHOE5BhM/geXHABbGtLSXnzlPHD8zqEJZVI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eOjHB88viwk+QOET1+JJlBueIlgyXn/dtbeSejvXm3xihxTL0I/AOPRLVQDmZdWGZiHm7S2KxH+gStExKNKlthmPydfF0HLuwbSOo+qzlQzPtf+b03uC3LLwrAixwg6wN/M++eXfy2vojMTAvThOZdAN4cpdhCEKG7aPsyz8EDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kTwEraol; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kTwEraol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B19C113CC;
	Thu, 16 May 2024 16:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715877668;
	bh=KTDWJ71QgHOE5BhM/geXHABbGtLSXnzlPHD8zqEJZVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kTwEraoljjNhndhmn06uFDrfZttEBsgRfKldUHHpjwiIz5ElAU+C01VSnO3AC623D
	 maLSlAg88HKDQwDW4nVoqNckBSuPbLboqIwq5ZENQQClae9uUpXEKn+KISVtqUawzV
	 ijDZ4gqozeKRfDMoBp0sYVZHXN2fo7T3Xev16mcNE2RCOtY6KjlFhgiZqrBT6batQc
	 R5HFffNYXarKxqSeG5FQ0bOBjfEEo7fWOV+w66iqqf10VWZbAUQw6YOFGJqcwmAk4s
	 UiCxqlhiB7apBfK9j2WEB7SUzZrxvS47TgvYmrI0Fcre+wO3HK8M/M2APHP+Y7xtdI
	 l0BJ9URkFrfYA==
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
Subject: Re: [PATCH 6.8 000/339] 6.8.10-rc3 review
Date: Thu, 16 May 2024 09:41:03 -0700
Message-Id: <20240516164103.79311-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240516121349.430565475@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Thu, 16 May 2024 14:14:57 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.8.10 release.
> There are 339 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 May 2024 12:12:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.10-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] cb6ab33e1bb7 ("Linux 6.8.10-rc3")

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
