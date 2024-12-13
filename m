Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4E813EFE3;
	Fri, 13 Dec 2024 19:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734116870; cv=none; b=I9qEeoEC7KB1EY3udTW9BzA6Th79mz/utWnCr2HipGizr+E+rGmvoAeEanuLbTCxrs1nBebRK3SLXiCCUlx7PV//ruM+AoEbA+sQwEYOSgAGcnewkedcahmu1khnQZS9Q8ey1ls1R8Y3q3xsu9QwOIS8jy87zFiOPIcrKXdH21Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734116870; c=relaxed/simple;
	bh=SfHguEVcIQTKifl290r/0Vnvpki1yGvo4gm+hpVAr6k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LrJ7vaRR2/5GTvO+GiqiojI5SoyQio80k9F56yf3EynuLsMhF3T0xD9eTgXpGqc8SlWyRRtymDftMPk3GOiLW0yjdkhOqwEI/le7y2TTqj5HsYsj8wGnqWtINFrUlopwxi6+vzuvd7yXtAxFa6/x8s3ANLUhMU1m5FPoCjONLf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WV7FMU39; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WV7FMU39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80EF8C4CED0;
	Fri, 13 Dec 2024 19:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734116869;
	bh=SfHguEVcIQTKifl290r/0Vnvpki1yGvo4gm+hpVAr6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WV7FMU39Hx6pv31RtaQMDkeXD5hD1RY0vbT/za/ecb65R326Zl1GTLsyjiu1MyBKP
	 da4PdaO6+3G+30TRCkYZ7JRs8E7rxRkh6V0FgK70ta1/+NlVb0XkBMSRWF51Ck5q1U
	 HI9ridjSMOCxp7lvzRrZNzx8siIA9Ix7bFCbfFuPZA7yV/Pn9t7Bc1nEhol78hNw4S
	 pK5D66L51VwLeqrXLENv0mJkXkQ20Ok9UCg94eRKm7agrA6J3GMuCP+JZ/hw0VjN6A
	 HLa2GHDk8DLjkHNEz30dNLQcodUURhE/CVvPoLrGIBUKn+4aDi13AKzFZayI5WGE/0
	 HGBoKesyxBrSg==
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
Subject: Re: [PATCH 6.12 000/466] 6.12.5-rc1 review
Date: Fri, 13 Dec 2024 11:07:45 -0800
Message-Id: <20241213190745.53095-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Thu, 12 Dec 2024 15:52:49 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.12.5 release.
> There are 466 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 602e3159e817 ("Linux 6.12.5-rc2")

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
