Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5487F1DF276;
	Mon, 28 Oct 2024 17:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730137823; cv=none; b=BH1EZVyT92PsbgyA5Hym66GLWCqwKjBebixZtb0mkOaxBgMtKcpPcfyCEERs7K4yz3Ef5W3XYCa51C9wx7A4FcEYMP7MmxO33j0RihRCKJOJy9p+eRnabFLNOwcu/9w82pBkTFeNHHdne7yx47dzULoBrmk4dkmpCsVroWu4cTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730137823; c=relaxed/simple;
	bh=BxbX8cBELmSBhogeubFLvo0Ofg2j8Rwst7VjqZwf6Gk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MVmrAX2qGvXPQzMEnGdJTo3jjWIlPt4+gUwGBnTnBGIPB97p7a7ZFCeedixBGqTSb7xxvQAoZZFvdqMflGU+bo3WrBn3b+slRt0+mVEU+NTMxwzSRtIW8kpDXU1JdxMnCcn4PcBooB3QhOu1e44w9oUYodjS8HqFzbMg8eO/uF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QHeyBgs9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QHeyBgs9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5EBBC4CEC7;
	Mon, 28 Oct 2024 17:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730137823;
	bh=BxbX8cBELmSBhogeubFLvo0Ofg2j8Rwst7VjqZwf6Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QHeyBgs9Wl25rp+MaqCfHT5qdVBARCjv+gCnyyi5hwPsUjsIS5zBjvpwR67K/8/s7
	 pfMe26xZuUlDaOw+CDNblr3szL3mhUAlc/C4/Ej7ub1F+B67DL0R/pQuSkA7tZJEQc
	 iXxXF18kW1XOLMFS3g5QWTzs29IqJkrSal4B6ZKI2OhWegDpfWSZMn08wDQcdRhhgD
	 NXS5H8zaNcfhH3Y+pb/4oYXGGWP8P4zmT2HU6jCPjJaZlnj77nY1IvciZ7RF1dyOvp
	 JAbIoNw47SZyqH9WN3va1S0Lu83WNv+P4Iu/MggWjIMMaNlNMjM/FXf0o8MfuvWQER
	 j+pH07/btcnnQ==
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
Subject: Re: [PATCH 6.1 000/137] 6.1.115-rc1 review
Date: Mon, 28 Oct 2024 10:50:20 -0700
Message-Id: <20241028175020.276656-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Mon, 28 Oct 2024 07:23:57 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.115 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Oct 2024 06:22:39 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] eeea9e03a3d4 ("Linux 6.1.115-rc1")

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
