Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F361B86D8;
	Tue,  9 Jul 2024 18:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720550489; cv=none; b=RgK7GM1jsUKBfVlQsrvHNCFOV1yvsV00zMjASdlrMxL+/MODyauVphxeWQCH2vAL1T14N1nCTlcASTLGJzpBIkVK7IhMcAcorz3PIlF8yrN/sjoYs3R+05U+pwnCOIYoeDmdjVX0zJmGfORDibc1GVMwzcu2fPiewKM6iMaWGKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720550489; c=relaxed/simple;
	bh=8Ey1es78R1JXJmlxmcEvZ9ryqUGX/0PE4tOhxo3U4BI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QQYBW/sDpCFyulJek5KJ5x/azvj8IDTs3PSIMj9Iv2f7YZQZOjnEeQZRPgjpsS0MVNw1BLBV1OZ9zVJ7+MSKvamjNW0zEVoAt/HNWSiiYm5Og4eh2ZzbZ/5+c999Wb6I+4MiwGaIo3K3ZVT83t+Uue4nads0IRw8kIMFkThaM2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KLU/oT9t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KLU/oT9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0F4C3277B;
	Tue,  9 Jul 2024 18:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720550489;
	bh=8Ey1es78R1JXJmlxmcEvZ9ryqUGX/0PE4tOhxo3U4BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KLU/oT9tAy7oXBsJpQQtFVRd1oTr2fUJiW+lZcGGLdZC4yj4a3oAUmzT/IZ0nYFdm
	 aiHgb2JsjESujGlFsQ5TYOC0iwsvMq6YeEWJSDjPhflSYsogz/ZIMJ5BeWNC8tPXtQ
	 PCHCU5CsArxcPZluEOEfyuM4pS+nNAEwUpHkDWOP9QLQkL6+yPDBpSyFu/5K97YM7W
	 2TnD9+MfMPHsLaOQzk7RxJD+bVc/vR/ajw+4/ZfOYR6D6XmcJANFw0JMCCF/f4GadA
	 RSBkO4nbMjAYBIGHRoIDeBqL1JVknNqOFba/JsTwOWuIU2yJtVMftYysjEUgs+De8x
	 OdQjjqYghVFTw==
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
Subject: Re: [PATCH 6.1 000/102] 6.1.98-rc1 review
Date: Tue,  9 Jul 2024 11:41:24 -0700
Message-Id: <20240709184124.702289-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Tue,  9 Jul 2024 13:09:23 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.98 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.98-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] b10d15fc3848 ("Linux 6.1.98-rc1")

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
