Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0100D14265;
	Sun,  9 Jun 2024 16:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717949437; cv=none; b=Qnmjl6oWac3mCyBgGnqKkmsBv+K+iTEexhKpUCZgo8ltaVNDd681wIzp1j8Yll4KQymkFPMW9eYUacwGAJz55MSfvHqIdoEd7bmaaGc3uuAYtDqSD7MMTceNrvrtcRhn4Xm0yocxuuGaTQzrPq/PZvbR7GHexfILpzwzoGqbD8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717949437; c=relaxed/simple;
	bh=oeXu4rLXkrMEaolsQz5Aqf61Yi+TBt3Qo8sec7rPtis=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tPip8gnNA4kvoY09DwIATCZYcYVS63qbDPOnWdKpYvJlgbmbKcCoT3OVFrUqjemzDwGTeKiSCAyT/EptO9tLfP8LO4k6vH+pZvO344sj5zYQQBgjuyFSz2pQgjeVLWANrcUVdj67x2pO1XtO3zIqRAQSg05CNEik/evRXlY0Qyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F8BedKyx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F8BedKyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70A2C2BD10;
	Sun,  9 Jun 2024 16:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717949435;
	bh=oeXu4rLXkrMEaolsQz5Aqf61Yi+TBt3Qo8sec7rPtis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8BedKyxzZ7BfckNJ9wRqnbNA6noRXzFK/IUYcfaC/I/hCFC/qPPp00NM/xdSTsrc
	 ST3B5k4CfFK78FhOVqBVU1mEbcbt1VE9s+ZbvWexG2/QqmHiT4lvgVPCxA5+g5tXmp
	 w5qoyKP+o11xLBAJuRmgOPqkF8J5FS4ehdKJFlUqVxTfp/wTseAByU3Qh1ajQkzBAN
	 Oh7Xa3FNiXQEZ95ft9TvKw/OEAQ85vaivD+K2HomdST6BCtzojuNZGv9j6oghwCHzL
	 0SOxOjNUDwW8XnrAjwQTOX8OcRerJ4n/ImT0/lXLbsqgZ5smWCylNhSN/4+aSctm1g
	 c5/m6xGvo+slg==
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
Subject: Re: [PATCH 6.1 000/470] 6.1.93-rc2 review
Date: Sun,  9 Jun 2024 09:10:31 -0700
Message-Id: <20240609161031.63516-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240609113816.092461948@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Sun,  9 Jun 2024 13:41:02 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.93 release.
> There are 470 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 11 Jun 2024 11:36:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.93-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] bd8637d23a9e ("Linux 6.1.93-rc2")

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
ok 7 selftests: damon: sysfs.sh
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
