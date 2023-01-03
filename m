Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273FA2F33
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 20:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E46C433EF;
	Tue,  3 Jan 2023 20:44:52 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="JLxfT6a/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1672778690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7cx/K+TO4UmCYrGKr/OeCO+B3doDOyrOgiixkdP5BVI=;
	b=JLxfT6a/rEkEUgFSY1L4yTIcSrF8hxovhO70zSbWxsGUSi+/sjYNdkoTdF4o4JMObk5klI
	c0Fo6JZ6+uqxC5jMswCTnFzpoxZSCY/tlQ4gnj6yz+8hZ6w1y4IVzghxvngOLLTnAhQ6xc
	l/qf0d0XJsIsdXWUPQO1ui6+hOiBHO0=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id fc45cc16 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Tue, 3 Jan 2023 20:44:50 +0000 (UTC)
Date: Tue, 3 Jan 2023 21:44:47 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@kernel.org>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	tglx@linutronix.de, linux-crypto@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Carlos O'Donell <carlos@redhat.com>,
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Jann Horn <jannh@google.com>,
	Christian Brauner <brauner@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH v14 2/7] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
Message-ID: <Y7STv9+p248zr+0a@zx2c4.com>
References: <20230101162910.710293-1-Jason@zx2c4.com>
 <20230101162910.710293-3-Jason@zx2c4.com>
 <Y7QIg/hAIk7eZE42@gmail.com>
 <CALCETrWdw5kxrtr4M7AkKYDOJEE1cU1wENWgmgOxn0rEJz4y3w@mail.gmail.com>
 <CAHk-=wg_6Uhkjy12Vq_hN6rQqGRP2nE15rkgiAo6Qay5aOeigg@mail.gmail.com>
 <Y7SDgtXayQCy6xT6@zx2c4.com>
 <CAHk-=whQdWFw+0eGttxsWBHZg1+uh=0MhxXYtvJGX4t9P1MgNw@mail.gmail.com>
 <Y7SJ+/axonTK0Fir@zx2c4.com>
 <CAHk-=wi4gshfKjbhEO_xZdVb9ztXf0iuv5kKhxtvAHf2HzTmng@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wi4gshfKjbhEO_xZdVb9ztXf0iuv5kKhxtvAHf2HzTmng@mail.gmail.com>

On Tue, Jan 03, 2023 at 12:15:57PM -0800, Linus Torvalds wrote:
> On Tue, Jan 3, 2023 at 12:03 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > That buffering cannot be done safely currently
> 
> .. again, this is "your semantics" (the (b) in my humbug list), not
> necessarily reality for anybody else.

Yea that's fair. Except, of course, I maintain that my semantics are
important ones. :)

> I'm NAK'ing making invasive changes to the VM for something this
> specialized. I really believe that the people who have this issue are
> *so* few and far between that they can deal with the VM forking and
> reseeding issues quite well on their own.

Okay, that's fine. I'll see if I can make this work without having to do
surgery on mm and introduce a new VM_* flag and such. Hopefully I'll
succeed there.

Jason
