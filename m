Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E18B7494;
	Tue,  7 Jan 2025 00:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736209325; cv=none; b=hoNdgtjghBWc6KsSAitUNVuw2gsmxZcne1pXa3mKS8ENArLEKjj/QVrmwAYGvkkxEtAlGe4xe282gl4Em4RyJGC/b9M8J4YEk2n089Fonw1/Fue2GmgK4fcHN1/DZWcZj+T1sWD/OFanYrZwTzANfgv05jQ9t2cXrFIO7asQ6nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736209325; c=relaxed/simple;
	bh=vNLeIITazBfKV+5Hkah/tvx2KR7IIZs4ktCjugx5Rj4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mfC1KZ6Y7lK0Gmas9xp4WhkBOnIWTXLDPryM2Mm9txC/mFhOWojWgms563XRhCIuELtpgC1vdYn1t4w5lMSibrx2aMg5gI/s/RmdERaSsm16m1Lax3MzKPHve7frhbDuTyY+gxl90fIuZ06d1pfEoqzBXlk65gItf3vCuESdCg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o5azS/hn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o5azS/hn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAA7C4CED2;
	Tue,  7 Jan 2025 00:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736209323;
	bh=vNLeIITazBfKV+5Hkah/tvx2KR7IIZs4ktCjugx5Rj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5azS/hn6tIJ8wPz3n4cXx1gp5DvX6CAe3ogGzndwGtbh2DTdqmI5pMwfFAQhBbx5
	 7gwBCLfhBtkXr7GwMd9f+SYhg2W0BhsIPlVfRsMgTiHtOSbjtHU3Asqbww3ojrFYmV
	 f0kRTPmcrRU3fy3CP6QLxjZgNnI1jWeUqdsqc+4bnteTZ9hIhKSK6IQgwappyWtrms
	 RS25c1Vhx3dH1aznv/6bh8pMHdOydoSyEP1/ilAe3IZOoPMq2V4U3868JHNH+4VGy2
	 WlaAXoi09FETdI0K8bLdr/HFe/CS7vYGpLn5eUK1B+jzPRczKjWEGL+/9ZNmH1xPie
	 +1hvr7+vsn2qQ==
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
Subject: Re: [PATCH 6.1 00/81] 6.1.124-rc1 review
Date: Mon,  6 Jan 2025 16:22:00 -0800
Message-Id: <20250107002200.3714-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Mon, 6 Jan 2025 16:15:32 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.124 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr
[2] 88f2306b7d74 ("Linux 6.1.124-rc1")

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
