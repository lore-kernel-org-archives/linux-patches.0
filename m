Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28304F217;
	Mon,  1 Apr 2024 18:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711996079; cv=none; b=YjWrIo9+NWYQl0lfDt/ID7zqLmfIq1XF6wuIgkmMfIz3t8HFX1mQBrC1L11/FqHKSXB4G3Sl8X9HCmN3UTTb1A6/As7t9a1l52QKBoVfP/c7jG5nGMtKpe/0b0ABG7GerNJcpgFKDLVxQgOMpMBvn1bqY7wMhWJDAmWs3ard5x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711996079; c=relaxed/simple;
	bh=DkBLyz6Oe5n20gIwuNBPAgT3BIFjXbqfmn5T3bPA09g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bCJlq3E58SdcYM4SHajwzse4efS7TBbo+2HA9opyKd+XCYw9m0R+NXdWAeO3RVEXMycZeUiGAz39GL5SazDWDSd3hfBj25IW8AwZ/nGRoYj3dD4jLYC62md+rcyyuxzEg+WuodytCMVlbwELK2XRwgaJ4u14klfgRxk1DWGAcEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ax+tQejF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ax+tQejF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C3DC43390;
	Mon,  1 Apr 2024 18:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711996078;
	bh=DkBLyz6Oe5n20gIwuNBPAgT3BIFjXbqfmn5T3bPA09g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ax+tQejF+PzTjPyE12/U3pWTu6ul++RYSlG/+sH6cg7hb11XHAE4uVupkvCdUOBRW
	 UVTITjO2whnr21M8gZKXMaS0oJT8Pz9Dgt6u/OTSOrYY+EdZUYlbWjRWElG7tnLpP4
	 XU9QgpP4QMVf5DNXEP6r4Pd9pnYdGUNsKgjelh7zQWJuw3m8j6BulkE1e24AlN0/oO
	 MOtmZ+3HxmExoGPjEfUawkW3iG2UKgFGoSC5tsJyunmA/hsqqzzcsDY2d7F0gDisaE
	 VW79TSFNVwgktjZhLIiySq192Ovv0XL4uzpLUXWL92u5yBZAWg8ECpe7hd8dcxI3mJ
	 rxWD9gh1WXufw==
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
Subject: Re: [PATCH 6.6 000/396] 6.6.24-rc1 review
Date: Mon,  1 Apr 2024 11:27:54 -0700
Message-Id: <20240401182755.248908-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Mon,  1 Apr 2024 17:40:49 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.6.24 release.
> There are 396 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Apr 2024 15:24:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.24-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] 75a2533b74d0 ("Linux 6.6.24-rc1")

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
