Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E68B1DFE1;
	Thu, 16 May 2024 16:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715877910; cv=none; b=L2JCONOevNGDSQGbWIH7RdXEK+5T/S1wsLNuCRqcPZAVnJEAnnAVIUbBx9aw0p+Rp4v0G6XMVJswrnQ7iQExSCNWXOgGguuwdR4EN5cocqFT83u7MA4Uuvhhk1wuN0TZOhHZ33prGDz1PmRFmemmpuISV6q7Jopu2DE/FjEP7nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715877910; c=relaxed/simple;
	bh=BwySwRMuh5mN2wc/dBAoizihekeUB0M0YxJbrgSYH6w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tVLYqIDM8ylE6ydnMWEKUsfDyAvq/vT74fXTKzUIft61i3ZCTicNM4r5ezC3WjbHLpEFEvnhHe16ivQbnqMRC9CahGIFfBgtJpNH7uK+g/gcyDhUB2nxFQTrsFrJcceyk6iZmbOtebMr7IEZgGCkr3zHYk1OhlfK0QU6k5guG9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rMLzoiLm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rMLzoiLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83D5C113CC;
	Thu, 16 May 2024 16:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715877910;
	bh=BwySwRMuh5mN2wc/dBAoizihekeUB0M0YxJbrgSYH6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rMLzoiLm56Yq/oY9BFaphgWyGXHC0m4cHzvgssAJ3pdIDoC5zDfN4vuKFDTSnV6EJ
	 XMCGNesaQevouLO81fo/hgZIuAuGcewoq0JDrWccovX1wMZKyVeWcuh6/MdqRSu4rB
	 EWLxG/ji1sT5vbg00G+gzg0c4BkpvwyJ6uC+wpDzm04d0SqfGPHbMjssLB5LfXcCnA
	 TDVt3SJYcYhDn7+sgBJGKa5zFSmH4hqjcgEt3bn8Z3gyrkaj1BAYorwQltylf3QEpJ
	 Z9ZOlBRTZ3hWC1xt2Fd/Jz6g4WrPqXjoc/zcg5S9FfN4KfsTFkRB02qkiryqAYT9ys
	 i0aj/dlUVeCWA==
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
Subject: Re: [PATCH 5.15 000/168] 5.15.159-rc2 review
Date: Thu, 16 May 2024 09:45:06 -0700
Message-Id: <20240516164506.79395-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240515082414.316080594@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Wed, 15 May 2024 10:27:48 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 5.15.159 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 May 2024 08:23:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.159-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] 1238a9b23a79 ("Linux 5.15.159-rc2")

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
