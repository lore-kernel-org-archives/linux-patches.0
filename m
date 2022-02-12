Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285497A
	for <patches@lists.linux.dev>; Sat, 12 Feb 2022 05:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697EBC340E7;
	Sat, 12 Feb 2022 05:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1644643481;
	bh=uEDAhcRzsKIbuXy+ThKnGGt3zbBE61T6oJdwQm2QIa0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UXXWPbTYZiIBrZ+2sX42s2jsYvKEFidIJ8x0EU2Ta+IsjY0skCdhTn8/5KC2Ee81e
	 XUA0PmG2xUpKLS2AEvMBUpbcaJA9B4ft3cjc0xUAnipR0xR2/l6KiNtco4To/ZwBFf
	 xke1oIh6uQVmZLabkox12Q9cwnyN/iZN/e0tloYM=
Date: Fri, 11 Feb 2022 21:24:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: incoming
Message-Id: <20220211212440.7fc283e731d05d5ce33dfd43@linux-foundation.org>
In-Reply-To: <CAHk-=wjxzxa36L0hO6FG9BQT9xsjLhi2G61r1EPjO3v7kofEHg@mail.gmail.com>
References: <20220211162756.9f8e8baef81183041ccfc16f@linux-foundation.org>
	<CAHk-=wjxzxa36L0hO6FG9BQT9xsjLhi2G61r1EPjO3v7kofEHg@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 11 Feb 2022 18:02:53 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Feb 11, 2022 at 4:27 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > 5 patches, based on f1baf68e1383f6ed93eb9cff2866d46562607a43.
> 
> So this *completely* flummoxed 'b4', because you first sent the wrong
> series, and then sent the right one in the same thread.
> 
> I fetched the emails  manually, but honestly, this was confusing even
> then, with two "[PATCH x/5]" series where the only way to tell the
> right one was basically by date of email. They did arrive in the same
> order in my mailbox, but even that wouldn't have been guaranteed if
> there had been some mailer delays somewhere..

Yes, I wondered.  Sorry bout that.

> So next time when you mess up, resend it all as a completely new
> series and completely new threading - so with a new header email too.
> Please?

Wilco.

> And since I'm here, let me just verify that yes, the series you
> actually want me to apply is this one (as described by the head
> email):
> 
>   Subject: [patch 1/5] fs/binfmt_elf: fix PT_LOAD p_align values ..
>   Subject: [patch 2/5] fs/proc: task_mmu.c: don't read mapcount f..
>   Subject: [patch 3/5] mm: vmscan: remove deadlock due to throttl..
>   Subject: [patch 4/5] mm: memcg: synchronize objcg lists with a ..
>   Subject: [patch 5/5] kfence: make test case compatible with run..
> 
> and not the other one with GUP patches?

Those are the ones.  Five fixes, three with cc:stable.
