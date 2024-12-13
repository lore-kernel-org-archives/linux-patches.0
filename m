Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC8F1F0E49;
	Fri, 13 Dec 2024 18:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734115907; cv=none; b=mU4fK6YCXBYIg+pNHGMWlBub7aiCOK0lLtBbVc4jD5B6KMbVj8V+NMmkYSt4qGUnJ89HR+ABdvxZU0swAgUG8JDm5vQm68+tJlbgHd3bNQKWD8VaoYNYH2aLd8UpkraWS3ZnlAInyBgoSlfwgYrIbCOGIpG7Nzgheo+tBm7Wdc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734115907; c=relaxed/simple;
	bh=59OYE5q9HFeoUIi07rjUbERHMTkLNvPvl5iRmcBjoHE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RRaXgCD3TUN9ozPpy48ki43MjlSARUyH3PxTj02YHJOgweR6zW/gtwcoithw/CuSHFq7ZCrFFAOyWjM2HP6LyXqlE+NMxuadJbJ1QfIieEuWksDclpZQYUbsgpdWjuO4/YNn+1ZBmDEljrPuuo6zvGzBAHK6lQjK6iNojc7YrHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MFjz78qG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MFjz78qG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572BCC4CED6;
	Fri, 13 Dec 2024 18:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734115906;
	bh=59OYE5q9HFeoUIi07rjUbERHMTkLNvPvl5iRmcBjoHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MFjz78qGB6ywQFhT4LQQtIeB02YUtNcTHh0IFCkHuHw/lPiFxpG+gdexK/5JwdFLY
	 4Oi45jQKEnnbo5DCY5ILmYuGKDx7Zlgorz47MfG90pZNTUNMe4QSE2sYHdtF5Bfe7E
	 e/nWY3w45mN6xAr6J9npMmAGEo+K/ukGLX4InMq+1vOOYB8U+acnmcHKSWvdv0XtuO
	 u9f1Oc6+Avdj3JA0ZGSZkRJxk3DVL0ThYLmv4/quiaBDn1QVfcDmW9hVmWTZUB4VLQ
	 PvrE9HRJM5Oj+rwNcdDeGuygXfVqYOqdTuaAxRj3HeQL+9BgfLpxBBBJcIP4idvrRC
	 h3En4876gYqxQ==
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
Subject: Re: [PATCH 6.6 000/356] 6.6.66-rc1 review
Date: Fri, 13 Dec 2024 10:51:43 -0800
Message-Id: <20241213185143.52946-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Thu, 12 Dec 2024 15:55:19 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.6.66 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] f5d2f18aeac4 ("Linux 6.6.66-rc1")

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
