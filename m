Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794957209;
	b=YsQSF57K1rCsbQMpUsAZCri3rK0KKe7yDXxjc1UHXgTyYHA6rtmlzw0+M4VAPfRWSGXY
	 /r8FnRvw3GgJpsaV+RXs3heC0KKK5z+DmcnRwbYuEVk84fPwutwjkF9xdjnwf9R/JE8Ot
	 kRfKnG3h8PxxAWfMushDSw24YsWNzdOh3A6avbobcrO2XuNFZWqBSzmzQ1mUew4eKXflb
	 JwEnUFZ2Pz0iL+V5uBgUT23z/zxM+Tma28ot0HYfvRmxJH5NNiu3ndrZroLSTqyQmI+se
	 O2I6cC4391sc2neyrbsq5DxJFP4vXEfo159G4jeqQgZQgDzUTUpM4uZj2h3rnRrq/ew==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794957209;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=F7u8VyCLcuVVeJxUa6WMZkgWVLg+37GZd/uec2cfUY8=;
	b=AzHQT9pifHBeczMWCHuxebGJQ7dE/UQoFOLqmbjZU1wIqYqYgEDkmlCfZXx5uRsxTzNJ
	 v118yZNd0n63ARWr2klVruNWwVK2H3C6fAYzju2hM+RKfCPsU6hR8hV3tTBTEuMo2wPmm
	 rG9mZuY29HVHhIvUsHDPjwRuY3tY2CHq6LiWIOiPGOtMiyQ4eD97iNDZGFFL7fsk3Ng+q
	 teBzUzuAJ4wE7SaRbs3Jq520mvwAcVECIwwiCW/WEKROr4NEtn/iadQ3/wgp018r1dICz
	 ju+uK4Pa0ADRyzGEMfpvTTJWpzfP64Pb6WQO5qt26ijCFx6WtQXG4I9jw9BXZwhRwQA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gBJoYg52;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C43606A31C
	for <patches@lists.linux.dev>; Tue, 17 Nov 2026 23:13:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3C43606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gBJoYg52
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6b8784a3284so681898a12.1
        for <patches@lists.linux.dev>; Tue, 17 Nov 2026 15:13:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794957207; cv=none;
        d=google.com; s=arc-20260327;
        b=O11rycuBpamjzlAn1s9LNn/mlothQeqG4hncD205ztvdFViSjwax/xBBIHr8t/2KZD
         zGLVSMWunaCNTeA0/WmFCHQ1a0av8qJfXW5JoDdh0ZWEP4Us4yKsPN++1XEdvCjBBbE5
         Xnl0+FDaiHCp7lrEjQVFXKxdC5PdDSlN+ofigY4RDk2LmqKhfGlOLsmE9vXY1nKbWEPq
         ycF/KV9Cy8pAkcFk4YvoKqhR8+S3M+VVuNzbzTxYmMCKH2yWahkA1IgLySNwMYJyKqh6
         NqgYZj4XQOBOi9bxRHuInOWoCfNuD8JtMwo8cSY2V3dKkDYQaW+I8gZMPqK0zvsGtpaG
         BiGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=F7u8VyCLcuVVeJxUa6WMZkgWVLg+37GZd/uec2cfUY8=;
        fh=5TGhVfvZV9Us7eOwvLIsAIRWA4Qq9AdZsXrvZrOqWHk=;
        b=BZmYPwNq7yGjf0MhfYcQWxMQ4GMhqMqONuaH9aq92htrEctTcW24qv2a5mwPkqJEYa
         9XzYRcER15sI9/PCyvLKem+KQWLms4bCAWGJZ4ucf97dM4THJUOQdr/emLtn295FpitW
         VDuW92sm65ExEXb1Pu4gWeaC5XB/fAEQAaMhgBut3sMVHzhpL2PWe29Ttdcn6RoJTMYy
         FJrqlYDTGJRR2T5OqwE3pe3VFVQRMBrTxsV69ppRDSTwshA1U9bd/NjG4ZKRX/LwWqez
         p6xm4tDuv7B//lZJBSFwpLgxy5F00dq6OXsaSX5cS3Nisk8vHx/i+2l8TVwiBG8bw0Yv
         qA9Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794957207; x=1795562007; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=F7u8VyCLcuVVeJxUa6WMZkgWVLg+37GZd/uec2cfUY8=;
        b=gBJoYg52GuJyAgJuAOWgyJxCsgLq5dTm/a/hR15zBf2GFGyrzhfLIDf3DfNz7F72W3
         UArQXCvq/WNYivQn7pR2ZA23iZPvixnezEUSa/5j/jkvojWRY/qLrLv50yo2MCpFnWod
         kGWicclVZtVmODZyP9NJlQt+it61s2KfyqCtH2xnozUAlSV8CO85hHzOp+NXfij/Z2kc
         O7bhQ2nDug/+8vH5y46o0HMc+WcfP/OYoWv52fZ1WmphmkmsfyI1vlCNriBkWA/KUrDV
         jTQbbYkOMdoVK3+wZMhiA4jxf5P5f0r37xr1s9tsGKDkZk0qDMXV0vj4/M3aK6YIyQ7m
         J2kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794957207; x=1795562007;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F7u8VyCLcuVVeJxUa6WMZkgWVLg+37GZd/uec2cfUY8=;
        b=UPwrJb/yd0dpk7Uo2C2+pnZCNS2dTo4Uad5moyGxy8eoPccRJAyWdbNGI0sRLP2MEq
         FhvxNhBVm0Bq/CnhX9KJF3VpxOvTT1I1bb7irJyr7HY7efBeo4XDHxhycRwvgD0dYz2N
         JWdGJ4nPWLrZypyD/shbjrTNYzL9yXGoEpjQH4lSV8F0SAott+c5Ga9N8j0LZJIzxJMT
         vcTT81+Bn9VKHfsQF6FY65tMfD5HstOOOyWBuHf31Lm9iAA5L78K2yuzYddf1dVa46pD
         9EYxEam8qG+hH33O8bFDUVYRtZOF+0saQLGFnjbuqVOTUnOR4w/W/ykhw2fzqj2TNekG
         sNEg==
X-Forwarded-Encrypted: i=1; AL+hErEncRBOeSCZespESWsYeJzANZ9DuNisuoV7M2LPrQt328ztbzWxJvlzXlTRUHvPinhFq3qhdXEb@lists.linux.dev
X-Gm-Message-State: APuU4Z+e/hkxeYwyPppiVIdnSW2SuPiL/hIyBvO+IAQTMvE0JtdXxW9J
	qTpHJV7Y2wEuJadvSpNFwvgc3BbSrS/r3QIZ3mTfuRrI4SBx67R/SCrEpvEUShau6K/QP+6ysGp
	gI3MblJFgjSUjRPPNTan7/qPh5+UhM64=
X-Gm-Gg: AYBFou19Ffa2pR46co6Cty7PESamfOdUJojjG6VZKG1isZev2WIg5sIHCSKN7XcUxmC
	JkVMccxFVwuMuDPaI6zVkkoe+uqRQYKheA7omYi9ucLRDbKYcV2ujDnTDj2HfrHTAMaWzf71Cjo
	jDZnYFcRAacMlDGEOCugOJwdJZHnd4iEMnm2r55MyiJKSvIgEkJFUP5cKHKqo7iPcF0SmX+nVYB
	sRe8RcTmBldYMEq9Q6GP0M2f0jqbLoe/w0YSv2zgNDCXgdcL5TtLt/bJ9Bmhidd6DMZnt9BDHED
	h6gO7rJf5eXgYHUaAGrdhd/rp7XUadBLGQ2nwkCWwHGbKsuWfUt9HTT92lUgRN4T2qjGaA+NKEs
	C8Z5NLsyq/tOHbSHGGmViEuLK5kS2CPlDiTKMUFOEF6+ZFHzOVbYGvQpGNMAkynF0gH0=
X-Received: by 2002:a05:6402:849:b0:6b8:6f89:33de with SMTP id
 4fb4d7f45d1cf-6b888155763mr513976a12.44.1794957206761; Tue, 17 Nov 2026
 15:13:26 -0800 (PST)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com> <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com> <20261106193018.GK770409@nvidia.com>
 <53bc57bf-1ee1-407a-b48b-bc6b2deee12a@intel.com> <20261108183337.GL770409@nvidia.com>
 <2b89b830-f1e4-4304-93ee-40287a4b5b2d@intel.com> <20261109185315.GS770409@nvidia.com>
 <4765e562-8c58-4e0f-89f4-eec23b5ef102@gmail.com> <20261110150747.GF738765@nvidia.com>
In-Reply-To: <20261110150747.GF738765@nvidia.com>
From: Alistair Francis <alistair23@gmail.com>
Date: Wed, 18 Nov 2026 09:12:59 +1000
X-Gm-Features: AclHuK9BqaTHMXLq-tjbK2K5Ee-2S_dRmHV8TMHcBR4rNkNet-jbTgQNocUrT1o
Message-ID: <CAKmqyKPQXnMiiD9z3Ww-YoOTOdByeCeNBLMXVYENDJ3+Qfab-g@mail.gmail.com>
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Dave Jiang <dave.jiang@intel.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, 
	Xu Yilun <yilun.xu@linux.intel.com>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Jiri Pirko <jiri@resnulli.us>, 
	"Tian, Kevin" <kevin.tian@intel.com>, Alexey Kardashevskiy <aik@amd.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Steven Price <steven.price@arm.com>, Kiryl Shutsemau <kas@kernel.org>, 
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Jonathan Cameron <jic23@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, "patches@lists.linux.dev" <patches@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 11, 2026 at 1:07=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Tue, Nov 10, 2026 at 11:40:46AM +1000, Alistair wrote:
> > On 10/11/26 04:53, Jason Gunthorpe wrote:
> > > On Mon, Nov 09, 2026 at 10:37:14AM -0700, Dave Jiang wrote:
> > >
> > > > One thing on TDX is that TDH.SPDM.CONNECT also runs a
> > > > GET_MEASUREMENTS of its own during the connect, and the kernel
> > > > doesn't choose its nonce. The kernel wouldn't hand that one to
> > > > userspace. Measurements only come out through the two flows, with a
> > > > user nonce.
> > >
> > > Why? Seems like another wasted operation..
> > >
> > > > That works for TDX. tdx-host's relay is one function today. It take=
s
> > > > the module's request from a page shared with the module and calls
> > > > pci_tsm_doe_transfer(), so att_spdm_doe_exchange() drops in there.
> > >
> > > Yeah, it looks like it works for everyone.
> >
> > Jason just pointed out this thread, I've tried to pickup what the discu=
ssion
> > is currently up to, hopefully I've understood it all.
> >
> > It sounds like the current thinking is the TSM will issue all of the SP=
DM
> > requests and be in control of the session. The kernel will forward thos=
e
> > requests to the device and Rust SPDM in the kernel will be used to deco=
de
> > the responses.
>
> 'capture' is the word I want to use here. We actually don't want to
> decode them. The goal is to get the message transcript and share it to
> user-space in a 100% consistent format derived from the spec.
>
> If DOE had a more sane protocol this would be trivial, just unwrapping
> the DOE transport and recovering the exact SPDM messages then storing
> them away.
>
> We don't actually want to decode them in the kernel. The padding issue
> means we need to decode them enough as part of sizing them :(

Yeah, for some of the more complex responses that more or less
requires decoding the entire message to determine the length.

Is the kernel interested in detecting errors in this case? What
happens if a malformed response is received. Should the kernel raise
an error, or just ignore it and let the TSM deal with it?

>
> > The TSM will be in charge of slot selection, bank selection and algorit=
hm
> > support.
>
> kernel will do slot selection, but TSM will drive the slot numbers in
> the commands. Yes on algorithms/etc.
>
> > The current Rust SPM implementation has split out the message processin=
g, so
> > that should be somewhat easy to reuse. Basically (in Rust) you pass in =
the
> > bytes of an SPDM response, specify what the reply is (CHALLENGE_RSP) an=
d you
> > get a nice destructed struct back (or an error if it's invalid). It's a=
ll
> > called the Validator as it validates Untrusted data and returns an SPDM
> > response.
>
> This isn't quite the right thing, we want a module that undoes the
> transport chunking, padding, and GET_CERTIFICATE chunking to store
> pristine raw messages. We don't want to validate or decode them,
> beyond what is necessary to undo the padding.
>
> The goal is to pass pristine message bytes to userspace as the
> transcript report.
>
> Your series should have most of this, but I am guessing in not quite
> the right arrangement.

Yeah, I do all of that, but not in a way that will be useful for you.

I guess the question is, should that be re-worked to be more useful
for you, or should you just use the 1000-2000 line custom C code your
LLM talked about?

>
> > > But it brings forward "rust spdm" or something in a new form as a
> > > pre-condition to do the TSMs. Which is annoying for sure.
> >
> > The Rust SPDM code is hopefully really close! I'm planning on sending v=
6
> > today or tomorrow.
>
> No TSM drivers will go ahead until all of this and the uAPI is fully
> agreed..
>
> Plus now there is this issue if we need to reorganize things to
> support this capture flow.
>
> > > The optional chunking features are a bit tricky, but I don't think a
> > > 1.2 only implementation needs them. They seem necesary for future
> > > post-quantum.
> >
> > Maybe for PQC, but generally this doesn't seem to come up much with DOE=
. So
> > for now it should be fine.
>
> I gathered the PQC issue is the signatures can get really big and the
> biggest DOE chunk may not be sufficient anymore depending on
> implementation.

Yeah, mostly. It's also different requests/responses, nothing too
difficult, but it's not automatic.

>
> > > This also formalizes the version locking: the TSM FW cannot use a SPD=
M
> > > version that the kernel does not understand. I think this was already
> > > basically true, trying to do the 1.3 multi-slot flow is not going to
> > > work out with out kernel support to move the additional data. Maybe
> > > nobody noticed, but with this scheme it would be really formal.
> >
> > The kernel patches support 1.0 - 1.4, so that should be fine.
>
> Not support as in "I can be an initiator and do a limited subset"
>
> Support as in "I can be an observer and accept *everything* in the
> spec the actual initiator might use"

Urgh... That's a bigger step again. Probably not too hard to support
just to calculate a length though, as you don't need the actual
functionality.

>
> For now all we need is a fairly complete 1.2 since that is the minimum
> rev for PCIe (by spec) and the only thing any TSM FW has implemented.
>
> > > But, I am strongly tempted to make a draft placeholder in C with AI a=
s
> > > a way to get alignment and try it out. Something we can throw out if =
a
> > > Rust version comes along.
> >
> > I would argue that you would be better spending that effort on making
> > changes to the Rust code and re-use that. That at least would make sure=
 it
> > can be adjusted to do what you want and would be more useful :)
>
> Heh, well I don't know Rust so I'm useless. I also have no Rust
> knowers to recruit to such a project right now.
>
> The best I can do is make a draft with AI reusing parts of your series
> that shows exactly what I'm thinking and we can talk about how to go
> from there.

I think I understand the big picture. The hard part is splitting it
all out of the current approach, in a way that doesn't just make
everything complex and messy or reduce the security of the CMA
approach.

>
> I fear it will not be very good rust though. I fear this will be a
> huge delay :)
>
> This direction would end up with two series, a core bit doing the
> message capture and a secondary one doing the in-kernel
> initiator. Maybe we don't need any new rust bindings just for
> capture..

There shouldn't be new Rust bindings, it should mostly just be a
refactor and then supporting all of the optional flags.

>
> But sure it is just AI $$ we can have a try.

Ha, I'm sure you guys have lots of those :)

Alistair

>
> Jason
