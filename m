Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D7D17D2;
	Wed,  4 Dec 2024 00:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733271872; cv=none; b=ESBDsZqmymrMX97R2W5r2HzJFxUjhsSP+9+5jwy/R0rbNFhABWJnM9Ce7HAp6ckISvLrTMr7hckoNxXBSYcoCoRCVEyYXU7WkqgPlXZyNOfLltO0lQEDhmuu6nu0P/1NPwQt9tOoM/dZVQ5LHc/ULf6ZZa1ZWDwrtQApgOhk1Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733271872; c=relaxed/simple;
	bh=3aLL3OQ0JjPgJJ3AA938LY53kK42EWSLbYjymQP4luY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=krFCtjg5wSoCCffpR5j8Nh3RD1v8DRlrlL1BBzgUDeRwargqUiscSixU5sCRf93fP7MLDpc9Xwnb2iMDJEt2AhEy5Bajsb8Tx12XabLBjJ+17y6R6uwY4PW0oZ3RuJfIA8FaLyZ1gNteDJFFantDsUz1WhfayuKWFNZIEprFojk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PaB/m/6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PaB/m/6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01882C4CEDC;
	Wed,  4 Dec 2024 00:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733271872;
	bh=3aLL3OQ0JjPgJJ3AA938LY53kK42EWSLbYjymQP4luY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PaB/m/6uERNd567YnOCKJUOPEsELei5qjtUUcBVeRrkmf1f7CWg9t6slPQsKD0QWM
	 pNQZNHGP0MHFJRqMOY7M0+jMKr/beWuEcisTare79cSFNGcKp3sMgVDC1z/VvFf6gS
	 x/vF2/c3sHutKk1UMiGYXOlo/OCgSR6iyktp1ZLiNl2go8Dfjenim1XTb+jTxcHI6V
	 R3TjkGxmEGn+vqoEPY6Ej/FJKNyhItqyeo5vJduU/K0Z651n/2jRSy4YXhW1MVne4C
	 Kc1uSUQI0mWPoB0YDjqDBpn/1KcxmTbCjms7EgI+PGGMktCx68xkvOVVdfyPHTH2PI
	 bhWGq2eFDpzfQ==
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
Subject: Re: [PATCH 6.12 000/826] 6.12.2-rc1 review
Date: Tue,  3 Dec 2024 16:24:29 -0800
Message-Id: <20241204002429.85717-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Tue, 3 Dec 2024 15:35:27 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.12.2 release.
> There are 826 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Dec 2024 14:45:11 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 1b3321bcbfba ("Linux 6.12.2-rc1")

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
