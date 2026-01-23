Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E889E285CA9
	for <patches@lists.linux.dev>; Fri, 23 Jan 2026 12:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769171355; cv=pass; b=qifoU5/UwFGl623QHuFA237cFhHV0FoQj+9fL0/NdIDzcVCU2L7lw50iqfBS1vhydfrZGlerQi+abyBO6ONmzLYMHZN/SUbanQrjlblu8zeoBLO8zQF5c2bzZDkZacaUkxK4MbaPxsnblmUca1Kp2TlyFOaQW11Ur8X04/Dk/NI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769171355; c=relaxed/simple;
	bh=XR+7C6pb807RCIW0CIuMZsWdXhj4rxWiUmBKJRrKbm8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CixH+xTm1LH087JmfP53Ys3q0vLR9fnSzjwdITE3zG/Q8Vd9nm0Ua9tHifiewBqD/7q6D4vMbzV10RwpRwr46UuJS8z1gMP4HSVI4Bd7DoEN4PaVmRW/AyJFY7BZfzmvI38EMcSc6+Ohd2c93sBudztjtfUzmEfRNFDU7c88cXs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=m7B8Ztlr; arc=pass smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="m7B8Ztlr"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-40421de595fso1694533fac.3
        for <patches@lists.linux.dev>; Fri, 23 Jan 2026 04:29:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769171353; cv=none;
        d=google.com; s=arc-20240605;
        b=fxZwKRgZ2J28CFW+3jj/Uh1pbi/ptJ7lo9c1pWQvFT5C/WnwglBfua/VAEWmeh6/vm
         cqIiJsos42ZPtJOVlhbV8fzqLghqbpDK9gDOH0PzNbDhEAlT3GpWuIlbzVihQkifMvCA
         Q8qbEKRnDuvvxe/KNTZ2lCfmANNPx6Nsk4tA83Du762QTURQotg6SzesOrzLcwyHdUY3
         sA1clKJa4+DiuAkC+DpXezs/JHklbRBP1QjeagSYLYU+9scpc16yHhJ67fzBzPRj8WYV
         PWbTJcx4Y9F45If+K/TCfpDVIy3Gp8x1CB8bw9QDKUBbMqSvGB53xordJE4dk/Ppicuo
         ayZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5ia/0onmW7rqxIqY0Xa3NnOog6ovCu83wYubolEXe60=;
        fh=eOVp747oj/a/CgaHnM7+Mrk5aAhNTgzGuuGEQ03xEXU=;
        b=WMvvbnkLmR41lweieMTSyL1cvq4dc2wZbp6AxPhUszVDcK04LsW3n44icwPr1pm+8h
         nA06UsOVcsPZJz95xPmvocL5PBritwZcINMKTnfwZt/CE0CrWsq0y9dOg2HGj+P88g4T
         H4Rn8FjQHq4eMZ9ca9Cx+h0k1s4BlyCaP8M2h0qy0Ru4mBnhw4GGAScIu+D8CeKD+P9M
         VEF7gB22tyfWu06oswSQXwWbKwPEis7hLQC4Rjs5/l1c2IE+pfKkolo8fRmKT9DXIh2H
         E0NUGQTS3iPorLdC0fYWiPF9sqDa1xNn+kHRN6mKR0y4Pn8y4HF/kumWP0GCdGXpITnM
         O1pA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1769171353; x=1769776153; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5ia/0onmW7rqxIqY0Xa3NnOog6ovCu83wYubolEXe60=;
        b=m7B8ZtlrsqyDaV6HmSAP9OTrRZfHKdyPFnd7byBO7H6OjGa8wa7+8r4GY/Kwv8pXV/
         q7DUd6QUoFTy29fekPcfYo5xsWI4L/1yP2ExRD08JJb5oVsfnv+8S/Sxz0AB7fP86cR2
         OizMGRtZlo0zyNY4fy/ocqJJ62+J8HACsbRgyZ0fihU3VuwOpDAr68ie05EIWAeDEHzl
         NPnDGHN8benSOAik+W2ZH2IY+/As7LZLnP0TtJTtv5eNfr5nstdUGWrguBT/FQgkaw7R
         qwC+iwK//ytD5QXVXfoxVDykZIEbJGuL2myURJk1OnXT5Ux0Panw16WkiDQWDs/MSe2Q
         XQvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769171353; x=1769776153;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5ia/0onmW7rqxIqY0Xa3NnOog6ovCu83wYubolEXe60=;
        b=Ol1mP2F9SoX6QNkkR/oqoy2DihnTUJBMtjjqcFo+PEw3WiqDXtimjSWZsO6O7dzCld
         aEGGRElQAxF0niy7oqXCZue9jyJh86aaIVtoKZoTtVwPR0y2JPMt8h5pq3QnqOazfq28
         2udbnGA1M2I55AUrmLVyUZj4ymcYWYEKEgiw59QuJDwcUgWKaQV7+C6OXRF+CHodCX24
         MnvbjF9q0/2ncgCKnGYLVY9XoB2qWW2YpiJwPtAW6xwifUX0D7CThsLJt8cJv/GQNbSE
         5wQZd6jhGZvwnsLJmUm/AjAvxwTQb9/LSgQsgNIOdeCcQXh66Joxq5ow88asZqnovY1E
         1bcA==
X-Forwarded-Encrypted: i=1; AJvYcCX5qvMLbzPxU9n6R9LN/zpppTHzG1SnLnC44QL+TlOJwM2nPqMLcSbc2Z6nSpqVL4gpndKvxJeS@lists.linux.dev
X-Gm-Message-State: AOJu0Yxhf9uYCxsxNo+RHb54NgF6vt12/r784eQDYSyHJEH2TbVK+RCN
	yfp/FZmCWHzs2DKzIY0vy/TAGt6WQrFWIK/a26M+0VBcBsrz4wT3pzIyaxsf+/JdKQphOOhnoBl
	u7kAiU49oVSQTUWFld7YgJcAgwWQQ2UofISLpbK3ULQ==
X-Gm-Gg: AZuq6aJ5I/+ngOtEnUXs5m7G7y80l5ZiXaKNP+wndc4Z27i56oL1WAs7hLrrKUA3f+P
	E1kcNRxST8LX9jsCLvBVNPGaQ51KbBX00Wh37cIgfoYkyo/i1HvKVnZSKn8C1Cq+PFo8yux+hTv
	s/GHcEJwFzuTZhVrDkDuLtNTgQoKpcZaE2iPdtN8ZifToI55VFHWFTrIX+wfQf6sWtwbzEI6UE8
	VrbmoTBDAK5nbeFGYZ2pvxP9kWszuDlzA8tvGczRFgWjacNNOx5AdmYILHP+686W/o7BMYzTiCr
	T1zUIq8SD5wivyR6c/hO42GuEtIMhw==
X-Received: by 2002:a05:6820:150e:b0:661:2215:4feb with SMTP id
 006d021491bc7-662cab7f464mr1186476eaf.62.1769171352774; Fri, 23 Jan 2026
 04:29:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com>
 <CABvJ_xiUK9BqUJS9-Sk1sS4vhVhyXN8P8NooZ0t_Zp7ycG0bAw@mail.gmail.com>
 <20260122153134.GO1134360@nvidia.com> <CABvJ_xgSbK3omxT7XGJ0N7oEva6dQAJwZxRhsBqi44BRNZ3G5Q@mail.gmail.com>
In-Reply-To: <CABvJ_xgSbK3omxT7XGJ0N7oEva6dQAJwZxRhsBqi44BRNZ3G5Q@mail.gmail.com>
From: Vincent Chen <vincent.chen@sifive.com>
Date: Fri, 23 Jan 2026 20:29:01 +0800
X-Gm-Features: AZwV_QjuLN0FLG3VneZxDaqO5dnkTcs75k0VirNO833q66YQcdrVcIgmsYXTtfY
Message-ID: <CABvJ_xhY_4ADOsVVbjhkBm8U1mKVOSwzKMfBw5mUsJe=kkUiLg@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Convert riscv to use the generic iommu page table
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>, iommu@lists.linux.dev, 
	Joerg Roedel <joro@8bytes.org>, linux-riscv@lists.infradead.org, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Tomasz Jeznach <tjeznach@rivosinc.com>, Will Deacon <will@kernel.org>, lihangjing@bytedance.com, 
	Xu Lu <luxu.kernel@bytedance.com>, patches@lists.linux.dev, 
	xieyongji@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 23, 2026 at 11:05=E2=80=AFAM Vincent Chen <vincent.chen@sifive.=
com> wrote:
>
> On Thu, Jan 22, 2026 at 11:31=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com>=
 wrote:
> >
> > On Thu, Jan 22, 2026 at 09:46:47AM +0800, Vincent Chen wrote:
> > > Hi Jason,
> > >
> > > I tested this patch set on my side with the QEMU-virt machine.
> > > I used the following QEMU command for testing:
> > >
> > >   $QEMU/qemu-system-riscv64 \
> > >     -M virt,aia=3Daplic-imsic,aia-guests=3D7,iommu-sys=3Don -m 8G -no=
graphic \
> > >     -bios $OPENSBI_IMAGE \
> > >     -serial mon:stdio -serial null -nographic \
> > >     -device e1000e,netdev=3Dnet0 \
> > >     -netdev user,id=3Dnet0 \
> > >     -cpu rv64,v=3Dtrue,vlen=3D256,ssdbltrp=3Dtrue,smdbltrp=3Dtrue \
> > >     -device '{"driver":"virtio-9p-device","fsdev":"share","mount_tag"=
:"host0"}'
> > > \
> > >     -fsdev local,id=3Dshare,path=3Dshare,security_model=3Dmapped \
> > >     -append 'console=3DttyS0 earlycon' \
> > >     -kernel $KERNEL_IMAGE \
> > >     -gdb tcp::6234 \
> > >     -smp 4
> > >
> > > The boot log shows that the e1000e is successfully added to IOMMU gro=
up 1:
> > >
> > >   [    0.752808] pci 0000:00:00.0: Adding to iommu group 0
> > >   [    0.753279] pci 0000:00:01.0: Adding to iommu group 1
> > >   [...]
> > >   [    0.763212] e1000e 0000:00:01.0: enabling device (0000 -> 0002)
> > >   [    0.765241] e1000e 0000:00:01.0: Interrupt Throttling Rate
> > > (ints/sec) set to dynamic conservative mode
> > >   [    0.868120] e1000e 0000:00:01.0 eth0: (PCI Express:2.5GT/s:Width
> > > x1) 52:54:00:12:34:56
> > >   [    0.868740] e1000e 0000:00:01.0 eth0: Intel(R) PRO/1000 Network =
Connection
> > >   [    0.869087] e1000e 0000:00:01.0 eth0: MAC: 3, PHY: 8, PBA No: 00=
0000-000
> > >
> > > In this environment, I used iperf3 to verify that the e1000e function=
s
> > > correctly. The result shows that the test completed successfully:
> >
> > This is great, thanks!
> >
> > Can you confirm that the iommu was set to translating for this test?
> >
> > $ cat /sys/kernel/iommu_groups/0/type
> > DMA-FQ
> > $ cat /sys/kernel/iommu_groups/1/type
> > DMA-FQ
> >
>
> Sure.
>
> # cat /sys/kernel/iommu_groups/0/type
> DMA
> # cat /sys/kernel/iommu_groups/1/type
> DMA

Hi Jason,

Please disregard my previous test report. I realized that the previous
result was incorrect because the IOMMU was actually running in "identity"
mode, so the test did not verify your page table patch. Sorry for providing=
 the
incorrect test result.

  # cat /sys/kernel/iommu_groups/0/type
  identity
  # cat /sys/kernel/iommu_groups/1/type
  identity

This occurred because the RISC-V IOMMU driver in v6.19 does not yet
support MSI redirection. Consequently, devices using MSI fail unless the
translation mode is set to bypass (identity), meaning CONFIG_IOMMU_DMA
was not active.

To properly verify the patch with DMA translation enabled, I integrated
the MSI-related patches from Andrew Jones's RFC series to unblock the
test.

  Andrew's series:
  https://github.com/jones-drew/linux/commits/riscv/iommu-irqbypass-rfc-v2/

  My entire source tree (Jason's patches + Andrew's MSI patches) is here:
  https://github.com/VincentZWC/linux/tree/v6.19-iommu_pt_riscv-test

With this codebase, the IOMMU group type is now correctly configured as
DMA:

  # cat /sys/kernel/iommu_groups/0/type
  DMA
  # cat /sys/kernel/iommu_groups/1/type
  DMA

I re-ran the iperf3 test in this environment, and the test passed
successfully.
