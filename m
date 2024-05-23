Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC82BAD2C;
	Thu, 23 May 2024 17:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716483800; cv=none; b=Hc9mP1szySFOWPy9zQax3VKTt/40CSay0Xz4wv9mY6KOrnxXFoTT7BZos8cxBOOZA90RAOSG0O2juLjS+DZpqrZDTEADOBocLr2xHbxBCAlJmA0cf3DCXoLuHZWRYGk4a1zBJlNpRZ5xKNAyaiff8Oc3/EyWXkKg3RONobCEQw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716483800; c=relaxed/simple;
	bh=grZLcm/jAuY92MQ3Lh8EjEksXhM59l10I+ShgzNYUtU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b1sYAI5B/ee67TaOTlTl35bTWJKI4fzH+76ZWhg6U/e38xAoiVZmPY1NNbqnvWH+JODei9LYvyMQI1tO13JlNV0h/eXqSF5PrB6t4sbW9YhXNLd9GlNPzJP/qRsUCzKVDp+ARV/p/gr3ZiVhH88gYMAEwIzeWFhKDT4SX/c5HL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MpJ5Se70; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MpJ5Se70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D8FC2BD10;
	Thu, 23 May 2024 17:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716483800;
	bh=grZLcm/jAuY92MQ3Lh8EjEksXhM59l10I+ShgzNYUtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MpJ5Se70YdOu6d2YOKgVzU5rzCLxCFiC9YYFXQzLKjJIh1XFljKZEYOREgABxiDFL
	 J+5rS/monbhz93umiHCGL4CuQm7n0YDZEVMMJDDj5n6i5s5BtxQpv4eL83NSI+hKhJ
	 xlB3x7vbFSl0Gr40NvlqSsQCS9uuIKuAoUasK19C/WuPWhlA8/ZQKqMQw2UWXr8nv1
	 C2V6GE/Nlb7DeG5RRfeGF57Tu20OAoOf4GZtlf9OKF0LiHUxl0lZUwY21EMUyWf5xw
	 4xo1NvtXSzOE2wEYY1Izedxzt7HmBUkFY5bWxZyWXUX3n8I380jzUk4z6sbd80pXY5
	 iBS4OsUO2aKGQ==
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
Subject: Re: [PATCH 6.1 00/45] 6.1.92-rc1 review
Date: Thu, 23 May 2024 10:03:15 -0700
Message-Id: <20240523170315.95602-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Thu, 23 May 2024 15:12:51 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.92 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.92-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] 662b26bd104f ("Linux 6.1.92-rc1")

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
ok 11 selftests: damon-tests: build_arm64.sh
ok 12 selftests: damon-tests: build_m68k.sh
ok 13 selftests: damon-tests: build_i386_idle_flag.sh
ok 14 selftests: damon-tests: build_i386_highpte.sh
ok 15 selftests: damon-tests: build_nomemcg.sh
 [33m
 [92mPASS [39m
_remote_run_corr.sh SUCCESS
