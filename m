Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCDB290D
	for <patches@lists.linux.dev>; Wed, 16 Feb 2022 15:33:53 +0000 (UTC)
Received: by mail-wm1-f50.google.com with SMTP id l123-20020a1c2581000000b0037b9d960079so4062907wml.0
        for <patches@lists.linux.dev>; Wed, 16 Feb 2022 07:33:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aCuubiScQpgBmI4JwD07tFpyDMvEgch7pbsgNNAd0rg=;
        b=JbVTvZdCTtWCmSxyaNv7MoOEo6fzq7Jqtn56YLxJD4asA9/l4NQFqvfFQQsLiVb52b
         SuLvT0B4kD7eelvR84YHoqtnET3/j8rMag8wte/8ZQelBwZ7O3FPwpASRexZ+wxVsem6
         q5D97GmeapHtXHvGH3I+FcIfENHPUHRX5OZaFOaKkBSi9+W23Qo+A9cy2Y+0HlpFJY7D
         eKZzM6uNLklHz+Q34i+V3CqItrrLoeeoBwIQ7DlwOojb3eBXT6mgza/t3SO/ZYqacDnV
         qF4RY19HGsvj/t8klItLQs2syFT3NpRbxhQNDbtqxUeuIWbl0Jis1U01bAZA/2sDlSPI
         R48Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aCuubiScQpgBmI4JwD07tFpyDMvEgch7pbsgNNAd0rg=;
        b=7JF+w9TO8ppX7rzCBYD53tt8i46lkZr3a57c0Rbwf73Me8bRFRXXLRf/F2FsnvmvGz
         +E2l6B53I7rK09/w5WNoK742xeqkg4RSIGa5hPBtPZn7wVxBg4g57pKVezvqxMq/eBru
         tM8KdnKQ9D7Mepw9rIllC6JiCTXqpGxpxhywyKHCSPGA5q2Md7AIW8SBrVL7vs9rciHG
         OtpsPbvcS/OE+pP3NSEyXV/CcTWkhsu5KV/NhzyVl6rfxEVdJUpotH36sjL7grxlIYjB
         1+Pj6Yq9nBZ/lpYwj5wAMAsbX/378+4sqs0DlSvq/Vb+ssR1KLmMHWfjbBUTcquF1rPq
         353Q==
X-Gm-Message-State: AOAM532PB2hCbOvLAftRsDwCU9AKjaPhrAAUy1WQGkqFDPHPNjtDG1EY
	SNmlmLcSebF0Tpts6tbiycl0tMWu7TC28aZpFscqTA==
X-Google-Smtp-Source: ABdhPJwX5fOV91US956nmrkSXgqVoC1if133LSL16hbHyI53xN+Ws9oXJMiWl2xwSaHgbUJ7gQUrPf1EB3GkCX55WgA=
X-Received: by 2002:a7b:c938:0:b0:37b:fdaa:2749 with SMTP id
 h24-20020a7bc938000000b0037bfdaa2749mr2176759wml.88.1645025631446; Wed, 16
 Feb 2022 07:33:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAPcxDJ6bDctjErv4ggtBiJsmPJb2e-3ng12f+hMuJ7SLN-SXOg@mail.gmail.com>
 <20220216055629.1542654-1-juew@google.com> <3288f39e32f04d67a875775414dd1c14@AcuMS.aculab.com>
In-Reply-To: <3288f39e32f04d67a875775414dd1c14@AcuMS.aculab.com>
From: Jue Wang <juew@google.com>
Date: Wed, 16 Feb 2022 07:33:39 -0800
Message-ID: <CAPcxDJ4pBdkJ4sNPJyrG3XqC=9JZvBfEzSK3hxzujJ5a9kYLRg@mail.gmail.com>
Subject: Re: [PATCH] x86/mce: work around an erratum on fast string copy instructions.
To: David Laight <david.laight@aculab.com>
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 16, 2022 at 1:04 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Jue Wang
> > Sent: 16 February 2022 05:56
> >
> > The fast string copy instructions ("REP; MOVS*") could consume an
> > uncorrectable memory error in the cache line _right after_ the
> > desired region to copy and raise an MCE.
>
> s/consume/trap due to/
>
> Isn't this just putting off the inevitable panic when the
> following cache line is accesses for real?

No, this mitigation is completely addressed this CPU erratum and not
equivalent to "putting off the inevitable panic".

The MCE raised due to the erratum is almost guaranteed to cause
kernel panic since the spurious MCEs from "REP; MOVS*" almost
always come from a kernel context. See the "Tested:" section for more
details.

The cache line with an uncorrectable memory error may or may not
get accessed by the owning process, thus there may not be an MCE
raised. Even if it is accessed, the access may well likely come from
a user space context, thus no kernel panic, but SIGBUS delivered to
the accessing process.
>
> Or is this all due to that pseudo dynamic memory (xpoint?) that is
> byte addressable but only really has the quality of a diak?
> It which case I thought it wasn't actually usable for
> normal memory anyway - so the copies are all ones which can fault.

The erratum is about "REP; MOVS*" instructions on Intel Purley CPUs,
PMEM / DRAM is not relevant in this context.
>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
