Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BB1111AA;
	Tue, 13 Feb 2024 19:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707851042; cv=none; b=FI5dw/JwsRohWskd2woeqqA+AwK0JAV+W533GtIM69KcdiquKf/oq7gK00lkjMJYT3MVNDw2LNgAOm8qlx81crmKBZdj6cYvAuLH8DFVX59irA6WNehD5QCnsDQCFsdBehFYYJMCNhGxIyRLNLczo1Y2eScX9k7weSdm5bnGIso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707851042; c=relaxed/simple;
	bh=V6arCQrvT/pMJXuR7qe0SWBGFzBArn264Uo53SqlZjY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=vFUK4+nwgmSZqGu6y5tT88Q4JnU7EVsAMSsX7guZbNOpQkefAJRebM1IeHuTZeb0sEQaNSxFfKT8SHt2YMqNgubb89DdcIxJnfnZ7dtNNKTHkofjN5pK227xFYd22sFplku4nWvW4VIeXZe13z9w6Ou+i1AZ8JWq0dS1c/S58Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kcIfovi6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kcIfovi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2E0C433F1;
	Tue, 13 Feb 2024 19:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707851041;
	bh=V6arCQrvT/pMJXuR7qe0SWBGFzBArn264Uo53SqlZjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kcIfovi6yUODRgelIpmlTiR2ePF6UjtetIBqBRUBlpt6VJfHEazmBIAjll0Echzwy
	 aVTp6flZ1XdEZGZZzqRuO6M36LCSgrs1qmMKf/ibf5UPdEG+pJY4W+y2EJKZ9YM9vU
	 BNbm7HhOZ1OOyLBvqQ6Y3j1if3NZfW7pHRltTowcIi6oppsDtafSx23I4p7hxCCdHB
	 hAYiM+7QasIsWSjYLcaiG4+nL9rSJ0JgbpIvvWvqUlc2Cn1uXTEWNPbNqDHLOUB4b2
	 R7Edp5ml2CBci/kTTZkXDL8Gyad3RovX4wdbgTSPwP18uqhrGRebgQuTXBGzuJ0Sxv
	 LI9AeSPhmKWSQ==
From: SeongJae Park <sj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org,
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
	damon@lists.linux.dev,
	SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH 6.1 00/64] 6.1.78-rc1 review
Date: Tue, 13 Feb 2024 11:03:58 -0800
Message-Id: <20240213190358.1977-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Tue, 13 Feb 2024 18:20:46 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.78 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Feb 2024 17:18:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.78-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] b29c5b14893f ("Linux 6.1.78-rc1")

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
