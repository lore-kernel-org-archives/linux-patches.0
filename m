Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A374123BF0
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 20:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DC8C433C7;
	Fri, 21 Jul 2023 20:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689971524;
	bh=ldtfk7SCS0uhcMiOLflUlFcLTiSPjTVuJhxd9yZNCGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3n2fyBJjrcQkkZmcg7eM8eY4Xr5Pe9gcDHaZGVh5wNeLynqfN+LG/vkwI8OmgdYS
	 BvXk0TBpNj534jnCRnIQDsTeWBZrq15vzKgjLYllNBN65fz4wR1A2d5AZwlptQ1OkK
	 Kd6yr0VyEaQJ7B/nVCij+mMXthd8Hqau3yofzyjE3bv3iNkGb5a108DkCErFUJ6DP7
	 iH0o3BMEP3LvAC6WcNJaFOSAexNUybQqtO/ko4lwMdkoB0BhTtAMWaHjoOSiWNUFiD
	 /MKJLhv/pJYhcUNQY9Ka0LRwaIyuxQ0sGB3zBFqgwOXFE5shsZCLQBMPQgqw4eoqk5
	 zeYLnsNlSn7lg==
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
	SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH 5.15 000/532] 5.15.121-rc1 review
Date: Fri, 21 Jul 2023 20:32:01 +0000
Message-Id: <20230721203201.61971-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

On Fri, 21 Jul 2023 17:58:24 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 5.15.121 release.
> There are 532 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Jul 2023 16:04:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.121-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.

I confirmed that this rc kernel passes DAMON functionality test[1] on my test
machine.  Attaching the test results summary below.

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr


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
ok 11 selftests: damon-tests: build_m68k.sh
ok 12 selftests: damon-tests: build_arm64.sh
ok 13 selftests: damon-tests: build_i386_idle_flag.sh
ok 14 selftests: damon-tests: build_i386_highpte.sh
ok 15 selftests: damon-tests: build_nomemcg.sh

PASS
