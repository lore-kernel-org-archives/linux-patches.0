Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EFE8172A
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 16:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708534382; cv=none; b=JHp5sGRtdKFQ5F9r/LnOCjS+0QVGgGdJZadH7W1ko6ogMMPGXNXPFFEXf3t32qfKXgBJRwRAnRLH4GDiyjDw1xL7ZRnm6PDO4awv895w8sIhSiK9xO6PTHMPqMcldDmwPHMt8veQocvr1+wJvxmzBx4FhLZl4DIk1NOnwk7ZgJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708534382; c=relaxed/simple;
	bh=FdTVZUN8jA8vDojCkcLqwg6JFZMnfdSMFaoqTpvoSU8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mUfyCjK0mDnUSxpmrpXygjPM/4QdZbMaAaGoPGSYTHCn/U5ea+4Ed6nas/0Ibs4Ht3J2F0v8xW6x2/4oeym4h90Swm7KIQaIkMBGsPN2rB3qD8b+fPF4roW6lrrl8RctQD0OOyxelRx9F4gqBoEhhBZ0mHXwHgR6N/hJLSDy0mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ssUSCJeI; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ssUSCJeI"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-42e0b1b11bbso181581cf.0
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 08:53:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708534379; x=1709139179; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=paZPA+1yf1I1mD9jTiD5GhTSSXqEn90JG/GxIlAh1vA=;
        b=ssUSCJeIBUlyY1O7+/ZmASMK9cmtSIzxVb8ZJpCUDAxYLszYOCtmcjXH0DgbyLb2a8
         703hWEvUrnVY5vNok5q/5zj53CPXjblb0eehOw4hhXVhgNfSiqif37XYIr2qFwh9QXiS
         wD7FAtVHR8LxuBG9gl2xud9OCO6RMofEY7YuD2Tl2/D0Owun7rWoAEbMSXAGLQaFrPLx
         QYet8Q0HtZbnWsTfEx0++L4k4FPepHiNCeImTtBaMy9QocD+xAlHKyg8Jm1R9QPhjqqm
         w/LrjbRve5U0HVwqHqxWPcrHL3qwRZ1DHK/jY+D+KVqWf0RAGxQIOjRnFvXexQ4QWqeQ
         aJbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708534379; x=1709139179;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=paZPA+1yf1I1mD9jTiD5GhTSSXqEn90JG/GxIlAh1vA=;
        b=cKmzIjEQH1Eo5dfpSf02vuOeK4GHOBjIVfs8I5WY9XBaO10uKbmu34TUQUKFFl/t4/
         qoAzN3pnIPUPG+mFA+uBWr5pW/yCa9UVUtnGy+kYEE8mIpWjZj2q9QDGhM/0gDia7Seq
         fojuTGhwjsRR4BzBwUVQfDgbeRYcXuKNNmn2mAZVP7IZ11rM4cThJupEQTf12sEzUx1G
         ikIuJExhCOrLhwg3VxRheFmn+uyovTEK7Ew3+u8Ogdmb1c1mn4YcvVapGnQofFgHJnMV
         DGwC4i5uAK+Mt6G0EcU0VATNVbeOttkyfPtIKEeNt7uHlXZEshkT99Buck5sI00Nl7PE
         XoQA==
X-Forwarded-Encrypted: i=1; AJvYcCUpiU8v6z5MY0Vs96V2hm6XqIxTKpZmAzJqfsRQZrla12KW8SML/jBDbQIxVGiFhk7J5eyfjiEvlVri5+Lv7M6dfeHxNAFEQw==
X-Gm-Message-State: AOJu0Yz2a92JH+kVKXC+P6THJiNwlaAtdrd0lOY4MxcMYpDOrW1uYV8y
	26UW1HcJQ/7aAzGxnXlteXZtPmLWXrqUwH4n3OTezFCzLq8hFRYTywkRs7qqTxzjK0nknAlr3fG
	xBc0voAYD/Jlh24fAzKumWuLBuhA2tXjhHxp+
X-Google-Smtp-Source: AGHT+IE/To1yvno8AuzIbajiKrMH1e4IHoS6KkfHy6iRNf6HMlZVXF6f8Zqec+Ccer2JOCKLlVAq/s48Im93aQJXtBE=
X-Received: by 2002:ac8:7c47:0:b0:42e:36fe:df90 with SMTP id
 o7-20020ac87c47000000b0042e36fedf90mr269484qtv.1.1708534379265; Wed, 21 Feb
 2024 08:52:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <1-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com> <20240215134952.GA690@willie-the-truck>
 <20240215160135.GL1088888@nvidia.com> <20240221134923.GA7362@willie-the-truck>
 <20240221140818.GA2635804@nvidia.com> <CAKHBV25XrwOXyrYkjLZ7=5sNoFsM8VPS=HaJupswu6QDZ02LcQ@mail.gmail.com>
In-Reply-To: <CAKHBV25XrwOXyrYkjLZ7=5sNoFsM8VPS=HaJupswu6QDZ02LcQ@mail.gmail.com>
From: Michael Shavit <mshavit@google.com>
Date: Thu, 22 Feb 2024 00:52:21 +0800
Message-ID: <CAKHBV25BMzLWM6xsqNyEYMhWH9GFwzYWQaTvTrXnmbsre8B_+A@mail.gmail.com>
Subject: Re: [PATCH v5 01/17] iommu/arm-smmu-v3: Make STE programming
 independent of the callers
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Will Deacon <will@kernel.org>, iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>, 
	Lu Baolu <baolu.lu@linux.intel.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>, 
	Joerg Roedel <jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>, Moritz Fischer <moritzf@google.com>, 
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev, 
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>, 
	Zhangfei Gao <zhangfei.gao@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 22, 2024 at 12:19=E2=80=AFAM Michael Shavit <mshavit@google.com=
> wrote:
>
> On Wed, Feb 21, 2024 at 10:08=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com>=
 wrote:
> >
> > On Wed, Feb 21, 2024 at 01:49:23PM +0000, Will Deacon wrote:
> >
> > > Very roughly, yes, although I'd go further and just return a bitmap o=
f
> > > used qwords instead of tracking these bits. Basically, we could have =
some
> > > #defines saying which qwords are used by which configs,
> >
> > I don't think this will work well for CD's EPD0 case..
> >
> > static void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
> > {
> >         used_bits[0] =3D cpu_to_le64(CTXDESC_CD_0_V);
> >         if (!(ent[0] & cpu_to_le64(CTXDESC_CD_0_V)))
> >                 return;
> >         memset(used_bits, 0xFF, sizeof(struct arm_smmu_cd));
> >
> >         /* EPD0 means T0SZ/TG0/IR0/OR0/SH0/TTB0 are IGNORED */
> >         if (ent[0] & cpu_to_le64(CTXDESC_CD_0_TCR_EPD0)) {
> >                 used_bits[0] &=3D ~cpu_to_le64(
> >                         CTXDESC_CD_0_TCR_T0SZ | CTXDESC_CD_0_TCR_TG0 |
> >                         CTXDESC_CD_0_TCR_IRGN0 | CTXDESC_CD_0_TCR_ORGN0=
 |
> >                         CTXDESC_CD_0_TCR_SH0);
> >                 used_bits[1] &=3D ~cpu_to_le64(CTXDESC_CD_1_TTB0_MASK);
> >         }
> > }
> >
> > > and then we can
> > > simplify the algorithm while retaining the ability to reject updates
> > > to qwords which we're not expecting.
> >
> > It is not much simplification. arm_smmu_entry_qword_diff() gets a bit
> > shorter (not that it is complex anyhow) and other stuff gets worse.
>
> I think the simplification here is in the first if branch of
> arm_smmu_write_ste. With Will's proposal, we only perform a hitless
> update if there's a single used qword that needs updating. There's no
> longer a case where we first set unused bits in qwords whose other
> bits are in use. I'd argue that setting unused bits of a q word was
> very clever and removing the logic does conceptually simplify things,
> although yes it's not much fewer lines of code. I also don't think
> this throws away the entire logic of the current design, the idea of
> counting the number of qwords that differ and writing qwords that are
> unused first is still there.
>
> But, it does mean that hitless updates are only possible under
> narrower circumstances...We now have to figure out if there are
> transitions where this is problematic where we could previously assume
> that we'd always get the best behavior possible. Both in the present
> (i.e this SHCFG discussion and EPD0 case) and in the future if new
> parts of the configs start getting used. IMO not having to think about
> this is a meaningful advantage of the current solution.

To be more explicit, I hope we can keep the current solution. The
tests we added mitigates the extra complexity, while there's no
certainty that the 1-bit-per-qword proposal will always be
satisfactory in the future (nor have we even reached consensus that it
is satisfactory in the present with the part 2 CD series)
