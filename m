Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF6E2116E4;
	Wed, 22 Jan 2025 10:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737543596; cv=none; b=ugAtDwZA05M9iOYv/HvrRA5LXzh0/Ul0gTjLFnokKauelyFVJWE84dNILoE9n0MWNHQlArJrkvDDBlmXvnvTmaZiioZjnZzR7ATpc9KCDc2ZM+CIzEooo5ZH9qfYD089mFxPIqSH7Mbf9XWhirNXnexx9WKK9khedbazgSqTc7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737543596; c=relaxed/simple;
	bh=T8CQvqwd8AofzYH/VgqLK0Y1sG2g7HNXXWQE5zvB61Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sX5VUK3IDCPZHyWD3quAp6vy2XNxnwz5F4P900FKoXLJSs8vEP5gKBABV+ycJn3lHdN1e/lG1k+3n/atgK5G/gAYz/b46ykoG4Sz02KkGHqVVKwR/Dzu6+eHSYDuiyVjBccgaW459di5Tcn8JY1l/mTYB60XOPI5VMIApvA4pEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Fm9OBiJH; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Fm9OBiJH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mkBKPInsrTFLae2VqPxAH4vEoUXMWWF4sBsGV785GTA=; b=Fm9OBiJHVWyW8EX7uaBNTY/6Ay
	wTO5/nBbPHWOcDZXTclzKldhAdc4nXJ4M64/26VSTx8GSP/N5nDA22uMYTx2oSyumL8nTJjH9zJSg
	stzyJ+O675cnEx3kpNNPh4YphZSzPRG/jLWP9Qrh7k9tliKPVskqKAMLh0JcPt9UuQos2cUEcpBLx
	HS0LiV7U9m3XFzp1hIiCaTUrRhCpBNz7Wa752eli4vmrEp5qkG36NBFedSQzh8Zn+wLQ42+Njx6u1
	hXLbf8BPZ9BkozWjacEeG5nNz7r3lkge+oG1w5xvttlVKFEI5D+5tsC3Sb0xsaAf0wfW0Y08Z8xU+
	0HTcB0GQ==;
Received: from 77-249-17-89.cable.dynamic.v4.ziggo.nl ([77.249.17.89] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1taYSc-0000000DXzT-2RBW;
	Wed, 22 Jan 2025 10:59:51 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 1A5DA300599; Wed, 22 Jan 2025 11:59:50 +0100 (CET)
Date: Wed, 22 Jan 2025 11:59:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>,
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
Message-ID: <20250122105949.GK7145@noisy.programming.kicks-ass.net>
References: <20250121174532.991109301@linuxfoundation.org>
 <CA+G9fYtv3NNpxuipt8Dxa_=0DhieWWc07kDgCDBM+o0gKRi4Dw@mail.gmail.com>
 <cc947edf-bece-498c-bcb0-5bc403141257@app.fastmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc947edf-bece-498c-bcb0-5bc403141257@app.fastmail.com>

On Wed, Jan 22, 2025 at 11:56:13AM +0100, Arnd Bergmann wrote:
> On Wed, Jan 22, 2025, at 11:04, Naresh Kamboju wrote:
> > On Tue, 21 Jan 2025 at 23:28, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> 
> > 0000000000000000
> > <4>[  160.712071] Call trace:
> > <4>[ 160.712597] place_entity (kernel/sched/fair.c:5250 (discriminator 1))
> > <4>[ 160.713221] reweight_entity (kernel/sched/fair.c:3813)
> > <4>[ 160.713802] update_cfs_group (kernel/sched/fair.c:3975 (discriminator 1))
> > <4>[ 160.714277] dequeue_entities (kernel/sched/fair.c:7091)
> > <4>[ 160.714903] dequeue_task_fair (kernel/sched/fair.c:7144 (discriminator 1))
> > <4>[ 160.716502] move_queued_task.isra.0 (kernel/sched/core.c:2437
> > (discriminator 1))
> 
> I don't see anything that immediately sticks out as causing this,
> but I do see five scheduler patches backported in stable-rc
> on top of v6.12.8, these are the original commits:
> 
> 66951e4860d3 ("sched/fair: Fix update_cfs_group() vs DELAY_DEQUEUE")

This one reworks reweight_entity(), but I've been running with that on
top of 13-rc6 for a week or so and not seen this.


