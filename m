Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5678B6D1B5;
	Thu, 23 May 2024 17:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716483745; cv=none; b=ddBchqn1iaGfHN0v4bNxCmHRq+Vd25hScT7WIlfgni0CHGAWHyB3UqFawc20EKUaCouXgN0vih4Eo8f90/hNDlV1IeeK5ogsjXSgMD3quUg0Ny4iUjstA3cRW0ndt6m+FKGubwt8wM0WDZoek+3yn1y/+DNUoTWrq2MKjipTMuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716483745; c=relaxed/simple;
	bh=d7D+pyOzbClQSli2DO+f9IhJdHvqq3EWbx+uTjIdFgE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DGjOH74zWCD6pg+K8vdnU1XJo9tw2C6TCo5RPZj/VvGwmItoT/i3tO0+1celeugIdLh53oiUokVb/uEbHnny/Z94fmnvQFNhnnEM5AZv27Y7xAnmlL4JlH49KRJAT7GznAI7pjQ2VLcHTAjVpMOnz1OfEOhz/U7+XSJw/LA46P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B/HF2s25; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B/HF2s25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6BEC2BD10;
	Thu, 23 May 2024 17:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716483744;
	bh=d7D+pyOzbClQSli2DO+f9IhJdHvqq3EWbx+uTjIdFgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/HF2s255o421eT4i7ZG0EoNtP5GIDSjt5Q4kK8jE7d3BHdNcB8QdrP4txTbGlJPC
	 XsTU0i0p3ZO4Kp5M0qezxI4fy/H+eUPDQVzUGwVbP3ZaLnLo9SpMfFFw+Ja6P3ayJb
	 FRVpKTISxJU78U7GmBo/4KpDwTVBw6LfwbmJW7HqmVtr4YKM3P9GsxCy70WoDUeLUH
	 IDRlXmCXJPkt6duhilDsU/CDe8OQMbMfTrCE6oFhblFP1LhQInIqgdj1Pbm9ITz/Mo
	 hfpEzFcZCAm6MZTNorndmgaeI7hMe02RHdYOf8SDuR76Vjd7JPIbW54oIAr9tSArtK
	 bC6777fvpu+Ew==
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
Subject: Re: [PATCH 5.15 00/23] 5.15.160-rc1 review
Date: Thu, 23 May 2024 10:02:19 -0700
Message-Id: <20240523170219.95555-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240523130327.956341021@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Thu, 23 May 2024 15:12:56 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 5.15.160 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.160-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] 0aee1934e6e2 ("Linux 5.15.160-rc1")

Thanks,
SJ

[...]

---

ok 1 selftests: damon: debugfs_attrs.sh
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
