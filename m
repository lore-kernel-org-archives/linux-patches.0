Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47AB1C32;
	Wed,  9 Apr 2025 02:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744166132; cv=none; b=KTjSOr0M4ZKzfZP8QHKl5sSmZ/+bv+/VC6le/e43gZZ5070WhTGLxcsVI3uB5uAE/TPySd9IZ/jlKnnMqKxUKZWURBpuM0EMdQIyhv6RgGTa1PSscOMtlUjGsalUu4/hTcTYrRrlE/7YNIZ6R47vJ/zIb5EVD+f0bkV296TOob0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744166132; c=relaxed/simple;
	bh=PwnJt720NH3QtrIqn/6Bl/e/bdsRC55t0JLkYbp6T8E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UjUf2AjhkUj2cezR73NbBx6zvz1HKyymW6/N6yBWUU0owXvSXjvVekU5oeqlT97p02hGsFkk4MlOk7/pSogSKGZvBPMh8+wRZay0rfRDp/+3HxPqawld6Q7JTqyVTJbVypB0V/K+GmMqK0jz5tTyxNg1brZ/YDA/Z/iGaZIuQf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EfHU9oTF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EfHU9oTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D72C4CEE5;
	Wed,  9 Apr 2025 02:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744166132;
	bh=PwnJt720NH3QtrIqn/6Bl/e/bdsRC55t0JLkYbp6T8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EfHU9oTFsSj6AkvMZ9Nbu5GUdM8IZYJ/SLdKY8gU2emh+8gxVjoYh54Ur6AMK2GQc
	 OljyPlVMkfC+k6jd6b1tlnPF9Rb1gOgYxlgL5AvKXk5lRqpDE4uzHlsL7GFUGxOzdO
	 p6399elcuVH6gJUy8rs+XnggkFy5/uzYAAga4BBdeWyRtq+8kXMrc0xb5fYh+G4RW5
	 +VHgE5oG0IbUgwTzpj99VF6weXeE1cLxst6ehl/XQ+wgYHv2EmkDz620ZH4EKcIa3H
	 RsTq6utVe0EF+Bw/psIx1qpEu/50nWGkBqiR712wl/LKQNe7h/mLnAOrfXKzzxmNN/
	 U0lXh9EG1rXDA==
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
Subject: Re: [PATCH 6.1 000/204] 6.1.134-rc1 review
Date: Tue,  8 Apr 2025 19:35:30 -0700
Message-Id: <20250409023530.70397-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Tue,  8 Apr 2025 12:48:50 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.134 release.
> There are 204 patches in this series, all will be posted as a response
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
[2] 41c273b7c6e5 ("Linux 6.1.134-rc1")

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
