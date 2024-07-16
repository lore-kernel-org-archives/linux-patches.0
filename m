Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8E61A070D;
	Tue, 16 Jul 2024 18:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721155091; cv=none; b=hPHKG4QdOlX6YRpJhGbvtzme8m09S4PldzcpEjQiZJ0r5FLx4rIZFSB8jm5xF/2YSsIdDd9zmXmX3vL6E2i5CS9zxccJ0uRrdMW4JomFEvC5sqXI3XlOsl0SGqhDdxNSaN++NU1lvuFDrZQ8fOBLwyRHDXuAkqT7Kk5aEWwIBN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721155091; c=relaxed/simple;
	bh=ks8giOZYGF988/KXeDcypvkOwki6xVu4b3JtS7gj410=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BmM3FohBd6K2fIgImXu8/uZyuVRpJRiPBuvb7fJfuDv7BXS/y04a/YFojDLEt/uC4mEYbxEsLvjZpvgthF9T6ohTIQfe98lXf+/hkXoO/xHBQNab6+MWrIwYx6soviWCjgc5ro4OgEaYyouDibkU3V47oqgLPIr+Tq8qVOhnTr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gF32R2d/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gF32R2d/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96B4C116B1;
	Tue, 16 Jul 2024 18:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721155091;
	bh=ks8giOZYGF988/KXeDcypvkOwki6xVu4b3JtS7gj410=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gF32R2d/NFstsE7r/wkzlvU9l46t6VYElBUSGuz2fxg6gekgrN2fm5T4yRAA8ln+U
	 sulm6it9ctjmeyPQ/fxTPXVKrTTJhBtq5T+9H2Hn5aRh5M5gKzcqKyvldpePMals7w
	 HSqfPiblfm4TPF6wHu4FP/oYsp3oNYZCatCb82VCzpilC9FMAbERtZMYU8y6SSfBz1
	 XM8VQVWem00DpvHATWBogsjEENOGFAEtCvnBA+C2KN6BYB3OfxCySLIpoZ/U2SgxFO
	 nkOCmFzsfRYMP9jcWbaMSXIy0irDpuk8B/W8dC4GobHy073+hr6PpJc7CRJ79QAO75
	 iz4IeXAJjRaEw==
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
Subject: Re: [PATCH 6.1 00/96] 6.1.100-rc1 review
Date: Tue, 16 Jul 2024 11:38:07 -0700
Message-Id: <20240716183807.138607-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Tue, 16 Jul 2024 17:31:11 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.100 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.100-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] 928b1b7691e1 ("Linux 6.1.100-rc1")

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
