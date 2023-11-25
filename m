Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB1D22069;
	Sat, 25 Nov 2023 18:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d2cwv6fQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C94C433C8;
	Sat, 25 Nov 2023 18:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700938721;
	bh=/uJWVRTVhr1xD5gokfNl1KVV9MZJDu4ilncSLnPbO1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d2cwv6fQBofTHtYALVzhGFsR9SmYjGzenekz2r1r8FfwIG/bXnPFnfVDUjphtCLjc
	 YCzxKUJ5NNt2ebl0nuc7UvT2llbRMZ2dN4Oz//qZPoSGXqmkRWbpOsPKM/86FFykjb
	 ZPzzLd3paQnykXEnxR+Sy/0LF1uJtTqgTVIOBGBkTTxqhfG3ww1kea/FKelKcxcR3k
	 5FzHO7wKhecYtUA5JP/EVWjmJ5G8ij8oOohcJHCpk7qAnswBRiMRe3gnNTpweRpy2Z
	 sgOZGXiWf6qLCIFNbB9dayphfHTjZIeyO95AU1DB6PGeaAYQXRGbThoql0yKCRcM5M
	 Wp/WQVnfJ+wmA==
From: SeongJae Park <sj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org,
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
	damon@lists.linux.dev,
	SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH 5.15 000/293] 5.15.140-rc2 review
Date: Sat, 25 Nov 2023 18:58:39 +0000
Message-Id: <20231125185839.101949-1-sj@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231125163129.530624368@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On 2023-11-25T16:33:08+00:00 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 5.15.140 release.
> There are 293 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 27 Nov 2023 16:30:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.140-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] a3664bb04ca3 ("Linux 5.15.140-rc2")

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
ok 12 selftests: damon-tests: build_i386_idle_flag.sh
ok 13 selftests: damon-tests: build_i386_highpte.sh
ok 14 selftests: damon-tests: build_nomemcg.sh
 [33m
 [92mPASS [39m
