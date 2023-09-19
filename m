Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA3338BB2
	for <patches@lists.linux.dev>; Tue, 19 Sep 2023 08:39:58 +0000 (UTC)
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-32003aae100so1727357f8f.0
        for <patches@lists.linux.dev>; Tue, 19 Sep 2023 01:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695112797; x=1695717597; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JrX/o9IaaLd8C3/27VSA5k/8nslPmD25D5g+cKSefCE=;
        b=NG9GJTh+x70eFQ+UooARr56YiZGE8dBM88IxO1T/YAbEqn7P5+fpWmc9++Kdhu9sD8
         RCoCtarVOCTeVDGCFMjIeUdlOBCfRGvJhuz08w1Dpp164WyVv34xswq735iK38zH5voo
         gBMTwt5GJvKrd60zxyVVRw5MtGT53yIjPDVF4hJW/OcsxJ4mtkj03YXMptzIVHBesSF1
         V+AMDDnzcXVKR73BtI++GSObEw7L7RTlyfhFReRtAzoRK87cgfP3BhDDUnBr2j7SHgRW
         VbWnmYwC3TS1+jeSJTqmYyFy2xJMDwYXCEQfWmCuxnM2ZK5ufG6solPGT5DeDSA275HJ
         KEhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695112797; x=1695717597;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JrX/o9IaaLd8C3/27VSA5k/8nslPmD25D5g+cKSefCE=;
        b=OuAB+i2/Nei7RjUtinw6q3nM3m45NGwsgAZSc3PDm36LYJT1xu5zgQHFC9yUmlZRuQ
         4nQWa1Wo4ot1vXQZxfq/kZTYpLVgQf+Dm1JLEnETkIw+DFDTBAYwUzjiNGVWVNHPYCQh
         b6mlRaKMLGUvY306pNZEHNZIVzRe9rs/cOYiq9/pcdLZ1i8fwLmgHVnGE7Aga/+oOp36
         rprk9Yi7wFhOa2RRXloNe57fgDy7mcuuE57vTVP2ZS/QFT/J4zDD2c7D3KxsJYR3UxdN
         SXjdOhdwWIJv6hDoRwldMibKWWEQFPf7lOItpS8g1ntIgc0Am1ZICNSWNjf8Bt7Q8EtG
         owqw==
X-Gm-Message-State: AOJu0YwOgFQkZPw7Hk2AJg5pLm424bpDd0FTIYaa0jdvrZWqoH3FKDAu
	VsiMgpRqIqxv/DDrnv/90Wfa+kTvwHz2XxXp2II=
X-Google-Smtp-Source: AGHT+IG8fnudphfgdHldNvvN6b9HAIfRVnw9j+S5EodSB92Oy7omzXNzKjvaXZIc8FjPg6CYiCvZuPP1S4vu4R1ZY4M=
X-Received: by 2002:adf:ed02:0:b0:31d:db2d:27c6 with SMTP id
 a2-20020adfed02000000b0031ddb2d27c6mr1286973wro.30.1695112797112; Tue, 19 Sep
 2023 01:39:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230911134650.200439213@linuxfoundation.org> <20230914085131.40974-1-gerhorst@amazon.de>
 <2023091653-peso-sprint-889d@gregkh> <b927046b-d1e7-8adf-ebc0-37b92d8d4390@iogearbox.net>
 <2023091959-heroics-banister-7d6d@gregkh>
In-Reply-To: <2023091959-heroics-banister-7d6d@gregkh>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 19 Sep 2023 01:39:44 -0700
Message-ID: <CAADnVQKXqaEC3SOP9eNQH1f3YF0E3A_54kSEsU2LvCL_4Awe8g@mail.gmail.com>
Subject: Re: [PATCH 6.1 562/600] bpf: Fix issue in verifying allow_ptr_leaks
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>, Luis Gerhorst <gerhorst@cs.fau.de>, 
	Alexei Starovoitov <ast@kernel.org>, Eddy Z <eddyz87@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, 
	patches@lists.linux.dev, stable <stable@vger.kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Hagar Gamal Halim Hemdan <hagarhem@amazon.de>, 
	Puranjay Mohan <puranjay12@gmail.com>, Luis Gerhorst <gerhorst@amazon.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 19, 2023 at 1:34=E2=80=AFAM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Tue, Sep 19, 2023 at 08:26:28AM +0200, Daniel Borkmann wrote:
> > On 9/16/23 1:35 PM, Greg KH wrote:
> > > On Thu, Sep 14, 2023 at 08:51:32AM +0000, Luis Gerhorst wrote:
> > > > > 6.1-stable review patch.  If anyone has any objections, please le=
t me know.
> > > > >
> > > > > From: Yafang Shao <laoar.shao@gmail.com>
> > > > >
> > > > > commit d75e30dddf73449bc2d10bb8e2f1a2c446bc67a2 upstream.
> > > >
> > > > I unfortunately have objections, they are pending discussion at [1]=
.
> > > >
> > > > Same applies to the 6.4-stable review patch [2] and all other backp=
orts.
> > > >
> > > > [1] https://lore.kernel.org/bpf/20230913122827.91591-1-gerhorst@ama=
zon.de/
> > > > [2] https://lore.kernel.org/stable/20230911134709.834278248@linuxfo=
undation.org/
> > >
> > > As this is in the tree already, and in Linus's tree, I'll wait to see
> > > if any changes are merged into Linus's tree for this before removing =
it
> > > from the stable trees.
> > >
> > > Let us know if there's a commit that resolves this and we will be gla=
d
> > > to queue that up.
> >
> > Commit d75e30dddf73 ("bpf: Fix issue in verifying allow_ptr_leaks") is =
not
> > stable material. It's not really a "fix", but it will simply make direc=
t
> > packet access available to applications without CAP_PERFMON - the latte=
r
> > was required so far given Spectre v1. However, there is ongoing discuss=
ion [1]
> > that potentially not much useful information can be leaked out and ther=
efore
> > lifting it may or may not be ok. If we queue this to stable and later f=
igure
> > we need to revert the whole thing again because someone managed to come=
 up
> > with a PoC in the meantime, then there's higher risk of breakage.
>
> Ick, ok, so just this one commit should be reverted?  Or any others as
> well?

I don't think revert is necessary. Just don't backport any further.
