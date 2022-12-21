Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CCC2FAF
	for <patches@lists.linux.dev>; Wed, 21 Dec 2022 20:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2A8C433D2;
	Wed, 21 Dec 2022 20:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1671655726;
	bh=V20cak5a7oCUhu/ElPJQDWDEPcrzF+kUY7ml3BOPRAA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ugzfuQ/F8El0jwSlwYMle/yRAjDhWVugkamPioI3pUY+8UDkXBGc1PHBwn8DGQkiv
	 IGRQdriSNr3uGD9Ra03+7w75b6rRHNUSxRCD1N3Womaolj2G7ePA+z2/+YI6XaA038
	 dsaLm+ie15QOiyOS3pJe8Jg3FR4zF+ya0zTgHOiD7MuP0XLvhw89RIC75wVV9pWdbf
	 jRRXfZYGifZfd+IMnojvmz5kzGVG4J9guOfY4ep/o/vKfNfIRKcUFpeIobehqrSXp1
	 svckhF3Mu4pRx6vuFsEYboC9GspJv7a9W5o3/1sVPpOlDoGHkl8XOjHvwTBloaMKtP
	 ijFjIzlG7t9wg==
Date: Wed, 21 Dec 2022 12:48:44 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Carlos O'Donell <carlos@redhat.com>,
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Jann Horn <jannh@google.com>,
	Christian Brauner <brauner@kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v12 0/6] implement getrandom() in vDSO
Message-ID: <Y6NxLCyk6XVJu2iM@sol.localdomain>
References: <20221212185347.1286824-1-Jason@zx2c4.com>
 <86cfa465-2485-ff24-16f5-9014e25a0e98@csgroup.eu>
 <Y6IXWltScF2CI1v3@gmail.com>
 <Y6MXbTAHBSR5WBrU@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y6MXbTAHBSR5WBrU@zx2c4.com>

On Wed, Dec 21, 2022 at 03:25:49PM +0100, Jason A. Donenfeld wrote:
> On Tue, Dec 20, 2022 at 08:13:14PM +0000, Eric Biggers wrote:
> > On Tue, Dec 20, 2022 at 05:17:52PM +0000, Christophe Leroy wrote:
> > > Hi Jason,
> > > 
> > > Le 12/12/2022 à 19:53, Jason A. Donenfeld a écrit :
> > > > Changes v11->v12:
> > > > ----------------
> > > > - In order to avoid mlock()ing pages, and the related rlimit and fork
> > > >    inheritance issues there, Introduce VM_DROPPABLE to prevent swapping
> > > >    while meeting the cache-like requirements of vDSO getrandom().
> > > > 
> > > >    This has some tenticles in mm/ and arch/x86/ code, so I've marked the
> > > >    two patches for that as still RFC, while the rest of the series is not
> > > >    RFC.
> > > > 
> > > > - Mandate that opaque state blobs don't straddle page boundaries, so
> > > >    that VM_DROPPABLE can work on page-level granularity rather than
> > > >    allocation-level granularity.
> > > > 
> > > > - Add compiler barriers to vDSO getrandom() to prevent theoretical
> > > >    reordering potential.
> > > > 
> > > > - Initialize the trials loop counter in the chacha test.
> > > 
> > > I would have liked to give it a try on powerpc, but the series 
> > > conflicts. I tried both on v6.1 and on linus/master from now:
> > > 
> > 
> > Same here, I can't figure out how to apply this series.
> 
> Rebased v13 posted: https://lore.kernel.org/all/20221221142327.126451-1-Jason@zx2c4.com/
> 

Thanks, it is always good to give the *actual* base commit though, preferably
with the --base option to git format-patch.  "Latest random.git master branch"
changes over time.

- Eric
