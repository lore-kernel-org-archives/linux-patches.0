Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E786E5ED;
	Tue,  2 Jul 2024 19:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719947985; cv=none; b=XsFC0JxNWbk5n0fb5eR4jAICFwMcnxrcNSuuH/+nDhuV1W/r/JuCfjg5/RxX/ucGNNkh/82ogzNbp4Y7XbRhOzacdUU8w6pQmNTAlsXhYf3A13s47VTXO2R7+6WcH1wXlcfK74ijFWxjmaz5OrnkH8OGOiLgDAYjO7o1dz7IzQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719947985; c=relaxed/simple;
	bh=cBKUdPM1KzA+AAC6Lzy49px9yfDnWaC0ADT8+exv2dY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UWU/W+fJIYdM1fNhjmE3Dl1OXzAr8bpKXfxPYBVidNGpkf/gqdSXgMYQQcoUePRo4Cj50T8GHdpuD328+RhYUSMjG5YbgJpxijYJ672+379Q6veCZJXKMMjIx3z9UH19eB6hzVBvvIemAtg+R9fAYpYsE2YxQ3qK/Utv5A8MGfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iojOh6wr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iojOh6wr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960D6C116B1;
	Tue,  2 Jul 2024 19:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719947985;
	bh=cBKUdPM1KzA+AAC6Lzy49px9yfDnWaC0ADT8+exv2dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iojOh6wrx0NwciU3vrFXb66n5wQOCcX5yhrgnJE3PAs1xM31xWXpBg9ba20+op2pO
	 quwV/Cmv5/nH/dhJZwj4DeIxf3E6zUD1Sf3yZVr/xeNGYMhs5J/1MA8/v6dGldaPS3
	 Mpq+wCOZ8bNh73Iq85jqZEwh3ywgTguUMfk0LTEbe5NNXBEBCoDcvfL3p9ajvE6c3X
	 VdQjTpT4MKahPJBnw+oZ4FhpdVtK6Ui8pu1aNSOq2/4wDxT097GgmAftY6+uO7FhaP
	 a3vKiQW//y7PU9ZTCVpdYks4CUW8MD18vChj11uwOZV7GvIkkrqvzGc/d+gPFbsHqL
	 bxThtRBKYh8KQ==
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
Subject: Re: [PATCH 6.9 000/222] 6.9.8-rc1 review
Date: Tue,  2 Jul 2024 12:19:40 -0700
Message-Id: <20240702191940.70836-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Tue,  2 Jul 2024 19:00:38 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.9.8 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Jul 2024 17:01:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] 03247eed042d ("Linux 6.9.8-rc1")

Thanks,
SJ

[...]

---

ok 6 selftests: damon: debugfs_duplicate_context_creation.sh
ok 7 selftests: damon: debugfs_rm_non_contexts.sh
ok 8 selftests: damon: debugfs_target_ids_read_before_terminate_race.sh
ok 9 selftests: damon: debugfs_target_ids_pid_leak.sh
ok 10 selftests: damon: sysfs.sh
ok 11 selftests: damon: sysfs_update_removed_scheme_dir.sh
ok 12 selftests: damon: sysfs_update_schemes_tried_regions_hang.py
ok 13 selftests: damon: sysfs_update_schemes_tried_regions_wss_estimation.py
ok 14 selftests: damon: damos_quota.py
ok 15 selftests: damon: damos_apply_interval.py
ok 16 selftests: damon: reclaim.sh
ok 17 selftests: damon: lru_sort.sh
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
