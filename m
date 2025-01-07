Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19F51367;
	Tue,  7 Jan 2025 00:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736209258; cv=none; b=sGJKAsd1aPVwwGC00hiVIryzw8mkmWK+Cz8Vkk1DrXV6I5Qxk8nd5x5GtEJvo4tSAFIZ160LCJeWXCsHIv7XLeu8SoJD0HLmh/83EffwTFZP8GyuBXW+occl+QriX1GqjND/FCRe3x52WJZPy7QM4H+kNmFRu3S36X0WO3/rhxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736209258; c=relaxed/simple;
	bh=lDrZVdZziMj5qQSzWv4xG4R6qqu4bxQoGSGdPERORvg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I82lMqbkKJkw0uZauwvJDM/+Q5Oo+bo0JHZBE7b0kvf3+6KH/Ma+ODaWjTIh1l2gQsRBPFSujaK/jzHjdkL8qEvcnx0tt7+cZp7geKHOpOrWTAdxuaE/QQXEuTWN39jEa5H07GoyFJrty08xKjolXBQValsLHIa3njpNxJUtM/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dtiFvmxe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dtiFvmxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30E2C4CEDD;
	Tue,  7 Jan 2025 00:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736209258;
	bh=lDrZVdZziMj5qQSzWv4xG4R6qqu4bxQoGSGdPERORvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtiFvmxebzqUaIlTVYx1vlCyHc7ItfFryNXCE6GbYW2gTJFxcsHhIxEd5Ao8CLNbu
	 0FM7RsvkkyW+lJzqm/xBGNvNXcq5IC7oeqqiS9dKP43GBbxVmBCo5HZlwyECVGKVFj
	 ObkMkE0Gxdp1vXH4WheN9CPoyw1ztOXGDvmnzRMmAmz5xSM6sup8WCJlqSS9Pk8hg4
	 7BCRvO4NzHVm5ZAbzN+3ZXeNhnyvaoNSWy5gQOM85Rl4XOPDx2WMqXE8Px/ThhdN1D
	 CB2PKY7tDQsQahwMVo8Fk4ZiJP2s/0k2cYJTsE6CAijiK9dxNzssl+pi47XQR4xMHC
	 J7JPaH2NNR/Kg==
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
Subject: Re: [PATCH 5.15 000/168] 5.15.176-rc1 review
Date: Mon,  6 Jan 2025 16:20:54 -0800
Message-Id: <20250107002054.3653-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Mon, 6 Jan 2025 16:15:08 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 5.15.176 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] bcfd1339c90c ("Linux 5.15.176-rc1")

Thanks,
SJ

[...]

---

ok 1 selftests: damon: debugfs_attrs.sh
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
