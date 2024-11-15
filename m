Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8861D1D5CEE;
	Fri, 15 Nov 2024 18:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731695125; cv=none; b=lmcIwPu2x5Ov7D4W7r1v0tkbwL0xt33/YXzngjFlHe5mfojthESg0+wUiSsx0rZmZzB0XSHsydM9ZtXqBK7p/fWowYNQD1UJNFo7MYMzJUSjQysticMZEq5yjPLYC4kfYJDQ40MKdRTjCOpQkMJhftgj6csuyry8OKUH82m1FUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731695125; c=relaxed/simple;
	bh=BcSbNF9ytPNrkCKd0d3FwDCibdkRmKB7zaLI37H+I14=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mP0l52yqBsg71Vl5cdYiDqe+MTf6Ug8HnE3NFvUdnnGtEtgOC4G3+DFxfzQ32UYTD8dejStEow8EVDO+vjVbS3giCxt10Q72MPEt+n9pWaBD5dvlf7CeJ2Tm0WyYC7WvZzXZLHnLY5uxXNtY9X7dvDk/JaOfK+iEPdlHoMO2ods=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X4i7ryaZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X4i7ryaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB33AC4CECF;
	Fri, 15 Nov 2024 18:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731695125;
	bh=BcSbNF9ytPNrkCKd0d3FwDCibdkRmKB7zaLI37H+I14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X4i7ryaZ+z856TpcMTuEwQkjfcyvmyyMq0Y57GGaFP4HP+f2DJiDzTfFBIyt9jvcf
	 +CZ/SLijmiwTbf/Mabeb8fj1GnKGLRHyXxJ5hz1Z2/bhDrWuF1np6hNlOJyoFJZ91f
	 qfNkwdwxKj1NKKGLdq07D9gq8hL+GJXTW0E61A+voIzRngUs9b0kONrkFuwrR7sYct
	 Tfd6I9hTT+sf8bT0GDHRiuPF82Ww41CA/WEEKH6F49LWLP1NxxL4aBjcDoHkaVAKNw
	 L2e25eUvlpUCh2Kqwo3izIzt72PRYDgSVbmHse3g1ov+Vrg1GYD/ebylueUTHD4du+
	 38egHUwY8l5EA==
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
	broonie@kernel.org
Subject: Re: [PATCH 5.15 00/22] 5.15.173-rc1 review
Date: Fri, 15 Nov 2024 10:25:21 -0800
Message-Id: <20241115182521.43956-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241115063721.172791419@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Fri, 15 Nov 2024 07:38:46 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 5.15.173 release.
> There are 22 patches in this series, all will be posted as a response
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
[2] 056657e11366 ("Linux 5.15.173-rc1")

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
