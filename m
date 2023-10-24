Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F6513FED
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 15:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="e3ecHRa4"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-586753b0ab0so353293eaf.0
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 08:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1698160178; x=1698764978; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fqT0ZpAwvVlI/uIx6DFzb3/0hYc00UNCYkZdfU6AruA=;
        b=e3ecHRa4X2W+Mg+znXodp3w28YBxyOT82aTF/nOtLJUZjlHziFrFhJ85DNdwwRkWCo
         XXx8N0n330zPkVabdUorzcEEsBLxHXwAbjhxyPdt0/urBnmdGEI7P8+dsITnznN0Sx2n
         o65Q6BzgaJR9xSIaNXbdtchJZ20xB7H/q7kVg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698160178; x=1698764978;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fqT0ZpAwvVlI/uIx6DFzb3/0hYc00UNCYkZdfU6AruA=;
        b=PRAiBUKpP0djYOByRJStV88S3C4TQ1gitKxzGv4vtDGDDdXeHdAH3CHF3B1piBlBXm
         +l1kYjHKKitQfCs5CxVu35FAMl46gcD33mZWsTagHMChMoFOxFVJ2Tuab/xzuSB6CD78
         HBdwfa6ytkByUQPGI8aJUUq6zgeWfX/p/at1ZH7vliOQmVSSmr0jjyPGpeQ0lQ7vDpAd
         hG7j9/f2bRafPTQCjLC6toMSwshcKogdYVrgSWIAEF1yJNQuADHNVxQ0qwogypQsR/eV
         UMR5p+yDWva0zRyeQZyAtBFZLQmeFSZxfniqXMz5gPV61GJg+5tmnf6lLudzyKZ93C4N
         gxgg==
X-Gm-Message-State: AOJu0YwRuGvXxikHFgNlIs1PYPI00pJsGWcHsEflYn34Fw1x1NIiifnL
	/sd2jdOTXHk9rD1v4QdeLiWiavHP0gFjMfqgwik=
X-Google-Smtp-Source: AGHT+IF8664jW9QtOkdQ/f7g3rJTDLDAVxkR/JUyJFSgkMyx7Sg/5hyXHugBvENMBVdpDMjLaZbuCg==
X-Received: by 2002:a4a:b2c4:0:b0:581:f6d8:5ca2 with SMTP id l4-20020a4ab2c4000000b00581f6d85ca2mr13084836ooo.6.1698160178066;
        Tue, 24 Oct 2023 08:09:38 -0700 (PDT)
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com. [209.85.167.169])
        by smtp.gmail.com with ESMTPSA id ba2-20020a056830460200b006ce2ac5daf8sm1871660otb.57.2023.10.24.08.09.36
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 08:09:37 -0700 (PDT)
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3b3ec45d6e9so2924604b6e.0
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 08:09:36 -0700 (PDT)
X-Received: by 2002:a54:4e84:0:b0:3af:75e2:4c34 with SMTP id
 c4-20020a544e84000000b003af75e24c34mr12647739oiy.50.1698160176277; Tue, 24
 Oct 2023 08:09:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230911134650.286315610@linuxfoundation.org> <20230911134651.582204417@linuxfoundation.org>
 <ZS6xYa_kjRGvdCG6@google.com> <bd5d2f882e47b904802023d5d4d54d8d4755440e.camel@linux.ibm.com>
 <CAHQZ30A8R+EDGbrngMOQrXabR=DTHL3Y-1Tv+3RF98VHQ5b68Q@mail.gmail.com>
 <c9b7de507e26cb4e5111cdc76998f1dcd3c0957a.camel@linux.ibm.com>
 <CAHQZ30BPUtNbQhxvUGMQWP3Ka4UxtaS_NUeK12jtdaheMq4EWw@mail.gmail.com> <e03ccb1e354cee0eea828cb6f2e6f91714218c49.camel@linux.ibm.com>
In-Reply-To: <e03ccb1e354cee0eea828cb6f2e6f91714218c49.camel@linux.ibm.com>
From: Raul Rangel <rrangel@chromium.org>
Date: Tue, 24 Oct 2023 09:09:25 -0600
X-Gmail-Original-Message-ID: <CAHQZ30B+=v+QpXNiXDrmDPLf2k2_1zeXnK7kWok4VspurNQw4g@mail.gmail.com>
Message-ID: <CAHQZ30B+=v+QpXNiXDrmDPLf2k2_1zeXnK7kWok4VspurNQw4g@mail.gmail.com>
Subject: Re: [PATCH 6.4 041/737] ovl: Always reevaluate the file signature for IMA
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Eric Snowberg <eric.snowberg@oracle.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Sasha Levin <sashal@kernel.org>, 
	Tim Bain <tbain@google.com>, Shuhei Takahashi <nya@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 18, 2023 at 12:07=E2=80=AFPM Mimi Zohar <zohar@linux.ibm.com> w=
rote:
>
> On Wed, 2023-10-18 at 10:35 -0600, Raul Rangel wrote:
>
> > > > > Instead of reverting the patch, perhaps allow users to take this =
risk
> > > > > by defining a Kconfig, since they're aware of their policy rules.
> > > > >
> > > >
> > > > That sounds good. Or would it make sense to add an option to the
> > > > policy file? i.e., `verifiable fsmagic=3D0x794c7630
> > >
> > > Perhaps instead of introducing a new "action" (measure/dont_measure,
> > > appraise/dont_appraise, audit), it should be more granular at the
> > > policy rule level.
> > > Something like ignore_cache/dont_ignore_cache, depending on the
> > > default.
> > >
> > > Eric, does that make sense?
> >
> > I guess if one of the lower layers was a tmpfs that no longer holds.
>
> I don't understand what's special about tmpfs.  The only reason the
> builtin "ima_tcb" policy includes a "dont_measure" tmpfs rule is
> because the initramfs doesn't support xattrs.

I mentioned tmpfs because as you said, it's listed in the ima_tcb policy
as dont_measure. I'm not sure why since according to the man page
https://man7.org/linux/man-pages/man5/tmpfs.5.html it does support xattrs:

> The tmpfs filesystem supports extended attributes (see xattr(7)),
> but user extended attributes are not permitted.

Maybe tmpfs can be removed from the dont_measure list?

>
> > Can overlayfs determine if the lower file is covered by a policy
> > before setting the SB_I_IMA_UNVERIFIABLE_SIGNATURE flag? This way the
> > policy writer doesn't need to get involved with the specifics of how
> > the overlayfs layers are constructed.
>
> A read-only filesystem (squashfs) as the lower filesystem obviously
> does not need to be re-evaluated.
>
> With the "audit" and perhaps "measure" rule examples, the policy can at
> least be finer grained.
>
> > In the original commit message it was mentioned that there was a more
> > fine grained approach. If that's in the pipeline, maybe it makes sense
> > to just wait for that instead of adding a new keyword? We just revered
> > this patch internally to avoid the performance penalty, but we don't
> > want to carry this patch indefinitely.
>
> I'm not aware of anyone else looking into it.
>
> Mimi
>

Thanks for working on a fix!

Raul
