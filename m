Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D35336ED2
	for <patches@lists.linux.dev>; Tue,  5 May 2026 23:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778023044; cv=pass; b=m2ZTdkyG66vfrYsK3xIim7JWxbPA2HfOhcsJREFGB4rBmxHOzYmoq8XAAxGTpFQIXYJeB2Xb2YRBa3LhzTWUYgiJ91c9mRA/IPwqzCyne3eQ5KtkTxHAqn/SfSYWscZKKMcpzxgnQBn/gD5U0UUp9EZP5nGhTKLtOgzL8QPNSX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778023044; c=relaxed/simple;
	bh=oQsEDd//6GGpYIwkW7vMkK0YPw/uPR57ysQMmbZnt6U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ftqY29uwWF5km13ioXuTlSnteetAf8hFRv3eCYJs2PdehBVk9xBatFXbGFVcVE/ZgKM55LkIwYG7IwRersKkdmHgi/0/6uurH5iXCM2iBJLgybEskcFZEP5IJwezC9veLOawqYykALltdEvD1bZL1oeXA954iYjLnQkpYgci6jA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=EBsE5qwk; arc=pass smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="EBsE5qwk"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-6966e1a0b91so3431081eaf.3
        for <patches@lists.linux.dev>; Tue, 05 May 2026 16:17:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778023040; cv=none;
        d=google.com; s=arc-20240605;
        b=Q2XeFXS7IidoM9OAhvmm5ihou0XvKFuJ/QnQkzUQC/+TdclWU6RMivqUw3y9d/MH1K
         a6JyU7jRBHnY4bm7RXGZftB8KtPy1sUTjI3MQABS/6t+QkayUmCnblxP8l94yolVtAqM
         i1ohECQxKd8I4dl7K3ec5wYbh9w5j4unB3j1B5U6/NPBan7h94PdoKIOKWTivGRhnhOZ
         SBQHcqWnCa0rEjsolhWZEvZoFeF/RbF05B4fYq5ftsB/Vz4GBfCyIKiDjjZAFyi6/pmn
         MKVZGlbxXhc1ylo8AzPUVysfi4BVY8vSJFrJdUHphdcbz89bQvYRXtlPGMmS+FxDvqLX
         Zysg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4mghS3H/aJ6lQNilWcJZ+hFDXZYtt6jkOPJMbybX0bw=;
        fh=mH2JnLcJeKwK7OmJLljSndXo2kC+QOO6VtWV6jglpQw=;
        b=JF8+JwaQ78Z5LaA0zcnxHUyTrxQYruqdYEUcMbA3etM1zjQJgjI8CfuO309kIog6lW
         Mz/NOfGLMcS3Q73qqRr9XZXnDIwhD2ufUPiNmGfIpXHEcPo0TVegIL8hsAVVxrlrYKVh
         fbo+tWqaLZAsyI+t4xKt8VgrGRkP48RMgbGcXO5UTK6MKREe6CLjM9GA05QRjSgy0rwQ
         6mvIaGj3oUH4gKLl+Ksycuq1Em+J+Vgnx3+3TFxdt46tWjYubXqQyZVFDaVL69p3ArM1
         r0Kw87ijNO8BPzrXOF35QdMRpd/uO3ioCgkUIrRZY4w9XzaK1DBWWK5W1+eIBIqYTccU
         MCuw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1778023040; x=1778627840; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4mghS3H/aJ6lQNilWcJZ+hFDXZYtt6jkOPJMbybX0bw=;
        b=EBsE5qwkY/qXdaBr2NLCqhxrvKXfVytp4lp92eYtSn9Pg4Z9NDPXb62NyXYyN6jRQh
         LfnnknxV7QUd2zZz64QiytDHaKoJFREaVBJsSvMZw67phRObZwTNfz1tBVdGgHTiFC41
         CJ6TXkzkg15otaKtG2gJC3PZZAmQlypZfZlHcLMJeW6tvBAAQ3aGAqRR1E+Q39BRYpSs
         8s3QZiFi/Zjjl2DHs4G+P2z7aWAJBfoYYN5v6Q67AxATqYL65XolNXl8WcLwYANaUWkO
         LhV+pKFDfoRVDPmPQy3mAZoRXW72QyLA9p4J+Dj0RtxW/1vsBqmwn8kzhC3je5TGgBl4
         keXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778023040; x=1778627840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4mghS3H/aJ6lQNilWcJZ+hFDXZYtt6jkOPJMbybX0bw=;
        b=SuVLKh1kR3HnA+RkYpEfplZHzElfPVMxI6ZqtRWW0zM1Kj9qee+eC78WJizQulOMdb
         Y83mljETlgvU7gevgzOV3YOv6plzcbDx4WxRuVGJTI9GAwYJxJki1slSoh7LZlcRQn3O
         Zt33lRtqxfT45gZQuhArZ8yiPsERk+9+Lab/6v+thSWyrPrqV1RIxJzA/BmieONkxrdR
         +ttsZ3eEaRM40ldXRnJmIppRngm0BJv9pUzcjrY0+8hDcmKlIcDaLRcIrMbw+9zFLU7M
         /pVmgkNzTkcDGojNrFwXhC05F5TXkyS3yn/5fljlnvFM5t/O18qu/e06k2+UqnWzQ9JZ
         WwSQ==
X-Forwarded-Encrypted: i=1; AFNElJ+BecCvx7RWvLpZyFip3fDj0MzVp0EYBSFkF6JqTkVCc6ednNMTCLhwsXl8MQj/PXfAYQsb9rz8@lists.linux.dev
X-Gm-Message-State: AOJu0YyXF6UlljnZtcghsrv1fFfbdIZxUi/bakpJkrD+Bo6qaEUHs+lu
	LbJMfTFC1Vs3yfB3AUAaL7keAJ2bIvlBipkcbyW+41yxINRjrg9mb7RZxyHo4cygj3JMYa83UJC
	er9fPbva42AUwW/BvBuyjau6q4u69b4zW68A9p+wqWQ==
X-Gm-Gg: AeBDiesU7TVwpbOi8przqKTLY/PCz/jSM05Z6h4wLLujH3kcyn7SmrtZaxUvim+XCHH
	u8V3CJhl3U7x0y3EOIltTf5Zeswvl5VRirp4/aZE3V/6VFZ6nDdLvJ09ALdbej1HCEiT/r5HoBW
	L+mWi59jIgfYjhKeL5T+4Mk7F2nT9/wl8kgfLREyaY0x2yxttFIzYtWog63gYrsCbczYZMZFRJi
	WJtfe7vKpCI3DN/Kx7Ae7ZCevFRLr2YyDTvG33XDamkyRvLi38M98xRiMODPKYJzCXEZjaqwjaC
	jlLEKiDsQELCsGs26w==
X-Received: by 2002:a05:6820:1897:b0:694:9071:b60d with SMTP id
 006d021491bc7-69998d428f6mr514951eaf.44.1778023040589; Tue, 05 May 2026
 16:17:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
 <7-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com> <oe75yk2fx2c7wg73xrikppw2gxxe2e6bsvkktowbo64ftldy7p@53gjjzhu6cy5>
In-Reply-To: <oe75yk2fx2c7wg73xrikppw2gxxe2e6bsvkktowbo64ftldy7p@53gjjzhu6cy5>
From: Tomasz Jeznach <tjeznach@rivosinc.com>
Date: Tue, 5 May 2026 16:17:09 -0700
X-Gm-Features: AVHnY4JEOw35_gt_Bdx03w1j0N_GsaZ_RjYELDTRZ0nPtLdGQ8v4coOohRfzozA
Message-ID: <CAH2o1u4-QLvc+-eCciyRsd5C-8KZfwqrra8Wv82-eOUgaX-eEA@mail.gmail.com>
Subject: Re: [PATCH 7/7] iommu/riscv: Add NAPOT range invalidation support
To: Andrew Jones <andrew.jones@oss.qualcomm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>, 
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, linux-riscv@lists.infradead.org, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Fangyu Yu <fangyu.yu@linux.alibaba.com>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 5, 2026 at 3:47=E2=80=AFPM Andrew Jones
<andrew.jones@oss.qualcomm.com> wrote:
>
> On Fri, Apr 10, 2026 at 12:57:08PM -0300, Jason Gunthorpe wrote:
> > Use the RISC-V IOMMU Address Range Invalidation extension
> > (capabilities.S, spec section 9.3) to invalidate an IOVA range with
> > a single IOTINVAL.VMA command using NAPOT-encoded addressing.
> >
> > One iommu_iotlb_gather maps to one NAPOT invalidation command. The
> > smallest power-of-two aligned range covering the gather is used since
> > over-invalidation is always safe.
> >
> > S and NL seem to be orthogonal in the spec, so if NL is not
> > supported then global invalidation is probably always going to happen
> > as wiping a large range without a table change is not common.
> >
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/iommu/riscv/iommu-bits.h | 17 +++++++++++++
> >  drivers/iommu/riscv/iommu.c      | 43 +++++++++++++++++++++++++++-----
> >  2 files changed, 54 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/iommu/riscv/iommu-bits.h b/drivers/iommu/riscv/iom=
mu-bits.h
> > index f01b49ac815586..32b3ad3ac9ae59 100644
> > --- a/drivers/iommu/riscv/iommu-bits.h
> > +++ b/drivers/iommu/riscv/iommu-bits.h
> > @@ -64,6 +64,7 @@
> >  #define RISCV_IOMMU_CAPABILITIES_PD17                BIT_ULL(39)
> >  #define RISCV_IOMMU_CAPABILITIES_PD20                BIT_ULL(40)
> >  #define RISCV_IOMMU_CAPABILITIES_NL          BIT_ULL(42)
> > +#define RISCV_IOMMU_CAPABILITIES_S           BIT_ULL(43)
> >
> >  /**
> >   * enum riscv_iommu_igs_settings - Interrupt Generation Support Settin=
gs
> > @@ -475,6 +476,7 @@ struct riscv_iommu_command {
> >  #define RISCV_IOMMU_CMD_IOTINVAL_GV          BIT_ULL(33)
> >  #define RISCV_IOMMU_CMD_IOTINVAL_GSCID               GENMASK_ULL(59, 4=
4)
> >  #define RISCV_IOMMU_CMD_IOTINVAL_NL          BIT_ULL(34)
> > +#define RISCV_IOMMU_CMD_IOTINVAL_S           BIT_ULL(9)
>
> We should add a comment here that this is actually bit 73, i.e.
>
> #define RISCV_IOMMU_CMD_IOTINVAL_S           BIT_ULL(9) /* bit 73 (dword1=
 bit 9) */
>
> because...
>
> >  /* dword1[61:10] is the 4K-aligned page address */
> >  #define RISCV_IOMMU_CMD_IOTINVAL_ADDR                GENMASK_ULL(61, 1=
0)
> >
> > @@ -731,6 +733,21 @@ static inline void riscv_iommu_cmd_inval_set_nl(st=
ruct riscv_iommu_command *cmd)
> >       cmd->dword0 |=3D RISCV_IOMMU_CMD_IOTINVAL_NL;
> >  }
> >
> > +/*
> > + * Set NAPOT-encoded address for range invalidation (S=3D1).
> > + * sz_lg2: log2 of total range in bytes, must be >=3D 13 (8KiB, 2 page=
s).
> > + * addr must be naturally aligned to 2^sz_lg2.
> > + */
> > +static inline void riscv_iommu_cmd_inval_set_napot(
> > +     struct riscv_iommu_command *cmd, u64 addr, unsigned int sz_lg2)
> > +{
> > +     u64 pfn =3D addr >> 12;
> > +
> > +     pfn |=3D BIT_U64(sz_lg2 - 13) - 1;
> > +     cmd->dword1 =3D FIELD_PREP(RISCV_IOMMU_CMD_IOTINVAL_ADDR, pfn);
> > +     cmd->dword0 |=3D RISCV_IOMMU_CMD_IOTINVAL_AV | RISCV_IOMMU_CMD_IO=
TINVAL_S;
>
> ...here we're setting the wrong dword. This should be
>
>         cmd->dword1 =3D FIELD_PREP(RISCV_IOMMU_CMD_IOTINVAL_ADDR, pfn) |
>                       RISCV_IOMMU_CMD_IOTINVAL_S;
>         cmd->dword0 |=3D RISCV_IOMMU_CMD_IOTINVAL_AV;
>
> Thanks,
> drew

Yes, good catch. Similar to the RFC commit [1] ...

- Tomasz

[1] https://github.com/tjeznach/linux/commit/ef51d4be750d2d7c449747ab53fd5c=
12d5a4a175
