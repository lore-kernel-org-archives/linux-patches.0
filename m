Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FE11684AE;
	Mon, 28 Oct 2024 17:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730137879; cv=none; b=eFJsMxuvn2V99FSj6wqLqgyh7VTNfFGk2vm0YGVgBerKa1gVfC58b9k3UO2vXE4BChn1hx67B1fCvgN8tsg+43Se/iuf2ISblpxDdtA7i+KYW2BBnYgH0F1q3sImJgGq+n3n8LFpYZlGo4Qw4KBCPcprVYDNEvkXPVwPjJ2UREw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730137879; c=relaxed/simple;
	bh=5HD5Ix6tLSJ+qpTg2awD/o+27qZNnx+O0H0sCXd3MWA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WZY2G9Tqo1noWL3DU1DoMhA5iVmeVKxqsOevpJJ5pfDfAKeDXs8BBFerbhSg2fHErFmUh73sQwNmOeaKWrSfHOTvnkuLnDAgiFhXyrOHzYZq302ovrNNgqWH1Nk1TMs8xcQtWVv92MfIdziMG08hgIFLgaPbg2Q9zn2WpC1Ljy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RPdfcLMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RPdfcLMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8FCC4CEC7;
	Mon, 28 Oct 2024 17:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730137878;
	bh=5HD5Ix6tLSJ+qpTg2awD/o+27qZNnx+O0H0sCXd3MWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RPdfcLMyJZyxPVYT4g7escX2GY+taYl5pAgCdpf8OUu9Tc5+2D/TDn9ey7UK14igv
	 k/nZeiIPCBMz49v49C4gZdsIcEINxOEzGFInaioIgnqhDr64QzhOY14ZeptXqp2K5I
	 fyXmYqRHzG7lanQivcXToDMclUHkxRWXORTBGWmRJct0Mq+3l6bINebR0+sqtt9Hhs
	 HNPrhn48REUvcbOeqw73Nm/DU3za3iKirz0LVBtez25hvL7X4qKcJbjAyLpZpePp/h
	 tmavHMx/SNPPaA1qqBN/PbZxFnMimv6B6KqAJCKEArPD5t563KCTrUGJ/ZYwVBX5SL
	 R9AVWYsT5c2yg==
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
Subject: Re: [PATCH 6.6 000/208] 6.6.59-rc1 review
Date: Mon, 28 Oct 2024 10:51:15 -0700
Message-Id: <20241028175115.276722-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Mon, 28 Oct 2024 07:23:00 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.6.59 release.
> There are 208 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Oct 2024 06:22:39 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 02900c91433b ("Linux 6.6.59-rc1")

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
