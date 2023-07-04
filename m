Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED69C1879
	for <patches@lists.linux.dev>; Tue,  4 Jul 2023 08:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE57C433C7;
	Tue,  4 Jul 2023 08:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688460454;
	bh=wiLQWpeMEZfyCX4MGG4bJcnARIlh8hWwkPNEE7EarQ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tPz82UdPJgvetK4jncfKD47WubHVyDAtVFjZihD8R9ysb98kaW8cNRnYxAS4Ft5Z0
	 xAsIaea9Y59yOZWYuBJjn55pKYlcCKCu4m9vjLk0S4pZuwasaL8bOUU8ABv48cOcSL
	 RAh4f12MKnsq1gSSEZ6UQQ1qa1Wsh7agtjLYthYk=
Date: Tue, 4 Jul 2023 09:47:32 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 6.3 00/13] 6.3.12-rc1 review
Message-ID: <2023070444-untimed-clerical-565a@gregkh>
References: <20230703184519.206275653@linuxfoundation.org>
 <CA+G9fYvf-sw8tCHjxhoMvHrtzzdE69EwvB2PmypUkGDdCFFASA@mail.gmail.com>
 <2023070411-steadfast-overtly-02a3@gregkh>
 <2023070416-wow-phrasing-b92c@gregkh>
 <37f9e884-6535-1ed7-8675-d98d0a6d8b36@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37f9e884-6535-1ed7-8675-d98d0a6d8b36@oracle.com>

On Tue, Jul 04, 2023 at 02:13:03PM +0530, Harshit Mogalapalli wrote:
> Hi Greg,
> 
> On 04/07/23 1:54 pm, Greg Kroah-Hartman wrote:
> 
> > > > 
> > > > 
> > > > While running LTP hugetlb testing on x86 the following kernel BUG noticed
> > > > on running stable-rc 6.3.12-rc1.
> > > > 
> > > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > > > 
> > > > Crash log:
> > > > =========
> > > > [   54.386939] hugefallocate01 (410): drop_caches: 3
> > > > g tests.......
> > > 
> > > And this worked on 6.3.11 just fine?
> > > 
> > > Trying to narrow down what would have caused this...
> > > 
> > > Any chance you can run Linus's tree with thie LTP test as well?
> > 
> > Ah, I can hit this here locally too!  Let me bisect...
> 
> 
> Have you looked at Patch 9 of this series:
> 
> https://lore.kernel.org/stable/2023070416-wow-phrasing-b92c@gregkh/T/#m12068530e846ac8b9668bd83941d82ec3f22ac15
> 
> Looks very much related, it also has a note on Backporting.
> As I think it could be related, I am sharing this.(But haven't tested
> anything)

Yes, that's the offending patch.  I should have read over the full
changelogs before doing bisection, but bisection/test proved that this
was not correct for 6.3.y at this point in time.

thanks,

greg k-h
