Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A3E17D0
	for <patches@lists.linux.dev>; Wed, 11 Jan 2023 07:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71144C433EF;
	Wed, 11 Jan 2023 07:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1673422043;
	bh=UNsE1Sfj5VIoaJ3hwnzx1FJI4j5UgDzN3GkA3q+AUVs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dxD1oUY/RiJXEOCbw6ek4gNpqHM0mBLH6ylbuGTsQAmrEb31BsclPpX+2w001z2pN
	 wUn2V4BtVR/nBTABTB5MnBq06fXVLWWfWRrD0RIISkXhqA5EOFB1nTdr5j5bRpUP3f
	 ZxIKCi4iBi5pmrl0OWhPYkSqWrgS8L44gJpC1UDmdu4s/T6YO1bkVqdB2GTAK1Bcod
	 VSVPPxRe8wziAVI8YJRZZtr6lhVzI7fDpKtki8x8Swdnsl3VwZimXrvodTZCDZlrM9
	 NHE74X7+o/MQvCYmP1ytwFRCo8LJMBdxHdGiwm1G9qPq8jL925wbDD5CKFYMhW4uaX
	 0kJUFhw7jl+Qw==
Date: Tue, 10 Jan 2023 23:27:20 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Florian Weimer <fweimer@redhat.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@kernel.org>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	tglx@linutronix.de, linux-crypto@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Carlos O'Donell <carlos@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Jann Horn <jannh@google.com>,
	Christian Brauner <brauner@kernel.org>, linux-mm@kvack.org,
	mlichvar@redhat.com
Subject: Re: [PATCH v14 2/7] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
Message-ID: <Y75k2KaDz2WdcXLk@sol.localdomain>
References: <20230101162910.710293-1-Jason@zx2c4.com>
 <20230101162910.710293-3-Jason@zx2c4.com>
 <Y7QIg/hAIk7eZE42@gmail.com>
 <CALCETrWdw5kxrtr4M7AkKYDOJEE1cU1wENWgmgOxn0rEJz4y3w@mail.gmail.com>
 <CAHk-=wg_6Uhkjy12Vq_hN6rQqGRP2nE15rkgiAo6Qay5aOeigg@mail.gmail.com>
 <Y7SDgtXayQCy6xT6@zx2c4.com>
 <CAHk-=whQdWFw+0eGttxsWBHZg1+uh=0MhxXYtvJGX4t9P1MgNw@mail.gmail.com>
 <874jt0kndq.fsf@oldenburg.str.redhat.com>
 <CAHk-=wg7vMC2VmSBdVw7EKV+7UDiftQEg3L+3Rc0rcjjfsvs5A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg7vMC2VmSBdVw7EKV+7UDiftQEg3L+3Rc0rcjjfsvs5A@mail.gmail.com>

On Mon, Jan 09, 2023 at 08:28:58AM -0600, Linus Torvalds wrote:
> On Mon, Jan 9, 2023 at 4:34 AM Florian Weimer <fweimer@redhat.com> wrote:
> >
> > We did these changes on the glibc side because Jason sounded very
> > confident that he's able to deliver vDSO acceleration for getrandom.  If
> > that fails to materialize, we'll just have to add back userspace
> > buffering in glibc.
> 
> My whole argument has been that user-space buffering is the sane thing
> to do. Most definitely for something like glibc.
> 
> The number of people who go "oh, no, my buffer or randomness could be
> exposed by insert-odd-situation-here" is approximately zero, and then
> the onus should be on *them* to do something special.
> 
> Because *they* are special. Precious little snowflake special.
> 
>              Linus

How would userspace decide when to reseed its CRNGs, then?

IMO, the main benefit of the VDSO getrandom over a traditional userspace CRNG is
that it makes reseeds of the kernel's CRNG take effect immediately.  See the
cover letter, where Jason explains this.

It's definitely important to make the memory used by userspace CRNGs have
appropriate semantics, but my understanding is that's not the main point.

- Eric
