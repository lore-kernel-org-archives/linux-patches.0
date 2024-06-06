Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1662AD33;
	Thu,  6 Jun 2024 17:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717696440; cv=none; b=BncuH8F8xEO5kkmyH139cr6iGq0008xIx4YD4OGUiuyAWmdpOrS0QjgYXjW0uDss+fRWtoPB3noYXrsAjani5KMA7+7x1pbn7wukyxi3f4P/1QwO2+pqzGeOuC1f19Fc6AfCRZGW90YFEWUelTSDhQ4C8VybWHnZy5ygvfebsbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717696440; c=relaxed/simple;
	bh=O7AReRC5xb6JZGo0fKvZRg+gKqrOFRU8cs6WipK538k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Tkila+Xpkp8B5H2Uf8hVCf7LmSiQpi7iisNlHV5Qce5O9IZgsmIrUORVoerFo4dLZPc/Gn2SeKAX2FqqT9zVyoal4iHSCqOcFW/haHqLQeNBqwVnAg3aIR7Z0FRVXWMtSyX2c+Q9GB6HQMo05HnjBVZkvTagP6W2m8go/Z9YA5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=khYK70Zh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="khYK70Zh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE80C2BD10;
	Thu,  6 Jun 2024 17:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717696440;
	bh=O7AReRC5xb6JZGo0fKvZRg+gKqrOFRU8cs6WipK538k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=khYK70ZhfHncLIi8h9FJCvwilqFJGD+YB9tkbGVHnfny+Zxa1twT1XXUJnh1ydzJc
	 WnfU0MaiH+xBA4V09zRbQ8lLA9OEBebLo6qZMtvooVQPb5SdcDkCbtVktBfLtIzeK5
	 gGtf7tp2zhSTi6JxikSCr8Ie9GoudEvH5HK9KP+zuAotNudS8sSoDZ1SPLPPOReMII
	 J5HeG1EYa3+uPdM/6ZkVQL8mBjTysQg/8m4dLv7jkIsqynrxww46IykWaolmsFndnd
	 j5neZW5oCQz+Lx/CgSm9K7eU5CF1hcX6sqQx4KKJDxD5Lnn4la0N62atyYqqfJ61hm
	 LMVp4qIZSvyfA==
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
Subject: Re: [PATCH 6.9 000/374] 6.9.4-rc1 review
Date: Thu,  6 Jun 2024 10:53:56 -0700
Message-Id: <20240606175356.20487-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Thu,  6 Jun 2024 15:59:39 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.9.4 release.
> There are 374 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Jun 2024 13:15:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] fcbdac56b0ae ("Linux 6.9.4-rc1")

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
