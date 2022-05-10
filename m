Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D4929A2
	for <patches@lists.linux.dev>; Tue, 10 May 2022 18:57:40 +0000 (UTC)
Received: from zn.tnic (p5de8eeb4.dip0.t-ipconnect.de [93.232.238.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 884281EC0453;
	Tue, 10 May 2022 20:57:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1652209054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=Mvbk6YXNHCDTVJq+TKolSmiEHwhVEhF+YCz4zXsQ9SA=;
	b=rz+8C4O2/HNXAoQEQ7GBFLegjlEYasDQmB2H3uP36SCWB+dC0LP1vNlMYNW/+EeyzfrKWq
	ohfHarSF9OIh2ZnlFf+KZUSfcf7KLb8Q01BBKsWOjzKGRXGufypJIGdqzm/sU77hvBiAu9
	RjQO2JC9JUjTrjhCLOEIOagreFGuNWI=
Date: Tue, 10 May 2022 20:57:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Hemment <markhemm@googlemail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	the arch/x86 maintainers <x86@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, patrice.chotard@foss.st.com,
	Mikulas Patocka <mpatocka@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
	Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
	Mel Gorman <mgorman@suse.de>
Subject: Re: clear_user (was: [patch 02/14] tmpfs: fix regressions from wider
 use of ZERO_PAGE)
Message-ID: <Ynq1nVpu1xCpjnXm@zn.tnic>
References: <CAHk-=wg=D9eaDHU5yHpqf_G7zTBcv6yU1kkNzV6KKb5jttNxvA@mail.gmail.com>
 <YnLMSWbz6BNfsBME@zn.tnic>
 <CAHk-=wh_62HBCz1g_6mKP71XOvJAs3JwBz0=jve2mg1DGWPq5g@mail.gmail.com>
 <YnLfl6lupN2nq7+t@zn.tnic>
 <CAHk-=wiGbrJMim6EWncZUQBzguqy-vtNd+grfNizm5L8Vcmu+w@mail.gmail.com>
 <YnLplKy0Y66SsvQw@zn.tnic>
 <CAHk-=wjUX5DGNSiBYvPC8fQJGRe5_RWR8NW=gYF4=UpPiwCE8A@mail.gmail.com>
 <Ynow8F3G8Kl6V3gu@zn.tnic>
 <CAHk-=whCmmipbBDips0OJ=UiBUjZfgBGYruoOsqcq2TVd5kBSA@mail.gmail.com>
 <YnqqhmYv75p+xl73@zn.tnic>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YnqqhmYv75p+xl73@zn.tnic>

On Tue, May 10, 2022 at 08:10:14PM +0200, Borislav Petkov wrote:
> And when you think of all the crap stuff that got added in silicon
> and *removed* *again* in the meantime... but I'm optimistic now that
> Murphy's Law is not going to hold true anymore, we will finally start
  ^^^^^^

Dunno if this was a Freudian slip... :-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
