Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A17362
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 17:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA56C433A1
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 17:31:09 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="jZKK1U17"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1672767065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jmz3B4N06geTRMh8pYrWdrgJ1hJ5+fSjFeBSA/9U4Cw=;
	b=jZKK1U173hU+Tm1B4VZIY2iKtnBryPgXtg7J+l/epGoKVwpvFCdtA/VuZREza/hKERPpLs
	7+ZrzFpexuA8LaynH1QEBXbw5XAYjvLgBQp5vg26C7fIrG48s1k7JTxe5ge3gE4UqL03m8
	yJD5GFLUSa+tY9m+OhndnwDWEDXQI40=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5ae12793 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <patches@lists.linux.dev>;
	Tue, 3 Jan 2023 17:31:04 +0000 (UTC)
Received: by mail-yb1-f176.google.com with SMTP id 203so33848164yby.10
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 09:31:04 -0800 (PST)
X-Gm-Message-State: AFqh2kr7tYbGM+cLzo1ybRCf7DKMwtlxMJYHcsxvr1LQAWGYJaxB6n6j
	Yzy3S3sYVx7EABwhjzixb5/fLAt9YN8L7b+zhSk=
X-Google-Smtp-Source: AMrXdXsqzKdjs796F972R+nah6TEAsws7b/uf6K5iQTSv3+zK+tre1qXfQnNtsot0TU1C0wZtvv2rmeH8iPAEAY4pxE=
X-Received: by 2002:a25:c89:0:b0:703:8a9c:fd with SMTP id 131-20020a250c89000000b007038a9c00fdmr4700323ybm.231.1672767063101;
 Tue, 03 Jan 2023 09:31:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230101162910.710293-1-Jason@zx2c4.com> <20230101162910.710293-2-Jason@zx2c4.com>
 <Y7QELo9etPM8Tpx5@gmail.com> <Y7RA3bmko0AjO8hQ@zx2c4.com> <Y7RfPnyK/25pxpKs@gmail.com>
 <Y7RmDVI/ScoeBO2a@zn.tnic>
In-Reply-To: <Y7RmDVI/ScoeBO2a@zn.tnic>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 3 Jan 2023 18:30:52 +0100
X-Gmail-Original-Message-ID: <CAHmME9ohJ3JZNjkxuA0KjFW0LLQksgQP5f8bfrogd3+GmLrpKw@mail.gmail.com>
Message-ID: <CAHmME9ohJ3JZNjkxuA0KjFW0LLQksgQP5f8bfrogd3+GmLrpKw@mail.gmail.com>
Subject: Re: [PATCH v14 1/7] x86: lib: Separate instruction decoder MMIO type
 from MMIO trace
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	tglx@linutronix.de, linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, 
	x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 3, 2023 at 6:29 PM Borislav Petkov <bp@alien8.de> wrote:
>
> On Tue, Jan 03, 2023 at 06:00:46PM +0100, Ingo Molnar wrote:
> > > I guess you missed the conversation with Borislav yesterday about that.
> > > He mentioned that I'd just take it through random.git when this whole
> > > series goes in.
> >
> > Please base your tree off on tip:x86/asm then (or pull it in) - it only
>
> My idea was a lot simpler: avoid the tree inter-dependency by us acking this
> patch so that it can go through the random.git tree.

Indeed I would prefer this.

Or... just put this in 6.2 because it's trivial anyway? Heck, even
mark it as stable@ so make future backporting easier. Then it'll meet
tip's urgent criteria.

Jason
