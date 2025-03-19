Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAB01DF269;
	Wed, 19 Mar 2025 16:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742403426; cv=none; b=bJG2bFYgPhH156Eh3S+vhL8vb1hbEzw8S8OmFCIO0sNoTkdQaE0mXxGy9GKAZC5vgObEzFUjxUQTkLAZrT8vuut+fjPrgX6YtdujL9Q3n3XfDLMJMhdXbMY/b+zoZLCYwHSC3Ttf82thGbBuYVyMy/R7jp3Iw3zPx9myYyKs0K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742403426; c=relaxed/simple;
	bh=PVhr9MrGKQfs91HXhSdClB1v/UDAGhKc2euw4IG5CUg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rC+elchA31FAU08NeJlVx/LmwUFP80ODB9iCDPiMM8R0qWvMgzww8EAjzs+6AGp0GXhpCaQPbjtRR5mrxTLOX/ipKsvHyyTzVRpnTzOkwxskNQuwGFwJ+pqd9ozBPgKF+9UakJG0sqbNNFBKn/1CFfgzjR9Z3066CpYYsQSFt6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b7F8RuN/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b7F8RuN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2980CC4CEE4;
	Wed, 19 Mar 2025 16:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742403426;
	bh=PVhr9MrGKQfs91HXhSdClB1v/UDAGhKc2euw4IG5CUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7F8RuN/hRtbmXgl2Ew/EFvPJ96Lpr3MEi2LMvUi+yR2Mk4qsEeDbnS2Da196X0tH
	 toMbk6+TRR+vX6jOCF7j5YGArM1AW7yAZiOJNFvj/Q9kkn9fb/QfyWa0DbctINimU5
	 s7luDG8sHDEqyZg0FBDc8lELtF+ezaKtZhLaxKbCCkXklmMLcw33Zm8QTQYFQFsnUR
	 BHNy9lRx2l5tP33MFxZKYUYLX3X8fCIyO6cs3JbUGM3fjjNaUcf9Kv8AZoJnVqTuvk
	 V6LKHsGGgHsk+3wYwoh/Xj9clA0EPx+r0B8gJswhV+PU6fXOsjaWLCHpDDFSAL90Gh
	 njQ1pN9g00ZXQ==
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
Subject: Re: [PATCH 6.13 000/241] 6.13.8-rc1 review
Date: Wed, 19 Mar 2025 09:57:03 -0700
Message-Id: <20250319165703.51651-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Wed, 19 Mar 2025 07:27:50 -0700 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.13.8 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Mar 2025 14:29:55 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 14de9a7d510f ("Linux 6.13.8-rc1")

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
