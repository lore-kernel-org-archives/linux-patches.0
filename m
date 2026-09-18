Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9377950E58C;
	Fri, 18 Sep 2026 15:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789746857; cv=none; b=TJ/b1WfSsochh5NpZNdqYlQa3gelxguQUBrIGpyJSWoVfKzy1EGB7GGlveU36GPHxGxOaRkO4UxQCali8P5bEdBZgY6ijuLnVBCWQV4heD3LrW5a9ukfh4FCz5e5AcRE+TPTTrhGJZ91oq7JSCNI4dHEH9XyHL1Vv3AzTWf/qto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789746857; c=relaxed/simple;
	bh=3s7VlBXzyG/7kkPBeLoAsKSYxsk1tpal6C8re4CJx/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/Ep1kn8sOt8k3N3uEimbXT1Ookhjn8oeLJmX1QQuEAW0UyExiuEkVWyKXHVwDTIs7XAM9HuTAlTDBrfwKIfjOF/LifN6vXbXpf/t5OfyDch6Q2YP15pdKxW09ikujVNBXuW7udvZmFenVTIRYZLx7J5ZfuoPQemHxgwgWSYSPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M2csbtW7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M2csbtW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB621F000FF;
	Fri, 18 Sep 2026 15:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789746856;
	bh=Y2vNMwDTnqcaVkXWIfYrhaeqbE/xwCCl/dlgb1QGIp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M2csbtW7rMlnqlWP9OYhkOYw0fYqp8jO/ODx1nvxvIrQ/z5/IkeqMiADtNXtXZmv/
	 AI08bg3croc0dnePAJ1Zm2gtJwX2ruOkJQaM7iW0Mys9xvSpC6c+97EpsRAWw2uJM3
	 dtC1Gbtbk0GATB31GjT2Bs3taY8Mwl6iP55zkTQxxPjGfO5n/lCbC89NkbnJx20Qkx
	 zM+QIdULVGFDSD878yLhfC9EUFZwFIwvk6ZmvxhS3emswPrYSgef0XbQ3qywTUZ4vx
	 p3QJzQGKTh88cE+WfwT/IELvpZbwVN+FlvrlQh3Np/2ivcdKH59o4+SUySF47d2VCi
	 z4LdzK4z3b/iA==
From: Sasha Levin <sashal@kernel.org>
To: Brett A C Sheffield <bacs@librecast.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	Peter Schneider <pschneider1968@googlemail.com>
Subject: Re: [PATCH 6.12 0000/1102] 6.12.111-rc1 review
Date: Fri, 18 Sep 2026 11:54:04 -0400
Message-ID: <20260918151137.2101477302-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <0dc35fd5-ee4c-4140-b154-78a49981ddb7@googlemail.com>
References: <20260917151539.408551884@linuxfoundation.org> <aqxBBu5GXVhHcqTz@auntie.librecast.net> <0dc35fd5-ee4c-4140-b154-78a49981ddb7@googlemail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Sep 17, 2026 at 10:19:33PM +0200, Peter Schneider wrote:
> When I revert 22ae428b0045981bd19f8c75f700a67198062f32 from rc1, the
> boot crash goes away and my machine boots successfully.

Thanks for confirming, and for the crash photo from the Ivy Bridge box in your
earlier mail - that is the same bug. Dropped from the 6.12 queue:

  b1b7c045e808 ("mm/hugetlb: initialize gigantic bootmem hugepage
                 struct pages earlier")

The backport relocates gather_bootmem_prealloc() into page_alloc_init_late(),
which on 6.12 runs before anything has initialized the per-node
huge_boot_pages[] list heads - upstream that is done unconditionally in
hugetlb_bootmem_alloc() since v6.15, which 6.12 does not have. Any
CONFIG_HUGETLB_PAGE=y kernel booted without hugepagesz=/hugepages= walks an
all-zero list head and faults.

> However, then I have another weirdo in the dmesg output:
> [   65.573307] WARNING: CPU: 14 PID: 0 at kernel/sched/fair.c:5303
> place_entity+0x13b/0x140

That one is a separate 6.12 problem and your follow-up bisect nailed it - I've
replied there with what was dropped for it.

-- 
Thanks,
Sasha
