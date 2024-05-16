Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B154A3D;
	Thu, 16 May 2024 16:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715877830; cv=none; b=cyP2QVUe0cSFRR3R6pdeDKsZhSX4EjPaWDYaVxh98uzro0HQCmKOXmNh54LqiEuTmmPr0LO5HOcAbunrb+/MFpW0boCrcwr2x2A43aUuNTaFsnm3f12muR9aKHeaPQ7+D0mckHzjcbW+ubMjUfaLYTZXVHwi66j4wV4iNjbWRuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715877830; c=relaxed/simple;
	bh=3GePKn8OIm7W+1wFdeIkXXQZwWDw069PcqBbahwZcJg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RgSWQJPAFhLc0PPPBVeHnrOpHqwXwtrKo4MddOL7no2fyPIIzJ2nje2Yg7hXwoQsIpXtvlkNxkXC+z0RJajq43nWPt8snnOImL8pTf/861iyWP3dOIXR1PwcA8qk4DuYzHlNGGqFJuBJWkiL1CFAcQE8VNGZStg2BeKTIwkUwlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dicBi1ts; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dicBi1ts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015F4C113CC;
	Thu, 16 May 2024 16:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715877829;
	bh=3GePKn8OIm7W+1wFdeIkXXQZwWDw069PcqBbahwZcJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dicBi1tsg5v4+wesyN2rhUoVIiOjWnOp57H5c/Cq3z6k0jsIF86tZMKXahd6+xerM
	 fVTgD41tsKtRvMleXAD+RZ3DnmXrrraNO+Hhn5eOXa5ySGb/JH7Mbc7wwkGuidPRCZ
	 qUUc2at/pRa65BPjcURpyFPSnuZlRFOERpXZn8IB4SoAelcJCk6jsw1biA3EsO+SDT
	 8lFDdYDzoTBFFH2GV9+uHRHQAXHZrR8dpYAQyi9zF5vRhQSAy5U35U1cmAtJlPg0mZ
	 FbfBLhrM0B0W/zMowmpZSR2JsTV7VSpGj3ewtslps52At1TpLP6xh7fYsIHT0Cv0Fr
	 bzsTNKAexrKFg==
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
Subject: Re: [PATCH 6.1 000/244] 6.1.91-rc3 review
Date: Thu, 16 May 2024 09:43:45 -0700
Message-Id: <20240516164346.79368-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240516091232.619851361@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Thu, 16 May 2024 11:13:37 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.91 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 May 2024 09:11:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.91-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] 68f58d77e671 ("Linux 6.1.91-rc3")

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
