Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CC919F11B;
	Tue, 28 Jan 2025 14:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738075201; cv=none; b=d8bNSw3EUSmyFt10fcItnO+CDrpzbDRvNXaPXVAu8disQwi4D3TPhavpUoQMAXbLgVTPvZSjrg+WtoWb2BL9pfE5bhf6VHeEU2yv0G0sGH1T+fyOOAfyFjc+uYh8o1PUtuCek+Ubv5rLdpL2AkG7CVv5isiS3R463Wu1HhaqA60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738075201; c=relaxed/simple;
	bh=oUcTmcVAmNBZ/NoDI3YkTtH9irf1hslfk+eA3qNUay0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I9yf1qL12hyrBli0N2zSMa0J6UUK/xwyFuQv53wWyeknO9EWzSPDxBIQs2m7AJ/8tDkZhlHO/iweUvq0tBb8Kq4urxV84PwUV6c6ePyDaDxPpFdTepyBbArLAiNrSroCfXgrSTE/LNTTccSZze0dL1qmj/hpfhL/egOUfDtbeAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=koBlIwM7; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="koBlIwM7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=huiVco/j3yKRvxHPwa1DDY+QxVnKZ9Xl4BeWWMs3dZA=; b=koBlIwM7RLZP1G4gVu/71LraDv
	8b1TJvLc79rwb99oP3p4SN71ErJbQ+t39XoJCMRmobl4YNv6syeeOiIM+3cJ1IZyg7VF1VVpzCd85
	v6xG6gQdpMpp5pW5/HriTotehxMQ9/8wVr7CaL9cO8kSf65pNoWKUNvW+6+Qm+ZUmmgeUQIQzqf6r
	JJXY7p9MMc13A3TG/DWrsqaDGVZhaocelraT07yZnDea5XBVIgKrN2/fkL5c7PwOMrZbphoOiZX0z
	I/0pYmTkdKV4L/ooBuEUp8WA19FLhWDJ9z0W9DKBP7u0q/+qBtLypXjy2f16fmrg3jc5Ce+i4TUGb
	2nvfcIDg==;
Received: from 77-249-17-89.cable.dynamic.v4.ziggo.nl ([77.249.17.89] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tcmko-0000000AihY-25Lf;
	Tue, 28 Jan 2025 14:39:50 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 8C6FA30050D; Tue, 28 Jan 2025 15:39:49 +0100 (CET)
Date: Tue, 28 Jan 2025 15:39:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ron Economos <re@w6rz.net>, Arnd Bergmann <arnd@arndb.de>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Guenter Roeck <linux@roeck-us.net>, shuah <shuah@kernel.org>,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	Pavel Machek <pavel@denx.de>, Jon Hunter <jonathanh@nvidia.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>, srw@sladewatkins.net,
	rwarsow@gmx.de, Conor Dooley <conor@kernel.org>,
	hargar@microsoft.com, Mark Brown <broonie@kernel.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH 6.12 000/122] 6.12.11-rc1 review
Message-ID: <20250128143949.GD7145@noisy.programming.kicks-ass.net>
References: <20250121174532.991109301@linuxfoundation.org>
 <CA+G9fYtv3NNpxuipt8Dxa_=0DhieWWc07kDgCDBM+o0gKRi4Dw@mail.gmail.com>
 <cc947edf-bece-498c-bcb0-5bc403141257@app.fastmail.com>
 <20250122105949.GK7145@noisy.programming.kicks-ass.net>
 <faa9e4ef-05f5-4db1-8c36-e901e156caea@w6rz.net>
 <bfc6d9c18eaa856cddb062ebc07c398a16d91353.camel@gmx.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfc6d9c18eaa856cddb062ebc07c398a16d91353.camel@gmx.de>

On Tue, Jan 28, 2025 at 12:46:07PM +0100, Mike Galbraith wrote:

> Seems 6.13 is gripe free thanks to it containing 4423af84b297.
> 
> I stumbled upon a reproducer for my x86_64 desktop box: all I need do
> is fire up a kvm guest in an enterprise configured host.  That inspires
> libvirt goop to engage group scheduling, splat follows instantly.
> 
> Back 4423af84b297 out of 6.13, it starts griping, add it to a 6.12 tree
> containing 6d71a9c61604, it stops doing so.

Ooh, does something like the below (+- reverse-renames as applicable to
.12) also help?

---
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b67222dea491..8766f7d3d297 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3781,6 +3781,7 @@ static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 		update_entity_lag(cfs_rq, se);
 		se->deadline -= se->vruntime;
 		se->rel_deadline = 1;
+		cfs_rq->nr_queued--;
 		if (!curr)
 			__dequeue_entity(cfs_rq, se);
 		update_load_sub(&cfs_rq->load, se->load.weight);
@@ -3811,6 +3812,7 @@ static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 		place_entity(cfs_rq, se, 0);
 		if (!curr)
 			__enqueue_entity(cfs_rq, se);
+		cfs_rq->nr_queued++;
 
 		/*
 		 * The entity's vruntime has been adjusted, so let's check
