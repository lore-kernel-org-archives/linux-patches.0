Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAAF1C5D6F;
	Wed, 19 Mar 2025 16:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742403381; cv=none; b=Rxg6cInC8e22xMjGBXyUhO5rZbnuKcbE8xlVd/LQfus9/vDTLLI3A34COvOYN30tdWNJeaNhCjnwrhp1GgLGlds2cRDkh+/nqJGuC88AzHNxbC+Dl9/RW9E6NXysZN8IjCjING0N/Y34EH36XHwY82Dn4fv2WFTX5l1pO8XfxW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742403381; c=relaxed/simple;
	bh=xOyykKkKVbHV35ajQgX6nyRlWd6PAMket5FROPrzqZc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FK1EO0yp+toKeMXrmzk0DtR9/8ESphh12BQ5tXv3tphXzjejg/jJQTVWic4npEOX5WQPIKPqwupqu90UE3boLuDYRT5qpwyfywX4cW3yTRHK05WKuZ7+U9ALMSSMOq6QewuJQo4+uVvaiOUxh4iDPa5sKpvEe/3jS0LKFInStLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oKA+2SED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oKA+2SED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0201DC4CEE4;
	Wed, 19 Mar 2025 16:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742403381;
	bh=xOyykKkKVbHV35ajQgX6nyRlWd6PAMket5FROPrzqZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oKA+2SED+BEt3QoU+EvpoiXY8LbmBL6IPLZeA3DWuRauSSW3ooFHeSVVX6elxdb2W
	 ++0Vp6Rq7c1LWZPu1VFt8FfviLpBhl48OkFg6j6p0iqC7cqBgmgi7UwIFaJEeFlFLL
	 HnDed/AM89QfSvNlxKRUaLtAhXacGn53icJCl7R10pY5JJ+ptpvrNqljocQQyY5AOd
	 o3ajOfhb+by0fvSmLscPeQnJgcMObVVk1iS/qgdWlGh5WZQHUbIswL34Lah+rHx088
	 ea5V4j3hS+Anw2LMdg8UpwQAfVmjWwG3jQhtG+tuSqnUca52MsyaXPvu2bQ2scJ9dF
	 ejBmBhA6vlN5g==
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
Subject: Re: [PATCH 6.12 000/231] 6.12.20-rc1 review
Date: Wed, 19 Mar 2025 09:56:18 -0700
Message-Id: <20250319165618.51582-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Wed, 19 Mar 2025 07:28:13 -0700 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.12.20 release.
> There are 231 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Mar 2025 14:29:55 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 981e6790e185 ("Linux 6.12.20-rc1")

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
