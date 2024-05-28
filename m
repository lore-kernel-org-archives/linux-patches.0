Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E11172799;
	Tue, 28 May 2024 16:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716912515; cv=none; b=uOeJybyxlDtO2EGGRfjvRc0Ko2N8LDSkfm1FZYWHdzj/OlmJFU0ywAJfHmm3+LycG6GpQNIMw7noJvIic8E6nu1RxX2yScUnNisi3QNoPvx0tCJ+DH628qajdr+iK2haG1VWM5x8h5Odd7lbbcAMvU4LPAXc03e8PD35JGTL8uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716912515; c=relaxed/simple;
	bh=dZre33+kTvP3qNM6Wq68jjxZ1j/0HNMDQQ574/KywCs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JPQ7iE7Swl8oXpqPxERhQkJhyZQM/hGPu6ypyODhHW4LboBfBOj84YoPzDU6aHzWIXeaKmtW3Hmlt16y4DIqsbIsX4sqLrOobtIqxw7pRFTv7iSrNFdtOkeRQmNXuerKwHoV2uGjsb3g54ig0yLAHwwnpjSAklziWWmyvZEMkYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m/lBnBuH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m/lBnBuH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B34C3277B;
	Tue, 28 May 2024 16:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716912515;
	bh=dZre33+kTvP3qNM6Wq68jjxZ1j/0HNMDQQ574/KywCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/lBnBuHh1e49A8BbMkgzPdBTO4YlWs56vwiUB70FI+UAdMzbD87ggPUiDe/tlJZ6
	 PV6wYrU8I0Sophj7v7/d6/PDU6G9Q7WbjieXoDj0sBU0LdV9oawFu5EXg9IX0fLXrO
	 xll2PZnFhUcZbiCZ4+B8MJK/zrQ8WkD5NCVSRC2yEWNo1X8YVYPP4+qTkqzoe7wX+I
	 oBbWKe75ScEVIXzDIQkgqYTvgIhHLkzJTOlknl2Hjqh05MGSUkSbNzKdOx+d9ms2WG
	 DOPwIn8/xYplVL56+rPX/7rUUW+UB8+1TgCphkWayA/MJVNY0ecXnS9WhvOsrTyZkc
	 x/n0JhI39F2OQ==
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
Subject: Re: [PATCH 6.9 000/427] 6.9.3-rc1 review
Date: Tue, 28 May 2024 09:08:31 -0700
Message-Id: <20240528160831.150674-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Mon, 27 May 2024 20:50:47 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.9.3 release.
> There are 427 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 May 2024 18:53:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] c1009266618d ("Linux 6.9.3-rc1")

Thanks,
SJ

[...]

---

ok 6 selftests: damon: debugfs_duplicate_context_creation.sh
ok 7 selftests: damon: debugfs_rm_non_contexts.sh
ok 8 selftests: damon: debugfs_target_ids_read_before_terminate_race.sh
ok 9 selftests: damon: debugfs_target_ids_pid_leak.sh
ok 10 selftests: damon: sysfs.sh
ok 11 selftests: damon: sysfs_update_removed_scheme_dir.sh
ok 12 selftests: damon: sysfs_update_schemes_tried_regions_hang.py
ok 13 selftests: damon: sysfs_update_schemes_tried_regions_wss_estimation.py
ok 14 selftests: damon: damos_quota.py
ok 15 selftests: damon: damos_apply_interval.py
ok 16 selftests: damon: reclaim.sh
ok 17 selftests: damon: lru_sort.sh
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
