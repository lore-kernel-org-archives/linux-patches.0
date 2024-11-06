Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15AA20127E;
	Wed,  6 Nov 2024 16:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730912128; cv=none; b=pQVAzjxSrjFPW3rdN6etpQ+JHtQDO/Cb0GyUIEIuFq5/jXqvg4wwD52LL6ujc/3u8vdU6nvDOQ7fDQwj8otupGtjZnGeBnlRcmeWZKqNFwuzTngXKpdLWtNPk8qM8Obo+TIQesJtgUrE5747k/mWBITh8OnnbQhi6WuQhVxgg5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730912128; c=relaxed/simple;
	bh=s4A6ReR75B3KcK1GquniY9ts7rIzzWeALPl1cUuWIVU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Is91xnbrxWPBJOKnTgiamjXrxo9/2FDjSErBEBuDJcCLDauwhYpuMipKLCIl5Uy96MJ4g0r53drP+CujK+51URcNBZ+I57WUrdP/bA1uEJRcZ81AhfqRTjgYY5ML8hOlSGZrP9q+o3cWo2nMzcQyCa67uxPjR1BOZVHGMXhpYdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KRvD6aap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KRvD6aap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E16AC4CEC6;
	Wed,  6 Nov 2024 16:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730912127;
	bh=s4A6ReR75B3KcK1GquniY9ts7rIzzWeALPl1cUuWIVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KRvD6aapjWutvG4uVbI2Fvm8lu9kuDEFF2wefhDxtBeXvUxIWqoTCuRLJnbsNDYu0
	 lKAmFkYXifLhi7i4WA3PO3OsklMmfJXv6pMN4QJ0mC+p++8z4NRWOpHiHV5O20+TEt
	 m64g4KHkelw4ahEBB7uSXpFfu4IU9WLqnXMiAk8SgsVOQ3fe/S9pah1flwCxQbf8yU
	 L3vO+VX81/SIZhdS9XcFcUNacd9JSQP6wVxMyp42MJ2EtJ5CfLplV35V1djUR8qy/B
	 bq9zKiZMOzHsXLcfX7WB3JnFSG3MK0nNYj/ZAOQMZDRVEZEz6Uo3pVMjVokmzI1V85
	 7V05I5pCSy/6g==
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
	hagar@microsoft.com,
	broonie@kernel.org,
	damon@lists.linux.dev
Subject: Re: [PATCH 6.11 000/245] 6.11.7-rc1 review
Date: Wed,  6 Nov 2024 08:55:25 -0800
Message-Id: <20241106165525.8204-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Wed, 6 Nov 2024 13:00:53 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.11.7 release.
> There are 245 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 0e21c72fc970 ("Linux 6.11.7-rc1")

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
