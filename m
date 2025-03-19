Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6581DF74E;
	Wed, 19 Mar 2025 16:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742403338; cv=none; b=r4X8Iol7ehz3DyDiByBBbFz/BWvvq46v/8UyJYlTnJHnZdqVOhsMEFtRWJCBlSeATJy000ju9qhCXw4mDDFStL7SFkCLmXzw0zxhOUzy3biqqHXNdYYtolK9Q7Xgv6avklC2+4xr84NMn+Y+mj9W38jqrHknQ8BfTgBOmKDaW98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742403338; c=relaxed/simple;
	bh=MsgLzD6PJaJW5GC1Kic0ijSywAJ9z3Kpg3x+ZmeJQy4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qV46nTK7EANa1Sikgb3gF9eQXdTY6JXuIDXJKYaID894mgRuJP9ib6G+Y05c4rmF3WGSvTaS+r9IHQvNDPnbGGc9dEKfdayOUhfAXBEXntyGEWzO1fgTtCx11grs/anQMA0CdDd1/CT4dyvo05L/5nsyTguEDGYvIiQBH8j3we8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jcfNHxwe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jcfNHxwe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D4EC4CEE4;
	Wed, 19 Mar 2025 16:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742403337;
	bh=MsgLzD6PJaJW5GC1Kic0ijSywAJ9z3Kpg3x+ZmeJQy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jcfNHxwemQPi3a7M8l5HMSOEdyOnBs2Et34UA8pYHL5Q4FB3WjLQtp/o9aGSCeYyx
	 7xFdRJLCQZC+Ak4Iwy3an3Jbp9ybyKMl4KgENG0rsCngg3L1ytsUXjH7RQ8RmNSlXs
	 azXY4Y351grm75fW/12Oa0j24csX3hk8kLO/sWKuGtXWjqMnF3d5TdVUPGRg8dPErZ
	 RZnyiz/SspnniszvWRkj6hHwtEelf2YdXwuMVC0dITO1AXHJoEGyhI1W5086EhnMbk
	 WCBM/lzxFbBpgYP3QASwD3oeUQUB/tzfKfdJGfpytwVa4PdZ4pMJZAvNI+OziOO5Ma
	 T0Zw12smq0V7Q==
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
Subject: Re: [PATCH 6.6 000/166] 6.6.84-rc1 review
Date: Wed, 19 Mar 2025 09:55:35 -0700
Message-Id: <20250319165535.51516-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Wed, 19 Mar 2025 07:29:31 -0700 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.6.84 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Mar 2025 14:29:55 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] d16a828e7b09 ("Linux 6.6.84-rc1")

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
ok 11 selftests: damon-tests: build_arm64.sh # SKIP
ok 12 selftests: damon-tests: build_m68k.sh # SKIP
ok 13 selftests: damon-tests: build_i386_idle_flag.sh
ok 14 selftests: damon-tests: build_i386_highpte.sh
ok 15 selftests: damon-tests: build_nomemcg.sh
 [33m
 [92mPASS [39m
