Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC552CAB
	for <patches@lists.linux.dev>; Sat, 19 Nov 2022 12:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0F9C433C1;
	Sat, 19 Nov 2022 12:12:12 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="crmR5Npm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1668859931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0f5sHGnHFD8uGcnBWXObpXpEeLaxXL7BEoTo3VGLAUE=;
	b=crmR5NpmQqT0pvhxMeGyRgocdNXOUxNE2Scu9tjN8yIldG4xmW5uRm1wi2vgh+5ydtKY2j
	x+huCYS/5LESEm96q+Rd3kdZ5RdpPR7xlOQirLKhHeYsvbRXBs+JYc2XtDiuviAqCfijuU
	ZAUiR8cJz/HJfMWaAgNJn7QBxtpCLnU=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3e4f51d0 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sat, 19 Nov 2022 12:12:11 +0000 (UTC)
Date: Sat, 19 Nov 2022 13:12:08 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Carlos O'Donell <carlos@redhat.com>
Subject: Re: [PATCH v4 2/3] random: introduce generic vDSO getrandom()
 implementation
Message-ID: <Y3jIGFRiMMsd/ZDI@zx2c4.com>
References: <20221118172839.2653829-1-Jason@zx2c4.com>
 <20221118172839.2653829-3-Jason@zx2c4.com>
 <ecfd265b-49e7-79b2-1818-e08a2c652db0@csgroup.eu>
 <Y3gbVorxZyb4SBJa@zx2c4.com>
 <Y3gdkxq4FjXcmAwA@zx2c4.com>
 <2571f72a-3420-977f-7b08-8f6216bba6a8@csgroup.eu>
 <Y3jBY4p2hEKDaUm+@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y3jBY4p2hEKDaUm+@zx2c4.com>

On Sat, Nov 19, 2022 at 12:43:31PM +0100, Jason A. Donenfeld wrote:
> On Sat, Nov 19, 2022 at 07:51:21AM +0000, Christophe Leroy wrote:
> > 
> > 
> > Le 19/11/2022 à 01:04, Jason A. Donenfeld a écrit :
> > > On Sat, Nov 19, 2022 at 12:55:02AM +0100, Jason A. Donenfeld wrote:
> > >> Sorry if I'm a bit slow here to grok what's up.
> > 
> > Maybe I should also have mentionned commit ce7d8056e38b ("powerpc/vdso: 
> > Prepare for switching VDSO to generic C implementation.") for you to 
> > have a complete picture.
> > 
> > > 
> > > Okay, I think I see it now. That's a complicated patch for a simple idea
> > > because gettime is more complicated than getrandom. I suspect what you
> > > want is something like the below, correct? Seems easy enough.
> > 
> > Yes it is exactly that, powerpc will then call __cvdso_getrandom_data() 
> > directly and pass rng_info pointer.
> 
> Okay, I'll do that and send out a v+1.

Alright, new series posted here, with those changes. Let me know if that
is workable for you. Since a lot of the vDSO is tied up (currently) with
timekeeping stuff, it's a bit tricky adding things to it like this. I've
done the best I can to keep it clean and such, but if you want to play
around with wiring up powerpc, that might prove to be an interesting
exercise in shaking out inconsistencies. New series is here:
https://lore.kernel.org/lkml/20221119120929.2963813-1-Jason@zx2c4.com/T

Jason
