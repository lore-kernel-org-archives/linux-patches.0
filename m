Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5C71CF2B7;
	Fri, 15 Nov 2024 18:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731695172; cv=none; b=Ou22IdjDwzMzbe18fVcXI6i0ev/6ebux9ud4KoNOvc+WGw6FdMNAsXYndMysYuAZwM8kN4lsRSkR/ZWR8pMmRqwMdmlvRlBwD74qG6iqYFZ7q7uVI9VMFLnWUwQMN7alDst+2orH20sNUUcDpyIR+iGDlmwsIuZ/B0X+vvZREFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731695172; c=relaxed/simple;
	bh=EsqiAzcPAp86m5J+JWKrepSL4HJDwknSWzoJuw184LQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EplYh+2lmA+yvWihV8+Jv4H2SXANuy/kzrwIyKJUwYswEW8z3i9tYQcepCRg77eDeJRagLB/kEjM6OSqwn9v9WWNjxW2RvPzjzU+Dppz3SkXliPiYAiSV56WaiDyYPgz53EWHg+5QXLjyH7lcLc3/zTQmxV7MxiP/H+TBoxr8vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D7UDkou9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D7UDkou9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C2FC4CECF;
	Fri, 15 Nov 2024 18:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731695171;
	bh=EsqiAzcPAp86m5J+JWKrepSL4HJDwknSWzoJuw184LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D7UDkou9hHH7JwDFMrTk2fyGFTEWGV0hND8x2+CRuUccm5x1jmidLR+nszEZAQxxT
	 sGlOPBRBYZcOuy075T/Jks0jg5uuitK/FMJcGDRW/jkhokQroflhkPlgDXdtrnEMM4
	 kh9QhBXYerx/CJKcb8fl7Ad/qwDwAehFHfhz510c2wi6e7W4HmzVdQ3Sp6U5Mt6VEO
	 e9NxI8RqRC5kxWKkSe1FvbEYJK8fzNaQSRF/TdYEo7YURo3dZ30j6ApKazV+qSmbyt
	 06clhI5lT4VHgM+J4P1cWZiUfKPKbKTgtFIuv/s7Bb9YCpNTiqf10P1wJKuSQB3M63
	 1rXT/6PEsE3LA==
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
	hargar@microsoft.com,
	broonie@kernel.org,
	damon@lists.linux.dev
Subject: Re: [PATCH 6.1 00/39] 6.1.118-rc1 review
Date: Fri, 15 Nov 2024 10:26:07 -0800
Message-Id: <20241115182607.44021-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241115063722.599985562@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Fri, 15 Nov 2024 07:38:10 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.118 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] b9e54d0ed258 ("Linux 6.1.118-rc1")

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
ok 11 selftests: damon-tests: build_arm64.sh # SKIP
ok 12 selftests: damon-tests: build_m68k.sh # SKIP
ok 13 selftests: damon-tests: build_i386_idle_flag.sh
ok 14 selftests: damon-tests: build_i386_highpte.sh
ok 15 selftests: damon-tests: build_nomemcg.sh
 [33m
 [92mPASS [39m
