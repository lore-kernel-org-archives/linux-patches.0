Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E97416C68F;
	Wed, 31 Jul 2024 22:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722465583; cv=none; b=n/bWPsXFA/0PMsT7fBLKpv3Mh8ickcjcWPtqicbEkyUxwTYtCm4kd6eOkTkBB02U0taDDgg4nP+4SlumWMaG6G4VkzWTYYv7z22a6aAQFpeylQnmWCE7es3jVa4hydESrYtUXK2ZZwYOQHsZzjB9TSc5gxQcfzcxPFDdhrzbNlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722465583; c=relaxed/simple;
	bh=JwJgS4ZEi+dNRXnCzB6M5oT1KbGa3Ll2QdVxKK74QkA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O2uhW12gyNNuwLlBlorKQiNDX+xckANwkJVMdkZq3MTd0BH+idbldBbY2UYGz4Ni05l76edYgTPoJXvYgzDbgU/kZD1J8+aaARa3qagUs+ScEmpTZzU6nrPpxFlcpucqpfruV3ZP0SzLQQRp+78ZPor7ZmNLgszJ9tzUt3cY4YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iGAO92sS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iGAO92sS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA205C116B1;
	Wed, 31 Jul 2024 22:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722465583;
	bh=JwJgS4ZEi+dNRXnCzB6M5oT1KbGa3Ll2QdVxKK74QkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGAO92sSuwp1PSSHZR6s+YE4MMYmUIfObWaOXWGgdJX75yaYHme9ZdeaTQanVymzu
	 7YUhC3Ug5TwXuPMCd6F6RzLDTe+6JkGLrwSzoeXumbhqHiT+ZwfhohGnn9/zaA3OrK
	 dmb5qgamOZvCU6OSo6ENiXpArGZzIWPe2KoRI+LVMPkFRJ4W/DLvhSquufJi6nGjn2
	 WH+poJ4vdvI7PUAH3qadSen/aoiSh4OoTcGVbwuGlCp7kwPSz7DyWM9zJbe+zfSgBU
	 zJPrNRYraB/K4fK6t/ZnyzLH0GYjj/+OH4UpovrK4FVUMyZOBUDOz+xuplZdzpUhC/
	 pleSnocXyTyIQ==
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
Subject: Re: [PATCH 6.1 000/440] 6.1.103-rc3 review
Date: Wed, 31 Jul 2024 15:39:38 -0700
Message-Id: <20240731223939.42341-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240731100057.990016666@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Wed, 31 Jul 2024 12:02:57 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.103 release.
> There are 440 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Aug 2024 09:59:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.103-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] dbbffaaee188 ("Linux 6.1.103-rc3")

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
