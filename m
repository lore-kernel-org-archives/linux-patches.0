Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89B3364D6;
	Fri, 13 Dec 2024 18:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734114844; cv=none; b=cgE9SXfVuHKSL45sokdmLYRQpnO3g1ge+9nxIGI9vAel5Cz+JcfZFhYFOb0QyMkvryF/FmD71A1pHFCuj/tVOlfS20QK94Htufy/khSX1YeSFuBnx0ZGMM/adU7+QZIOREOnx59XfBWCOfGERptyPhiSTP9wJ3AwGGhc986qqBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734114844; c=relaxed/simple;
	bh=c6QaCi+csUzrFKqJQeJC3Iz7NJnFz8biXkSovhI1qys=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Wtnqozko+Qr/CwDk5UHdiDVWZpf171f4oPPFNKt2S0JcW1Qx44KFU4hqYt9ZUvikby7D8/gWjgG/AvsvxMhOhMbv1Q+gQZQ6WY+RLHFhSoWJM6v/ewk767jV8uTURLElUgwrCU1uGR2OpttK51gzyVTzFQ37/nQ3Z9VHLUVAVmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hLyRhUpg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hLyRhUpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA5CC4CED0;
	Fri, 13 Dec 2024 18:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734114844;
	bh=c6QaCi+csUzrFKqJQeJC3Iz7NJnFz8biXkSovhI1qys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hLyRhUpgouUVhiR34XPcal6WlQi5HwA3ipGlNVvqgOjL8qPikY1YbrNTL6DOgIKYv
	 LMrtV2IKZ00rD1Z5j4xu+flrvf1m4GApKargcop1zjmlRyDUaRlNGW3C8Y5H7UBkHl
	 OMGmeQSrUco29YPYomRM9OG7yUOtp7r10Okw2mVXicT/EPZcMt5yzSnYpQzRz5oLHt
	 s5HaS418zTRP5fygbxfe8767dVduOkNnL/wl/LUhM3Ms+LYxP+56oNaKGdCMZdtxNq
	 /9BpanODXo1IHQf5ATswmEVPhbP/8BMaIth1BqkZWELvCYCBlho9ftPG3SJZLe7EoO
	 5HLEDRItDXX1w==
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
Subject: Re: [PATCH 5.15 000/565] 5.15.174-rc1 review
Date: Fri, 13 Dec 2024 10:34:00 -0800
Message-Id: <20241213183401.52726-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Thu, 12 Dec 2024 15:53:15 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 5.15.174 release.
> There are 565 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 8d1a4b85ba4b ("Linux 5.15.174-rc1")

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
