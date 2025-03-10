Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A971C5D7E;
	Mon, 10 Mar 2025 19:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741633349; cv=none; b=QriVeqcZbhwxIcIeLp7dFBmaSiUTBEksJmr2wrJklSh5uYtob68kYJH6l5XDUrowPFtCqkaYWsFIdHxbrIPqFv7YpX+WxHZCRhNo74aY3/HfW1uFxJ285xslCiQ1fcFtgEnpUy7pcjtrCvMpBXzUMizhf3cQwd0IM05zCPSviYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741633349; c=relaxed/simple;
	bh=SAzuJmkET5y//wVeN3T/mcn3z3C5MvbGtRUGdoC6wRM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bDn2/fLcPYagdjf420EQKwZtD95fqIUxr+zjqyxzuTggUDbYuDMsy9JAUY8MYFrsEFmyyKPUFks6T3EBrt+IaGZuiLv+m+goqejUsICz7r+WfoJPslaF0xiqA2fNWjrHoWxpEK63g32UEgnkGVpk62N2TZO6LPEYvwAWru5oVyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L2KaZ/SY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L2KaZ/SY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F82C4CEE5;
	Mon, 10 Mar 2025 19:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741633348;
	bh=SAzuJmkET5y//wVeN3T/mcn3z3C5MvbGtRUGdoC6wRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2KaZ/SYRfSWYjb6tTNqtreMAk8GqM+bSKkxJuFtTH5IXj9kLxzcFI9q9gxiTfRBi
	 NjNjMdp7Vh6/S9/5vLvWt0eMOpspMdgX1TN7W2xgcu89MZ0Z5uzxCXEYV89faE08yi
	 HRQOU7W2qZL/yLjg2djf6fGs5JfEdYUR54u1qgry0q4XEvsJxDJnzb7SDuRLDRKDBr
	 Qo4iEfaqWGWgA9P/8rz+iFKQOwxVbk2mYVCFHp02lxen4DxNLziaIF1xi35c3Azdi9
	 jFfbhq6eGKkapVUvlJRrA+U4g/pVKVlWdCxWUAJBLOp6nx64bz/xJQ6dQn3H3ROkKg
	 QdYvUu9BuC4bg==
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
Subject: Re: [PATCH 6.1 000/109] 6.1.131-rc1 review
Date: Mon, 10 Mar 2025 12:02:25 -0700
Message-Id: <20250310190225.656424-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Mon, 10 Mar 2025 18:05:44 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.131 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 5ccfb4c1075f ("Linux 6.1.131-rc1")

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
