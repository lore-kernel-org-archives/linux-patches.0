Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDE484039;
	Wed,  6 Nov 2024 16:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730911994; cv=none; b=KSHyunQ6S7Vmq+TK2k+zsqYxWTwLIXZrO1pOiSZfIvRF3hIQmb4OyOgBlyFXY8Ia9dD0UnHGrZXewyQ1r+83DX9mqhk6VBSG9jmKwSPMrN7+HA2aomDr2TJUbDS9ypxAuqwIo/5r3vDWK4ogKy44dkFvqzDfoprI6/KBAcfS3Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730911994; c=relaxed/simple;
	bh=2xtSNP79Z+OcH6i5Q5Uvg2EduBSaA1/JfcXdLbWhHp4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OEBjLu0xz0qIxy0oMJZzlcKM75mNAxvAAwm7AdHuurXt3I3jZVeAi6ct3eW2ydQp0M0D7aWhV3SqYoLk0Qd4nwzPjHeGkK9nVBxN0Dz1avzp5vM41DUflgVWu0KbGHRHXDqUrpOfTaYvYUUPz8Ycv0BASrRRTJGtJK6I8Da9VNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l8P3uzWj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l8P3uzWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491C2C4CEC6;
	Wed,  6 Nov 2024 16:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730911993;
	bh=2xtSNP79Z+OcH6i5Q5Uvg2EduBSaA1/JfcXdLbWhHp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l8P3uzWj1HyOqlbDZfRwAbr83eq6Bxwf1fj1MeSmmXknp9ejaLgcHqGyNomcQSFSn
	 vHkWQRzVLY8qg/FuyzKVbxSKDaceokh/17ynDBIJTaA0r5oi4Li6U/HIbTs99Ihqpl
	 U3dIQJP83n/67F4SOrb2MTjbEdROIY8Y6301eErQV9/4bGPED5myu7AI8FpfeBtGEH
	 kEUiZH0lzHSmY/W5rgA1sQUE8oGlji5Oi4Wun0Yg2N5zJjEVHR3noT9CUXjPtFkiEB
	 m8+T5vBFYYQxlRTei8qkY9MjSbzcyFY7zNEgWp/9QzPrPQIEOQECMVFkK+hi0CowsV
	 iE4A52eoLzvrg==
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
Subject: Re: [PATCH 5.15 00/73] 5.15.171-rc1 review
Date: Wed,  6 Nov 2024 08:53:11 -0800
Message-Id: <20241106165311.8008-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Wed, 6 Nov 2024 13:05:04 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 5.15.171 release.
> There are 73 patches in this series, all will be posted as a response
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
[2] 7a95f8fff07f ("Linux 5.15.171-rc1")

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
