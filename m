Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA9684D13;
	Wed,  9 Apr 2025 02:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744166181; cv=none; b=ndE41kxggC0G5hn8Ea7MOprSzl4H05M8Z1POo3b7tVA+lw/lorBXHPqKHxmLHIlUjA1SEBTl5aq7KpP3yFzYDYWWjiKz/QDQpFn/f47DWPmlwcd7jYBAPClWXh7O0AKQIQpWa9iQM2cJROmsZRv0UrS3SsytdMamaQyWOSU4A4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744166181; c=relaxed/simple;
	bh=e30ZB3HYy50+lqVsFSuwMLvoDoP41VEnsYY5MoZEUFk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=upgudv3n+yxebPUj+fM4HICRNbIocbTkGCQrRJjWitLXICkgjjcJ0r5mDS8HFzoAR7OSKZFkWfRKj6gKv6BaFZFJO5TL3AeuH5VYwx9BwVLcykHpb8R1u3al2x8LSQhScwVKl3FKCnmUC33JolUas/+m5UI8mr7qowiciCzLiRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rjYydueC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rjYydueC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA74C4CEE5;
	Wed,  9 Apr 2025 02:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744166179;
	bh=e30ZB3HYy50+lqVsFSuwMLvoDoP41VEnsYY5MoZEUFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjYydueCPaqDR1tLI0+kj3WkRPT3GU0ElQcQKVvhTzcRv6rXkjOvUtVy3p+ZdF9rS
	 wKuV1H+PlA+czyjV3ucbk5rtPGBaIBHXYSAhQxXqL17oMhsli/Z3RAhtf9toS61hY3
	 H6FC0nW5x8v2WIIYgiAKNyC9vnVioq/TIcspbipmP2M+IytWgFSEzIeLjWHW6zfPFf
	 4s9dqUshIHmLF6Y6hV0A7AnlB85chXYQUaglRDgPuCGvTRyF8kwYKQMuUM0qow8OP5
	 6e8YRfMbnkZsLON4pI/qqiaMThBLkE4Y8qQxBsxrwjgDy0hwmJWp/jC7Q+QLRhrbZ9
	 UZ5NCp86KvMKg==
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
Subject: Re: [PATCH 5.15 000/279] 5.15.180-rc1 review
Date: Tue,  8 Apr 2025 19:36:17 -0700
Message-Id: <20250409023617.70466-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Tue,  8 Apr 2025 12:46:23 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 5.15.180 release.
> There are 279 patches in this series, all will be posted as a response
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
[2] 0b4857306c61 ("Linux 5.15.180-rc1")

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
