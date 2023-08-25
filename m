Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65EB621;
	Fri, 25 Aug 2023 01:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB978C433C9;
	Fri, 25 Aug 2023 01:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692927099;
	bh=lhrAqAxMEr40IS0xmnCfLWy8ejhy3ZAXRBr9oZpBrPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SUVywRZKobOQhT98vwJuJMIoTrhrmyoxh+4+yYubfBpjyDH5qHuj5CCxzE3QueOJz
	 XChGafqDn9ZHsXw88lPPbxXuCgTUs1t/quLImQ2WnKbq8Uyjp3EGfZdcBUyjAP+nER
	 wAhLLnEB79SPpAsoi+aBcYas+q2SbhSX0svFoB046U6M+v8s97ZSmF4K8NoiEXnn2P
	 qyKxcQuOd+lzXuLP2VUnMk0ARnSeammu4Uhtpg4bMjseT+bCZQVJky6XT7lVJR+o46
	 ZxdrtysAvxW7cXj9Ez96hpw4OjJC+lwicL35Ft8sUMF5PUzJgkp9kqpTAMuvUVveMv
	 5/8dsf5JMcCdw==
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
Subject: Re: [PATCH 5.15 000/139] 5.15.128-rc1 review
Date: Fri, 25 Aug 2023 01:31:36 +0000
Message-Id: <20230825013136.50239-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Thu, 24 Aug 2023 16:48:43 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 5.15.128 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 26 Aug 2023 14:49:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.128-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] 00e5f0b76767 ("Linux 5.15.128-rc1")

Thanks,
SJ

[...]

---

ok 13 selftests: damon-tests: build_i386_idle_flag.sh
# selftests: damon-tests: build_i386_highpte.sh
# .config:1341:warning: override: reassigning to symbol DAMON
ok 14 selftests: damon-tests: build_i386_highpte.sh
# selftests: damon-tests: build_nomemcg.sh
# .config:1342:warning: override: reassigning to symbol DAMON
# .config:1352:warning: override: reassigning to symbol CGROUPS
ok 15 selftests: damon-tests: build_nomemcg.sh
# kselftest dir '/home/sjpark/damon-tests-cont/linux/tools/testing/selftests/damon-tests' is in dirty state.
# the log is at '/home/sjpark/log'.
 [32m
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
 [33m
 [92mPASS [39m
_remote_run_corr.sh SUCCESS
