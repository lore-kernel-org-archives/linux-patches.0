Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE8218C13
	for <patches@lists.linux.dev>; Mon, 31 Jul 2023 14:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=de/TnfHLNzlXaZEGiGMOZ3pjsjE8E3tLktqfu8enDYg=; b=UBV36TsbyfRyMX3qdstj0yCKfS
	Cq0UOjQLNxoN7QG6D6muG7TOulGGqh8jDvZxfyGKTaisV13PkfCyDB1isV2WKGKavzMV9K6cMkkDL
	Lv1W7iNwLxH4vf8g/z3oHNBQUKpQkGV2TfzwQkTd89GY7nsmouQ4mC9qUfRt98ET7liVQKkONMhME
	H7N1cEA7jk8SCRxKvtMCTcTu5sBPXkB4t6HHdmlLwlqyOBKAV25zTy2XkBZBYMPkj5Zlu6hSfzcuu
	zZz0yX9vlYevMOBMQLm657gnmxivYGYcE3cfrqPVmqOEuMUf/LhL5ZTpPh7dC1dXErL2HMF6nXWjr
	iFGxt+uw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1qQUG8-002Ezp-KX; Mon, 31 Jul 2023 14:52:33 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A09ED300134;
	Mon, 31 Jul 2023 16:52:32 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
	id 6551C2058B54B; Mon, 31 Jul 2023 16:52:32 +0200 (CEST)
Date: Mon, 31 Jul 2023 16:52:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Joel Fernandes <joel@joelfernandes.org>, paulmck@kernel.org,
	Pavel Machek <pavel@denx.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	rcu@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: scheduler problems in -next (was: Re: [PATCH 6.4 000/227]
 6.4.7-rc1 review)
Message-ID: <20230731145232.GM29590@hirez.programming.kicks-ass.net>
References: <2cfc68cc-3a2f-4350-a711-ef0c0d8385fd@paulmck-laptop>
 <D56D0318-A2EA-4448-8F4D-BE84706E26A5@joelfernandes.org>
 <3da81a5c-700b-8e21-1bde-27dd3a0b8945@roeck-us.net>
 <20230731141934.GK29590@hirez.programming.kicks-ass.net>
 <20230731143954.GB37820@hirez.programming.kicks-ass.net>
 <f5a18aa3-9db7-6ad2-33d5-3335a18e4e2f@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5a18aa3-9db7-6ad2-33d5-3335a18e4e2f@roeck-us.net>

On Mon, Jul 31, 2023 at 07:48:19AM -0700, Guenter Roeck wrote:

> > I've taken your config above, and the rootfs.ext2 and run-sh from x86/.
> > I've then modified run-sh to use:
> > 
> >    qemu-system-x86_64 -enable-kvm -cpu host
> > 
> > What I'm seeing is that some boots get stuck at:
> > 
> > [    0.608230] Running RCU-tasks wait API self tests
> > 
> > Is this the right 'problem' ?
> > 
> 
> 
> Yes, exactly.

Excellent! Let me prod that with something sharp, see what comes
creeping out.
