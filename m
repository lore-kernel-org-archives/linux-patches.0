Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4720188713
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 14:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775053962; cv=pass; b=auyDFPr47X0aiJNiJeWMF9QyhebjqNk6BoAfqUZWjiw+uJxEgWdZzKT17KbcCS4BowzcyFs2OYb7pOoPaj5kVHH7OAswY29vCEnSzgJlwiAOCrX3nWgXkIHEbgBfK3df+uBU567JLMrX5r3Qo6Hmn+nb+fpfA2ITQqy4Iwjpj4M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775053962; c=relaxed/simple;
	bh=XaMfUH02oYMrD9jBToB3ald/aQh9AL601otOm6ZFYr0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C2P+RA3+qxgHHE49V3VVHx3ICle+6tR8HKLjsLKL4NnXKpkXQ52BWLowYqrakPylB4uCihFx3mauR77KwxQ80MwufTi0OCfdQh2dXpCIgEPTOHjiw9cyYpFsg03rgYQs/PaHGQzUpWS7WjkrJE72meUDt0REet2KqeBn21yWKUI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bVgD6zVJ; arc=pass smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bVgD6zVJ"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b9c1da7ac63so133195866b.0
        for <patches@lists.linux.dev>; Wed, 01 Apr 2026 07:32:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775053959; cv=none;
        d=google.com; s=arc-20240605;
        b=BCpNt+4+uHA8rL86xH5oxFGu+kelLRgdF6pfZ8PmOBuzctgBQ2dg91DeCbZqYzF4KI
         BcoG18BfbaRL1g6KKQhD/eNXZ6dFV2sQO5ZfFXpZrhPWx6/vMC8Pe4fwFCSkGSq4iHdS
         43iW+ZLyKx1Shk2EOAiJpvLQAbo2UJEJ1kLSqBOvUGwhoixmBeM8XyrVbQYfDhA5IjyL
         7r/MWo5ZMEo+1FbxSLLESeAO2bJiOqBubaxIztuRUXVKEgjBBJUnibdR2hpQR5XZ5XID
         aHbl0xaCVHCIJHPbSQhg1KRi+Py/LhtuxnVaaU72INFWWuUcJkwOZKNTiz5PlEB1hVOG
         QioQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=214ntsITO7VOPzCNbP241Ydd138fuA/mCLIQDcrarVQ=;
        fh=uuMIe5xvmR3T4mOg6WiI58f5KXqluj/1GFvtqFgicy4=;
        b=Q8DX427UHP36CqjwZj553ThSjo8kfkqDQb1izAfj+sAMpmZXE3w/ZF6rNWtAdekZur
         DqPQZQvcxphdQbb5bm0B4hHI7C86IJPVLc3O9WWahkTUspfPSzS+RFuEEeIIIdUNtoiv
         Fzl2qybE/X9EmehF03yKsJzLNJBoN4PCn97OVce4YSpwJTj5xzuKAi2RkOxsOy7rx+wo
         fMvVKbIQ5dtl5Rlsfz1sXhuivPlMIYNweak6nS2uTHmprIziKUVn6xBbKhP2x34cJBpm
         1jz0sggOQtffyq/s51f8PYOmAVTCDdhBuJzh0slpZn/C0v00K+34WJwm5BZhvX9n73nz
         0FRw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775053959; x=1775658759; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=214ntsITO7VOPzCNbP241Ydd138fuA/mCLIQDcrarVQ=;
        b=bVgD6zVJSAFOlUdaqz2PZnKlnZeq+IXfKUrphRcMdNCJ8tNDeudOq8cmbX8cA48Y0K
         MilLOUZcgpxnNgLYAy0IW3Vy7M3SA98sBHuLrnnn5lD6/hsxfp/KxUyNQkPb/F2+rdTO
         VdJJDBXK/EtsQ9VGnn5MFEE7di2o+v3hrwAvN2zXPWxr3xC2JvzshCcv5wyYbF6bQdso
         6LMFy1Gy6UumpJRPtI6t1x/BZHx/Hwv7AVdDi3QNUIfgJA+1rBrSWyXKcOqnjIVWq8sG
         YWykqtxYYpw3W7/8pTwK+Ntm8D65JywcCdQnp6nP1qXLdPyCsdKZbuUOMl2jN0nhHA7h
         VVhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775053959; x=1775658759;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=214ntsITO7VOPzCNbP241Ydd138fuA/mCLIQDcrarVQ=;
        b=Pb+qYUcVcx7WnCeZAoDc1Oq7YA9A1idBHIAqdfKCsIA8+SPul1YDFS0lySkKzzGoxx
         8IzGK4XGbukTkGGVzESsBMPS7pHIchtAASSxF+Q5BsPNBGcaUjD6/zNQlHoYqn6d5oJN
         MuSW+GZI/y3AlpTOYiT+c+ClSrEBjGNgYN9/55TksnTSzaJct2tuvKKLyejEbhu4rCVu
         1iCubZcxw/PSNJhfg/jG63QLd4p4+F/1mzvI7H7m8nUtDyL/px1jrZhj06JGuU/mDmBN
         RNVwQOD13MPE5ijeb2gjDPHZsinOUWHWM4KTca+cEcuJ8/mbbPhXIQDS6tMMQAYDHyQE
         grOA==
X-Forwarded-Encrypted: i=1; AJvYcCXQSugR1wUabmsodSt8VE8LSj4o2uFi+GoMJItRFDuKsh8r9xKvm7D7yVX7WD3Di5dbrjNZnobZ@lists.linux.dev
X-Gm-Message-State: AOJu0YzgiibnbXefRTz8bJnnIhPxkElhqNjyrIHaUb1n8Ol+YuB36LZA
	S3Gqj0Ds1CtJKcJZOpYbK62DGrRApqHXTz/t5BUgT/Bo8QxDFu3Q1ccU0atL9ULlTmzV08ChCzE
	vhiROZpKuB7DutyYPWBXN63HQpqV/c1s=
X-Gm-Gg: ATEYQzyqMXAVbpIXkCux2KU3D1VrAdkYRBMchKPQYwimKGPOWRZWb+CUhk9U4yZ9/28
	H9MjT25sC3CWcgtcYtGzhEd2aeZrvJTYlwlwNrhTvyLI/mYZROH97/Dd05uf978RB/gwIHjIdwi
	TOxtMfbunJ1O/4IPoP62XeHNRuEMgW9GJiUH2+PTmVaSmatYUBhO8njfHbSTs3ddR/bnz7IJsdi
	EUN9v02mpk3yN3nPXRxDTCqHe9dwvMmFrJbK/H/ldR+5cOwI/TDk/9GP6SGmg0UtzQqlk1PMfnu
	qcT1vaCzA1Uz/9yOpP1FdRhUu/YpUN0gJFP8uRsDzRdEn79ehnfEIIidx7sC3VVg/+f/q54DIIo
	ItS0ycDm3ImZJxDskS+yL
X-Received: by 2002:a17:906:e0c6:b0:b98:1b18:782c with SMTP id
 a640c23a62f3a-b9c137b54f1mr196289066b.6.1775053958657; Wed, 01 Apr 2026
 07:32:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260331161741.651718120@linuxfoundation.org> <20260331161742.960922011@linuxfoundation.org>
 <i4c753x3y67ek3r7dp774pcmaaaid3gvxcsvdssosdingre4in@od45qzitwtrf> <2026040115-dose-aerobics-7c6d@gregkh>
In-Reply-To: <2026040115-dose-aerobics-7c6d@gregkh>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 1 Apr 2026 07:32:26 -0700
X-Gm-Features: AQROBzCMxWD9iSptIB9IWDuC78nahPwj7Gh-nabCq0dqjkd4j_Bk7ubHWIV9Nvw
Message-ID: <CAADnVQLSfDtqeLFw=DjG-dG=xD_qS7p2LHsT9jAxO5aAK0YJig@mail.gmail.com>
Subject: Re: [PATCH 6.12 034/244] bpf: Fix u32/s32 bounds when ranges cross
 min/max boundary
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Shung-Hsi Yu <shung-hsi.yu@suse.com>, Eduard Zingerman <eddyz87@gmail.com>, 
	Paul Chaignon <paul.chaignon@gmail.com>, stable <stable@vger.kernel.org>, 
	patches@lists.linux.dev, Andrea Righi <arighi@nvidia.com>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Alexei Starovoitov <ast@kernel.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 1, 2026 at 4:44=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Apr 01, 2026 at 02:22:58PM +0800, Shung-Hsi Yu wrote:
> > Cc Eduard and Paul since they know this change better.
> >
> > On Tue, Mar 31, 2026 at 06:19:44PM +0200, Greg Kroah-Hartman wrote:
> > > 6.12-stable review patch.  If anyone has any objections, please let m=
e know.
> > >
> > > ------------------
> > >
> > > From: Eduard Zingerman <eddyz87@gmail.com>
> > >
> > > [ Upstream commit fbc7aef517d8765e4c425d2792409bb9bf2e1f13 ]
> > >
> > > Same as in __reg64_deduce_bounds(), refine s32/u32 ranges
> > > in __reg32_deduce_bounds() in the following situations:
> > ...
> >
> > Hi Greg,
> >
> > This patch is causing the following BPF selftests to fail
> >
> >   #222 reg_bounds_crafted
> >   #222/27 reg_bounds_crafted/(u64)[0x7fffffffffffffff; 0xffffffff000000=
00] (s64)<op> 0
> >   #222/28 reg_bounds_crafted/(u64)0 (s64)<op> [0x7fffffffffffffff; 0xff=
ffffff00000000]
> >   #222/29 reg_bounds_crafted/(u64)[0x7fffffff00000001; 0xffffffff000000=
00] (s64)<op> 0
> >   #222/30 reg_bounds_crafted/(u64)0 (s64)<op> [0x7fffffff00000001; 0xff=
ffffff00000000]
> >   #222/59 reg_bounds_crafted/(s64)[0xffffffff00000001; 0] (u64)<op> 0xf=
fffffff00000000
> >   #222/60 reg_bounds_crafted/(s64)0xffffffff00000000 (u64)<op> [0xfffff=
fff00000001; 0]
> >   #222/79 reg_bounds_crafted/(s64)[S64_MIN; 0] (u64)<op> 0
> >   #222/80 reg_bounds_crafted/(s64)0 (u64)<op> [S64_MIN; 0]
> >   #262 reg_bounds_rand_consts_s64_u64
> >
> > The failure is caused by the selftests' expectation not aligning to the
> > stable 6.12 behavior. I believe the easier way out is to drop this, the=
n
> > wait for [1] to land and pick it up in stable (or I'll try to backport
> > and send). That should address the root cause of what this patch is
> > trying to workaround.
> >
> > 1: https://lore.kernel.org/bpf/d4fe45f8bd5c6a48efd2ba3b66932bf7eb5aa020=
.1774025082.git.paul.chaignon@gmail.com/
>
> Now dropped, thanks.

I suggest ignoring the selftest failures.
The patch is necessary for stable and backports.
It's fixing a real issue.
