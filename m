Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64C57DA6C;
	Wed,  9 Apr 2025 02:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744166035; cv=none; b=Fl+bL3yYYk/KkvCONc0diNhsVpcStmqlVPwNR2zyD+gE94Lu/D+jxG1UMoB/Sv0MtMRZwx23lYR2OGEnwz3mMl/0WxPXG17WDpYZNgx3MUG/qgOiOUeg+MmH5tDqOE1DJBP+3R+zdTKhK5Xx3qQntvtjZ1yE/zUk7+kUjLNuSl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744166035; c=relaxed/simple;
	bh=EKFvcZNIYgHZGNztB3K4T8oOE7jCRagR7Yf3yBNrW9I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KqUOrh4y3w9CF4q3h+eYsTYUmo9j04uaRqwTfrH5Vz0lFmwIBlj7zkg3lrxk40J2Qb7zlPzt9+UOGgzhpjT2nJUmcc/TI9IkftPjnK+VCRd6aDQKbohUwMnpnZ55shFzUf5RgxGC1dtYDqoTDB1LB7XIjFcAjxsWO0Bi5aNRiPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qcIX1XMI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qcIX1XMI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B64C4CEE5;
	Wed,  9 Apr 2025 02:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744166035;
	bh=EKFvcZNIYgHZGNztB3K4T8oOE7jCRagR7Yf3yBNrW9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qcIX1XMIEIg6bIJrEiB/hprLJ6FCx4cf+0sn+YdGACW7UIO0S3pqRgFw7l11aOURw
	 pM3iNmZfUvRZ7H0EEKF6nUXxf72NkMmn1PU5EpgD2DCCczVq+SsXtn/1wPqHDrRjx9
	 Q/DJosJp6+hopZxeQkhSP2dDRBebd+VkYCTc0AQVH97WuV6gUftrwQ6GdtJLwtfff5
	 H7NXlcLqeQIMHS+4Ad2iL9q8ziXwxV2SmqtH+S1Ob22JUVaj4rqO4vlcy3ygzNY3Wo
	 PiN4914hiaZB4xryLsIysPS1MgkVo6IRyByBHOZauVxdk1I4lO8jpCucQffb7JMwlj
	 qFYPA68R3ynOA==
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
Subject: Re: [PATCH 6.12 000/423] 6.12.23-rc2 review
Date: Tue,  8 Apr 2025 19:33:53 -0700
Message-Id: <20250409023353.70260-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250408154121.378213016@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Tue,  8 Apr 2025 17:53:48 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.12.23 release.
> There are 423 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Apr 2025 15:40:31 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] a285b6821aeb ("Linux 6.12.23-rc2")

Thanks,
SJ

[...]

---

ok 9 selftests: damon: damos_tried_regions.py
ok 10 selftests: damon: damon_nr_regions.py
ok 11 selftests: damon: reclaim.sh
ok 12 selftests: damon: lru_sort.sh
ok 13 selftests: damon: debugfs_empty_targets.sh
ok 14 selftests: damon: debugfs_huge_count_read_write.sh
ok 15 selftests: damon: debugfs_duplicate_context_creation.sh
ok 16 selftests: damon: debugfs_rm_non_contexts.sh
ok 17 selftests: damon: debugfs_target_ids_read_before_terminate_race.sh
ok 18 selftests: damon: debugfs_target_ids_pid_leak.sh
ok 19 selftests: damon: sysfs_update_removed_scheme_dir.sh
ok 20 selftests: damon: sysfs_update_schemes_tried_regions_hang.py
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
