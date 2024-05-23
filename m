Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2D86E615;
	Thu, 23 May 2024 17:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716483896; cv=none; b=lPPycqI8VnSeVo9GTzwBOAai77/omICK0W3jLYEM0h7hZwSv4BQz0GX49i6G7ZmpHPpeXhnzM+K9ClxoZMlrOVEYla63peu6SroJ/MJDEnuHwqpSgQD1YAE07eGPSVGekZPwkZKeDyUNzuYpDSRCbCdyINSF6moNjEktVAYOD2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716483896; c=relaxed/simple;
	bh=w66TQ6PsDuA0a/h843rYNISAAgB3Pjdh1sIysBWrH6U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nX6y0QxlM/7Y/VN1lN1fjoaqL7vr320mSf/s6SGiDILrxnncD6DW/ets0h9NK3z6SYFRcEHNDVPMIAgDMVmfOZUGpDquqSV8TThxWfMqfJjQ19fLfg2IKgcMmaQJ+7SrfSh3G1OrElP0FK8huAHu5hOZT9pj5DXiNr7FpACZbNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E5w4TqN2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E5w4TqN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05580C3277B;
	Thu, 23 May 2024 17:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716483895;
	bh=w66TQ6PsDuA0a/h843rYNISAAgB3Pjdh1sIysBWrH6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E5w4TqN2yUntSPt0U2wudujxeUkIAEqkhhvbh53jiapWZ3B8lPVfPEZuu9rkKobhp
	 vggSZkMbq/DLOg9TBfrdlY4X+VSP7TdDm52tCGfamOi/YCs7SPxEDPsnEoTXa5xiXM
	 m3SQ2h0KJAjfIRaIlwt3QfPsOUA983xX3D/WDL/G8E9FYM+lislX7AS7U85FkaH57q
	 MpK5hFkhMsr9i47zr+0FufLZ84Krp5K3tbCurLErCL8xRcC0oXxteB/+guE2QKRQ4G
	 ZSSvjFRyZtzVvTmcclPM9PIp3Xn3ofRTxwkiz71B8NGJ11bDW95v7zrlYhF0nN+GOo
	 scsYD2GsOG0hA==
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
Subject: Re: [PATCH 6.8 00/23] 6.8.11-rc1 review
Date: Thu, 23 May 2024 10:04:51 -0700
Message-Id: <20240523170451.95653-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240523130329.745905823@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Thu, 23 May 2024 15:13:27 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.8.11 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] 4d4c8ffe74c4 ("Linux 6.8.11-rc1")

Thanks,
SJ

[...]

---

ok 2 selftests: damon: debugfs_schemes.sh
ok 3 selftests: damon: debugfs_target_ids.sh
ok 4 selftests: damon: debugfs_empty_targets.sh
ok 5 selftests: damon: debugfs_huge_count_read_write.sh
ok 6 selftests: damon: debugfs_duplicate_context_creation.sh
ok 7 selftests: damon: debugfs_rm_non_contexts.sh
ok 8 selftests: damon: sysfs.sh
ok 9 selftests: damon: sysfs_update_removed_scheme_dir.sh
ok 10 selftests: damon: sysfs_update_schemes_tried_regions_hang.py
ok 11 selftests: damon: sysfs_update_schemes_tried_regions_wss_estimation.py
ok 12 selftests: damon: reclaim.sh
ok 13 selftests: damon: lru_sort.sh
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
