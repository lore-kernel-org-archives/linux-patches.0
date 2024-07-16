Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F7B1A01CC;
	Tue, 16 Jul 2024 18:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721155043; cv=none; b=PfOjIUBV0cPwd/EILQRBGmE3khwwlhRSKDWpat2a4RcOhOWlGbBzq/2ZKOc+3GWy3xdMy6hPIiS9P1V9onNTKab/BROnfgkFDWp/fQG3nzxBpMxTTLXMbb6tnn+qRT1FY5JushA6VmvCWgsPhV3cSSWxYoJdhOoROPGTNw5zTzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721155043; c=relaxed/simple;
	bh=2F1Q0Q8KMSSwcAr1IEKnv2KljN0W4M+dYsWSTEL+zto=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h8IUo4Zg+6MW9f/NJQMAySt0Cf+AUiB+DmEioLU6hFWti5seS8RlQv4IwRcmvRcrwc6muRYgxyD5XQZKJuWRzMpqPiiWvWLq0wjM5SPcc2bCEG3XGLaoajjLm0P+5LWd5IohEC6jhyVRcv/IBABvaBGg0SSAvFvX5XVD6j0cATo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AvtUJshj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AvtUJshj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA66BC116B1;
	Tue, 16 Jul 2024 18:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721155043;
	bh=2F1Q0Q8KMSSwcAr1IEKnv2KljN0W4M+dYsWSTEL+zto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AvtUJshjLq/qDPvZXYoJECvrSAETMKcsyixxcDIFNzJAOlGYhpHRUD29gNLS87+TS
	 oiizrIzd+jzWixgDXRCeOhKpsbxGWJ7fptUC25TUxv/Ux6Cuv5GseZrFpnxQr+QDKQ
	 6qx2fMPyo4INA4rQAbYzcfGkE0uJRx/173mZfPpcYIS54CyJg2Ma4WOgFk0+NO/am/
	 Sqo/AfUbXk5cwfSMLN/KuDyyc/Sd6F4ZooVu/O5yfebmAYGgdjt+yzXxdN62rPefr7
	 n28ELQxDGUDqbC/D3Z0HBB4FvVyN8CbHGNZ+O7F3KOukEfR1/BbQz7xd1zk/hTpm2C
	 hm7ZYcwgrFBdQ==
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
Subject: Re: [PATCH 6.6 000/121] 6.6.41-rc1 review
Date: Tue, 16 Jul 2024 11:37:19 -0700
Message-Id: <20240716183719.138589-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Tue, 16 Jul 2024 17:31:02 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.6.41 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.41-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.

This rc kernel passes DAMON functionality test[1] on my test machine.
Attaching the test results summary below.  Please note that I retrieved the
kernel from linux-stable-rc tree[2].

Tested-by: SeongJae Park <sj@kernel.org>

[1] https://github.com/awslabs/damon-tests/tree/next/corr
[2] fb57426efe05 ("Linux 6.6.41-rc1")

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
ok 11 selftests: damon-tests: build_arm64.sh
ok 12 selftests: damon-tests: build_m68k.sh
ok 13 selftests: damon-tests: build_i386_idle_flag.sh
ok 14 selftests: damon-tests: build_i386_highpte.sh
ok 15 selftests: damon-tests: build_nomemcg.sh
 [33m
 [92mPASS [39m
