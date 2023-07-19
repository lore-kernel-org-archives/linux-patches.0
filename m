Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7043B17C8
	for <patches@lists.linux.dev>; Wed, 19 Jul 2023 01:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7112DC433C7;
	Wed, 19 Jul 2023 01:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689731614;
	bh=3FBnzkP6pgeUS+Ui9l2ehSB5W9hcuMMuRXv0tAYDx/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TT/p2Z7TWx0kxWBdutaY7BnoLGQzC7vfsIBtt1FP9zOMQ1WLJVK0Vm9FBhTgNqpgG
	 8RU5iUXt887vHV8mF93Pq7PmbTbQUvHL1oPPnFJ58/+URXVF0hWEUTfPbSsYfAbMeU
	 NCcsS/seI5it78/Fpm2TlCduoNXPg+n1wPipdg/g09FwBrtnxIzAG/JFDOZrXeg+sx
	 BZpBqSrH9aSwuAqlpX9i8EtP0jybOOfFvwZhAerQHM2FatTv/nFASWrVdhVuur4eN+
	 XPYJLsFbHAf/cYWinOfNBlAyBWXLuhxTDutlIv9HTVRYu3QCaEsMGMSZxW1shILeZJ
	 vBga848S0OTYA==
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
Subject: Re: [PATCH 6.1 000/589] 6.1.39-rc3 review
Date: Wed, 19 Jul 2023 01:53:31 +0000
Message-Id: <20230719015331.65070-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230717201547.359923764@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 17 Jul 2023 22:34:23 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.39 release.
> There are 589 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Jul 2023 20:14:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.39-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.

I confirmed this rc kernel passes DAMON functionality test[1] as below.

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr


Thanks,
SJ


-------------------------------- >8 ------------------------------------------

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
ok 11 selftests: damon-tests: build_m68k.sh
ok 12 selftests: damon-tests: build_arm64.sh
ok 13 selftests: damon-tests: build_i386_idle_flag.sh
ok 14 selftests: damon-tests: build_i386_highpte.sh
ok 15 selftests: damon-tests: build_nomemcg.sh

PASS

[...]
