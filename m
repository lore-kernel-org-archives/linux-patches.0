Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C87D3346BB
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 17:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765906990; cv=pass; b=B8gTOBhRIQeYimTU+O4Quswyxd7lMTQDZr6gtJITV/eAIIk80UbDyk6DW0xayOjS6wRYe5OjRrGkKzYEX3C3bIIDLRe2dPfzQcjesElMXFUvj1MS5YzTcKjxCJxhD529kw6kGzozsRhh5HuIWVApxPpfdH8cq7s0pC28IgsYwgs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765906990; c=relaxed/simple;
	bh=qdN+/T3hdnfEIEp342kUdLFY9kitbvncpOtzuXxRAYs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=myZk0SQ9BTzTYwx/VSoo6oX7neTtmbzvnUBTPqTnaKHnsa4nwwTCJr90GIrwSVuS8JGInSmsf/YOzbnsuropHMXbMiqvALXiuyTcf3YZ8rZ8yr6PL7ssF3irdVxc4NUImZd6GKYGuIX7hJZwYrVjYK7EAhbVTMS870CnRMXNclA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gc7YTrEs; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gc7YTrEs"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4edb8d6e98aso8451cf.0
        for <patches@lists.linux.dev>; Tue, 16 Dec 2025 09:43:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765906988; cv=none;
        d=google.com; s=arc-20240605;
        b=ST7viNv8oeRHr0vTKYsj7A9x9gVMD9yT3t1HzAYMkWIPclGKn7ZmEejVtidzrusgIY
         rQKguf+pdP7H4gkaxYruud4vZxx9IKKCSsyZOReVnfG74pLkSzr/7xbPljJbxW+cdUbn
         IlWghDQDChti+hshvyOUl98dBqQ6nBAbK2Ei0IBgA//rAb9bwCR4dT+bCbVpvikMA8s4
         ymMqZZr2WXJ3DoZ+Pm7hq9TrEEyDJ+AnEYEj5fUc454ZQqhxXCLf9hvgwf+VVyw4TXUa
         O2PEsgU8/iKc5BrI+bGfIZLNVJad4k63JqdwnWd3hktwab0QaAhu9AbxGYtF4xbpNBme
         KVwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=S+M2g7NVjb+Q98XuM7RkaFG+o6mss3wU5tl++i9MeKA=;
        fh=Gg+jvZDDW5sCC3GuXY95Vx+um1Kc2mXtBcB8Qt+0mm8=;
        b=h+JKr4m+VnCq6uiJ4WaOt3zmrOIlHNxqBCFsayOkDi7riDaWlRyOdYx6A16T7lR166
         M9fIFCOFCmgfG9JAZH4hKtgOWNW9iwO0mtNZkYvybJhHvrrUWWub5mXV6dzZ8uMwBebK
         JkuBViYc9FQCvEFSr48sSaXuq+uaxvhmr2eYFZt5FXSkyDfo9FnOBwWprC6T2aVGSM29
         oDndhXuH5r4/XExL+6l7uQjtJfU2PDGsswh0eOlZQ6U41sDQgvyALTdG2jIsae7mv8BS
         6rd6ihrmoSIiqGEO5gC63BIejJ983CVmRt1W1wygq/zobCURKxPDwDsKPZNpbGzRPLe3
         L16A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765906988; x=1766511788; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S+M2g7NVjb+Q98XuM7RkaFG+o6mss3wU5tl++i9MeKA=;
        b=Gc7YTrEsWEt0Sn46/6+2onuV67OStd3OQ0+R88AMjRj6GX7jy1K3HcCyzhGO/d6WUd
         ggDcPqhA0/ia9ZWzGO7h/42sq9RaV5rcScKejK6AKNb6EJy4vCUMMlbEajByK2BNRTme
         rqKXe7WFLpqcLhCJ0NsIf4t3Xe/E8pKQ04tuwHFSK/ppsOiWsU3Pp1Fr3rweQVua4Vgi
         pe20WMy6dWmBotH1O58KlLp1i33YqYkjlXQzcRzYteq1pWAs5K3KHJ9+SswhqtlbA6yW
         gSiUaUYHbqfEq59FjQI2uHnF7eS4k83j24tNanBupeHvwIBpJGh+Kn1ZU1apPw56ax2g
         L40w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765906988; x=1766511788;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=S+M2g7NVjb+Q98XuM7RkaFG+o6mss3wU5tl++i9MeKA=;
        b=dTMD0IY/IHkxXXbzzn0RRZGqAzLDspuFc/MDqFhgIzDCbJZ2JkoJbNM+xS5nNh7/FE
         5gwisVTDRO8gLx2Trz5glwNcVvifbiJ7Ie0LRi5ZBIgxut72qlhPBNBCARkUSj32ef3X
         BGx5bN3wHOHD8PEdXMRcvIE9BcGfqDTSUu/dLeH0y1YTi8o0cjGmV6HqC0QYEVhpj0VM
         PQX7vvfL3axJI6FU8eG5/KH4uet1mRJ1TBZSkB96FbwKvomWPBTvebMYj0peG5hjxsQR
         vM82qSLP+SkPiGZg194qRDYvlWfLTyIXNftPPDnlY469X2BNOepRR8B6PDJg3xLf5lZq
         TfMg==
X-Forwarded-Encrypted: i=1; AJvYcCXWbaG7D78F7qvfHt/90kJzwRs5OCbrU19gNSi/MH8SWwBov98maAQvsCJD46DDSMI4YHDvEm2Z@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6sY/gH2S8kH+/xC4pUMLVNjWZUN5fMSddi4+Z+j8ijRrDRq7j
	G85hbNAQryknPGx6wkWymRC4zeRl77JWd4pmEIVBmQeEA6o8frCFq+Neub7x1D6l4jiCCkFmsxX
	ZsH2G0PlzF/Ihvq1eacOHSgPXs/UQE4pb+feFRZ4j
X-Gm-Gg: AY/fxX6FJuLn/SeHGZPqdax0UXtLqGFUCr86Rn/e88WxLFGVafzMsGen4wvvvhZ1QV+
	Olifp/CK2IWZFfqUkskdQi9/Apz629kZzuloObUSzGuQE22Yruafsv+m+O0O/i/LB2Wi0zG8XDv
	0viT7RxKOsCvdsn/ZUgRBy81ytH55boAHcqHlsskmDKtJw6B6vk8O/NJsWtaRgckfAeqTGhecQX
	m+57U7N/j4CKEKjaWEpc54A68L0ErGosiU84tY03mVRdkoWRSTwgNjyTh/ikqXQMmruIzkTs4KJ
	zTlrpmaUaN/IP8f/nP8Qdo6D2QfcwyHkOUw6Ng==
X-Google-Smtp-Source: AGHT+IFFYwYz5lb1UiltQsx4DpnRWa8o6scoNJhIMT8mvh/fT0XuoATXijv41fsf+D8/QerFrM9u5fgbhtCFV/o9ROE=
X-Received: by 2002:ac8:5d14:0:b0:4ed:a65c:88d0 with SMTP id
 d75a77b69052e-4f34a9a6098mr8710501cf.6.1765906987654; Tue, 16 Dec 2025
 09:43:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v1-cd99f6049ba5+51-iommufd_syz_add_resv_jgg@nvidia.com>
In-Reply-To: <0-v1-cd99f6049ba5+51-iommufd_syz_add_resv_jgg@nvidia.com>
From: Samiullah Khawaja <skhawaja@google.com>
Date: Tue, 16 Dec 2025 09:42:56 -0800
X-Gm-Features: AQt7F2rm5JAA7BEaV5eUIbjINlL49jAhyqMynyodmR7eSsrtt6kmKreym_HBf-k
Message-ID: <CAAywjhSXf6+b+PHCecBH7JBA-Lv6P9Jev36Bco5kwqLJsm39rw@mail.gmail.com>
Subject: Re: [PATCH] iommufd: Check for overflow in IOMMU_TEST_OP_ADD_RESERVED
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	Kevin Tian <kevin.tian@intel.com>, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>, 
	Matthew Rosato <mjrosato@linux.ibm.com>, patches@lists.linux.dev, 
	syzbot+57fdb0cf6a0c5d1f15a2@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025 at 9:15=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> syzkaller found it could overflow math in the test infrastructure and
> cause a WARN_ON by corrupting the reserved interval tree. This only
> effects test kernels with CONFIG_IOMMUFD_TEST.
>
> Validate the user input length in the test ioctl.
>
> Fixes: f4b20bb34c83 ("iommufd: Add kernel support for testing iommufd")
> Reported-by: syzbot+57fdb0cf6a0c5d1f15a2@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/69368129.a70a0220.38f243.008f.GAE@goo=
gle.com
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/iommufd/selftest.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/sel=
ftest.c
> index 86446e1537949a..550ff36dec3a35 100644
> --- a/drivers/iommu/iommufd/selftest.c
> +++ b/drivers/iommu/iommufd/selftest.c
> @@ -1184,14 +1184,20 @@ static int iommufd_test_add_reserved(struct iommu=
fd_ucmd *ucmd,
>                                      unsigned int mockpt_id,
>                                      unsigned long start, size_t length)
>  {
> +       unsigned long last;
>         struct iommufd_ioas *ioas;
>         int rc;
>
> +       if (!length)
> +               return -EINVAL;
> +       if (check_add_overflow(start, length - 1, &last))
> +               return -EOVERFLOW;
> +
>         ioas =3D iommufd_get_ioas(ucmd->ictx, mockpt_id);
>         if (IS_ERR(ioas))
>                 return PTR_ERR(ioas);
>         down_write(&ioas->iopt.iova_rwsem);
> -       rc =3D iopt_reserve_iova(&ioas->iopt, start, start + length - 1, =
NULL);
> +       rc =3D iopt_reserve_iova(&ioas->iopt, start, last, NULL);
>         up_write(&ioas->iopt.iova_rwsem);
>         iommufd_put_object(ucmd->ictx, &ioas->obj);
>         return rc;
>
> base-commit: b80fab281349f107a07e841eb412a86e2877ae88
> --
> 2.43.0
>
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
