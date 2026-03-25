Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6644B1B86C7
	for <patches@lists.linux.dev>; Wed, 25 Mar 2026 22:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774476979; cv=pass; b=aSdN6uI6pxRGZrNB15U8HB96NO/vYoZl5MJijWMq+B3pr67Tp8V78kyi5wchAS7PQzX3RdlvN/IZ7eaO+N+cODdRbf4NKfS3O1CMXAwgCsD8VDyND0tds//9dlMHpyLkpl1BPXXGn2FjFYGU9TNcnLH6Y8W5KqlJ+Gg6gH3G6Sg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774476979; c=relaxed/simple;
	bh=CKPaPT6pFzg5mW5MbWk4jzTi2tnODuirpxJdAHgBJAE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OJv3I/eMXjKOReEApxLUuU2X3inxgsvnP6djZ/VTQ58R0e70bKgacjTH8X0yBMZjiH3e40G3Hn9WLuqgw+vt/TQTGBpC9jhbLDfkHIbw8M2rFzDfwge0872yD4cn3yCg2j5Rc1U4prBUeBp0gU7Lu6VddxaElBoY3SbaFTWtefI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GHvpCyXD; arc=pass smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GHvpCyXD"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-67bac077116so216912eaf.1
        for <patches@lists.linux.dev>; Wed, 25 Mar 2026 15:16:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774476977; cv=none;
        d=google.com; s=arc-20240605;
        b=hPyIhNsu/N5zorzQiSxxx6luNY8r5f5pib7OFKhXVZTMJE2DfxvBePpb3I93byq/JJ
         61/GKfER69aj8cy0dE3XPghC8ILocjRBPT0ZAi8XmVYblAKsTTxagVoWgdmlh2v/JQPI
         tE0lOLNHLF/p/xKnWp/ZcbygShYPkP6AF9z6Dul7xnMUwFKs0QKHVCQrK4ajTxQGWwhc
         oTCxDWv5cKbABDp8VHgN+fS20iPSzBMln0AYoh5lJpp69cVhwtTMfszdG9Lt5CiE00FR
         k5Ca+l50mpliw3YwRnC2tPexEu0veAlWQhBAZAlYChChsBdn1BEzsHwCqthhUxaMd2ME
         QC1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cQDzQb/gBIw+MDDDjq7X4ZU1Rk6doOJDsa8UP6sNnoE=;
        fh=rEniOU5pnQHmMhhRw60IlP7cqhPr37B3FVZB1A/PJAQ=;
        b=hr5O1nOKmffeAM8ONGqR//xOo5dyNJTSlXa1zg6c1d2mRF4brqL+Cm/uKqfsKNBrz1
         LOZ1sPw34ww8sW2jFV0zYKrvVCG8RUYceReSvYh6JZxOI0r5XYF1m3kwl/ydn+5pwPY6
         amBxBqo1vcveezJYMoQ60uuLUg8CoRKkAjmMoneMjGUQYAAYpUFF8RcHqYN3xMOM9aav
         kI9fXgGfJZkxT5Xct5arWo5zEbfLDF0gU4ed+7H2eCPklSTStfFNvwx+IBqqTouLvywh
         k+Mf+Uu+tyN1TNdmEtqFDpHxBx6X6wF5DAjrg6IB02O36/gSKFSr/fS385lNEUMc5v55
         dvzQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774476977; x=1775081777; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cQDzQb/gBIw+MDDDjq7X4ZU1Rk6doOJDsa8UP6sNnoE=;
        b=GHvpCyXDSwkkapsPGHxW0jAJI+gHLclrGmIScn9luV3hbpnFLC/Sa3hoOGk7uKyXcd
         PF3B0aLkS7H6raYEu7WG+F7sxMb8DV2xAjNkcGi1bREcumNXVAgFtcjYEQcmAlhG4U9l
         OK3B1O4vtB/kQsJEf6NAGJjxhihFevctrGO09BnlyentNiCIOW3hqHNq6Vf3+qBiqB8L
         Ri5wrBeamTyLF11h86H5tdtIj2k0oiHAaSB43+ua2k2Wc+uzk4LbysWQR7cTBCTkg6Sa
         JZxl9nGhTIXTU/ZA1jELAMnhs3CiQSttyGRIS9baOEkofUvW20Mxx+rgSuWJGLlLMbzj
         +4dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774476977; x=1775081777;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cQDzQb/gBIw+MDDDjq7X4ZU1Rk6doOJDsa8UP6sNnoE=;
        b=CrO5TeHeyTmLoRzFuLgHtWEWKBV7Ip+/L638xWP8EHC4H3xDWzJ/MWvldkNRsXE93Z
         6EbAJCxcZddaRXFAe42i6WFvPrQV67uNr+T7eB1dwgEb+PzNfTQADn+nwrtLvrrAZ1LB
         +iao5xbBexub1i6zCwgW9fwBQnzcua9nwQ7FpaRKDeGG/R6Aak8uxb7hdPvqo6PXVaZt
         9LT8iHXqSz1Yh1/n9bJpKUynComE5wg85+hBf0DxPKFGYmCEqUJsEZtJwe8+EaKozb/R
         8vwSiDv4yQ1ZLboIje/F/6DCfhi/rtZ00dqsTB+mx20H9mkNMFG7B39YYuUUeq55EGng
         Wpmg==
X-Forwarded-Encrypted: i=1; AJvYcCVieoRzLInXJtRBKpVVe43aGRptmdLugRDuB0jUUFrW8z8vIyyPL3zBh1zj1PowSwO0LxNPbfvm@lists.linux.dev
X-Gm-Message-State: AOJu0YzSAsCI92Dm/nvTQs0/4c0P8AO6+qiJ5PY8TmY3ukC+4suLSWON
	50zDZnWILNqv3Sul5PfrOIvK3RNJoFUM3i0Yci47HLMjv/6uD6nYczsnK/ZXLdEdX6ywn5lpN98
	1dcnRVxiY8eenkKaVT72Re1tURkLx8laD7kaDXzJ4
X-Gm-Gg: ATEYQzwVdWOxonTPkhOVUZvKYH0ADHJ8/FKeesqCueGlTV7W395ItEGBykw+XrU2VVV
	QhFSEvvw/Px7cmqHCwADOoNIeT4pASzh7tWemJeeCZZ2E2zphx9wUSX+MKFYsZVGj3RtZC2fBlr
	V+DpBHKR+raeMjSTiMf27rHKyQ3YmRfgHnB25FXpS7Xsb4+8phXjrRWKX8IZPcQcdH3iI8H9wqc
	i+0mjpCzZpnnsGQ1WHwrjQe9M7/WBPSCMN2RRhP3trehG5tQaBPplnKYAnzgxSF91cMLaBZaBuX
	87oW1SdeVaMeZh+vuV7baI6C0xLLp+HAdKOkxg==
X-Received: by 2002:a4a:ef81:0:b0:67e:aa1:87fe with SMTP id
 006d021491bc7-67e0aa18de3mr609126eaf.26.1774476976932; Wed, 25 Mar 2026
 15:16:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v2-f4ac6f418bd6+12c5-rdma_udata_req_jgg@nvidia.com> <14-v2-f4ac6f418bd6+12c5-rdma_udata_req_jgg@nvidia.com>
In-Reply-To: <14-v2-f4ac6f418bd6+12c5-rdma_udata_req_jgg@nvidia.com>
From: Jacob Moroni <jmoroni@google.com>
Date: Wed, 25 Mar 2026 18:16:05 -0400
X-Gm-Features: AQROBzA4qyqKM_YfcGn1wN202YeqdJ-wh9W4v93pqVeHVoUP6HSGLEO470XesXs
Message-ID: <CAHYDg1Rx_o5osDGWX0q_=BES4C-rpbhOXjfWcQV-yAOe38sn3Q@mail.gmail.com>
Subject: Re: [PATCH v2 14/16] RDMA/irdma: Add missing comp_mask check in alloc_ucontext
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Abhijit Gangurde <abhijit.gangurde@amd.com>, Allen Hubbe <allen.hubbe@amd.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
	Bernard Metzler <bernard.metzler@linux.dev>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
	Cheng Xu <chengyou@linux.alibaba.com>, Gal Pressman <gal.pressman@linux.dev>, 
	Junxian Huang <huangjunxian6@hisilicon.com>, Kai Shen <kaishen@linux.alibaba.com>, 
	Konstantin Taranov <kotaranov@microsoft.com>, Krzysztof Czurylo <krzysztof.czurylo@intel.com>, 
	Leon Romanovsky <leon@kernel.org>, linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org, 
	Michal Kalderon <mkalderon@marvell.com>, Michael Margolin <mrgolin@amazon.com>, 
	Nelson Escobar <neescoba@cisco.com>, Satish Kharat <satishkh@cisco.com>, 
	Selvin Xavier <selvin.xavier@broadcom.com>, Yossi Leybovich <sleybo@amazon.com>, 
	Chengchang Tang <tangchengchang@huawei.com>, Tatyana Nikolova <tatyana.e.nikolova@intel.com>, 
	Vishnu Dasa <vishnu.dasa@broadcom.com>, Yishai Hadas <yishaih@nvidia.com>, 
	Zhu Yanjun <zyjzyj2000@gmail.com>, Long Li <longli@microsoft.com>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Jacob Moroni <jmoroni@google.com>

On Wed, Mar 25, 2026 at 5:27=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> irdma has a comp_mask field that was never checked for validity, check
> it.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/infiniband/hw/irdma/verbs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/=
irdma/verbs.c
> index b2978632241900..d695130b187bdd 100644
> --- a/drivers/infiniband/hw/irdma/verbs.c
> +++ b/drivers/infiniband/hw/irdma/verbs.c
> @@ -296,7 +296,9 @@ static int irdma_alloc_ucontext(struct ib_ucontext *u=
ctx,
>         if (udata->outlen < IRDMA_ALLOC_UCTX_MIN_RESP_LEN)
>                 return -EINVAL;
>
> -       ret =3D ib_copy_validate_udata_in(udata, req, rsvd8);
> +       ret =3D ib_copy_validate_udata_in_cm(udata, req, rsvd8,
> +                                          IRDMA_ALLOC_UCTX_USE_RAW_ATTR =
|
> +                                                  IRDMA_SUPPORT_WQE_FORM=
AT_V2);
>         if (ret)
>                 return ret;
>
> --
> 2.43.0
>
>
