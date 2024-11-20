Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B01146593;
	Wed, 20 Nov 2024 17:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732122137; cv=none; b=agyTipXW1gzeLKlHL6mW5jpRkmwMxNIXW+FKQJTpB2SIswRUd5VED0G3yQ3m/yPO6ybstHotq1uhi/ibq1DTxVdbW9U5aUO1c0xY4IxG7xhF3X3EfCaO5SufHCZcBgvOGMbtBMc5WRhxw1j2c9/DnFyMesq1wDPfwuKqz4qW0wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732122137; c=relaxed/simple;
	bh=rPj7c6XkgTyMaLeDFKMtm3WS5U51tHxoI8+nJxdf5ag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IQxn6ZE3EBwLqSqthKj97epHNko9A3m3AKlia+VucHzNnlxTvpgVSttM/mBFsWOaqB8TP9cF22xk2sHj5mVLZwaGLfi9hoj/8ojVwJllTEioac50noGpEDxPTCddKQ1E9g7maUc4s/7E2q4UWqiJ7g4GVqixyI1DUiNaGaQCLA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZAxrkwWs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZAxrkwWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6B8C4CECD;
	Wed, 20 Nov 2024 17:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732122134;
	bh=rPj7c6XkgTyMaLeDFKMtm3WS5U51tHxoI8+nJxdf5ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZAxrkwWsX50W7OrSqe3iRMKC5QGNrPOuCVAxqrthBXHm3O+OoQ75vPH1RlQjVGheZ
	 O4eozhDoZU8NbYwxKU0B/vzZmXohyESVJ46KyvqsYYcYR6FjeGEydUCLY2gL6ALwtU
	 n2dtEw/KBb4pCQpdUzYThhzgtYu/lTKT4q3KUdj56ZmRg8G45Y07vu3jmKFwPTQaNk
	 097SIcL1ETsmhmtuaTD5qTgvNCK2BSyccFU2oi8taAPGkcxHrOZ9icFswQwh8uf4SM
	 IC+rsWJCndK4kPeD/6n5OWdrkbPhoUQrDgnybVQ+yrmOhIF1wYKYegPiVdReIFugtn
	 z+aw9+e0yHPGQ==
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
Subject: Re: [PATCH 6.6 00/82] 6.6.63-rc1 review
Date: Wed, 20 Nov 2024 09:02:11 -0800
Message-Id: <20241120170211.69434-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Wed, 20 Nov 2024 13:56:10 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.6.63 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Nov 2024 12:56:17 +0000.
> Anything received after that time might be too late.


This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 2c6a63e3d044 ("Linux 6.6.63-rc1")

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
ok 11 selftests: damon-tests: build_arm64.sh # SKIP
ok 12 selftests: damon-tests: build_m68k.sh # SKIP
ok 13 selftests: damon-tests: build_i386_idle_flag.sh
ok 14 selftests: damon-tests: build_i386_highpte.sh
ok 15 selftests: damon-tests: build_nomemcg.sh
 [33m
 [92mPASS [39m
