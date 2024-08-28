Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C031804E;
	Wed, 28 Aug 2024 01:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724806844; cv=none; b=Q8Mk+er4r06AmJnj1OkZw5h4646QzFcuM3sWX+Zii+6iWDUqO2H+NwGTsxYrhlIZhQ5+FWNQWivjeePw7hfPeI1/256rx5SNLGkEHtIRd55W4L4radj/BJ2MCYkgUHHSui5jlNlSqzDVPSi9XDoJxzDZe4PekdFwM+UQDp+q/sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724806844; c=relaxed/simple;
	bh=03r10DrpIBe+cgKGft20S+HsqwBncAQDtv+Z5pnWL/I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u7whXhpEA6axC0h95sKi4FlF7Ur5qDDZvWK5igf4rMm/6h/FEhlHJc3j58TtFSHrqPdMx2lz9VeMK3l0WRdQXig6tKRHw3kJlLimUvED0w50zb/OwLJh/XPqiz3TQwsE0u781TXOweXiifT/c6GbPIvG5tktkjXEOjJIYHMUzyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eYV1mJdm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eYV1mJdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9E0C4AF14;
	Wed, 28 Aug 2024 01:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724806843;
	bh=03r10DrpIBe+cgKGft20S+HsqwBncAQDtv+Z5pnWL/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eYV1mJdm6qY5nadAPTyGYLX/+1hNs0G8XKLOV+e94r7j8bJG3v31z/XB5ryFZkg9G
	 7Oy11Same60fnZHlcD83QC633mC4WWLzEJep9J5O0kq7Ae6CKWazcAQFdSbClQVmUq
	 +SmJX1ez62J+NgiAbHBkOfRd0Cl9xpjo8/cjT1kO2dXH4EODCEIxt8wOzGKQC1NHdT
	 2K9XjOOxiP5npMV4Zcaw+rhPSnwmpYZAlr0UABm0nVKmLE+k7VJ70YtjPcpWhg4MGU
	 QH8sfg0awNmhHN0Dhb0+0VShhD11qoL8oKAtnojfYuOc04iMjqgufV2txbIshNmqxB
	 dLPFwye5a712Q==
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
Subject: Re: [PATCH 6.6 000/341] 6.6.48-rc1 review
Date: Tue, 27 Aug 2024 18:00:40 -0700
Message-Id: <20240828010040.17047-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Tue, 27 Aug 2024 16:33:51 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.6.48 release.
> There are 341 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.48-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] 0ec2cf1e20ad ("Linux 6.6.48-rc1")

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
