Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80323146593;
	Wed, 20 Nov 2024 17:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732122073; cv=none; b=IGB7TXDSDMSGhsn6yaTLpLnZMTA/sVg3jrgthGR49cZXpswHYa6I7+qOC2GMEolRPdruGyVn/EvJ6hSBun67BYh1cNE+SbZsKCrEP/75jrEW/NyNQXjxsrtfOcfdA9vT9xeA+ECbijf99eKFoniNUiAH62WfZ/h3tXwtN2yfEt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732122073; c=relaxed/simple;
	bh=Yd5y9TAqwXW3wuS/C2vKft6znlgb5goQ9UaHAHJ2e2c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X1B0LL/DY4AkYdNFNjACIw4wOi8xyDXMQjNLAHsBL373ONkw1L5kifui/7IjqU7QE0g4bDHHMCtq3EdJ+WLY5pF17FnJVRZoQGRS8fYuLQMMMLEoy/48sAAUJw9mlJ1FQfZxkyGBrF3rAKbsZQlQZaTScQKGTWxYMjwDXZMrUAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cVW90Z/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cVW90Z/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93BCC4CECD;
	Wed, 20 Nov 2024 17:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732122073;
	bh=Yd5y9TAqwXW3wuS/C2vKft6znlgb5goQ9UaHAHJ2e2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cVW90Z/TPrLPPd+7wyWG7tpIGLozX/SyP4F/bOBm/vBzIbkNQ5SgbnunOeDUMvavV
	 JG/ekmYn6Edh/j8rDfmfVih9PlkS+l0+iCanUSw6vs6ByS7SAjJaNwGRuFd5g4ZTA6
	 +FFszA9egDZwJEKjR3bhyTlOZngNuoNnQS491dttMnUUb4xJ/6Hlm1nl8Inzmmh3+X
	 NSPJYDFYqVTbKwtoC5OL9bDyQCHjzKr9L3D+vmmUcPdo6wX91bKUFe8LRSikVQhQO/
	 VIgwYe7EnVP7x/OUdrINgYXexb/fRGgAMsloMJj8spg6owSNIdTwGOvIrmMpHvMbS9
	 Nl6ejX6moncpw==
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
Subject: Re: [PATCH 6.1 00/73] 6.1.119-rc1 review
Date: Wed, 20 Nov 2024 09:01:05 -0800
Message-Id: <20241120170105.69369-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Wed, 20 Nov 2024 13:57:46 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.119 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Nov 2024 12:57:58 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 43ca6897c30a ("Linux 6.1.119-rc1")

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
