Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1B463B8;
	Sun, 17 Sep 2023 20:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD44C433C7;
	Sun, 17 Sep 2023 20:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1694983642;
	bh=SFIIku99AhDNaEZJOG8NLumuR2cifXm1O4mGPq75dKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qf0K9cUAFISgN3Ytse+7JXbRk5drgqDxQo9VTmV9kebroDt0wt+dUYscvpWuAt5Pk
	 pI1WaRQD7vcrC8Q0xFlysDNZdus8Q834lfWQSQzQB7uXixYSNehWH0g13n0M4Xa6cz
	 INNRk8Qst01pSM/W6sdDYg3P1C5G4we0x7r1lHkJ1xaKJ59z2dTir04Zyhh8X4Vwyc
	 EHSa04TP4ZLoLYyTtoit4mFXOkDXrpZfrYB3wV9HoRYXlGyE/Odb4YlGqe9QTOZn6t
	 kPWrcTiYE1XQ1gjPvJM6m532BNpRarxZwI+LVB6N9Ik5dK+KhrB1DOjXtLYOOg2hDR
	 k05FYXjqibeqw==
From: SeongJae Park <sj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org,
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
	damon@lists.linux.dev,
	SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH 6.1 000/219] 6.1.54-rc1 review
Date: Sun, 17 Sep 2023 20:47:19 +0000
Message-Id: <20230917204719.104921-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Sun, 17 Sep 2023 21:12:07 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.54 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.54-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] 89fc7c511aa5 ("Linux 6.1.54-rc1")

Thanks,
SJ

[...]

---

# .config:1408:warning: override: reassigning to symbol CGROUPS
ok 15 selftests: damon-tests: build_nomemcg.sh
# kselftest dir '/home/sjpark/damon-tests-cont/linux/tools/testing/selftests/damon-tests' is in dirty state.
# the log is at '/home/sjpark/log'.
 [32m
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
ok 11 selftests: damon-tests: build_m68k.sh
ok 12 selftests: damon-tests: build_arm64.sh
ok 13 selftests: damon-tests: build_i386_idle_flag.sh
ok 14 selftests: damon-tests: build_i386_highpte.sh
ok 15 selftests: damon-tests: build_nomemcg.sh
 [33m
 [92mPASS [39m
_remote_run_corr.sh SUCCESS
