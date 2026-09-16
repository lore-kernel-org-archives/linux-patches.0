Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABA13AEF54;
	Wed, 16 Sep 2026 01:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789523569; cv=none; b=CnK2pIuswUNefiGGLULHJmv0mx40m3iGS5HqFl/kBe/ltw68Qmcw//ymoIzfUXHaVoT8457f3fvsp2pCyjKyBuD2sSMwtGIiTVwRCCOMONh5RJJBUasyo6beayDBbCSj2LRVBzigMIn/RHyPK5tiZPp2fH8dAUZzrRrgRmwc72A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789523569; c=relaxed/simple;
	bh=XFX2xIv/sy3XoBm1x2XRF/nO4jflpAmdNmV9poizng8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4jljrAJestU1Ux0bhzGIMYPGALFvl6hH13L7ffB66JXLOyYfZe558L6+1uR8JfBfWRtm3j0qPdxna7VfCnQ1z2BVpl3DKJhZa1/QMAlFUk8A45KXU1lE69H57lPPetl9R4cRcfsZd96UBJQa3UcFrkgWJ8VHYYNv3g91Rsco1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kEDzbxwT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kEDzbxwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D08E1F0089E;
	Wed, 16 Sep 2026 01:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789523551;
	bh=LVXuVv26svLlY4qbCrxJiy9+/zg1bsfvPN1rCoBQlH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kEDzbxwTEhZBEFnakuxM9EiZoE0RCl3lsRgh6fjHhU27w3YyyTVVDP3e8O0urCXAq
	 W4mX7l0i95nha4dcUYlLmXfqjlCArKEiQqSO6lJ83ibA4MVQL5CkgSW/kX3Hn/vdvd
	 RdnXklF+expMKrsC81/rokD+vT2XlDgp1avSZTNTE9INW3ju2hup77pgk2vAX4eLpB
	 0dz4WsDNLA2OIt+xR9evDH1XgErn67UIA76DMExkwSCU7YdjLtERefT/1v+ThGAJZ/
	 df3f1dbSlPo9Wu0QnDlono8Y2Tyq8hY/kddstVl0cr6GL3IRp30LzlypCApX14cjTc
	 4rMFdHwRGYStQ==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org,
	linusw@kernel.org,
	rmk+kernel@armlinux.org.uk
Cc: Sasha Levin <sashal@kernel.org>,
	bigeasy@linutronix.de,
	lisongze2@huawei.com,
	ljs@kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org,
	wangbing6@huawei.com,
	xieyuanbin1@huawei.com,
	xiqi2@huawei.com
Subject: Re: [PATCH 5.10 613/798] ARM: 9485/1: mm: acquire mmap write lock around show_pte() for user faults
Date: Tue, 15 Sep 2026 21:52:12 -0400
Message-ID: <daily-reply-20260915-0007-re-arm-user-fault-irq-chain@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260915033519.16922-1-xieyuanbin1@huawei.com>
References: <20260915033519.16922-1-xieyuanbin1@huawei.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I suggest that merging all these patches into the linux-5.10.y:
> 1. commit 7733bc7d299d682f2723 ("ARM: fix hash_name() fault")
> 2. commit fd2dee1c6e2256f726ba ("ARM: fix branch predictor hardening")
> 3. commit 59e4f3b45b96a24fc9b7 ("ARM: ensure interrupts are enabled in
>    __do_user_fault()")
> I tried, and the patches can be applied with very simple adaptation.

Your chain is right, and 5.15 needs exactly the same three commits: both trees
have identical arch/arm/mm/fault.c and arch/arm/mm/alignment.c, and all three
commits are absent from both.

Since you have the adapted patches already, could you mail them for 5.15
and 5.10 with Russell on Cc so he can ack the resolution?

-- 
Thanks,
Sasha
