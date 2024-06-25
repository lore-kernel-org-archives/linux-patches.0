Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB891459E2;
	Tue, 25 Jun 2024 17:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719335026; cv=none; b=X8lMjuK3RAPW6stxbTXYZePTX43VI2JAx5djGfmbr5yxQqoMYyO8eIKPOFJrAOFeE/GEjdro9jcMTGOHHiTiY2EHLyoJnZcioyI2STNu9WKFEg2haaprs0MiCH47QrSNaTRcOccM3zrrE1Scfj4zUaZgLSVUD23BrOHRNA3SAaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719335026; c=relaxed/simple;
	bh=ok6Ob7SXUaniUDIsyw0Drp+62Ec8mYkXz7nD+DYG7Y8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qWn/K8/bJtGEuAFy6AE2nks5dMRWqS+kNXN0IlhtkfHE4sseY2IXA7IT+VQ7eOPgPFjmg0szt6o2IAee16i3hW2sE4lHwGYVBDIdOZXGFlgsqQK83epvvAvTLRoei9zRy/8oYmrSoFWpvRv67DVsxnhHBFYZGTiGfOu37V8V3PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AZuVjNXV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AZuVjNXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04EF3C32781;
	Tue, 25 Jun 2024 17:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719335026;
	bh=ok6Ob7SXUaniUDIsyw0Drp+62Ec8mYkXz7nD+DYG7Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZuVjNXVBPSSAAU0fgCpxCYD37Qo/fWiE53ze0NXHLIKH/J/kKx6KRCCNMWvHtAFW
	 /g0cUnsZqmMgMg/pYdBK9mslnyT9rXn39FCdRXACyj2i1HW9g4Q4/xCx9je0YKIxj1
	 xOPGSR5rBwZStPz5wVxNYF6Sl+xGWVIGof8N8EYEXi3vd0OygNb6SRW+50ptQi2KMT
	 wZT9EUnC4d4dqsUzYXRvw4rotu018k3BYoF3QAEKvZ6Sx1MkDSxwaV7p+HKxmtyLzr
	 fcDdg7PjYCQRASxnOKBkOxEyF/PzklpDRDfGm5I2peBoQFvY5B+kj3VlQ2LwBVvN6w
	 5wRDolP36P04w==
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
Subject: Re: [PATCH 6.6 000/192] 6.6.36-rc1 review
Date: Tue, 25 Jun 2024 10:03:41 -0700
Message-Id: <20240625170342.100098-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Tue, 25 Jun 2024 11:31:12 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.6.36 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jun 2024 08:54:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.36-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] 580e509ea134 ("Linux 6.6.36-rc1")

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
