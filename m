Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9891B1F91D3;
	Tue, 21 Jan 2025 23:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737503192; cv=none; b=HxAkoSZo4M3BQqaGehmXavLNFHTEVbxk+oxMraIhWmjq25uWIJtDZoFwgAP00ivWu4v8yvMck3+Uof2ya/bUe7z4Y4gNMLLVvY/1lfoF3SuVlt+7cnoZLiGmohHaFCTInUkqgJM/FptGy7+9X8g3e01o4qcjhPrGUSK2iKZOSLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737503192; c=relaxed/simple;
	bh=BOGlTFNu1i0JPsXOkCTJlyu4dUvnZRGYjSSEyNZX9mM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cOmJFvhGwv5Mw3aayZIKDUJN5CilTV2m38iloSgUdsJeSsJ+FM8fsMMqeq6B5aUeK1G8dQ1XsDkTRrZjo0hilUOaq5hHKT6vAs6PBPcJVOEvGVF4Ow4gyxHr1lPIWNU7nbhZqN8ytTEP1QrKflNo8/7fGBVVnjQGCqCtWxW5EQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CeLla7CJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CeLla7CJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8C3C4CEE1;
	Tue, 21 Jan 2025 23:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737503192;
	bh=BOGlTFNu1i0JPsXOkCTJlyu4dUvnZRGYjSSEyNZX9mM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CeLla7CJyw+wRNtZxKwJK4pmEzb+olY8+ZTqXOBrfAlnCYmoGrabnEoGCgOR9OHcB
	 pFT0Dq+T0MGrWmk6ElamG0H+rNWb1JNUxIvFIkbxTJ5shTtG6lBeVyolbSaGjnVlVP
	 Ba7tqG+nstxHZt7ApntxZGySs00VZi97Sl6pXjkYmSIGEfsLO4Cy9LwWdH9lPRWmSN
	 lyls9gTZi5wCubsWO/KrLdVO1Qsce82ugHKYYuPRy2ZMvvX3cwvRrlVt48CSh2lrXp
	 50kyyaF9uuR2StCQBUIBgdYodHjVd8hNwE1ZbD7pnZOOyMylbox5CJYdO/FGt2DKZz
	 L0Wz6eU1vOJ0Q==
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
Subject: Re: [PATCH 6.1 00/64] 6.1.127-rc1 review
Date: Tue, 21 Jan 2025 15:46:28 -0800
Message-Id: <20250121234628.46155-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Tue, 21 Jan 2025 18:51:59 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.127 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] ad6747190c53 ("Linux 6.1.127-rc1")

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
ok 11 selftests: damon-tests: build_arm64.sh # SKIP
ok 12 selftests: damon-tests: build_m68k.sh # SKIP
ok 13 selftests: damon-tests: build_i386_idle_flag.sh
ok 14 selftests: damon-tests: build_i386_highpte.sh
ok 15 selftests: damon-tests: build_nomemcg.sh
 [33m
 [92mPASS [39m
