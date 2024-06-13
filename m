Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F7663A5;
	Thu, 13 Jun 2024 16:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718297335; cv=none; b=rrFuzyN3sr58D29m7+afhlhTneDAcLDOH66Dr9fqb342Y35PmRIVRhW/2WgN9Dyn0PpZ6F/THlcp2FL6msvckYK20WnLRY3juzmHrgv/e+Z9RPTCjiD9floW7qDOE1VD/SzjHKr9X1GQb0sg41QGj+okMRt7tx3GUGzZjxhtpbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718297335; c=relaxed/simple;
	bh=jGUmh0q+O6SqbqP06gP9IPUhfXRnEQrElPzOhbWDQXg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pRrTQqYDln1JcY0wHjvwJ6QYQLs1s/uwMjV4HAwHhM85ubw75oKqQ34qWs5o6LsN+vSsEhucqwTpiukX5gxyKD/vhUCUzeDsOlA5qLhoDximZmTbq1NzeN7QYPKw0wXpC5Or8t4lBCi2wJu3pxh0SmYuXUiO1sXPsdeDrQWOy8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JDpjmoDc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JDpjmoDc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F894C2BBFC;
	Thu, 13 Jun 2024 16:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718297335;
	bh=jGUmh0q+O6SqbqP06gP9IPUhfXRnEQrElPzOhbWDQXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDpjmoDcHPTLMf3kH/tGvozc1smvMoObwiBot8JIY3wost135Mksl8N5t8ZOlacME
	 9I975IBLmm+qV2RQj14K49M2sfUXUzMEdw9thNMO5ZUFKgS5m0XcYEabCy16T0Cb62
	 tV+6n832rDilw2FuDnSKzaY6p7vDDBgeNg+/2hCrQkghQKMXXrOAob1yxMj4VWAOSi
	 LG7xYHQEie/N4nBC7HSLkTI2jMA0jaPZ9j/ElN3MF+CYMeBHnf3L4euCVMl9O/BE0y
	 ZopniMDHKDgvUzUwGllBzKHBbcUUd3k8tLEaPPrSvRP1BeJz1Xlqp5AIUcgO/o8Xpr
	 63KjOHjQOBlCg==
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
Subject: Re: [PATCH 5.15 000/402] 5.15.161-rc1 review
Date: Thu, 13 Jun 2024 09:48:50 -0700
Message-Id: <20240613164850.84793-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Thu, 13 Jun 2024 13:29:17 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 5.15.161 release.
> There are 402 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.161-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] 892374ff1e8d ("Linux 5.15.161-rc1")

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
ok 11 selftests: damon-tests: build_arm64.sh
ok 12 selftests: damon-tests: build_m68k.sh
ok 13 selftests: damon-tests: build_i386_idle_flag.sh
ok 14 selftests: damon-tests: build_i386_highpte.sh
ok 15 selftests: damon-tests: build_nomemcg.sh
 [33m
 [92mPASS [39m
