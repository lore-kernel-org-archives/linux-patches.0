Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BD81372;
	Wed,  4 Dec 2024 00:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733271820; cv=none; b=NxePHYcCVLagpvodf6qShHq4JHKq37Q6U1emDXNVOC1OYzNBDYxaAs38IRuk0o/lmuXReLct2OR9UqSuBG+e1EaoQDtLpMKTtYjub07in1efUTvg1jmcLPRAVt/ZfElzmUmQHUVrCqX3HN63inBD4tPD2PEjDUighZxvsA30KzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733271820; c=relaxed/simple;
	bh=mHyvXhKyZLMpFcnJTGgrfl8X1foUR+VJ2zARLjKgCCE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P3B11+NmLDgPA8bLiiTnNiTVwTW4a28GcHX+mzyDT58tJ0hyPNGQric3B23waT+fFW9fn4LBQTuiCsCcVWEJEFk+OpuYWzVRfgOD5DFPk6AU2ARBUIUUAzQsksjqladhpLb+4uRbrebEvt/y5CUj/S/3KBuGOFchtOS2OyfoAko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sQfI+OWb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sQfI+OWb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A64AC4CEDC;
	Wed,  4 Dec 2024 00:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733271819;
	bh=mHyvXhKyZLMpFcnJTGgrfl8X1foUR+VJ2zARLjKgCCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQfI+OWbM5LibBB/dCMGRyqUWzriEf25PSRkcR5pIeh+6dsR9qgEXSrCpfyOQGy3a
	 J6N5pK7z8VtyEVzddkC5TqCkUrosd6UXqNB7JUQeHQkp4YKDe3e8Z+htorZ5xB1Ug9
	 8ZoKO/20JXkpqPqSvsAgQbuN8yU8cEpe6vMNOzQOJ02AZ7AIEbJgNko42Zni0TGKas
	 rj1FF+ZlqVjErDbYeb/lsA4wkAHtCcLNqMBiISgnVQk+MGrqN2eRokOBnXosbIgQMp
	 JPxodIZF+kTkwJiUt5Gk/+V/WvYC7vQoMADqQ5Ty6stKtm3qWPBcUGNXDj5rhoTQ/f
	 lSWht1VZqPT9w==
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
Subject: Re: [PATCH 6.11 000/817] 6.11.11-rc1 review
Date: Tue,  3 Dec 2024 16:23:35 -0800
Message-Id: <20241204002335.85653-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Tue, 3 Dec 2024 15:32:52 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> -----------
> Note, this is will probably be the last 6.11.y kernel to be released.
> Please move to the 6.12.y branch at this time.
> -----------
> 
> This is the start of the stable review cycle for the 6.11.11 release.
> There are 817 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Dec 2024 14:36:47 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 57f39ce086c9 ("Linux 6.11.11-rc1")

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
