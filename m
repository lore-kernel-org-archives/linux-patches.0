Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8804F50E5A2;
	Fri, 18 Sep 2026 15:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789746859; cv=none; b=SHnuX3Q09dLJf271eg6YRvX8jFzmT/MbW1TpOcFDdqdrGbGsPNaEKtkwBBqbKN1by+U0/+aypfF8dujlGrhYTJyvXO/UHSMQfJcU0OzXfGIa7H2BLZ6mEzsuCH5zUUb7x9P0AUwfgOTpx7T1kk+RbFS+VYEwOVyVdBbO6iMkD5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789746859; c=relaxed/simple;
	bh=48pWqb5Yj6a7QnjmVJbOWVqwqPuD5kTjTSTV5vGNkxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxOAxHXKrRRrTRCaD3OeV7bsBNVwZrtA15KCousYROlM0iSfq46FmE0G7jXB5rffTPmGNKdy3WcOYSG7WuRhOCY95G4Jl2FPY4ez/dMsUJz/3G4m2OePIUiRIOCSQaVeeqBTVf2TNgitpVMjPsnfXpJlBWYFwZqwbXCOVIEc+6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P/J7oAfO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P/J7oAfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7EA1F00898;
	Fri, 18 Sep 2026 15:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789746858;
	bh=NRNWg8hV1eAfDqRqVZBeUZziA8JOqxKim6N8/iE9Y1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P/J7oAfOfUMV0zLNWpV7CFO4yUtfxZKYHGAQJYiG50qnDcL+PU/8dUyrasN714/p6
	 QCnZNkd/zYgYBrAVmDqApwlfcg13/wwNnSKhfFopz2E9rszTF50eNapLff5YnrCpR5
	 VDLcSK9aqw0SCRKG10Sw2H8PFBE2ACAlGg7YxK24WMLVmXD6FgdUUDXAP8Guk6MTlK
	 ZguRLA4APfDTb45YxdY39nITqJiMlWpbfzFKNo+TNy9K8DUyTj98YT/pMheztTqdzC
	 tLu3vRQ12TREayHoQ+Z1JCkazgLhR5yHHfeUrlsYFw7/1jlLdrPW1lRu3MhAumH3ji
	 v5/OxeFGiZUfg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 0000/1102] 6.12.111-rc1 review
Date: Fri, 18 Sep 2026 11:54:05 -0400
Message-ID: <20260918151138.2101477303-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aqxLGIyiWCdsQoyR@duo.ucw.cz>
References: <20260917151539.408551884@linuxfoundation.org> <aqxLGIyiWCdsQoyR@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Sep 17, 2026 at 10:18:32PM +0200, Pavel Machek wrote:
> drivers/net/ethernet/ti/cpsw.c: In function 'cpsw_ndo_set_rx_mode_work':
> ./include/linux/container_of.h:20:54: error: 'struct cpsw_priv' has no
> member named 'rx_mode_work'

Dropped from the 6.12 and 6.6 queues:

  0b8c878d1173 ("net: cpsw: Execute ndo_set_rx_mode callback in a work
                 queue")

It only touches drivers/net/ethernet/ti/cpsw.c, but the
'struct work_struct rx_mode_work' member it uses is added to cpsw_priv.h
by a different commit, c0b5dc73a38f ("net: cpsw_new: Execute
ndo_set_rx_mode callback in a work queue"), which isn't queued anywhere.
6.6 additionally lacks disable_work_sync(), so it could not have built
there either.

> I don't have good diagnostic for runtime problem on arm. Example is here:
> (hang)

> It is better on x86:
> L328[    0.264887] RIP: 0010:gather_bootmem_prealloc_parallel+0x117/0x250
[...]
> L343[    0.264887]  hugetlb_bootmem_struct_page_init+0x6f/0x90

That one is a second, independent problem, also dropped from the 6.12
queue:

  b1b7c045e808 ("mm/hugetlb: initialize gigantic bootmem hugepage
                 struct pages earlier")

The backport moves gather_bootmem_prealloc() into page_alloc_init_late(), which
on 6.12 runs before anything initializes the per-node huge_boot_pages[] list
heads - upstream that happens unconditionally in hugetlb_bootmem_alloc() since
v6.15, which 6.12 does not have. Without hugepagesz=/hugepages= on the command
line the list head is still all zeroes, so the first list_for_each_entry()
iteration yields NULL and m->hstate faults - which matches your log exactly
(CR2 0000000000000010, 'mov r15,[r12+0x10]' with r12 == 0, .hstate sitting at
offset 0x10 in struct huge_bootmem_page).

Two independent bisects from Brett Sheffield and Peter Schneider landed on the
same commit.

-- 
Thanks,
Sasha
