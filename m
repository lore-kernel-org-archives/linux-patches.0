Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22D4471CEF;
	Wed, 22 Jul 2026 16:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784738619; cv=none; b=E1QoStNWHyTxWB7Aj9bVFVq2r/sSk+nsBl/BAUfONNpLJ6/3TqGDU7vP0pjsd1/D368aT9zjBUnKJpuQdk/zNOjN2AEWvwwBMsNUrgTFDaVXgXDlT8VcDHVXHDWQceoPeh2gDjc0IDcBmySi0DmYm6k/9bLGEYhGaJ94TFCnKZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784738619; c=relaxed/simple;
	bh=XjYmCDMzYWYlPMl7zStNn6MTQiqYP3kthFphvhqNbBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KH0mPCio7mrXd5DE6umIV+FQhlCYkXq69pKxenJO9kFDFbNr1RU+45w7bCEPdQ6fn2rKkulXVlsNIToAjAnLFIGbvIRdtgfIsrBJmu+1UFfvFaVtn6yXYw0PRdUv0sseoDU3kQaYRxfutlRguUzhkJS1+BWeSs2BL5cMhkzWseU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=frFMMjw/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="frFMMjw/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A061F00ACF;
	Wed, 22 Jul 2026 16:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784738607;
	bh=8zDLUS0bxfHwOpEZiuLxrdyTwvpr5eTnLI5y0qRTQxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=frFMMjw/9WZCRrWn9HMsy59FxL0zNi+hvPx15mf+7ITLRmsKINtsz1mHqtW10HjjM
	 P/G85OGf2n6XQOKQVuPJt63b4KqNusq08aGWk+q7lPMcIJya6+nv7XACJ1xVdcR1OI
	 pjUGNIoss0NHU6O0X9b/h1egcKLcy840V0hdYPO6ZueakuuVRnXq7Ec1XLtyk2uZO1
	 P5PeACYwHxSOIFWSx4y4AXS/UTPGwalVEtUe/m4+krX4KfcSVllwnqtXQvlzgtrH7t
	 eXE2lrOzTMMlf0uvRX5+4Zkym2npBO8q7M9oVrRhpEUtIl2FhRWJ5RSoPahWLAWr/E
	 sWSX7Oo5/ANow==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
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
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 7.1 0000/2077] 7.1.5-rc1 review
Date: Wed, 22 Jul 2026 12:43:16 -0400
Message-ID: <20260722113506.rc-reply-0006@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <b7e241f0-2604-4609-ac21-483b95757e10@gmail.com>
References: <20260721152552.646164743@linuxfoundation.org> <b7e241f0-2604-4609-ac21-483b95757e10@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, Jul 21, 2026 at 10:54:18AM -0700, Florian Fainelli wrote:
> builtin-sched.c:1196:34: error: 'struct perf_sample' has no member named
> 'file_offset'
>
> which is due to 6018a2a9ff1baa45426f7a52f8ec4f7d32fedfce ("perf sched:
> Replace BUG_ON on invalid CPU with graceful skip"), we need to backport
> a490187f22b4bfae7ef752edbe3fb13017ca11c ("perf sample: Add file_offset
> field to struct perf_sample")

Greg has queued 7a490187f22b for 7.1 (ordered right before the
perf-sched patch), so this is resolved for -rc2.

The other two perf build errors reported in this thread are covered as
well: the libdw.c inline_node__clear_frames() failure is fixed by
674dea094ef6 ("perf srcline: Introduce inline_node__clear_frames()"),
which is now also queued.

Thorsten's third error ('evsel' undeclared in
perf_session__deliver_event at util/session.c) doesn't apply to the
queue itself: that code block comes from upstream a2e59fb79f449f
("perf session: Bound nr_cpus_avail and validate sample CPU"), which
isn't queued for 7.1. His local cherry-pick of 7a490187f22b pulled in
that surrounding context without the evsel declaration; the backport
in the queue doesn't carry it. I verified the current queue's
perf_session__deliver_event has no evsel reference and that perf from
the current 7.1 queue builds cleanly, so -rc2 should be good.

-- 
Thanks,
Sasha
