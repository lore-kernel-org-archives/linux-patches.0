Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1AE259493;
	Tue,  7 Jan 2025 00:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736211247; cv=none; b=OLB757/mXsb+cos9cIf9h6EnvUVNBzyDFXeP4Cthy1be7WkA52nFrIVMFGbFP/DyHte9zUIFaPxO4pf5Kpo7Bf6PXBSrfmbMKzn9W5vCpXYU9wPeHXvuCZC4MPxPPxhNVPmg9YW2x3oWsQbRayTxBDB9NSMAoo9uF2zeKemBpxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736211247; c=relaxed/simple;
	bh=goCw+Q9VB7nkZi1Xy/MkqfA/MLwmIrQlUcuAVxuEoKM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XY9zHgdtX0sf7g/+fISDOHjdOi/uVQkS8OWox/QmdzSDL5SRUP3dgYgYO/ByDFZHqYXRA7/WtEWRDHgOEEUYrv+IXrn+Flk/Pf3836fRUP4TKBcaOTI7F+IZOU3GbH6bGtbX5/0bWnKGOU3aLUDKawSM15eGkiSm987DsXv/P34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z186qOj8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z186qOj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645A4C4CED2;
	Tue,  7 Jan 2025 00:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736211246;
	bh=goCw+Q9VB7nkZi1Xy/MkqfA/MLwmIrQlUcuAVxuEoKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z186qOj8WsYGd532Tf90fguq+q+ii4NIvJZmaLqiSDoD27dA4C62WBIZwaUAalRJk
	 oY1CHO0VHc0T40CWBPA7+oj5XNCuPEU4MZNHwBmNj7FOsWo1ZC/+lTcjQAImdzAS3M
	 0EtoyUY0YMYKx8AkILCTHUSJ5XSsBD8iN6vEjQ+sPocJ1stNnHVF4E8muo3LoRyRw+
	 fpXyGot5jdfqum4R/x4CG1Vc9B+u31ByEY+aRTdC+DeymE0++Fc8U/sd0I1Dh87pal
	 6hlJVRGnOcSb4WW+Jol83wT3TinGlA20tKqkUCA4+cMQKxtrTbCHr7MJtE2+CzF0iz
	 aciPD9wOEJ/IA==
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
Subject: Re: [PATCH 6.6 000/222] 6.6.70-rc1 review
Date: Mon,  6 Jan 2025 16:54:00 -0800
Message-Id: <20250107005400.89398-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Mon, 6 Jan 2025 16:13:24 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.6.70 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 5652330123c6 ("Linux 6.6.70-rc1")

Thanks,
SJ

[...]

---

ok 1 selftests: damon: debugfs_attrs.sh # SKIP
ok 2 selftests: damon: debugfs_schemes.sh # SKIP
ok 3 selftests: damon: debugfs_target_ids.sh # SKIP
ok 4 selftests: damon: debugfs_empty_targets.sh # SKIP
ok 5 selftests: damon: debugfs_huge_count_read_write.sh # SKIP
ok 6 selftests: damon: debugfs_duplicate_context_creation.sh # SKIP
ok 7 selftests: damon: debugfs_rm_non_contexts.sh # SKIP
ok 8 selftests: damon: sysfs.sh
ok 9 selftests: damon: sysfs_update_removed_scheme_dir.sh
ok 10 selftests: damon: reclaim.sh
ok 11 selftests: damon: lru_sort.sh
ok 1 selftests: damon-tests: kunit.sh
ok 2 selftests: damon-tests: huge_count_read_write.sh # SKIP
ok 3 selftests: damon-tests: buffer_overflow.sh
ok 4 selftests: damon-tests: rm_contexts.sh # SKIP
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

PASS
