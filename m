Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA20F2F616E
	for <patches@lists.linux.dev>; Sat, 31 Jan 2026 01:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769822898; cv=pass; b=c+vT2dv/AZ6VcTmEYAkw1Wsle72LDU7PQ1beraifp0qT7ISgYaK9bbaW1PJZc+nRB9KgEnEHawVJ3e2K8+OXBbjfb4X/ES3YxVzFTYqs+kFRTcwSoys7+qBi0DzOuPQRQ8A4y9hegcIUuPBQJFZIynoZ5gRzn6LtoAOvhRPkykc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769822898; c=relaxed/simple;
	bh=xdF1VHSvk5HtQPQo93L5tHmtzKUQ+pGnABByZHwLB/U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Aga6pViuKYmGJmxF+hIOxFmaOQrriOkPP4y+TG4XgfTshDKYI8KFiFIAaelZbE7w0jiWybD9JJLxt8ILJRrcktZjn1/Cvp/qCFg0Of/hp6Ls/k+fJvZ0iCY3H4O5qdA0ozM9i/zmK+FlCNrwrPOfLNgk5pkbb0HOUNmfa8JSuhk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=NS+RGObc; arc=pass smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="NS+RGObc"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-6610b05b37dso2158411eaf.2
        for <patches@lists.linux.dev>; Fri, 30 Jan 2026 17:28:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769822895; cv=none;
        d=google.com; s=arc-20240605;
        b=RFrdmNO1yxF7TA37ZouTpZCafNOZFMbi/T9OUHub8WjCYQTDPQUz8W5cDf8c/LcA/K
         rhEq/oDGp0VsislkSp4FAAPLR/9b0RvYj5idP4wtoQCfI7+nOz86Rw0fFhnjfyaYJ2P1
         5BbgwAgoh/feo4ZpA3VaQfpDs5Z6SCzZokvQkxwH5RPur7WRb2alr+4q2rxl/oQl0AkJ
         dA0FwA0ASy103KiyDlkBdcaUUU5901ZSoAn3jRgt2w/7kQBaahrrepu5SZghC68OfUof
         Fqe5IzOGpvGFQdjU1LfS07KEsBmum1E+MkEJbOHU9vOY/B6jLQiDgLfeD1R0w8v+unoO
         4Hmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hAdK8PSPpbAG4ZF3DDf9iwcQO/z7KVY0C1nZwOLHMfE=;
        fh=lvQT+HXBqlsk0zYJ6CUVhLUErEi7UMEEKNHO0RAGiD8=;
        b=JLU0caPR6aAYzGgsqG6zc2XYtraYIKd3GqjowPlkjep9AEPb0UE8+TPOqYLIT9zqpO
         FnbBcoJJRinOgh+tws+d21pTMWzKASfZoniwqgNd6XHWxQ9gfR6FYWmlkf7NgL3fBy7G
         /yrWwRw43GOlZC7O2pzbmfZDR4VUdJEdcbqMbqJZimBlsL+GSoxGAvIP6ohny7q8C7bR
         Zjl5VZrel3k5BuYdftzg43oCcGZ5pLTJIRrby7APSkiA3ROjuqIxkA3ad2MvNoMAHUIw
         O3MiuITceqRd9M1riqApkgeeoBPlXWwcQxEomPfUFFVB94N+I6pxZV2zF3Jar11qsL92
         3U7A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1769822895; x=1770427695; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hAdK8PSPpbAG4ZF3DDf9iwcQO/z7KVY0C1nZwOLHMfE=;
        b=NS+RGObcCq6a68s9lz8DD3702YTOoX1zmm1bEgNIqdXW+NwqMdo+XHiTjc7T1hrs6x
         BYjMTeLKtQUTx9p4CYgCtnETNM0P0B0xSvKNJFl5/2PBMl2KpdUVMCEJ83wfsjeyyeb0
         nfp8ZGT6viDZJinCvoRLNf82umyG3IGdV95K2Ps4Quage1mQPtfvqAV0MplI2ZmwL7eO
         7fnVAHICnxLgdChGBIhuFDcungjDzzCNJ34e7jy6tfS7oOTFEYYDcKDOAECpyGYRwWX9
         YydXa8AX3oLKLfsNc752tTFHGyAu/jXTUxNLrwITAa9w6u8PkdPBy1/OxBVcDzoHsnJh
         W6LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769822895; x=1770427695;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hAdK8PSPpbAG4ZF3DDf9iwcQO/z7KVY0C1nZwOLHMfE=;
        b=nzXnBHJ8YdX80JvXDB5VGFO5vwGSmtuCKdlngOewpR/IQ/d+qJYxxHS6Ved58bp3DD
         0BBQb3+fB+5/dxSGWixutE+e2AUahwD0KKN26OpwgOW8LjVGnStxW4Yycqc9VjWDKQjU
         eGsO4aBYKX3zd5ckQGa0PQY+isKssDtnA0ZTTE94TXVZOJwSkAJUYuS+FySgqjPqAiYv
         VojjwkKP05qItjwVRjbfPbBni5qsIV5POWJBhLNLhri+wX4cl54S0xz8fmo40GNLb9NE
         pUj5g34WvlnD5YJF0IzIr4tG1mzWpCgNxNW6zr/5A10w2bqDfxmaj7noG424qFPUcZLp
         Njnw==
X-Forwarded-Encrypted: i=1; AJvYcCVrHwawP0zvrUqMZY8KZ0myjZAJJCazmg8WANXruPr4XX7NvG08urrfzi4+r2GmO6MSILdFea1V@lists.linux.dev
X-Gm-Message-State: AOJu0YyDdSxo5IYPfPEMhgQvc5b4p+olxiu8aNH+6BJ1NhdU44pCdC8g
	owBgpbrHmR2jWwrvVGtt9qHpKwD7+9m2RYKtTx0v5DJSzr24oS2H/cB3o9U1Io7sANQSkm6FNMx
	FNMo7YqqqVWkapJzcdm7uKm/jDcj3S/ymT++8xg3aww==
X-Gm-Gg: AZuq6aJ0lcd5mtqUGFd+HIhpjkT8vreXoasAsykndkaHE9Ey8bzoAHt6DkYqMsaf9lk
	vu7QipIZp+xjBHNRBr9CSyDUo/kYwcGG/kfOC/Nss/I207njtLdl0LflOzB2B17Oh+ryJndZnDR
	sydXjWjgtyo/vA4ae4zFnwUHUvFmf9wVgM9S4E8AAQ6ikIm6WPj9eowqEEcgwPPhjV1mF2GnPRO
	lgtbMYLZ0P8NdmhIYcjUBHGz74tv5QMKrEM2CtfQsVd9NL3SefnKXU5L+cF/TRsAJ8vtg5cc3lS
	W9ikxQ==
X-Received: by 2002:a05:6820:22a9:b0:65b:257b:a898 with SMTP id
 006d021491bc7-6630f0507ffmr2047585eaf.29.1769822894013; Fri, 30 Jan 2026
 17:28:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com>
 <72olk767l4goaqsrkyelhtnzg33nxbtwnammy4asnqxukbolnh@gwypmg6n5t3e>
 <20260129004640.GB1641016@ziepe.ca> <63c38161-762f-bff5-0b9c-0148140c695b@kernel.org>
In-Reply-To: <63c38161-762f-bff5-0b9c-0148140c695b@kernel.org>
From: Tomasz Jeznach <tjeznach@rivosinc.com>
Date: Fri, 30 Jan 2026 17:28:03 -0800
X-Gm-Features: AZwV_Qj0tZjKAecspcSVxodkCX0io_Vn0UvzOmM88WNtFjCfrWhK6JNivTo3BO4
Message-ID: <CAH2o1u4_bieYiNUwCvhheKeRg6wvjH3Y4hZY9AGLcMbH5A-rDQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Convert riscv to use the generic iommu page table
To: tjeznach@fb.com, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joerg Roedel <joro@8bytes.org>, Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>, 
	iommu@lists.linux.dev, linux-riscv@lists.infradead.org, 
	Palmer Dabbelt <palmer@dabbelt.com>, Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, 
	lihangjing@bytedance.com, Xu Lu <luxu.kernel@bytedance.com>, 
	patches@lists.linux.dev, xieyongji@bytedance.com, 
	Paul Walmsley <pjw@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello everyone,

Sorry for the very long radio silence. I'm back online. I'll update my
email in the MAINTAINERS file soon, for now adding my new address to
the recipients.

Thanks Jason for this change, I've looked at the v1, looks good. It
passed my initial testing at the time. Unfortunately I had to hold off
on testing for a while...

I've revived RISC-V test flows based on v6.19-rc7 + this patchset and
hit translation failures on DMAs from/to NVMe SSD. Hopefully
unrelated, still investigating.

Best,
- Tomasz


On Fri, Jan 30, 2026 at 3:14=E2=80=AFPM Paul Walmsley <pjw@kernel.org> wrot=
e:
>
> On Wed, 28 Jan 2026, Jason Gunthorpe wrote:
>
> > On Thu, Jan 22, 2026 at 08:56:12AM +0100, Joerg Roedel wrote:
> > > Tomasz,
> > >
> > > On Tue, Jan 06, 2026 at 11:06:44AM -0400, Jason Gunthorpe wrote:
> > > > Jason Gunthorpe (5):
> > > >   iommupt: Add the RISC-V page table format
> > > >   iommu/riscv: Disable SADE
> > > >   iommu/riscv: Use the generic iommu page table
> > > >   iommu/riscv: Enable SVNAPOT support for contiguous ptes
> > > >   iommu/riscv: Allow RISC_VIOMMU to COMPILE_TEST
> > >
> > > Any opinion on that series?
> >
> > Let's take it if we don't hear from Tomasz this week? It brings
> > the contiguous page feature people wanted and now that it is tested
> > I'm not especially worried about it.
>
> In the event that you don't hear from Tomasz:
>
> Acked-by: Paul Walmsley <pjw@kernel.org> # arch/riscv
>
>
> - Paul
