Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82073BBC9;
	Tue,  7 Jan 2025 01:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736212120; cv=none; b=SbVgR4ktTNwL+SAHuQESgVxxkVof2ary4JWYsDWO13yZ7yPRd4z4xo8f7yAezUgW0LgOj7Mg1PjLwRIn/dj1z9gTt7bo4PkeUZSE+ieb2Am+Weir43Hw3qD2YHGkfekYBN6QaD5c6SEzmoXkrkWebJ/EYe8cEo23dp5lYrbqYGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736212120; c=relaxed/simple;
	bh=varv3qT2IGTIm1/bh7iJu+QJ67gTFvg2BBSRTS4p0eQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EuqAZy5Q4+RRoc4eGkywVzyc92xKxYmQ4p8vr4voDvHkL2rk35IJk1Djf4z4c9WxseVwMlFK84XQeIOginBEciIrcjBOTtOtkjU3ybeD6HgO8nnPOVHRM0RAzh7+rYyXXjp4lre42urOLxWTJ1GAMaCj9zy9vt8CufBhqftRciM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ufU5uM+Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ufU5uM+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371F4C4CEDD;
	Tue,  7 Jan 2025 01:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736212119;
	bh=varv3qT2IGTIm1/bh7iJu+QJ67gTFvg2BBSRTS4p0eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ufU5uM+QMFkQNYtG0tLdL6bDmDpbJZWik3Op75vxFgUFS7oXQ8OntqC2rNwFJqv6a
	 M2TF7k97TENOMi34X6gu1zx4DhMWF3O3swO+1ISnlZQMuKNSIHFkABFx0kWlpCpnVL
	 YwN/+MoSrscWDjtrFT3ulcelK1zVIgMqCgy9PLG35h15O2HuSzggEyAlI00FAz7QEA
	 YWn8tOntpiucOnLrO5rBOLUXiOOd87LrryU7WEtB86dfLQ1lnXptxdX2k/RZ+qbqTg
	 QtPTqWt8JUJkY/OKZYF8dAskYFL8Kjfp+s8gNjKRq7SeliZSrjv51prvLILcGFUK2X
	 fNFwnxcQ/PMdQ==
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
Subject: Re: [PATCH 6.12 000/156] 6.12.9-rc1 review
Date: Mon,  6 Jan 2025 17:08:31 -0800
Message-Id: <20250107010831.82558-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Mon, 6 Jan 2025 16:14:46 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.12.9 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] cab9a964396d ("Linux 6.12.9-rc1")

Thanks,
SJ

[...]

---

ok 1 selftests: damon: debugfs_attrs.sh # SKIP
ok 2 selftests: damon: debugfs_schemes.sh # SKIP
ok 3 selftests: damon: debugfs_target_ids.sh # SKIP
ok 4 selftests: damon: sysfs.sh
ok 5 selftests: damon: sysfs_update_schemes_tried_regions_wss_estimation.py
ok 6 selftests: damon: damos_quota.py
ok 7 selftests: damon: damos_quota_goal.py
ok 8 selftests: damon: damos_apply_interval.py
ok 9 selftests: damon: damos_tried_regions.py
ok 10 selftests: damon: damon_nr_regions.py
ok 11 selftests: damon: reclaim.sh
ok 12 selftests: damon: lru_sort.sh
ok 13 selftests: damon: debugfs_empty_targets.sh # SKIP
ok 14 selftests: damon: debugfs_huge_count_read_write.sh # SKIP
ok 15 selftests: damon: debugfs_duplicate_context_creation.sh # SKIP
ok 16 selftests: damon: debugfs_rm_non_contexts.sh # SKIP
ok 17 selftests: damon: debugfs_target_ids_read_before_terminate_race.sh
ok 18 selftests: damon: debugfs_target_ids_pid_leak.sh
ok 19 selftests: damon: sysfs_update_removed_scheme_dir.sh
ok 20 selftests: damon: sysfs_update_schemes_tried_regions_hang.py
ok 1 selftests: damon-tests: kunit.sh
ok 2 selftests: damon-tests: huge_count_read_write.sh # SKIP
ok 3 selftests: damon-tests: buffer_overflow.sh
ok 4 selftests: damon-tests: rm_contexts.sh # SKIP
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

PASS
