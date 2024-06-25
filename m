Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C6B16FF59;
	Tue, 25 Jun 2024 17:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719334973; cv=none; b=aogBq1GqLwUJN4qCiVa6J/qWtaC9XvlX3Hsb2NANzsRHqfY0KUm8kqOB4/YTPNzqs17zW/Qfp+FyUcOM+EMfSwXnAzPC5C+OBGZNPLm646JGUzn1sI6klzCRps5GUBDZJXhj+KbFvEipgJJJ5cJ51qwwcLT0x+tmP6OWcDpaBQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719334973; c=relaxed/simple;
	bh=Q505DfjJdSwcOr+4/TLR6Krmv1tGHNMkPXgu0K1ngZo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZLAmWfGZu5dXSEnrJMK3hYpmC9jzea7sNsNKiRRvZ5CY3Fi1qdHI69+LOcSKNZe0LrX7JVzfjQl3fNfVP90pwqRsQGFA4VNb0jiGX9zy8hptQaDMB5FFg7nh/b1A7M3A3KiFeP3g8jh14LxJekYpqszHmPh7nvkEiBUfNfXwepw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WD3YQ9K+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WD3YQ9K+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBEBEC32781;
	Tue, 25 Jun 2024 17:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719334972;
	bh=Q505DfjJdSwcOr+4/TLR6Krmv1tGHNMkPXgu0K1ngZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WD3YQ9K+HHkQCAX9iVLjxadyF+l3dhloQUQXH/KQAJMLgTOi8fUwGQw8PVoca9pDp
	 /F+YAQIJ7PPHd218eTZ8uXQQBaXxAq1o7M+Pmk5OiMiJtTfKrtXlP0p4Mqw3p1iZBc
	 B3O1ElmYJJaalqibgj3/GZDu7tprjywNlKgKu3y6ZHa2jc+d1WHa3QYQtK3HWKUOcO
	 2GeYgC/OQB1kuQJH6IOvJlijc62FIsWQzKGtHowIAaZjMIoLCNUzD5LIAPN7QZoq7E
	 BscPpXdsYf2TWnst1QhMJSd31c5A+LtEfzRYAEiYXIc9rqZihX8x1QPXKWUVvTkt6/
	 851oOf46FstbA==
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
Subject: Re: [PATCH 6.9 000/250] 6.9.7-rc1 review
Date: Tue, 25 Jun 2024 10:02:48 -0700
Message-Id: <20240625170249.100038-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Tue, 25 Jun 2024 11:29:18 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.9.7 release.
> There are 250 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jun 2024 08:54:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] 681fedcb9fc6 ("Linux 6.9.7-rc1")

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
