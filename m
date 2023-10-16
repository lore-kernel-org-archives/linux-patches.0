Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDF4328A2;
	Mon, 16 Oct 2023 18:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jt0TIgG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF54C433C9;
	Mon, 16 Oct 2023 18:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1697481337;
	bh=0sZNyYJufZfEnzv5I8B+QAwaoh5lUuIQWXv/vgtfVqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jt0TIgG7sFtxR8y20e/lHFFOYUCy5BC1u7iodPkgoarrO5mX/b9r9clGMqx7Q+M57
	 CZB8r77MMhdWTxvCL7FgvX2Vq27T5ufruy63fiTyrYt3Q+Wgw+/rbGUVIdQPjeJCyj
	 dT3yppsjxWgOhJ8E7W8dEDqrOy9wzdpuAVCXPYxnMLg5iAfZIxKrE37fHiQEmCHbS6
	 dBkcluZPTt6xmDzm4aLQJ7TFlmJSnnhY2US8EZXE6Rdp9e/6MSQ9RV8n7VvJG+6jP3
	 R163ctoPTUC0MDkJT4mxPZZZbw2U6V62j8yVRpTXobdq2d458BhyIAYvqPT7rFLT6Y
	 zzJUU/UL4WAvg==
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
Subject: Re: [PATCH 5.15 000/102] 5.15.136-rc1 review
Date: Mon, 16 Oct 2023 18:35:33 +0000
Message-Id: <20231016183534.98630-1-sj@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Mon, 16 Oct 2023 10:39:59 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 5.15.136 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Oct 2023 08:39:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.136-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] f11fc66f963f ("Linux 5.15.136-rc1")

Thanks,
SJ

[...]

---

ok 1 selftests: damon: debugfs_attrs.sh
ok 1 selftests: damon-tests: huge_count_read_write.sh
ok 2 selftests: damon-tests: buffer_overflow.sh
ok 3 selftests: damon-tests: rm_contexts.sh
ok 4 selftests: damon-tests: record_null_deref.sh
ok 5 selftests: damon-tests: dbgfs_target_ids_read_before_terminate_race.sh
ok 6 selftests: damon-tests: dbgfs_target_ids_pid_leak.sh
ok 7 selftests: damon-tests: damo_tests.sh
ok 8 selftests: damon-tests: masim-record.sh
ok 9 selftests: damon-tests: build_i386.sh
ok 10 selftests: damon-tests: build_arm64.sh
ok 11 selftests: damon-tests: build_i386_idle_flag.sh
ok 12 selftests: damon-tests: build_i386_highpte.sh
ok 13 selftests: damon-tests: build_nomemcg.sh

PASS
