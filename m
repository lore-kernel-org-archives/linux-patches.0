Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B50487BF;
	Thu,  6 Mar 2025 01:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741223427; cv=none; b=KzEnQMwQl1irBJ6R4GiP1KF7btop1m5rIViigcrhblW/jZ1cmRW++PMQpA4eVYc70NMWc1w3z8IfpxNAcVS7LBq1GK0EU89+18SQFevOc6JlzNw4M9jVHoR0LL6ghCaIRp7H2dAHnz7KhIV2qmJ5RWIZ051ZX48wASmqJHAuXe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741223427; c=relaxed/simple;
	bh=JdMx8rpHUmrNZGddb5mliSm8PXvq+fqSeBA43WDDaCs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kUsfS/G8kXMdPgQ9nYKHcawMUuKb8my/t3ZXaWPuMT+lWBp3K+8f7ItLNe7HDDZHxv2nMm0GZaovjcu2XM5jKLKXBrI9jWn34t3B6fJmtkchRgIsqPZR2uVLp2mHJF5rv1k0EX+2Qs4onGwDldbFViMyUFy2K7yWMnEmhnLzZ6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AEwoTixC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AEwoTixC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF534C4CED1;
	Thu,  6 Mar 2025 01:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741223426;
	bh=JdMx8rpHUmrNZGddb5mliSm8PXvq+fqSeBA43WDDaCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AEwoTixChRlo/Yt8jFmI2FmAYMqUGt3sYODVbOKg4fQIDSu10qht2E8yPRNYYI9jN
	 RyOz0D2NDsczQunFv/LzG1ylmkG1dRaVNDxeSe0vRtQswZGBasj+FQW1PD37PHJuSE
	 iHG2odgNI1vbsQZj0M8ho5t3sxATwemjpesv46/40f+Bf8uFZ13Qg5k1IfQ3geYRYW
	 H/8WZoU7Pi4u+qoabgR5jD40kA7vTPawxNdUwkYbSTlozLKhfVoHGd2VhLLyxl9Eut
	 hN/usxG6jqbOMYfSHAEIfUa0ouCpHftYm0lYi7UUKaNbQUTlniuTooB0l7My7dhWsA
	 1fLRCLCuI/GKA==
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
Subject: Re: [PATCH 6.6 000/142] 6.6.81-rc1 review
Date: Wed,  5 Mar 2025 17:10:24 -0800
Message-Id: <20250306011024.138861-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Wed,  5 Mar 2025 18:46:59 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.6.81 release.
> There are 142 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Mar 2025 17:44:26 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 9f243f9dd268 ("Linux 6.6.81-rc1")

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
