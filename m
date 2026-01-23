Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295F9355811
	for <patches@lists.linux.dev>; Fri, 23 Jan 2026 03:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769137567; cv=pass; b=Kwbgpzfibx4lUQ9NDHH5+vIWWHbZE7qSsztHG7C0fwN3EbwiHagJWVPD4CBb4311+AARzm0aDe99fANQCGwkcyrUlwpcJv2Wwp9xmGMR16uwiH9rh8A151YcVi4qEAvzQfprM5gWPwBnT7Y5WydDFzOsjCZ/huprOk2tJUJFdvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769137567; c=relaxed/simple;
	bh=1wnj6FJjUa5YD6snLv7xk5DLRr7pplGGAM5h/Cjd1J0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ePkEhjq1g6p8c1EXca3OBAS7B1LYIU+Eph/80W1ksevNFCDaqw29MDUGZ7oesXY9xVt+K6EiuT5c5N00JqHaf75LuvqVwZa/d8JIMxZN/kuQipqkI5+MMp+GzgjpyJbLVFw80Mq79VNAWhDVPtHRHrUWMJf8JOgf3MvSjiAr3Qw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=hNYZ9loT; arc=pass smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="hNYZ9loT"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-662b5db048cso491251eaf.0
        for <patches@lists.linux.dev>; Thu, 22 Jan 2026 19:05:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769137552; cv=none;
        d=google.com; s=arc-20240605;
        b=AF4P0bLK1JWR/7mctmRJBJXEVUm1ZijV3P92bgksip+YNSWQVxjDga8a6vPPX9FDtA
         AfJm2eWguo0SGGlm8TsCTaQvzjbUKSgdJtOzOEulGFyjvaFFtpeSFYeySMrvb6fnLWkl
         PZKRWFqhmtEZmHyPYHJgj3xj0Kd8Ce8kFGVZeke/C/J2AKx1jEI7X+5h3n3+vqRFEQMr
         gNTcpHLsl6zweTT/gaTG7wnUm8HvOK4eXn/A4VNhuLNRRWmC1j44xty8KfUDrwoK/ocg
         LXPIKWT84ziVLnOU/F7VRzMs2iBPJd71FsNFbS8PRNf2aBuRqYZSK1xVl8PfJpksspA7
         i4tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HGEqT7UyTgtMNvCrnujktZSI0NxpTV7HktWMzKUJGvI=;
        fh=qilKs1K+0nqCo5buk8dCcSpzoDqrOd3XgHgudfCCNf8=;
        b=hP1GmXa5NEWCsHB1tlx2lSwuB/VYAGqSZq1IVBvkhSppdLqmcqS3PcRc5+UUbGCSwg
         rspBMYnMS8QyGk0uzbJeJBhzApwmscEwFcRoMvSNVd+rOzpwo17UEIPT1b78T+AAHzWe
         y5K1IIXaPthtOolvOvpw8NX4+X+0pxgLYW3OHZY5CdCdhO7ieYm9E7dge3+etjLvVxn9
         v9XLN63A3c7oiBFqPsA/n0gij1x5BQmSHS0zMl8ZX+sOIOVKLbEbe1pftuNS+2BWmlzX
         gGf/mp6TgOxL2HcDEC3xXCNuz0RMVH6otwmVTlMBzSnbteIyBxH3pfQ4NCJB3GZ1MtgV
         OvQw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1769137552; x=1769742352; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HGEqT7UyTgtMNvCrnujktZSI0NxpTV7HktWMzKUJGvI=;
        b=hNYZ9loTUp7MGvaxmheCqublwfG3w2T+fPIhd8BpCBNkl5qy4xjGhJpU0vOYW1hx97
         +04dntL9duXjD/L0AeNOnoigHbI0ZsJhbgfY3UZGgut8NNOKoRC88MaAyn6tz3cEhkI0
         NtnCtIybVUiAlbBf34EfcmIr8/F3PEu92e7EoOvhotrJVRBCgPKjNYpVEF4llulHrs7V
         6lUT0UxicQw01r1NG9io2y3/JMXq5bA6O7uYMAB2vC09mIdNTe92mFHV/5Phy77UdlZK
         /KTi9YMoBHpKsyCCk2STygGmeB48ePB3deJYitk/6ZU9FZqmvo+cy5tShidznR2EQTaq
         JPHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769137552; x=1769742352;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HGEqT7UyTgtMNvCrnujktZSI0NxpTV7HktWMzKUJGvI=;
        b=KbWKiVEu4PoWl1AYtcBBHZhEKmAbZ/PTOvDlVe5KC5SNWE8NnKO1Qh+YJsEnvoU5DF
         0ghquqb3v3OrWQ45Xzgb6ePTGkSm3UrYkiU0P3qtiVhOGbyXvsOHxhXVCJAJNYj7RA4m
         33meCn6eWu8RxDTVCGKIsTgAfdpz5IUZR0ANj+xEVNhQPQVQ4TYFAaHdyCPBPrpL1GY5
         STAiLpA36z9pWGMWmuzJK3fyb6uACgN4vv1s0lkz+8TrAo/2QKSbgNOBipnkuOj35rHz
         45encuA4a9s5BVW616cTdQ9tH2sQLEnv0qs5MDn5RFcMZQ99k62rC8OWegJT6duVpVtS
         OOag==
X-Forwarded-Encrypted: i=1; AJvYcCVpZytx4b35nYcmVdT8HkVdj2V0IeOyxoZg85Si9x83lWURzohZQm3746LmGyiusD3XHQt93NsC@lists.linux.dev
X-Gm-Message-State: AOJu0YxFcNDiMkn4ZMXcPcovbINVZXRzjkk5wKn1rOsxP/jz4eAGT5eA
	VW1leEXYQiGkpwPaFqirMexdXJP156KRxbKaHcZHstedG1eT1DY/ZUF0/O3p+z/riRsgd083W9z
	ZyCUlOBDVuV171PYaQNE2eJIQ7bqem+7RSy47L8sW7Q==
X-Gm-Gg: AZuq6aKSSYhiutS2uI7kAG4pop8Oo/yokitBMqzBbGYTCBHNizQTrXyIHAVZCqGbmK9
	Nf+vp0m9Vq1DwJvv+JSdn4VFq4a7YwvchfpIIC7nKYe21TzdtYqHDWIgptOgwstcJqfffLDrSHN
	3NtbSGmc/Tvwk9r1vEIZ1+Ve/ii4FwgLOxcAH/Blm7lFyd8hBFHNkzffajXYVcj80CKOE39MyDB
	eXefF8aRLf9HGO4PoIYBtGuxyNsIpOC1k+ikod3OLLR032kLRljV2D189xJjSRTB8suo0pFOw==
X-Received: by 2002:a05:6820:1689:b0:65d:95d:2de2 with SMTP id
 006d021491bc7-662cab0b17fmr951053eaf.25.1769137551657; Thu, 22 Jan 2026
 19:05:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com>
 <CABvJ_xiUK9BqUJS9-Sk1sS4vhVhyXN8P8NooZ0t_Zp7ycG0bAw@mail.gmail.com> <20260122153134.GO1134360@nvidia.com>
In-Reply-To: <20260122153134.GO1134360@nvidia.com>
From: Vincent Chen <vincent.chen@sifive.com>
Date: Fri, 23 Jan 2026 11:05:40 +0800
X-Gm-Features: AZwV_Qg9IApxpDwG1qJn4LgmdvEEpNtmIvGulgwGbciwMW5SeFs7SpLra02DWaI
Message-ID: <CABvJ_xgSbK3omxT7XGJ0N7oEva6dQAJwZxRhsBqi44BRNZ3G5Q@mail.gmail.com>
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

On Thu, Jan 22, 2026 at 11:31=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> w=
rote:
>
> On Thu, Jan 22, 2026 at 09:46:47AM +0800, Vincent Chen wrote:
> > Hi Jason,
> >
> > I tested this patch set on my side with the QEMU-virt machine.
> > I used the following QEMU command for testing:
> >
> >   $QEMU/qemu-system-riscv64 \
> >     -M virt,aia=3Daplic-imsic,aia-guests=3D7,iommu-sys=3Don -m 8G -nogr=
aphic \
> >     -bios $OPENSBI_IMAGE \
> >     -serial mon:stdio -serial null -nographic \
> >     -device e1000e,netdev=3Dnet0 \
> >     -netdev user,id=3Dnet0 \
> >     -cpu rv64,v=3Dtrue,vlen=3D256,ssdbltrp=3Dtrue,smdbltrp=3Dtrue \
> >     -device '{"driver":"virtio-9p-device","fsdev":"share","mount_tag":"=
host0"}'
> > \
> >     -fsdev local,id=3Dshare,path=3Dshare,security_model=3Dmapped \
> >     -append 'console=3DttyS0 earlycon' \
> >     -kernel $KERNEL_IMAGE \
> >     -gdb tcp::6234 \
> >     -smp 4
> >
> > The boot log shows that the e1000e is successfully added to IOMMU group=
 1:
> >
> >   [    0.752808] pci 0000:00:00.0: Adding to iommu group 0
> >   [    0.753279] pci 0000:00:01.0: Adding to iommu group 1
> >   [...]
> >   [    0.763212] e1000e 0000:00:01.0: enabling device (0000 -> 0002)
> >   [    0.765241] e1000e 0000:00:01.0: Interrupt Throttling Rate
> > (ints/sec) set to dynamic conservative mode
> >   [    0.868120] e1000e 0000:00:01.0 eth0: (PCI Express:2.5GT/s:Width
> > x1) 52:54:00:12:34:56
> >   [    0.868740] e1000e 0000:00:01.0 eth0: Intel(R) PRO/1000 Network Co=
nnection
> >   [    0.869087] e1000e 0000:00:01.0 eth0: MAC: 3, PHY: 8, PBA No: 0000=
00-000
> >
> > In this environment, I used iperf3 to verify that the e1000e functions
> > correctly. The result shows that the test completed successfully:
>
> This is great, thanks!
>
> Can you confirm that the iommu was set to translating for this test?
>
> $ cat /sys/kernel/iommu_groups/0/type
> DMA-FQ
> $ cat /sys/kernel/iommu_groups/1/type
> DMA-FQ
>

Sure.

# cat /sys/kernel/iommu_groups/0/type
DMA
# cat /sys/kernel/iommu_groups/1/type
DMA
