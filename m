Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CE016D4DE;
	Wed, 31 Jul 2024 22:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722465636; cv=none; b=Q2xXLVn8ksxESfifAEsuu2e0LYC3IKT50WjBbfSAPcAptRwMsHtiqaYydI2zKvpEnK7n0HXj21wO4FenRWHh9I+Vb4qutoYp9qI0OCBzE9qZeqkMIRQhrYkkmmZ7EzbOs3P6ophRqhb1SAgtoNCmnkwDOu1LBtvsftWAKqgCmjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722465636; c=relaxed/simple;
	bh=tETh/Vi+zu7QxmeEC8V1A7sujbIPE5A3qowdiWZFMAI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SGVS0YMxYZh6CgmdUK60KSuTz/I/fW+kDhrNyQrvTG0gJmL7bLK9Jismv69ENoVU/h33HvMZHlvLSECENWRLXDf5ki4IB0W7kzCNx7UJe92AiomqgHzZ6G6Rn3JMUqxX0XwhYWDEnxCU2+H7yI45I5UQnLJPvM0by0oMLAMTavs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PL8kEFJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PL8kEFJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0C1C116B1;
	Wed, 31 Jul 2024 22:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722465636;
	bh=tETh/Vi+zu7QxmeEC8V1A7sujbIPE5A3qowdiWZFMAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PL8kEFJUwuKDQ96sVz+7vf2ksowpTkoFYV+yVS9QjA9oNKxIOf/6frotb6tnoWpun
	 4k9o3DRE7j+SMXqK5JzRTIS9LHV2sEiqvbxqdy7ZvvsUyPdCCyA66XB5LCGKv3bkDX
	 ZdZwrozaMUB3i33hU6jPz8JREYhnUR7xDl08BIzDGWCqi3X5EggyZTKV6frumtv4I3
	 5IePQzVuyA4kgaxmV19SY97cOuQALXDCz9JIGBY4azGGPupjd87G2yTiu0PfUidN8Z
	 iImaeUiqqMiQLggEZO6a2cqq+oxn20PE+j/2J/d9vL6GTtV1INzypIDIca0q1e+KCk
	 5f8Kb+f/l/F+Q==
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
Subject: Re: [PATCH 6.6 000/568] 6.6.44-rc1 review
Date: Wed, 31 Jul 2024 15:40:31 -0700
Message-Id: <20240731224031.55620-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Tue, 30 Jul 2024 17:41:47 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.6.44 release.
> There are 568 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 Aug 2024 15:14:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.44-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] 7d0be44d622f ("Linux 6.6.44-rc1")

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
ok 11 selftests: damon-tests: build_arm64.sh
ok 12 selftests: damon-tests: build_m68k.sh
ok 13 selftests: damon-tests: build_i386_idle_flag.sh
ok 14 selftests: damon-tests: build_i386_highpte.sh
ok 15 selftests: damon-tests: build_nomemcg.sh
 [33m
 [92mPASS [39m
