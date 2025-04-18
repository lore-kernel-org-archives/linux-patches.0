Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03112A1C9;
	Fri, 18 Apr 2025 20:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745007428; cv=none; b=r+QIwasZT49mOGMPjmDo532hTnOyYzSkeMoVn14PcxdtWV/wlACDaXI0RRcyxvMa+EUUPT4PfCbqsKNaB3YWltQg5caQ76WCO2TkOd2+EoqjbA0klZupv/Sxws4U6dOuIQz1KSj4MeOeG6MLM+vkYMZSIli4G9R/GVjC7gD02L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745007428; c=relaxed/simple;
	bh=LqBBrDYSFPq7qwiPArMtIpRUwFr+ehgmwr9qj6TRhMc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VYTZVsznxH9FAzyCfEHl0rQ8w7/Bs+RQkRdsS30CZkyQv704mp+j8AzmeB0ui41IeHE5PCzwhmUbIvHNY93i8EctA2UOKVbsAxGVxQlvxWTLlmSqmjXeZ5kQls1LZ1lEM8GFq8AdEQiHFNjo98cfhGurv5BzACoxn/3khhmOVAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DTiQDuMA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DTiQDuMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E248C4CEE2;
	Fri, 18 Apr 2025 20:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745007427;
	bh=LqBBrDYSFPq7qwiPArMtIpRUwFr+ehgmwr9qj6TRhMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DTiQDuMAKi3pUPVSuJvtIMOuY0Kh5OBPqSPql57cZBMkDWWEFIH0OqH1tNvfm5HqW
	 FWfPqP2bXoHHwa6X4nnRacdG2ecEBOYvghqqJqgh+flyGf6h/IuSsawtX5kSp4rQWK
	 24GgwvUmkyGT3w2c3rojHJ8X6qlrWVnCyNzsLkScHG8xuovvnbl2VFqBINWWNONPGX
	 O6bxwSzqM83Pu+iRxuEEOfLT1Y+4Xz8bFoCk4Gwqn3oh+nbM0zJ6ZBTMcwj4H+q77H
	 LvlArFYPOPpCjzl9P2nnN8cN5R1fkipZ1NiRvJvjR7OMx2Mda1nvnCRS2ny7vUN9V/
	 QpT8hhHkjcp0g==
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
Subject: Re: [PATCH 6.14 000/447] 6.14.3-rc2 review
Date: Fri, 18 Apr 2025 13:17:04 -0700
Message-Id: <20250418201704.68961-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250418110423.925580973@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Fri, 18 Apr 2025 13:05:27 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.14.3 release.
> There are 447 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 20 Apr 2025 11:02:55 +0000.
> Anything received after that time might be too late.


This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] fc253f3d7070 ("Linux 6.14.3-rc2")

Thanks,
SJ

[...]

---

ok 1 selftests: damon: sysfs.sh
ok 2 selftests: damon: sysfs_update_schemes_tried_regions_wss_estimation.py
ok 3 selftests: damon: damos_quota.py
ok 4 selftests: damon: damos_quota_goal.py
ok 5 selftests: damon: damos_apply_interval.py
ok 6 selftests: damon: damos_tried_regions.py
ok 7 selftests: damon: damon_nr_regions.py
ok 8 selftests: damon: reclaim.sh
ok 9 selftests: damon: lru_sort.sh
ok 10 selftests: damon: sysfs_update_removed_scheme_dir.sh
ok 11 selftests: damon: sysfs_update_schemes_tried_regions_hang.py
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
 [33m
 [92mPASS [39m
