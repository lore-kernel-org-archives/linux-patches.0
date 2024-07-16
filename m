Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66BC1A0727;
	Tue, 16 Jul 2024 18:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721155151; cv=none; b=pWow89RxIovZ0DZoX5xeMzSNVpB9P7bn6RsGOcwjYc0eb5jnAnPfBYhtyE65Y0rnQ5amz+ptmsjhWc3RemcNcTIQYP9LNHn0jsiz0biNgKII7sjo/Hf4khqy79ISej4G5gVtx87CZjeXcvNaVX+p+cOPIXbe9cjqSdYo6zlO8XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721155151; c=relaxed/simple;
	bh=BiPImUtB6qk98ZWfX+0Bxu/M4b5XvqdxrGBLvNJa9o8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Rgehd7ln5fEpxjmidIhkzI9u7C/giqAjjVdDx7G+7tUQWpKVzy2cZqnOB5ivybX8i7H2u3cM/yhGCeDepUg8tlL8pXK8RL34sllutziPKQ4BkNX/Rur0Ezn3mhfmv06ndzBo+9auF64A8uuOwLqhupXa6qjX9fdpLDHGco6IdY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=acZcXplB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="acZcXplB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215C9C116B1;
	Tue, 16 Jul 2024 18:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721155151;
	bh=BiPImUtB6qk98ZWfX+0Bxu/M4b5XvqdxrGBLvNJa9o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=acZcXplBdILFl4JHXIHDtm9Pf0KauPCeP8nZ3kvXApMirkmRq6LePQDZTOxbX4AIz
	 YVhJCeWchCvuQpPsLFI/ahbkudmjc6xGWFeJl0RBIftSQJqtYomHmCwQbhCGMCRjKg
	 Xtad8YGY2jFE5TAl6Q/7c0iaJS5O2UAeTVpW3EUIAjIYp8EBSpYkZ6gS0w1A0KHYIT
	 wJSBqFRVWkDRyJYs9XqONGfiC6IG1Lac/euusSTebwbXoNJ784P8chu/VoeDLUXiOZ
	 jz4vufXo/N0I8hyneTtFoEW152nB2VFBetzxF3CQDwHvyyjvz9rwSg0K2Rjy7yD7wl
	 EcJ4rr/fNyGdw==
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
Subject: Re: [PATCH 5.15 000/144] 5.15.163-rc1 review
Date: Tue, 16 Jul 2024 11:39:07 -0700
Message-Id: <20240716183907.138625-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Tue, 16 Jul 2024 17:31:09 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 5.15.163 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.163-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] b9a293390e62 ("Linux 5.15.163-rc1")

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
