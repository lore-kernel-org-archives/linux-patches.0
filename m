Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A797D13C676;
	Wed, 19 Jun 2024 17:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718816857; cv=none; b=QBO2+euGmOWbvBAMaaxknLmkUo2OBgOaF9msjukw0E0QeBAG1TFzt9vpRSG8C6RHJRewXC3mpe4hv3r6In+yiSVQOawujziY8n2p17oFaOdFK6Cx4vJw9aA/o/jlBD4xwLrzw4l4BxaL9O0fF5pY+RUuHDXiPjJY8VbWkI5VBKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718816857; c=relaxed/simple;
	bh=Wloo6JWvpUfTAnHdSarjG8T5XmeBeAp8kjm9RSazkqM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e9ogdXSY3sFbArUBpJrcugALkzD72yvPa2qaQGytYtMcOuob+b/Z6tJEIsAumPcTMkD4vFc4rwWNjENRKOYFYynrjVvtGsZcFqcVB3sluGZD1TqCPqM3eaD3XcEqa8iI+qve06x/rv5Rk2QQLK7GQazaKyL1rJUkp5ejGZE1+6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oiE5KgQX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oiE5KgQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB484C2BBFC;
	Wed, 19 Jun 2024 17:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718816857;
	bh=Wloo6JWvpUfTAnHdSarjG8T5XmeBeAp8kjm9RSazkqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oiE5KgQXl2swtL+2brbWjeQqNH+KEG9QAD16d5T6BJ3d3ltBHVA6y5KMKU/gIbOBb
	 LkZAxR0ysyV7WvlNGAZcjTfPBubklbW1qc5xzMqPxPGC2rygHRQNhzE0RuC/fCSXrg
	 37OHG95E5DOqYB8U5X0EoZb/P5ocUSUqwVwBxKI6NX7NUoRvbomdmn67VX0vGgOa99
	 Ca3BEuKwGU3DE9Hk4kf9wvu6dttgn2VFxkpNHwcIUwPmUIzmYaLilyt60RdCNup0RH
	 886QuQCmHNRJ8a29UsXQS+rBoUU/KYTL/DOarjzivYGG749f+r888LB8TlMDZiQafH
	 /DvbKpAROfBmQ==
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
Subject: Re: [PATCH 6.6 000/267] 6.6.35-rc1 review
Date: Wed, 19 Jun 2024 10:07:33 -0700
Message-Id: <20240619170733.108998-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,


On Wed, 19 Jun 2024 14:52:31 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.6.35 release.
> There are 267 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Jun 2024 12:55:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.35-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] 0db1e58b51e3 ("Linux 6.6.35-rc1")

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
