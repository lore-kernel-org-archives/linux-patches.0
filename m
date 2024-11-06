Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D89B1DFDAF;
	Wed,  6 Nov 2024 16:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730912042; cv=none; b=aK6YF2gDLcUAR+/hCepFrF9Ut7R4z0gZM6OwFuXKPkN22EQorgg2onPn5zSPrC6g7oCFUbWwRl7ZqDe1QUIBXfmkSm2rF0SYokBMrfKByRlrZaRrIX6Kuu88a215Vo8Pk9oxv+1SCQs7t4Ay/pegwdKJT3eoTiy+xqqhBwhSleo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730912042; c=relaxed/simple;
	bh=OUfJJpPFp4yMByn2WrWM7TkzbCeyOZgaJChBhUy88rA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=vCgIOeAN7ADXt97OXNTqCX42/ojIbmuxOoi8pX+2OdZKvLSPX8hTa6dq1dRyYyaJqZ6rNJ3GPZmzqtLRrNGIysuvcHJXxkisz4/N9roydC4Jn99yInEmV0eIFDf+qEUMpMD+R6Dwu5AZd2BEMtqcD3p+tOXpoXsxCqaiZNk4aUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kw/b6+Z8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kw/b6+Z8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE74C4CEC6;
	Wed,  6 Nov 2024 16:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730912041;
	bh=OUfJJpPFp4yMByn2WrWM7TkzbCeyOZgaJChBhUy88rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kw/b6+Z8J9j47zRDIUnMPYgxzQwE2/GZGWNnfokK10zPcmvwOhXe24LfMZgEGKer3
	 kJ9LMoAnOE6BS0xnnCvsxNdOGYm/0CSENUudsYJ8k4CX4zqH6lMFsLzN+wtd/bIrbg
	 X+nGULmIe7gBmTcbtIcSkuuAeDzNrEu2r7gIVYMqBQMHR3G4sIhF64xxpYtqMJ/dUK
	 d/C6wqsVGretEoCmom3DAn+vnVivbYy7BL7t7rriZq59Ks4I80YpMnY8EcuYOZh7+2
	 SECI3DE/ozNJsB3ueOFFW4thiod5OiVxJ9FjKMcSGyNqf4bHnO0j0Hlda8EYQRR3Ao
	 yoEp8Wxpc8cSw==
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
	hagar@microsoft.com,
	broonie@kernel.org,
	damon@lists.linux.dev
Subject: Re: [PATCH 6.1 000/126] 6.1.116-rc1 review
Date: Wed,  6 Nov 2024 08:53:59 -0800
Message-Id: <20241106165359.8076-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Wed, 6 Nov 2024 13:03:21 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.116 release.
> There are 126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 17b301e6e4bc ("Linux 6.1.116-rc1")

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
