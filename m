Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983E0EADC;
	Wed,  9 Apr 2025 02:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744166084; cv=none; b=UsDvKktO9/ohtvCZhSS6RIB3w/SqmVp0gm9/dai9g1WAkv5clyqA44Da5fpB4q3Snw6WHQyS/mberibi9r2DqS08cwOlALyDPELpgO2vqT2n/qdbTEiHnj3///nI+k51qc+xNe8yhl2ZcGdOJrAy6mdfLBDea+Uw37ESNQ0q3Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744166084; c=relaxed/simple;
	bh=3OPsoSyOCRmbwNgVJr3yBADRd7u4r+Ym9qfIAP1ONZk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ajFfTPtXqcnwUULzNKx3debNkJsjdbRcyAKiB11IUAKRmvHigIH62mepIVt2IyOmibnDNvvtDS+3p2hF2yq/YMO36o+MHgLsHA3+/YIpajGSD5Mh18u2HdqNT39KN6T+ueTgG9Wpx28YLDNOGPcVzp2JMR0tjaaNrMhWDLyR0P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W/7i8wUq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W/7i8wUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A24C4CEE5;
	Wed,  9 Apr 2025 02:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744166084;
	bh=3OPsoSyOCRmbwNgVJr3yBADRd7u4r+Ym9qfIAP1ONZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/7i8wUqVNGQOycaefV739Nj2qNcjPDJRMOm3DLMy4aZFmYZuI80/upigwk00DcCc
	 5BBi5bKeFeTSrOdJOfTMn1xB7I4hl+5Osn9PwMQAXEMBM56r4yqye9JJ7nBhn9VO3l
	 jYt89jpv55pIoNPw/lREWarejrTXFbjpZfvv1wp05iuoF+oqAx843Ikg4c6257Xaf+
	 n9RapOqWwH4/wnldGRjiad4/iHeE9E7JKPGmYukHBmAcxDXervfxaVQHlY9FbA1HjH
	 3d/tJ+u1gV9eJb7QVVVyP7z9p11VwWiNHYGEvBgLqpE+9zc98zCgORudA99YNdqxP3
	 Nn1Qbf7k1M2Ew==
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
Subject: Re: [PATCH 6.6 000/268] 6.6.87-rc1 review
Date: Tue,  8 Apr 2025 19:34:42 -0700
Message-Id: <20250409023442.70329-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Tue,  8 Apr 2025 12:46:51 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.6.87 release.
> There are 268 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Apr 2025 10:47:53 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 5c3c45826e66 ("Linux 6.6.87-rc1")

Thanks,
SJ

[...]

---

 [32m
ok 1 selftests: damon: debugfs_attrs.sh
ok 2 selftests: damon: debugfs_schemes.sh
ok 3 selftests: damon: debugfs_target_ids.sh
ok 4 selftests: damon: debugfs_empty_targets.sh
ok 5 selftests: damon: debugfs_huge_count_read_write.sh
ok 6 selftests: damon: debugfs_duplicate_context_creation.sh
ok 7 selftests: damon: debugfs_rm_non_contexts.sh
ok 8 selftests: damon: sysfs.sh
ok 9 selftests: damon: sysfs_update_removed_scheme_dir.sh
ok 10 selftests: damon: reclaim.sh
ok 11 selftests: damon: lru_sort.sh
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
