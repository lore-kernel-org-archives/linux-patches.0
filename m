Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1561642125A;
	Wed, 16 Sep 2026 19:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586966; cv=none; b=iPmlTMpO6KrMufH3dDGwvRWQL9o3JyddSnBGA4BMyAXbHv+8C3/1NR3Yl9MAdF2fgSxgeUttHbkkNXWra+jpWe3+toXua71iNIR2+hskxXv9Gc/6tqAvUWH72XtllyVNtT0VzCwWUbMz+SCARvKM+pYjtCLcPLzT2fT9lACJwh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586966; c=relaxed/simple;
	bh=pK3nF7jj0769vMvEIJNEPnhetYLbRoRPEE6KgxaQn18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RLhESE8fOOq/jnNypPqblYpcYn7v9DMcZwg7ORNOvKVWq9Gq+rK/OlpEBQWrJBi1gstMKjAjYcQE8RCtTUeLY2VfHQyJC8PKJup64KOOcqXGOSUMW/nGfPiuFhm9qAV4/JbOIt+T8UIanH6IzAgwPBlTojX2ethZRIsJlsgquXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IIe52iSA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IIe52iSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06711F008BE;
	Wed, 16 Sep 2026 19:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789586943;
	bh=hQvVovAsk4MfMfVt3dCWT7eSlsH9bgSlNla/bSeMA+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IIe52iSAYbJtgF4JVNN8kS8XX6AY8PdObMQGnXuGzBF3aABqivPG3HHfKFQlDla3p
	 rfaQ00VTLJ6amVhbuEOBGZMkE4SViPMO1OL4zQWrF+7WOZqDZctRGZy1RrcNvC/Z7I
	 HvAuZ8DPlmcDT0InYNqlPEqiJCE2dyM1gHbx0COFPy1L4RARfoZwkNH8u/dEIb+n7y
	 QOcVLI0XawN8qPfEQh+kOOXqvv/e2fAuMcHOUCvRuDp/8HvVdR2h5CoVWEe9k7WyOD
	 6Jm6AF7r2pei1J0xnSCrq6focMo8Ux5Z0Y0pfJ6MhMiKvR+8z2LP7UV4D+hpqoDYBM
	 X/PPmQ8b8dbeQ==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org,
	linux@armlinux.org.uk,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	rostedt@goodmis.org,
	rmk+kernel@armlinux.org.uk,
	linusw@kernel.org,
	kuninori.morimoto.gx@renesas.com,
	arnd@arndb.de,
	xiqi2@huawei.com,
	ljs@kernel.org,
	wozizhi@huaweicloud.com
Cc: Sasha Levin <sashal@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	lisongze2@huawei.com,
	wangbing6@huawei.com,
	Xie Yuanbin <xieyuanbin1@huawei.com>
Subject: Re: [PATCH 5.10.y/5.15.y 4/4] ARM: 9484/1: enable interrupts when unhandled user faults are triggered
Date: Wed, 16 Sep 2026 15:28:20 -0400
Message-ID: <daily-reply-20260916-0031-re-arm-9484-already-queued@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260916080011.170295-4-xieyuanbin1@huawei.com>
References: <20260916080011.170295-4-xieyuanbin1@huawei.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [ Upstream commit e79ca91165d4fd18549c536abdb86101e889052f ]

This one is already queued for both 5.15 and 5.10, so please drop it from the
resend of the series.

-- 
Thanks,
Sasha
