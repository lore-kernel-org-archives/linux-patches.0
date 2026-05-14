Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8273386553
	for <patches@lists.linux.dev>; Thu, 14 May 2026 20:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778789066; cv=pass; b=DTaKJ1b9OTJLcwcPxekrSY3M42R2Tdb+xG/VkZgXBsQZIghdUCxXHGKK/j/0wUcMcZ4qHA1BUsRkttMQBTJVeDWgs/mkLKQqC6dWr3mVRlxh459WE4O2jhMyvg2rqEXt28HtRxTsCFQxK3X0oVuKR8Xv1JleG449zk4kLtYLltc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778789066; c=relaxed/simple;
	bh=XAwG/G3iDHkyBn0YCjcah8x0gmHTRYddR2yWgMaEkVI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X15w3BG4WTvwY7LW0rs0xPGMDoWw6df8qMvvN8cRM2NlDRNtQ6iszXtfGXYsHJemyrU0C9ZXE2kDcnYiy/eePxqjpHRFM4ANNV+GjTT+scFxlSarCCBF0rvN05xCJ5fMT9zziLxlBG53QK1FYB4bE0LBN/Ns5KSkizbgYKPqZDM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=MxkdwFEH; arc=pass smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="MxkdwFEH"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7dcc9b506d9so6898869a34.1
        for <patches@lists.linux.dev>; Thu, 14 May 2026 13:04:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778789063; cv=none;
        d=google.com; s=arc-20240605;
        b=eqZyKChofWXK4btZOB2PNxWxm6vd3mt0mGB3eCE3QeK0MZofBIjOz5pD4UC8w4J/hV
         WY0QnNgAuaxtdBu7Drr8LvEgWjJwo4C379sZph5Qw9HsnxmALoX98vsZYro1nf/G6fMb
         ve/OVpO2Ns1g91sgiUE5E7arGbDmpQ4yBFlZwr6OvNXDVQfMrRMWcYQcVDTzeZ2zEc+X
         0Q8A1woiBp6Rgra7ZDYtM2Nzs/IhkPETae2yKH5t4MLMNfHq4AlPWNb4DKzHRURhc4j+
         djFuuQHI3AfA/+s8i+pKrsz4RRByJaTgv74uCEGT1vC6b7pZCzbJtvgdeLLwMDTT2j4b
         QfJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BmrYvBS4e5yQgiQJc9bw4b0Yvv5PakgHG3Rw+9EZ0Lg=;
        fh=Q4uR067AKoAwNosJf3dK4aIQqyspY3mHCTw0QN9O7EA=;
        b=LLHTGGz+TkSuchstjx2khA2edI4ctoD1xPpADKwDfh4YK7UXFVMzrrKLEneReg6IR4
         /so0eIkAbvqAGKD1SL2NOTdY7H7h8wWrSkKCl6heonKkNuaFGM3SevNckDkEO1JS1GpR
         /+tHCXlCFWDYz+0UXPRiC2b/HT/q5S0unFTIgggtqa6/WZlx+DcfDjIB5Blw1cTxQOeT
         sHxcbDYZrQmSmt4My/JTPihtPApM/M21v1Xk0M31gU8gCwAqB9689zwaJF0LmvFzcapv
         GClAP7BSTpCJt9/fx5/6eBPhLwiOXmCsVMWGr9XEFi2pJoXA7lpUdnS+mnwnYtMxJfoX
         zaJg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1778789063; x=1779393863; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BmrYvBS4e5yQgiQJc9bw4b0Yvv5PakgHG3Rw+9EZ0Lg=;
        b=MxkdwFEH3v7+rAYzDUYCbW7Et3dDsZqd/NVwLKyPBphGdWn9N3CQWTsC+2ctXzC3H6
         8iiKDsEQjrOjo3w7rIi74KKNyDnZdlrCz6W5Gg8EMU0QuhvdMbxrqZpLygpqTMV433Ss
         z+zQ1KaQh7jMUgYl5Z2sFTbCQabrcTEiWR9QG43E33SJKZcgKBNqVdUku07uHf4Fw1yt
         DAQHc1Pbmarwhu07DqIwcrBA1SYRMXjQ3yqo95gMU3AOBJPWoHTnPvv7Z4D3mYTVxE7p
         6BHK56Q2PxRQ0+bxG73X+oBEAiBHwAHpcGp8CR5K/3QHH93ssqwgI6/4UK5e1KJcOqTV
         gR4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778789063; x=1779393863;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BmrYvBS4e5yQgiQJc9bw4b0Yvv5PakgHG3Rw+9EZ0Lg=;
        b=B2CYEUCLwo2LmhxTdEQgRaNtTcPT1EbOSlKGUq54AnXOFXc9ltK0vbF0WKlPGThA6e
         3RND8durMIRf6vRoZhJSk9I7oT2ktB3/R569/XgKMC1PuBXYE6JY4B1+2Y6A02+K+F96
         753fNIc1Fyrw7Cvz7QP1rVRgE03QM0+zVHoJlj3OX+wQQGIZ696z0L1yGTIhptw4tl/9
         rpHsGxGvaAKKZeTzHQ0QBm81IkhIifWOtf5mBzMGXDHhIqCuHqiuXTwfQSkKBFbQcUzn
         6XmYUi9CzjeZnt+QUvs9XpCWXCvTCckgr2D5THsDp2XkVucoOBebMqyCiIaghqNO8uzB
         dKTw==
X-Forwarded-Encrypted: i=1; AFNElJ+M6oE8XsSe/nhqkgRzVkfJPFfWW7pUwAD0OoosAbCicoiZrKJL3VCenBpDSkxSbx9mETmHFruz@lists.linux.dev
X-Gm-Message-State: AOJu0YxcDaG66m9MTsCzCE2Y3ZpkqfIiPS+TcxuykGyYAdyRw5eW4hc0
	iKbBnM5WiTAuguBwG1Lpg5YUdSj8Dl3A0Us+zGmR4B61/5LSd+e8AVo2rlsX0OVICx5QUaUFIMJ
	C2nFmhXhc5jdMhgPthUgvbdYL0d9cmGBgMblUoHa/5g==
X-Gm-Gg: Acq92OEu0pxZVpz2ytaTJkqHBv3sF5y6rPR/XCeSDY3xGUTNFVDAUlGiORWbm8ianfw
	p8JI+pROSbhK/dF1mjRXcUV1QY9vTNtQsmfSWDZb+YNc3S72jDTVV11gqLCYVH3DzWwXPVQ5Ti8
	sNFyg/YN7FJjHA55lTOLOe8x22ungf6m+oP9oRhjHqqc4+eMiw8vzJjLdgDwBjWwrFGPx/dIKFd
	Fw6Fad5fOx+T49g7h51JjDcEtu5pI7IJ2yDIm31GQsK4ghLh2j27LS59gEUEodYB5TKFKH5QUF+
	g2jBMkY9Bn/9YJ436Q==
X-Received: by 2002:a05:6820:1515:b0:694:6acf:a42d with SMTP id
 006d021491bc7-69c9438d904mr619190eaf.39.1778789063465; Thu, 14 May 2026
 13:04:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com> <7-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>
In-Reply-To: <7-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>
From: Tomasz Jeznach <tjeznach@rivosinc.com>
Date: Thu, 14 May 2026 13:04:11 -0700
X-Gm-Features: AVHnY4JqzUN5fb812OBcqjCgX_4bBXAuXGB2_vgh_Ze0FsamHQUFofj3i2u3Hgk
Message-ID: <CAH2o1u4ur16NQd8ZMgs3ch6BNcvQcuNP51_Y6UBwCRkgykoKUQ@mail.gmail.com>
Subject: Re: [PATCH v2 7/8] iommu/riscv: Include the dword number in
 RISCV_IOMMU_CMD macros
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>, iommu@lists.linux.dev, 
	Joerg Roedel <joro@8bytes.org>, linux-riscv@lists.infradead.org, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Andrew Jones <andrew.jones@oss.qualcomm.com>, 
	Fangyu Yu <fangyu.yu@linux.alibaba.com>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 8, 2026 at 7:53=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wro=
te:
>
> The command queue entry format is 128 bits. Follow the pattern of the
> other drivers and encode the 64 bit dword number in the macro
> itself. RISC-V further has similarly named macros that are not field
> layout macros, but field content macros which won't get a new number.
>
> Overall this is clearer to understand the code and check for errors like
> using the wrong macro in the wrong spot.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/riscv/iommu-bits.h | 102 +++++++++++++++----------------
>  1 file changed, 51 insertions(+), 51 deletions(-)
>
> diff --git a/drivers/iommu/riscv/iommu-bits.h b/drivers/iommu/riscv/iommu=
-bits.h
> index f01b49ac815586..8c60780363da72 100644
> --- a/drivers/iommu/riscv/iommu-bits.h
> +++ b/drivers/iommu/riscv/iommu-bits.h
> @@ -461,32 +461,32 @@ struct riscv_iommu_command {
>  };
>
>  /* Fields on dword0, common for all commands */
> -#define RISCV_IOMMU_CMD_OPCODE GENMASK_ULL(6, 0)
> -#define        RISCV_IOMMU_CMD_FUNC    GENMASK_ULL(9, 7)
> +#define RISCV_IOMMU_CMD0_OPCODE        GENMASK_ULL(6, 0)
> +#define RISCV_IOMMU_CMD0_FUNC  GENMASK_ULL(9, 7)
>
>  /* 3.1.1 IOMMU Page-table cache invalidation */
>  /* Fields on dword0 */
>  #define RISCV_IOMMU_CMD_IOTINVAL_OPCODE                1
>  #define RISCV_IOMMU_CMD_IOTINVAL_FUNC_VMA      0
>  #define RISCV_IOMMU_CMD_IOTINVAL_FUNC_GVMA     1
> -#define RISCV_IOMMU_CMD_IOTINVAL_AV            BIT_ULL(10)
> -#define RISCV_IOMMU_CMD_IOTINVAL_PSCID         GENMASK_ULL(31, 12)
> -#define RISCV_IOMMU_CMD_IOTINVAL_PSCV          BIT_ULL(32)
> -#define RISCV_IOMMU_CMD_IOTINVAL_GV            BIT_ULL(33)
> -#define RISCV_IOMMU_CMD_IOTINVAL_GSCID         GENMASK_ULL(59, 44)
> -#define RISCV_IOMMU_CMD_IOTINVAL_NL            BIT_ULL(34)
> +#define RISCV_IOMMU_CMD0_IOTINVAL_AV           BIT_ULL(10)
> +#define RISCV_IOMMU_CMD0_IOTINVAL_PSCID                GENMASK_ULL(31, 1=
2)
> +#define RISCV_IOMMU_CMD0_IOTINVAL_PSCV         BIT_ULL(32)
> +#define RISCV_IOMMU_CMD0_IOTINVAL_GV           BIT_ULL(33)
> +#define RISCV_IOMMU_CMD0_IOTINVAL_GSCID                GENMASK_ULL(59, 4=
4)
> +#define RISCV_IOMMU_CMD0_IOTINVAL_NL           BIT_ULL(34)
>  /* dword1[61:10] is the 4K-aligned page address */
> -#define RISCV_IOMMU_CMD_IOTINVAL_ADDR          GENMASK_ULL(61, 10)
> +#define RISCV_IOMMU_CMD1_IOTINVAL_ADDR         GENMASK_ULL(61, 10)
>
>  /* 3.1.2 IOMMU Command Queue Fences */
>  /* Fields on dword0 */
>  #define RISCV_IOMMU_CMD_IOFENCE_OPCODE         2
>  #define RISCV_IOMMU_CMD_IOFENCE_FUNC_C         0
> -#define RISCV_IOMMU_CMD_IOFENCE_AV             BIT_ULL(10)
> -#define RISCV_IOMMU_CMD_IOFENCE_WSI            BIT_ULL(11)
> -#define RISCV_IOMMU_CMD_IOFENCE_PR             BIT_ULL(12)
> -#define RISCV_IOMMU_CMD_IOFENCE_PW             BIT_ULL(13)
> -#define RISCV_IOMMU_CMD_IOFENCE_DATA           GENMASK_ULL(63, 32)
> +#define RISCV_IOMMU_CMD0_IOFENCE_AV            BIT_ULL(10)
> +#define RISCV_IOMMU_CMD0_IOFENCE_WSI           BIT_ULL(11)
> +#define RISCV_IOMMU_CMD0_IOFENCE_PR            BIT_ULL(12)
> +#define RISCV_IOMMU_CMD0_IOFENCE_PW            BIT_ULL(13)
> +#define RISCV_IOMMU_CMD0_IOFENCE_DATA          GENMASK_ULL(63, 32)
>  /* dword1 is the address, word-size aligned and shifted to the right by =
two bits. */
>
>  /* 3.1.3 IOMMU Directory cache invalidation */
> @@ -494,9 +494,9 @@ struct riscv_iommu_command {
>  #define RISCV_IOMMU_CMD_IODIR_OPCODE           3
>  #define RISCV_IOMMU_CMD_IODIR_FUNC_INVAL_DDT   0
>  #define RISCV_IOMMU_CMD_IODIR_FUNC_INVAL_PDT   1
> -#define RISCV_IOMMU_CMD_IODIR_PID              GENMASK_ULL(31, 12)
> -#define RISCV_IOMMU_CMD_IODIR_DV               BIT_ULL(33)
> -#define RISCV_IOMMU_CMD_IODIR_DID              GENMASK_ULL(63, 40)
> +#define RISCV_IOMMU_CMD0_IODIR_PID             GENMASK_ULL(31, 12)
> +#define RISCV_IOMMU_CMD0_IODIR_DV              BIT_ULL(33)
> +#define RISCV_IOMMU_CMD0_IODIR_DID             GENMASK_ULL(63, 40)
>  /* dword1 is reserved for standard use */
>
>  /* 3.1.4 IOMMU PCIe ATS */
> @@ -504,25 +504,25 @@ struct riscv_iommu_command {
>  #define RISCV_IOMMU_CMD_ATS_OPCODE             4
>  #define RISCV_IOMMU_CMD_ATS_FUNC_INVAL         0
>  #define RISCV_IOMMU_CMD_ATS_FUNC_PRGR          1
> -#define RISCV_IOMMU_CMD_ATS_PID                        GENMASK_ULL(31, 1=
2)
> -#define RISCV_IOMMU_CMD_ATS_PV                 BIT_ULL(32)
> -#define RISCV_IOMMU_CMD_ATS_DSV                        BIT_ULL(33)
> -#define RISCV_IOMMU_CMD_ATS_RID                        GENMASK_ULL(55, 4=
0)
> -#define RISCV_IOMMU_CMD_ATS_DSEG               GENMASK_ULL(63, 56)
> +#define RISCV_IOMMU_CMD0_ATS_PID               GENMASK_ULL(31, 12)
> +#define RISCV_IOMMU_CMD0_ATS_PV                        BIT_ULL(32)
> +#define RISCV_IOMMU_CMD0_ATS_DSV               BIT_ULL(33)
> +#define RISCV_IOMMU_CMD0_ATS_RID               GENMASK_ULL(55, 40)
> +#define RISCV_IOMMU_CMD0_ATS_DSEG              GENMASK_ULL(63, 56)
>  /* dword1 is the ATS payload, two different payload types for INVAL and =
PRGR */
>
>  /* ATS.INVAL payload*/
> -#define RISCV_IOMMU_CMD_ATS_INVAL_G            BIT_ULL(0)
> +#define RISCV_IOMMU_CMD1_ATS_INVAL_G           BIT_ULL(0)
>  /* Bits 1 - 10 are zeroed */
> -#define RISCV_IOMMU_CMD_ATS_INVAL_S            BIT_ULL(11)
> -#define RISCV_IOMMU_CMD_ATS_INVAL_UADDR                GENMASK_ULL(63, 1=
2)
> +#define RISCV_IOMMU_CMD1_ATS_INVAL_S           BIT_ULL(11)
> +#define RISCV_IOMMU_CMD1_ATS_INVAL_UADDR       GENMASK_ULL(63, 12)
>
>  /* ATS.PRGR payload */
>  /* Bits 0 - 31 are zeroed */
> -#define RISCV_IOMMU_CMD_ATS_PRGR_PRG_INDEX     GENMASK_ULL(40, 32)
> +#define RISCV_IOMMU_CMD1_ATS_PRGR_PRG_INDEX    GENMASK_ULL(40, 32)
>  /* Bits 41 - 43 are zeroed */
> -#define RISCV_IOMMU_CMD_ATS_PRGR_RESP_CODE     GENMASK_ULL(47, 44)
> -#define RISCV_IOMMU_CMD_ATS_PRGR_DST_ID                GENMASK_ULL(63, 4=
8)
> +#define RISCV_IOMMU_CMD1_ATS_PRGR_RESP_CODE    GENMASK_ULL(47, 44)
> +#define RISCV_IOMMU_CMD1_ATS_PRGR_DST_ID       GENMASK_ULL(63, 48)
>
>  /**
>   * struct riscv_iommu_fq_record - Fault/Event Queue Record
> @@ -713,8 +713,8 @@ struct riscv_iommu_msipte {
>
>  static inline void riscv_iommu_cmd_inval_vma(struct riscv_iommu_command =
*cmd)
>  {
> -       cmd->dword0 =3D FIELD_PREP(RISCV_IOMMU_CMD_OPCODE, RISCV_IOMMU_CM=
D_IOTINVAL_OPCODE) |
> -                     FIELD_PREP(RISCV_IOMMU_CMD_FUNC, RISCV_IOMMU_CMD_IO=
TINVAL_FUNC_VMA);
> +       cmd->dword0 =3D FIELD_PREP(RISCV_IOMMU_CMD0_OPCODE, RISCV_IOMMU_C=
MD_IOTINVAL_OPCODE) |
> +                     FIELD_PREP(RISCV_IOMMU_CMD0_FUNC, RISCV_IOMMU_CMD_I=
OTINVAL_FUNC_VMA);
>         cmd->dword1 =3D 0;
>  }
>
> @@ -722,72 +722,72 @@ static inline void riscv_iommu_cmd_inval_set_addr(s=
truct riscv_iommu_command *cm
>                                                   u64 addr)
>  {
>         cmd->dword1 =3D
> -               FIELD_PREP(RISCV_IOMMU_CMD_IOTINVAL_ADDR, PHYS_PFN(addr))=
;
> -       cmd->dword0 |=3D RISCV_IOMMU_CMD_IOTINVAL_AV;
> +               FIELD_PREP(RISCV_IOMMU_CMD1_IOTINVAL_ADDR, PHYS_PFN(addr)=
);
> +       cmd->dword0 |=3D RISCV_IOMMU_CMD0_IOTINVAL_AV;
>  }
>
>  static inline void riscv_iommu_cmd_inval_set_nl(struct riscv_iommu_comma=
nd *cmd)
>  {
> -       cmd->dword0 |=3D RISCV_IOMMU_CMD_IOTINVAL_NL;
> +       cmd->dword0 |=3D RISCV_IOMMU_CMD0_IOTINVAL_NL;
>  }
>
>  static inline void riscv_iommu_cmd_inval_set_pscid(struct riscv_iommu_co=
mmand *cmd,
>                                                    int pscid)
>  {
> -       cmd->dword0 |=3D FIELD_PREP(RISCV_IOMMU_CMD_IOTINVAL_PSCID, pscid=
) |
> -                      RISCV_IOMMU_CMD_IOTINVAL_PSCV;
> +       cmd->dword0 |=3D FIELD_PREP(RISCV_IOMMU_CMD0_IOTINVAL_PSCID, psci=
d) |
> +                      RISCV_IOMMU_CMD0_IOTINVAL_PSCV;
>  }
>
>  static inline void riscv_iommu_cmd_inval_set_gscid(struct riscv_iommu_co=
mmand *cmd,
>                                                    int gscid)
>  {
> -       cmd->dword0 |=3D FIELD_PREP(RISCV_IOMMU_CMD_IOTINVAL_GSCID, gscid=
) |
> -                      RISCV_IOMMU_CMD_IOTINVAL_GV;
> +       cmd->dword0 |=3D FIELD_PREP(RISCV_IOMMU_CMD0_IOTINVAL_GSCID, gsci=
d) |
> +                      RISCV_IOMMU_CMD0_IOTINVAL_GV;
>  }
>
>  static inline void riscv_iommu_cmd_iofence(struct riscv_iommu_command *c=
md)
>  {
> -       cmd->dword0 =3D FIELD_PREP(RISCV_IOMMU_CMD_OPCODE, RISCV_IOMMU_CM=
D_IOFENCE_OPCODE) |
> -                     FIELD_PREP(RISCV_IOMMU_CMD_FUNC, RISCV_IOMMU_CMD_IO=
FENCE_FUNC_C) |
> -                     RISCV_IOMMU_CMD_IOFENCE_PR | RISCV_IOMMU_CMD_IOFENC=
E_PW;
> +       cmd->dword0 =3D FIELD_PREP(RISCV_IOMMU_CMD0_OPCODE, RISCV_IOMMU_C=
MD_IOFENCE_OPCODE) |
> +                     FIELD_PREP(RISCV_IOMMU_CMD0_FUNC, RISCV_IOMMU_CMD_I=
OFENCE_FUNC_C) |
> +                     RISCV_IOMMU_CMD0_IOFENCE_PR | RISCV_IOMMU_CMD0_IOFE=
NCE_PW;
>         cmd->dword1 =3D 0;
>  }
>
>  static inline void riscv_iommu_cmd_iofence_set_av(struct riscv_iommu_com=
mand *cmd,
>                                                   u64 addr, u32 data)
>  {
> -       cmd->dword0 =3D FIELD_PREP(RISCV_IOMMU_CMD_OPCODE, RISCV_IOMMU_CM=
D_IOFENCE_OPCODE) |
> -                     FIELD_PREP(RISCV_IOMMU_CMD_FUNC, RISCV_IOMMU_CMD_IO=
FENCE_FUNC_C) |
> -                     FIELD_PREP(RISCV_IOMMU_CMD_IOFENCE_DATA, data) |
> -                     RISCV_IOMMU_CMD_IOFENCE_AV;
> +       cmd->dword0 =3D FIELD_PREP(RISCV_IOMMU_CMD0_OPCODE, RISCV_IOMMU_C=
MD_IOFENCE_OPCODE) |
> +                     FIELD_PREP(RISCV_IOMMU_CMD0_FUNC, RISCV_IOMMU_CMD_I=
OFENCE_FUNC_C) |
> +                     FIELD_PREP(RISCV_IOMMU_CMD0_IOFENCE_DATA, data) |
> +                     RISCV_IOMMU_CMD0_IOFENCE_AV;
>         cmd->dword1 =3D addr >> 2;
>  }
>
>  static inline void riscv_iommu_cmd_iodir_inval_ddt(struct riscv_iommu_co=
mmand *cmd)
>  {
> -       cmd->dword0 =3D FIELD_PREP(RISCV_IOMMU_CMD_OPCODE, RISCV_IOMMU_CM=
D_IODIR_OPCODE) |
> -                     FIELD_PREP(RISCV_IOMMU_CMD_FUNC, RISCV_IOMMU_CMD_IO=
DIR_FUNC_INVAL_DDT);
> +       cmd->dword0 =3D FIELD_PREP(RISCV_IOMMU_CMD0_OPCODE, RISCV_IOMMU_C=
MD_IODIR_OPCODE) |
> +                     FIELD_PREP(RISCV_IOMMU_CMD0_FUNC, RISCV_IOMMU_CMD_I=
ODIR_FUNC_INVAL_DDT);
>         cmd->dword1 =3D 0;
>  }
>
>  static inline void riscv_iommu_cmd_iodir_inval_pdt(struct riscv_iommu_co=
mmand *cmd)
>  {
> -       cmd->dword0 =3D FIELD_PREP(RISCV_IOMMU_CMD_OPCODE, RISCV_IOMMU_CM=
D_IODIR_OPCODE) |
> -                     FIELD_PREP(RISCV_IOMMU_CMD_FUNC, RISCV_IOMMU_CMD_IO=
DIR_FUNC_INVAL_PDT);
> +       cmd->dword0 =3D FIELD_PREP(RISCV_IOMMU_CMD0_OPCODE, RISCV_IOMMU_C=
MD_IODIR_OPCODE) |
> +                     FIELD_PREP(RISCV_IOMMU_CMD0_FUNC, RISCV_IOMMU_CMD_I=
ODIR_FUNC_INVAL_PDT);
>         cmd->dword1 =3D 0;
>  }
>
>  static inline void riscv_iommu_cmd_iodir_set_did(struct riscv_iommu_comm=
and *cmd,
>                                                  unsigned int devid)
>  {
> -       cmd->dword0 |=3D FIELD_PREP(RISCV_IOMMU_CMD_IODIR_DID, devid) |
> -                      RISCV_IOMMU_CMD_IODIR_DV;
> +       cmd->dword0 |=3D FIELD_PREP(RISCV_IOMMU_CMD0_IODIR_DID, devid) |
> +                      RISCV_IOMMU_CMD0_IODIR_DV;
>  }
>
>  static inline void riscv_iommu_cmd_iodir_set_pid(struct riscv_iommu_comm=
and *cmd,
>                                                  unsigned int pasid)
>  {
> -       cmd->dword0 |=3D FIELD_PREP(RISCV_IOMMU_CMD_IODIR_PID, pasid);
> +       cmd->dword0 |=3D FIELD_PREP(RISCV_IOMMU_CMD0_IODIR_PID, pasid);
>  }
>
>  #endif /* _RISCV_IOMMU_BITS_H_ */
> --
> 2.43.0
>

Reviewed-by: Tomasz Jeznach <tjeznach@rivosinc.com>

Thank you,
- Tomasz
