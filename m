Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388B11F931;
	Wed, 20 Nov 2024 18:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732126451; cv=none; b=kBKm9zV5x/thlsEHxU+IIsZqqFmjaTcRX9EL2Uc5krPM8aW2hzeRdUUU6V+lq+XNOs0JVoSW4Tzr9j7z85YY5yrbV++gCw7i6lv7+N2XcuImEb7u8RWWNA216zAcn7sH2Hth8MYvn5DXcJHTcC0zrIoqaZ15CGfZwxy0E8dSuog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732126451; c=relaxed/simple;
	bh=uwloS8aq1NCY5t6kL4Soj/ngvcEhOYV4IG3I/Xyh4Gk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qyz4r8jKrdIarSrwTHLcRIiHnLZ2CbO7A8VYCM7BkMTmuY2yZ7pCE5aV2wm81Pa0bHAbdk1OwzNJC1lWG4QoDR/blxHtBDmAzvLu7OVln+IOSFt1BoRx9fRoj7SI4pOFb3ohbV+iCLVGGGeYtnp7nb6A1Ulhc31H2GhiZjRYMwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TCZ8mq5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TCZ8mq5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9448CC4CECD;
	Wed, 20 Nov 2024 18:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732126450;
	bh=uwloS8aq1NCY5t6kL4Soj/ngvcEhOYV4IG3I/Xyh4Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCZ8mq5EVoCYmVRZjbZet8aNfT0cwzgeNSmkfylCs+EQ5rQCOpAJt0gDA3i111USb
	 aK+6DPRGsxHSkZMoVdPzP5Yq5DgTbnaX1S4WNNaO96l/5vKLNp3vl9lfP0zfyyJkyx
	 rVDdqDpcF1y68J1+ZertKjNEj+CSvVJMcNsljfCyziDC4NJq8aan79jplEhN5PjMj4
	 aKCM/TrZpOCYABa5Ai7D/ZCjU3jDjIiBpl9i6UBNbdhGT4JtLPYL0jCdfvhzyHUUyW
	 AnYvQyzFqQRYE0n7atrnRCRtAnmbsj97UbCn8byE6PZMq9amjvssnYrtdVvZm+IE52
	 EO6/IolgKQY0g==
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
Subject: Re: [PATCH 6.12 0/3] 6.12.1-rc1 review
Date: Wed, 20 Nov 2024 10:14:05 -0800
Message-Id: <20241120181405.70382-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241120124100.444648273@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Wed, 20 Nov 2024 13:55:54 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.12.1 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Nov 2024 12:40:53 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 11741096a22c ("Linux 6.12.1-rc1")

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
