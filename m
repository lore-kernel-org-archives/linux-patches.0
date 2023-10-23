Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE6114F70;
	Mon, 23 Oct 2023 16:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uv8P4u2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27DA7C433C7;
	Mon, 23 Oct 2023 16:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698078296;
	bh=QafwhIyKRywPgzKy2niqWZ7a6petGIcryfRlf2IB1GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uv8P4u2sNzRrofvbSUkXlHEHg1CkEkrW+GHfHKgKffBQ9qQwRmXq5HKaJalEmh9j0
	 zDrxDYwbxL1nRSZQa8jnY0pgGaDcwTeyO6TcCGDifHN0M/qYsqMfgUqqwia2td2xXr
	 WFchUyEswZzcxBpbCaJpmvvMTYw0OArQtzJSa9UyI5xBdixnX6miU+Nj0ofjasL17b
	 NMS4gGWbEdMDD7uOi55PXK5G3Eg/bHIW+5cy4pE4WSVQb1EdDaoGhWj0vkSWuPq71C
	 t3TJzBLcczrOSheZWWZpMu+61ji//cctcF8hvTTAqydcwFcN3XOmle7gTcoJyl1GHJ
	 cXwlWTAwPI8EQ==
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
	damon@lists.linux.dev,
	SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH 6.1 000/196] 6.1.60-rc1 review
Date: Mon, 23 Oct 2023 16:24:53 +0000
Message-Id: <20231023162453.188072-1-sj@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Mon, 23 Oct 2023 12:54:25 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.60 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Also, please note that the automated run of the test was failed kunit test due
to a buggy commit.  Attaching test results summary is that of the failed one.
I made a fix and pushed[3].  With the fix, I manually confirmed this rc kernel
passes the kunit test with the fix.

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] fa9447b759f6 ("Linux 6.1.60-rc1")
[3] https://github.com/awslabs/damon-tests/commit/6182d52940e83623376ceceb6c0b90e661abba3b

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
not ok 1 selftests: damon-tests: kunit.sh # exit=1

 [91mFAIL [39m
