Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF81C1F03CC;
	Tue, 21 Jan 2025 23:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737503249; cv=none; b=eGMnganqZLujNgK91axdMkEwUzlZpOeYrQmjg2/gKSwsOOF+HDHLI7vKFVdgIN92BU6oJyqNw/XmN+om/20rHXFm6we27yItjoKyHgTVXn6kgDt1WbC0Z3vZ/ShBfJNs77klZR/q/9d0h2q/mS2a9CohEFMm9/USGU2STSo7WDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737503249; c=relaxed/simple;
	bh=eCXZLMg2NjMG6xlsx9Rawnzdfw3zRMUBlUyecHU7eME=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Wt63x7CPmWTJniV2VD3hUSekonpS0HWaPCk0ASWK+H18OeUXNPZ3opLYTtMCj79Zy8zjg+bDp0ZcvZKYEkXGY4DxtL05TK5TijttQ/uOMsG7Zcbyo/SZef4QaMqfTdr8/+dZH1D5Oppi5H2PUVm5oqb6FfBGeoQpngyCWe/oE2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s6sebvzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s6sebvzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA6FC4CEDF;
	Tue, 21 Jan 2025 23:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737503248;
	bh=eCXZLMg2NjMG6xlsx9Rawnzdfw3zRMUBlUyecHU7eME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s6sebvzAaH3saryKYuF6qqKQO55f0rYl0T2RO9ceCM6/tnIjZI0k0An5IlpstB2tR
	 7StVySWXfYsH5pl/TTNSb0Lp6K7hJslMn769m/9ML0CSEOMuiWPTUOf64YOKzlQete
	 nKHoJaw6+my2VPKadZMgUJOE/mfk5x52lAwLTsrJpsRXfbUrG9F4Oe10dIzq6jKr4W
	 VO4EDgVyPS5h57fFiPwnus1wQGtfcRpEBL3saiOc/8cGBGZHNTICiVmuJae54DJHjw
	 KNNz+uFVg5Q2fwNiaEc01Gg8XsCLSKHRrfoCzLn/4Glio4i3ejn3B2FI8slA4HiuEF
	 eI3u8N+UllWbQ==
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
Subject: Re: [PATCH 6.6 00/72] 6.6.74-rc1 review
Date: Tue, 21 Jan 2025 15:47:23 -0800
Message-Id: <20250121234723.46222-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Tue, 21 Jan 2025 18:51:26 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.6.74 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 429148729681 ("Linux 6.6.74-rc1")

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
