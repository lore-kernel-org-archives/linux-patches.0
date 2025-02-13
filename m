Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75A72066E4;
	Thu, 13 Feb 2025 18:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739472094; cv=none; b=M00hXzdig5K5WMRgyutFBDdEQqwupHor8fv+X4l8+Ttzm+CuQxasHwdCbWteiezYCHVNBolqmofov45gbGnU7ZV5P7oIG8+PBvlR9YvG0Iwv1TE0KZA85X5/ZmRI2v35I0EJOxV6+qG9k4zcc5Phpmk/2j3IWMRaACW+qIe92Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739472094; c=relaxed/simple;
	bh=rw00Gz7cnVQmbHLNqSxEcLYZa2f+ksVxqZ28EQC9uwA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CVroyqhf7qXE8Gu4ksiNM8mnyQXRCH5Jlu/yvKRfhIguWt5BnwiE68PRH7NGqQBLM7nGPJdr6NWA7vV5ZqUDlmI7j6ObYw+5OjYgoTmVgZ/eOy9A0UlcTsdk4puTxVGXf26Nx78DkHhW41WGjh6F8roBo4822tDF2Kxlgl1vpkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mkk76idV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mkk76idV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045E2C4CED1;
	Thu, 13 Feb 2025 18:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739472094;
	bh=rw00Gz7cnVQmbHLNqSxEcLYZa2f+ksVxqZ28EQC9uwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mkk76idV1M+0RKAJk02D6NKn+e+kE8dy3J63A8eJcxBWOESyIMzI8T7k6U/NpmYXf
	 h63iudoK2jyuP4mQkm9eIC8xnV3kHaNIAsauvGY9A2m1nj9z9XaWjR4Hpe7ltIKCiT
	 piMEpN0TeXiamx1ZeSkCGragMfl0tGqFJ7qVEhzmZfSGYR31V1wWabz4391ffEiOw4
	 6DVCsmfOrERugzARwo1V4ezpeHUxtpxFtd9HMAx9oE6PVBwntv81olBFI5/NQbqZ9K
	 6yD/5zSkfscZCIgKSy4GQNXxNcC7E7kuBomSGsgNZj0TC0BhFlmYccW7MwNnxcDrd4
	 99yDMYFSFgZOg==
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
Subject: Re: [PATCH 6.6 000/273] 6.6.78-rc1 review
Date: Thu, 13 Feb 2025 10:41:31 -0800
Message-Id: <20250213184131.242959-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Thu, 13 Feb 2025 15:26:12 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.6.78 release.
> There are 273 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Feb 2025 14:23:11 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] e4f2e2ad0f5f ("Linux 6.6.78-rc1")

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
