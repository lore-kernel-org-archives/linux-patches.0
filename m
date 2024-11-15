Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77051D63E1;
	Fri, 15 Nov 2024 18:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731695218; cv=none; b=ICKYnT7cu+/MZJihi4a0TPzGLB6yPbNAgiqjHcSnsMyvTVBh+Ut/D9e2rp7MEYdy1iZEtl6eBJEWJ1Krp0kXseNhu0N4id5I5fVRyj9pbb7zojjW4MSAR09AsspZPSQwwM+I/RYlCNKd5ez0teJzYuar2wNAChfY8d6pnsaPw+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731695218; c=relaxed/simple;
	bh=+VByZUT0/Vv1iSWKSAmQN0bHl+ivMh6EO15rgkyroMc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kRYOVg6sIPbTNRp/CAZdqDqj0SD8vl0FIvPWN2NdAAYGmDuO9/yvFapzdxJZlCkIOaryHO4daco50sUqJOfhQJJ/YM2JblhULvpQvZcUMAHO2SNtqSl1qRn97yNh8zQwRbYM8UCEf08Gu3IHNvfO/oSiTqpKhDqhWBXOm/Fpht8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ek4+vuR3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ek4+vuR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170AEC4CECF;
	Fri, 15 Nov 2024 18:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731695217;
	bh=+VByZUT0/Vv1iSWKSAmQN0bHl+ivMh6EO15rgkyroMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ek4+vuR33dmd6/O+kyr7uXywFFqcP55z+6f/TJD3YZXQy1WzCeR5nYcFeDaGsOTr5
	 vGJWNEXSjFhjJtOL3KSY87na35FNWJ2bFnHh03LVXSu8RRIR7pfTato1PU/PySbtHA
	 9XQm7xB1yVkT05Pdr8VQgidMvwW53ZCBiEVF6oYw1MXxJpXc/GNkQD/0Oofj6wRgJk
	 gcHND1OmpHd4e5cVGbZov1okuPXKKYsicZBW2Pmh2/SBWspeqtQrlPHp49aU4jz/Zz
	 QbOXIHJA/XcbM5qP7FuxyRaTnsq8JdqUAZNmy9vi9mNENIFRt3qirHrJCwSfGYVHe3
	 wijhYOdRkf8Fw==
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
Subject: Re: [PATCH 6.6 00/48] 6.6.62-rc1 review
Date: Fri, 15 Nov 2024 10:26:54 -0800
Message-Id: <20241115182654.44082-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Fri, 15 Nov 2024 07:37:49 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.6.62 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 68a649492c1f ("Linux 6.6.62-rc1")

Thanks,
SJ

[...]

---

 [32m
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
_remote_run_corr.sh SUCCESS
