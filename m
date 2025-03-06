Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2659224EA;
	Thu,  6 Mar 2025 01:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741223381; cv=none; b=DyFdPjET9CbD9fFr23GGwixOmTMcNkJp9NfeSM1f+IqltOf7yDvVfTgo61kadUeb9ODdjLQSbA3CbOrjqcWhYinjxJs/rkm4pm5JEeBHcLKgsrHVpapWpUyMODzGmm9FJcRNLN07duCGkskRGkG6VbOvjy4VUZWaSC0q+G6Bmb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741223381; c=relaxed/simple;
	bh=b2O3intjjzzHZVCLA/WUqLy+RaAc48GwCL3MWthLRUE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hA8jyCPKkMgSKhaMqZlqlPI3bYHAWh4LtQWnQUs9vqhLHfp7QhuONpy9qZ7CujzMvX/Q1kf37yJduyfBurbtsIkjg3rXy9eXPOEXhb070atCiLrrKClsGDwzK/IabEAWWJiG1Lye5kefRSmMvdk7rPT/n8yXtK5lj9hFdyEPXZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KEkJMk2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KEkJMk2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D49C4CED1;
	Thu,  6 Mar 2025 01:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741223380;
	bh=b2O3intjjzzHZVCLA/WUqLy+RaAc48GwCL3MWthLRUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KEkJMk2SNS7jI+zACEr7gu9d7PzymrprIWw9h8HfyFBOMA8/CLfAusRait9kUzmWP
	 Z9xpttwLdMHjeTxVVkIc8mX8onz/xPj+AW6bnCJmK9CnOvj2dp6OIsg6C3OOOLJ3Kl
	 wpZLYk8U15P72P30vwUGzAmaBG2N0yM/ZUcGiHMqtn+CNvno/zUtay0diGu7NT0mtd
	 To+dgMHhb7YR1PLiE1fRLjXYemLLELgbrtKGpkmRfRmtRDmI8e3Yzy4A5+LmoaTLZ4
	 oJ0v//RW/jKl46UpLLHgWLDazZCoBZlIgYfeXuKWRVrcYEqlE3z8d1g0hOUyxYz19Q
	 ZpFSQOWpBH4Xw==
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
Subject: Re: [PATCH 6.1 000/176] 6.1.130-rc1 review
Date: Wed,  5 Mar 2025 17:09:38 -0800
Message-Id: <20250306010938.138792-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Wed,  5 Mar 2025 18:46:09 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.130 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Mar 2025 17:44:26 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 34da6dd4fda1 ("Linux 6.1.130-rc1")

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
ok 11 selftests: damon-tests: build_arm64.sh # SKIP
ok 12 selftests: damon-tests: build_m68k.sh # SKIP
ok 13 selftests: damon-tests: build_i386_idle_flag.sh
ok 14 selftests: damon-tests: build_i386_highpte.sh
ok 15 selftests: damon-tests: build_nomemcg.sh
 [33m
 [92mPASS [39m
