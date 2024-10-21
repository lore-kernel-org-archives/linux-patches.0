Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD3F1FA26B;
	Mon, 21 Oct 2024 18:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729534131; cv=none; b=uQIF1sjHi7u5w7PH/kbmFkwlV3XdgZlZ0HYPPi64/iGjcgkfkqPrjKAj/ZpgTAVzu8ir5YtoUPwf6zlDLR7JXRyiXAFVcasFO9AZMmhe+LMqzvOWaPcTzjV+QnCvmQDjwwM60hth2KcWXhcD+XRm6kUMs0gKbO9Mvso2vhk9zQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729534131; c=relaxed/simple;
	bh=yTh8hfc7ZsTY2rP3cPtemnpjC2eHCRsTxWmZ2yyByYw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D9XbPyldal/JlR3UBlkBKst+dlcDCymObsuXegz4yL6PCWn2wNCpUbfepimCqtS3MKyQjzqsAu4xPemb/Ctl8dl3vM24N7eQDHKAOP+oFIkWyF79lzt74rR1RPKAtdX0M/KjUbpGCtJNs5bqTFpNjajM5K0MryKWJsQlBL3MSM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qOIvnO6Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qOIvnO6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F145C4CEC3;
	Mon, 21 Oct 2024 18:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729534130;
	bh=yTh8hfc7ZsTY2rP3cPtemnpjC2eHCRsTxWmZ2yyByYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qOIvnO6ZPHGUOdw2RSidx6ElORYT5Ed0yNd1aC1M1Mz/B8er+2jGAGG4eYHSOQh9R
	 gT27FEQdFbWQG8doYV+9nLT8rcyj8izL83eUNqX0zZERBj5CUmCNmb/kN7XXGSn3DK
	 R+K/TSl28TJU67dc+T9vtaqXJkp/nupFjn21vX0LpQAwgKQuSiamw5DciksnS+zQ83
	 Lio8X6jeB/Wsyy9vQl1br+YIpXDOBWij3kcOH/qq0iXRp6UB2cC2K+FN7cAaTEhiD9
	 Jiw9KI8hsBufndlWMEgJOLKw6/oOmj1rpzZ/aC4cA5yGuyacX/ScyDlx/pZKbiOqui
	 0iPTam7NZu83w==
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
Subject: Re: [PATCH 6.6 000/124] 6.6.58-rc1 review
Date: Mon, 21 Oct 2024 11:08:47 -0700
Message-Id: <20241021180847.15025-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Mon, 21 Oct 2024 12:23:24 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.6.58 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.58-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 6cb44f821fff ("Linux 6.6.58-rc1")

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
