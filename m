Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8664A1514DC;
	Tue,  2 Jul 2024 19:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719947889; cv=none; b=Z0ZSLsslNXFD4+2tFB4N6plIJWIIdP0vSLDoDHttnV3qe6GT5gVCfuunmyCu8Hma6luJ7RurfISqlTHRfiT06DXovBmdHX/bISONQ2mOiQuSNQ+wpF8hDaA4loZ+2BBHkS1evydnGRrflcrqcWc56suRxeW/90I4zKdJAWIV/fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719947889; c=relaxed/simple;
	bh=xd/DF0+Gmml8wqZbl8HrFxX/XgUfPC57AW2BJIJfTXY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xlu66eW1uYcbhV4bqMkslCNa4hN9iI7g1XPAtRNew9FsahN+z6jhQk3+lodYy30ZOC7ug1HLvqG1bHxb165253VLMRmAnd1AIH/lq6fKoYSiSQecogeP69d3SU2zBUZZdANaJGGGDdwxgDgXj5YSJEE/0fdoMe4aRW5bQT8tcc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bqq7tp5+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bqq7tp5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95910C116B1;
	Tue,  2 Jul 2024 19:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719947889;
	bh=xd/DF0+Gmml8wqZbl8HrFxX/XgUfPC57AW2BJIJfTXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bqq7tp5+hTMiyNGbgSMgQ99TOX6fR/z/muDMhS47Fi1dhftU0tmbkDaEEaFHAvZXz
	 mdNw8t485NLwPbQr2YpPSTFz7OiC6y710mTHr6YVdXO9NGXkKqS/r0tz3b2p+V1jyl
	 IdlI0XdDF7BGCcoxGEe9nmFDptDR0Lo6HfTS9quvcp+zkLcXVT8dsOI5apTFcJTRFS
	 phjwIfQSm9hZAIqIQyJZACpJuh2E9Qdz/b2J9AhqgLZlnOwyVx9CtunBEz1cueGYd1
	 lYh8MVFJ/+fmprUw7aV4CVYoYZ0Oc4f9BPD3gGUHBlBdslsyUza4iTqaw3iaMbRvfp
	 6cGIBp7ep8MDg==
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
Subject: Re: [PATCH 6.1 000/128] 6.1.97-rc1 review
Date: Tue,  2 Jul 2024 12:18:05 -0700
Message-Id: <20240702191805.70782-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Tue,  2 Jul 2024 19:03:21 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.97 release.
> There are 128 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Jul 2024 17:01:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.97-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] 54f35067ea4e ("Linux 6.1.97-rc1")

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
ok 11 selftests: damon-tests: build_arm64.sh
ok 12 selftests: damon-tests: build_m68k.sh
ok 13 selftests: damon-tests: build_i386_idle_flag.sh
ok 14 selftests: damon-tests: build_i386_highpte.sh
ok 15 selftests: damon-tests: build_nomemcg.sh
 [33m
 [92mPASS [39m
