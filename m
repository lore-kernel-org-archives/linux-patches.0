Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533D41EB25;
	Tue,  2 Jul 2024 19:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719947937; cv=none; b=OSXrmHgh2m/imdzRaO9he7R6K6gaTuuJ8W76Nybncd+9Jrk9OPE2rc9OWVCCmP8sKJG19D+cdIPY6vKLGICNuvP9mhEIA3n5m5Xt8kTWJmAB8XhVOTsO2IqgZ5j2GSPCrcBf0kON1YlLK9dwzXiWOkbs/LGv/S3oTxhF3LjJAcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719947937; c=relaxed/simple;
	bh=CzLi21/gLCzjAYQxAxiW/afKJ7ulheUZD71U2PZ+f+Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N1p3RMcCQktFnqQpq0T8VY116WL8xWK2rojMqNU6ILs/vqX0+DvZgMtDEgnDd6Insrw42SLh/Hy8B5EcGpgkKBLniKLPnrg6CX4Z70fZIJUrWpY62KsAupCsZn0zL/78yT9KfgKVW++IvBvNH9M37NhxTOfW59j+qJvY+V5g6Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h13ybAA4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h13ybAA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57838C116B1;
	Tue,  2 Jul 2024 19:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719947936;
	bh=CzLi21/gLCzjAYQxAxiW/afKJ7ulheUZD71U2PZ+f+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h13ybAA4bA+7BUTeIDm9/A9K/0sSzDm7suveJEhqOjxdP0H2Q1ZZFYMF4Z3UI2uJ1
	 cVtEGSTgxRaj0GK+MyW2ao6Ntiyd/fR05aTI0pXjMoOlorVLXnc8+fq3lSY9E8X5Zz
	 EwG3dOBfD0oSD6wlgik7JCfs/qfYGOfZOADNTI4MWkn1VO1llglpqvaHre5ebTj2Hz
	 qUTUIslUDBrnYIEXj77s95Ax6FcPq/9SA02jp+FHdddbz+XtnPwn7fRdQeubCIaj1R
	 FscSgnShftn+3uhVl+Oho8fCLl6LxGy3ENEECO0im45QLcwj4H91eVzG3vHkrPWCR5
	 pAMSOh9B/NaFA==
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
Subject: Re: [PATCH 6.6 000/163] 6.6.37-rc1 review
Date: Tue,  2 Jul 2024 12:18:52 -0700
Message-Id: <20240702191852.70810-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Tue,  2 Jul 2024 19:01:54 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.6.37 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Jul 2024 17:01:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.37-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] ca32fab2f2f9 ("Linux 6.6.37-rc1")

Thanks,
SJ

[...]

---

ok 1 selftests: damon: debugfs_attrs.sh
ok 2 selftests: damon: debugfs_schemes.sh
ok 3 selftests: damon: debugfs_target_ids.sh
ok 4 selftests: damon: debugfs_empty_targets.sh
ok 5 selftests: damon: debugfs_huge_count_read_write.sh
ok 6 selftests: damon: debugfs_duplicate_context_creation.sh
ok 7 selftests: damon: debugfs_rm_non_contexts.sh
ok 8 selftests: damon: sysfs.sh
ok 9 selftests: damon: sysfs_update_removed_scheme_dir.sh
ok 10 selftests: damon: reclaim.sh
ok 11 selftests: damon: lru_sort.sh
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
