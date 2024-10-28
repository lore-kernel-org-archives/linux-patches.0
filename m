Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5643F1DF972;
	Mon, 28 Oct 2024 17:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730137759; cv=none; b=SAyn7Jh3Y+XoLqVrQxx6pTPKWTse2EAQd8LnsQPIHxThz5fc74BKKiRpXNtDcHOYaLx0TSEANyaepPDmnJXUYGWiANsljnDUTe0W25K90nZ+T4I2guIz74TIkbHwZ9Bkoh8p6CvqGYGGUAE13ogc6YJOiZwh2wGln84Oby4L988=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730137759; c=relaxed/simple;
	bh=Hroi2NQYXOr47zG5Kz6WK7ouM5FbBDqTfo6anyTINnI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QpKEB0NsTr6dW8mLzjM4Fwu9cXvAgdYLJT+TQLOQqKDbFbTkWD9Jmgph0EtmPzsVgDA6HmkY3mHXz7XW55lGayzVfuhJbg6+CNN5D85pV2sEKfX4rfjHBYH3LMvmQuowuZN5ZMK/l5aRNx/BXSPSw1aABbv5deYHU7fBQETPgKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XhLUsFPs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XhLUsFPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3726C4CEC3;
	Mon, 28 Oct 2024 17:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730137758;
	bh=Hroi2NQYXOr47zG5Kz6WK7ouM5FbBDqTfo6anyTINnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XhLUsFPskUJSqgYjxgrEDJWM+0cMhsVI4Q7ms71TcdkDUOW4/OTHl/AtYbXMpxcu+
	 6U12U0VvKlNiPuhnClKKEnYQ5kP5IEvV5Y7BMmipk9Kd8tcnpZ1T2GnxBL693VI2mN
	 yxwb0wGWVGJ72yCQD4XJvJW8GYVCS9H35i+ZhhvkwtaVb29BcZz2OVRyfpzNgwA6Cs
	 s+XdaT6SZCSuDk28mB82Uoop7AfxR5Z4pKFZ+sZYeAgalnU4MFRuyoZBWfiusRz6R2
	 xt09eSgS1z4z9LECSsJ0sGLYZTd95mq6+h0sS4sY+UizhKOFGPBwzNZIQXv34t+gwe
	 s1KZaAwJUm30A==
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
Subject: Re: [PATCH 5.15 00/80] 5.15.170-rc1 review
Date: Mon, 28 Oct 2024 10:49:12 -0700
Message-Id: <20241028174912.276586-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Mon, 28 Oct 2024 07:24:40 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 5.15.170 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Oct 2024 06:22:39 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] be79a1947245 ("Linux 5.15.170-rc1")

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
ok 11 selftests: damon-tests: build_arm64.sh # SKIP
ok 12 selftests: damon-tests: build_m68k.sh # SKIP
ok 13 selftests: damon-tests: build_i386_idle_flag.sh
ok 14 selftests: damon-tests: build_i386_highpte.sh
ok 15 selftests: damon-tests: build_nomemcg.sh
 [33m
 [92mPASS [39m
