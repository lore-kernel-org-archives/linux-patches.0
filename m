Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE39362
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 17:00:54 +0000 (UTC)
Received: by mail-ed1-f53.google.com with SMTP id r26so39497361edc.5
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 09:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9XGF/oHYkE2lnb+e6AM2YoeOvVTcCohPHHsm6JMBYZU=;
        b=JDnCpKyYZH9ch/oXO9ePdMr6nXo6+0cW9i508hhjlh5zT44nCdfAggvBsb9VuWsgF3
         pm7qz9lvpzvNIDdnZ9rJHOeOwiYK7PcIkFW1Gwa8q/fwah8DGmsKuPGGCxvJgNGMF+3I
         wkfn1AF+Oj0zsjmJnnjuFUlHdu5RDBopb6hQLhxL+uRnDZEmL8VvCEWWFhzSt6G94Kua
         SLN8u2wr98j/CzArKxSPgzhT0xP9cKSG/qRfu0SVKiD/TyBjqjM/zB/Hz/0McDHCH1WS
         Qpwo72f4apurBO+drAOl1SEAm40lNuCIXq2wji+g4uWYU4Lp3iAhY1y0KseaA7OzfDc2
         SeWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9XGF/oHYkE2lnb+e6AM2YoeOvVTcCohPHHsm6JMBYZU=;
        b=4koeEST0OKeAooHJUQGtbXQZG7UwqLfKxZ5U9JSeVwP9+Bo23wVukGWtCmY5TV+0tI
         uTT7OhAnKbVB7WzyJA52EUoybEgGlcfCfDfqbS0nsou3XlwmSxlJYjMV6IB1BcGOPTGn
         1+XwcfUKw2Sz0JmvYvS+M0/TeT5BCVeQ7SZd1EtvUQq/WnAmbrb0AmxeJnMt/IN8ywXv
         lq0Nf0S2d8JsQF7ksCLOskOsxYvA9d27soFOgfhE2BjJZbW/RQtFgnlyz2ISXnExrTDG
         vf+yzbWYujqY9h2+rmj7wKnWk0GFQl6PPyZcfJoMbtCMy+Zf9XUJwuO0Tc38v2SY3SIl
         8bTw==
X-Gm-Message-State: AFqh2krYXt7tFih3YcCOB9qWajc5QdgLxIAnfQLkIVDwRMKIpUFRXMcb
	hQniL3vBQwfe3O7D2DIjqy4=
X-Google-Smtp-Source: AMrXdXtSYbu5hBJ16foCqcNUSZci2xbRQgMPpDknr2ME3NpvEQ7R5l7mS/T8utPIRP3G+YPQUXMw6Q==
X-Received: by 2002:a05:6402:1f89:b0:47b:16c7:492c with SMTP id c9-20020a0564021f8900b0047b16c7492cmr43128963edc.25.1672765252973;
        Tue, 03 Jan 2023 09:00:52 -0800 (PST)
Received: from gmail.com (1F2EF380.nat.pool.telekom.hu. [31.46.243.128])
        by smtp.gmail.com with ESMTPSA id da14-20020a056402176e00b0048b4e2aaba0sm5018870edb.34.2023.01.03.09.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 09:00:52 -0800 (PST)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Tue, 3 Jan 2023 18:00:46 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	tglx@linutronix.de, linux-crypto@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Carlos O'Donell <carlos@redhat.com>,
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Jann Horn <jannh@google.com>,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v14 1/7] x86: lib: Separate instruction decoder MMIO type
 from MMIO trace
Message-ID: <Y7RfPnyK/25pxpKs@gmail.com>
References: <20230101162910.710293-1-Jason@zx2c4.com>
 <20230101162910.710293-2-Jason@zx2c4.com>
 <Y7QELo9etPM8Tpx5@gmail.com>
 <Y7RA3bmko0AjO8hQ@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7RA3bmko0AjO8hQ@zx2c4.com>


* Jason A. Donenfeld <Jason@zx2c4.com> wrote:

> On Tue, Jan 03, 2023 at 11:32:14AM +0100, Ingo Molnar wrote:
> > 
> > * Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > 
> > > Both mmiotrace.h and insn-eval.h define various MMIO_ enum constants.
> > > Rename the insn ones to have a INSN_ prefix, so that the headers can be
> > > used from the same source file.
> > > 
> > > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > > ---
> > >  arch/x86/coco/tdx/tdx.c          | 26 +++++++++++++-------------
> > >  arch/x86/include/asm/insn-eval.h | 18 +++++++++---------
> > >  arch/x86/kernel/sev.c            | 18 +++++++++---------
> > >  arch/x86/lib/insn-eval.c         | 20 ++++++++++----------
> > >  4 files changed, 41 insertions(+), 41 deletions(-)
> > 
> > FYI, I've applied this fix to tip:x86/asm, as the fix for the namespace 
> > clash makes sense independently of the vDSO getrandom feature.
> 
> I guess you missed the conversation with Borislav yesterday about that.
> He mentioned that I'd just take it through random.git when this whole
> series goes in.

Please base your tree off on tip:x86/asm then (or pull it in) - it only 
includes this patch and another trivial patch at:

   a0e3aa8fe6cb ("x86/insn: Avoid namespace clash by separating instruction decoder MMIO type from MMIO trace type")

We often modify these files - roughly ~4 commits to arch/x86/kernel/sev.c 
alone per cycle on average - and it would be better to avoid conflicts 
here.

Thanks,

	Ingo
