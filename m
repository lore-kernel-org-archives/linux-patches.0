Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C99F1EB9EF;
	Mon, 21 Oct 2024 18:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729534176; cv=none; b=fS1IKkCRWaAgRMDAw9+spH2hkZ6yunjSGWNMJYiL9EqzB8vEVDFNHAM8C7KYcFBejze7pofw4+yWFi8UqEr/xxyxTb0pCSpTN0ePezadZWS4wF2XpH75IbL0xPLnx9SY+Hh3UtggvVxfjdoJ9pr6wQ+3bWL5+Lwu9rEOXQskamo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729534176; c=relaxed/simple;
	bh=LC0A/Rdjec5aDSJht41Id9IaHLYV+tuUkNDUK8OL93s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OOawYbtghBga6AKdQZQjyIwtAH9krUpUaHECoM3ZYDPsP7D95+gquIfvcAMCImfnoELpJYhP6FupoXsa29a+DT3geyxZX9jQ4JjYIsCSe7Rx+AW1l6bRnqjFIDqoe6rKBjLqFrVfrmOQ/aJPrKafJdbEn85TA1vxJe+qK698M/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fJrVradM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fJrVradM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C798C4CEC3;
	Mon, 21 Oct 2024 18:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729534176;
	bh=LC0A/Rdjec5aDSJht41Id9IaHLYV+tuUkNDUK8OL93s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJrVradMxURiouC+jgE/SGFb2gIoiG4mvYFoZ8W5cwMHNdUmON4B2caiRjaA7Pc/i
	 UtWfklugQZydjf5fVb5Xa0uy5yD++79KuiCBJaFbqB73ECEJTvHOkR6/xTfxkbNFp0
	 NZewGc/TD7ICjHDwbtHVctz2jGV9JHcpD93Ojiu2PWttwgyRtTjMtjStSeQ2RwzZu2
	 aDm1yp3WDPzGTJfGsgCEl5t5PGsfnIeBt5mmU5l/evrLN/osbZcP3MzMHdtTshtgUC
	 rHDN7rcq6U4vO2Ys28sgGY8u55sZE8FURd7gBSAtyQ2LxMQmR6gyHM/cBcydUitckN
	 l3+XQnTzO/04A==
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
Subject: Re: [PATCH 6.11 000/135] 6.11.5-rc1 review
Date: Mon, 21 Oct 2024 11:09:32 -0700
Message-Id: <20241021180932.15092-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Mon, 21 Oct 2024 12:22:36 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.11.5 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 96563e3507d7 ("Linux 6.11.5-rc1")

Thanks,
SJ

[...]

---

ok 9 selftests: damon: damos_tried_regions.py
ok 10 selftests: damon: damon_nr_regions.py
ok 11 selftests: damon: reclaim.sh
ok 12 selftests: damon: lru_sort.sh
ok 13 selftests: damon: debugfs_empty_targets.sh
ok 14 selftests: damon: debugfs_huge_count_read_write.sh
ok 15 selftests: damon: debugfs_duplicate_context_creation.sh
ok 16 selftests: damon: debugfs_rm_non_contexts.sh
ok 17 selftests: damon: debugfs_target_ids_read_before_terminate_race.sh
ok 18 selftests: damon: debugfs_target_ids_pid_leak.sh
ok 19 selftests: damon: sysfs_update_removed_scheme_dir.sh
ok 20 selftests: damon: sysfs_update_schemes_tried_regions_hang.py
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
