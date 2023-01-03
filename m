Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C8D8F47
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 17:47:49 +0000 (UTC)
Received: by mail-ej1-f52.google.com with SMTP id u19so75755484ejm.8
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 09:47:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W7cyotX0l7ebhA4GIXOl1W2CMlFAspZ6Tf1buLbR5Nw=;
        b=iu960tRompiJyFTJnEjBi11ZS+9d8i6l02Zfuya9QRR8fqgx5gmgJyEeRmp/naqHrV
         RBN9Sav3ZMUUYu3T9rHQrg2bpeRXsi3Uc/wWc0MYB7BZCLptyqc1rOYs7F757gICKEBE
         Pox0q6WWxbNtjQ4tQwP5ymahr6+GNAZ7P4e1zKCE1ojoGoLHoKC9CZS37Bai0Dwyd6C2
         7fr8j6/IOU6VyTTHDPJrPGBBtb7ikxjmgd3IWoPofp6rIJ7/j66xA1moZx0G6B8UlbDV
         fjfFCK5JLX/FQg7F2G35yZQatml97b9Or2BOgOaSfmXMW4G94bkY3rgf4cfxRyL8FAYG
         HHsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W7cyotX0l7ebhA4GIXOl1W2CMlFAspZ6Tf1buLbR5Nw=;
        b=nAIec2ZYaCo3XkQRoF7SCyCVAJtR3TGulWb15hjp3lIOnhKH5dFoLJa65LMnjEEZUq
         AlXiIqfcvVC3qx8MXnWDgdTUwr4VFhpZPYKjDa2H4Ho1hhDAZ680vPZm5YhU/tX1YahJ
         WqtXzJsq0j/g59RTAEqdeOjKW+TEe6lcDojj6xpqEuqO1Z1TO4rDWSv5NO+m8Z/FA1sl
         DY7JjCs9iDy3EmuNt61yBqWg+m7Fw4/UKwZHR/5iefKTY284YCVHqLWEVqpSM9g+rOef
         NMK+UB41na7ClwslCDblh2Ijwjn6gh1iVVbOvsj+KnoQo/08KWBXVVpF/US5BqV6iMvy
         nTEg==
X-Gm-Message-State: AFqh2kqqjSEElJQCbXdEXZQlu4deUfuawzkBsS4+u+rWaDOIsO4d8u1v
	QykInjx1TVumJqTRESqEJj8=
X-Google-Smtp-Source: AMrXdXtEgaqK+gulQ7OcVitdluoQBbDA+fdlh+FFGqJNxGkLF4DjAh8aeRkqM3BM6+nwYfYaYrBRsw==
X-Received: by 2002:a17:906:82c3:b0:7c1:9041:8c5 with SMTP id a3-20020a17090682c300b007c1904108c5mr52710406ejy.41.1672768067457;
        Tue, 03 Jan 2023 09:47:47 -0800 (PST)
Received: from gmail.com (1F2EF380.nat.pool.telekom.hu. [31.46.243.128])
        by smtp.gmail.com with ESMTPSA id kx20-20020a170907775400b0078d3f96d293sm14352978ejc.30.2023.01.03.09.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 09:47:46 -0800 (PST)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Tue, 3 Jan 2023 18:47:44 +0100
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
Message-ID: <Y7RqQNH0OuiYCDeE@gmail.com>
References: <20230101162910.710293-1-Jason@zx2c4.com>
 <20230101162910.710293-2-Jason@zx2c4.com>
 <Y7QELo9etPM8Tpx5@gmail.com>
 <Y7RA3bmko0AjO8hQ@zx2c4.com>
 <Y7RfPnyK/25pxpKs@gmail.com>
 <Y7RmDVI/ScoeBO2a@zn.tnic>
 <CAHmME9ohJ3JZNjkxuA0KjFW0LLQksgQP5f8bfrogd3+GmLrpKw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9ohJ3JZNjkxuA0KjFW0LLQksgQP5f8bfrogd3+GmLrpKw@mail.gmail.com>


* Jason A. Donenfeld <Jason@zx2c4.com> wrote:

> On Tue, Jan 3, 2023 at 6:29 PM Borislav Petkov <bp@alien8.de> wrote:
> >
> > On Tue, Jan 03, 2023 at 06:00:46PM +0100, Ingo Molnar wrote:
> > > > I guess you missed the conversation with Borislav yesterday about that.
> > > > He mentioned that I'd just take it through random.git when this whole
> > > > series goes in.
> > >
> > > Please base your tree off on tip:x86/asm then (or pull it in) - it only
> >
> > My idea was a lot simpler: avoid the tree inter-dependency by us acking this
> > patch so that it can go through the random.git tree.
> 
> Indeed I would prefer this.
> 
> Or... just put this in 6.2 because it's trivial anyway? Heck, even mark 
> it as stable@ so make future backporting easier. Then it'll meet tip's 
> urgent criteria.

Yeah - that's sensible too, it does fix a header namespace bug - I've put 
it into tip:x86/urgent.

Thanks,

	Ingo
