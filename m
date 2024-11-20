Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682281A9B57;
	Wed, 20 Nov 2024 17:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732122177; cv=none; b=QpoP77nKKTNUOJ7ehElP9xJYVd6JqxA+hII/WOSO6L/S3QgzJ9oaALoMhq45KUqjUkfJBANkgwLZ7jf6g6jO8jnbFX2zF9uTjM6fwD1lXkEIHWAH9VUtOp+cN7mZ9zAuThpmI7tnQmh6VC0Su0s47ABr2XI4AAQDOEhDPSDrVP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732122177; c=relaxed/simple;
	bh=jAZjr6uZmIpn8znH1f7+i/DoO9TQa5nzhIeLcjQqb/M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PjcfQyViIUigyEjrraq0HWRiPP6e9iuU1CIakYHFLf7KE+80mXoIyQAWfDxNdlgSlI1qKZzXdLSQrqvu/gJPvmVRi8helFxXklz15P01f3WhTA8IziGHvqAGLRQjWP4Fl2G5Scjm+VyzmzrYFY59HyXFk+K+Au545nZZSFdlFsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ed9/Io31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ed9/Io31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DBAC4CECD;
	Wed, 20 Nov 2024 17:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732122176;
	bh=jAZjr6uZmIpn8znH1f7+i/DoO9TQa5nzhIeLcjQqb/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ed9/Io31TbUaY0/i/6oc8vGK556Ha1ErkaKHjp/vdBstUO4lsvfFKIiw21wYFxO44
	 eVsL+LruUm456uQlfE4u8y1gTMCFHKC6Q/JwdOxmgOSzEMYc2j0sXjLQmgBVD54nvE
	 EsFqSVXlKyUgt6auoXf74My1cwNqWDZajpIvHhUaa5LEefPQx3A/C5JT2q3s4y2t46
	 b4Bxg7k4FVY6qKOYqyivsKIOhRINeHkaV5Dx9ta8CoC0PFdMay3f9Y/ffFrDawj7i3
	 ZK+g45vmH3Sa6BGLTk1keFMZFCVvAEmN1lJvrwQNFH0s4Et00ar27KFDLvljPAxh07
	 PUtwTI8MBq2kA==
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
Subject: Re: [PATCH 6.11 000/107] 6.11.10-rc1 review
Date: Wed, 20 Nov 2024 09:02:52 -0800
Message-Id: <20241120170252.69500-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Wed, 20 Nov 2024 13:55:35 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.11.10 release.
> There are 107 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Nov 2024 12:56:14 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] c9b39c48bf4a ("Linux 6.11.10-rc1")

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
