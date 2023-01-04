Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1604EBA3D
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 20:26:04 +0000 (UTC)
Received: by mail-ej1-f45.google.com with SMTP id vm8so78509825ejc.2
        for <patches@lists.linux.dev>; Wed, 04 Jan 2023 12:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0nsiYCj7E7B/biignvWJEgK9zv09wv8jx0ObzuZD7BA=;
        b=fJo+QzADxBj8/jQzpQWRnaynpQlqiQTaU8QRE0zlmtiZtHSDcIvUYgewPOiKgZNZTe
         /yRGQZvqwnny1JWPcL1tclqzX0QV5ufBq8bti84ktBySJJEGiRypr3Kkq4TOyKLp6AXD
         mfMt7OPZ64ktLHIucPvlMzAaH52uZBe0AD7iAWOEY4Iow+ySDaLfa8dHyU36aK37Vc3F
         dTRI+AYLnjue07kLuxOAdUchHCm74+vc9J0xsrL+a4Coml52gdkW3ScywY02wLj7yxtF
         L4dEStUENFQcp9YA/7ExVOXgTkvX80J2DTlQSkAAqAK6G5ZHNL1NlNrXkTonCP1bXbIM
         2eHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0nsiYCj7E7B/biignvWJEgK9zv09wv8jx0ObzuZD7BA=;
        b=DPKcrREmyhjEDRVft4b7vfThT36i3KuxsgVrSxKQzhdyibuhPWeUdOhEG+hyeY/O/w
         AKhjXZEa0ti+M1/UjuHzcRQOlsavEOWpH1XXLwA2LHkBUr6m/1djuKfcleC3uZUMhapM
         3wLrt0ByFA4BEZ6IHD5PqpZOEnPbVogA9B2JLXdtH1pYkg82Opv0aY3voAQgmWFYWBXL
         R7Tk/bgmyAxngoBS4JKu2LoBAhOVSZGOuMl3FtFPnti9Y7qGC9Ok+Wdm+0ohfk8WMDlq
         bvkmIl1hL6ITuF0VSeYvN5l+QNeRU7VVeQ8EX0m1xmZb6mSYvdadJ98QBt5BGr59dEfr
         9b/A==
X-Gm-Message-State: AFqh2kpbf6yYDcOKNH0O2zV640yIvh2Rtt9J4bU9Bs+0jtGQ88DL9SCq
	+VP6I9hI8CTzHfz8UpaKqQk=
X-Google-Smtp-Source: AMrXdXv39pIwvzSW1JK083DyvEaIimvX/j6XZ5/7LzVNcY31rmnGqXtGzu/G8SSUDyZANJn3v1+kpw==
X-Received: by 2002:a17:907:80ce:b0:7c1:26b9:c556 with SMTP id io14-20020a17090780ce00b007c126b9c556mr44908907ejc.15.1672863963331;
        Wed, 04 Jan 2023 12:26:03 -0800 (PST)
Received: from gmail.com (1F2EF380.nat.pool.telekom.hu. [31.46.243.128])
        by smtp.gmail.com with ESMTPSA id l9-20020a1709060cc900b007c0f2d051f4sm15462557ejh.203.2023.01.04.12.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 12:26:02 -0800 (PST)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Wed, 4 Jan 2023 21:25:59 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, tglx@linutronix.de,
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org,
	x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Carlos O'Donell <carlos@redhat.com>,
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Jann Horn <jannh@google.com>,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v14 1/7] x86: lib: Separate instruction decoder MMIO type
 from MMIO trace
Message-ID: <Y7Xg19H39FqTwyEL@gmail.com>
References: <20230101162910.710293-1-Jason@zx2c4.com>
 <20230101162910.710293-2-Jason@zx2c4.com>
 <Y7QELo9etPM8Tpx5@gmail.com>
 <Y7RA3bmko0AjO8hQ@zx2c4.com>
 <Y7RfPnyK/25pxpKs@gmail.com>
 <Y7RmDVI/ScoeBO2a@zn.tnic>
 <CAHmME9ohJ3JZNjkxuA0KjFW0LLQksgQP5f8bfrogd3+GmLrpKw@mail.gmail.com>
 <Y7RqQNH0OuiYCDeE@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7RqQNH0OuiYCDeE@gmail.com>


* Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> 
> > On Tue, Jan 3, 2023 at 6:29 PM Borislav Petkov <bp@alien8.de> wrote:
> > >
> > > On Tue, Jan 03, 2023 at 06:00:46PM +0100, Ingo Molnar wrote:
> > > > > I guess you missed the conversation with Borislav yesterday about that.
> > > > > He mentioned that I'd just take it through random.git when this whole
> > > > > series goes in.
> > > >
> > > > Please base your tree off on tip:x86/asm then (or pull it in) - it only
> > >
> > > My idea was a lot simpler: avoid the tree inter-dependency by us acking this
> > > patch so that it can go through the random.git tree.
> > 
> > Indeed I would prefer this.
> > 
> > Or... just put this in 6.2 because it's trivial anyway? Heck, even mark 
> > it as stable@ so make future backporting easier. Then it'll meet tip's 
> > urgent criteria.
> 
> Yeah - that's sensible too, it does fix a header namespace bug - I've put 
> it into tip:x86/urgent.

This namespace clash fix is now upstream as of 512dee0c00ad & later kernels.

Thanks,

	Ingo
