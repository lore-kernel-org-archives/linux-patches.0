Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEC31E25F6;
	Fri, 13 Dec 2024 18:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734114941; cv=none; b=kkfAEV5Xjc/ZIZrNm5HA7RwpYBd4F8qN8uLL63p7n3AyZ0K2y8xK+M4BqTE5T4IvIAYaNcpAB6gkddu8h0xpOOXb0O63ZrdpT5SCYmZLutqrIf5B78mI7y9v+5GcIC5EUcnJYxyw+flgF4TmePSMU26LPljABfau8VrpSakdkj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734114941; c=relaxed/simple;
	bh=SmYsLGI/Atq0ZcsU5+KYisl+ABkTAvpIEsNZZVJ/cv0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X5WeOv2dn9sISJHw0Ivhmr0ersA/jjv2qt1NUeKNFPrFxH73Ak8ynsseXuoWvetiVDTuIgpPO8x1RSOAnh8Jbu/FWY8/cLd2RyM5d7WZ0TxHsmDfN3aEDM71BGzqdKlvdIpzQ2Xz11sBKuai+4eU3afi3YgZZfgsMzUf6iNC3CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B41d1/SR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B41d1/SR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD947C4CED0;
	Fri, 13 Dec 2024 18:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734114941;
	bh=SmYsLGI/Atq0ZcsU5+KYisl+ABkTAvpIEsNZZVJ/cv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B41d1/SRQXJ0zt9tlKYCPv/+rQ1mIa4aa4DO0OFSh+8ex6ol1/x8Ef6O2WNbeBE5/
	 uYJDR/h807EX+09+6VeYDdU2GjVC7rrOTwDQ2o/loVsXcASdKICg/6mo5fyJxlDh8q
	 9DdU65jY9IdBjRqPruijsOxYQQCJqM506amNG5UrOMHRuye3rvceUqISGFdIFU8Mbz
	 Xww6rksxsrWmXeWEGtM1a+WsZ0hivdZDuBCw7GJFFJiQPNzopt84rrYJhcTmdfpwD3
	 XJbs/UTtJv6yGrUy4/7pGMc3EGftPci4lUpYxm6GMX3XkHUGYJyIhNM6qdUA/a8U7r
	 ps3wshrC2/3/w==
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
Subject: Re: [PATCH 6.1 000/772] 6.1.120-rc1 review
Date: Fri, 13 Dec 2024 10:35:38 -0800
Message-Id: <20241213183538.52793-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Thu, 12 Dec 2024 15:49:05 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.120 release.
> There are 772 patches in this series, all will be posted as a response
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
[2] e4aa4e0f93a4 ("Linux 6.1.120-rc1")

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
