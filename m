Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868A71FCC50;
	Mon, 21 Oct 2024 18:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729534079; cv=none; b=eZTlIhf8JPJE08wehdl+tiPD9YFdvngM9Px8TanZ/n1EYoD2X45k6J9mlcJzRTJOfoy/qZc2DmKEftnV3IizQ7UqDBFGKKn3rPb4MP3lNBQVRsYrXQNaLWIe+Gund16ZDHUMeI02DREDIh4rdI7VjTt5hlxtCkCCyqWy3QW3U/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729534079; c=relaxed/simple;
	bh=nyRMRD/saj8XQy/8iZJU5zX7p4e5ufrzv2LZlJ0usKw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RK6khuryDjM5/ay5byPaZtInj224P5dGyePBlSbwr4K0lRWnp6O2WgaJV821XhiFFKu0jVh7QF4DzFQglUbtYq0EB+Qp5yzYlEGBYxRSFRnwlFZZNSvFbqvGZydrxjir+mMcPmx6mLoNJFvzyLe5ws5j8sfYeydC+C82BFWOWgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rwp4Mk+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rwp4Mk+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D24C4CEC3;
	Mon, 21 Oct 2024 18:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729534079;
	bh=nyRMRD/saj8XQy/8iZJU5zX7p4e5ufrzv2LZlJ0usKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwp4Mk+CBT9+9d1n4SaHLzXbfkYiaV95HEeI/bFwEai9O8yAtMvNgTuTpcg8TMxCm
	 KgVBs4ZWsJkiVkk8071DtNQSecpnDWpsfMEyVQyEX1LB92VBPBGEGiKoYXsj9N4J7i
	 EBj+tGokJPOFqewXd9PSbNCVRU8K4MGlUAZDQGtCXgDHg608v+ZkgI5JSppcvip0iF
	 qA/clXfiYupBx2S/ilzUrhvwmc9Nx7Lhyo7rdvs8t56/f6dnJ7rQV302AsN8J5DcBd
	 E+7w7WOej8jI63UIVzYEMAwspZ7ucBNeq/EVTkKnGeOvjuOqhy1u7NeQk1tcM12ixp
	 Pslt86BpK9A1A==
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
Subject: Re: [PATCH 6.1 00/91] 6.1.114-rc1 review
Date: Mon, 21 Oct 2024 11:07:55 -0700
Message-Id: <20241021180756.14960-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Mon, 21 Oct 2024 12:24:14 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.114 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.114-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 6a7f9259c323 ("Linux 6.1.114-rc1")

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
