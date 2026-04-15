Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C98D21CC4F
	for <patches@lists.linux.dev>; Wed, 15 Apr 2026 18:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776279275; cv=pass; b=W910WIQ9bmQPGgAv+RWR67+0qvikih4RUge2UTQGc7Vy48/Zy5aVA8OuPrKe6x3JPA6rCPFPFl9VQnP3UR/4lX0fkm0p0tvW+0nqRgXGzp5wSdx7LdIU1lERV13oKCTiQQx6Y83wKwtg05E/BgdJ0j2clePasf1rwxvGZkkN2Bw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776279275; c=relaxed/simple;
	bh=fQaHT0WZJOK65WyNe4PaPMmmwzlL0FOR1eTK/cw4iBw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tHfyfy5r4LZiZXDQbqaMRo1int106PWQydeYTVfdWOaHL8KVrlzT7zkfhqH90GlEHCAVK5BYwO+aj5N5dGuNiaUE/VeiKISju3V09tXFnqlsDjZ/63RwON2Uxmh+jSZ4RrYM3Edw/kDrpURFHPRSQguz23X4jqO5V76bILzeNo4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SD8OUCsO; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SD8OUCsO"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-50e237ae754so83591cf.1
        for <patches@lists.linux.dev>; Wed, 15 Apr 2026 11:54:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776279273; cv=none;
        d=google.com; s=arc-20240605;
        b=JnXwjbR33ZTP11EUV1wzwnZSbi/b0ykIVEKlBJmsq7Z2R9KD3ixUJJ7ABgWNQAXG4x
         PPVjk86gADoZxmpfGKKblfR2gkWRszOZwAKZTa1TkTrrQhUHxaYFotQfv3szFaSARRos
         wYTLKO0NF9kmSvM6FLvplDG/yZ4SOtYICk59gk9mpIrwpaM8fek7haI5KCIUEYJlvxnq
         G2Pya8uFQPetq6OgqYFpKVlidHVrccoNdHL+5RYXaUprOmPn/97cX82T2yDivpYcNruB
         E9D0W9PLEjBIeYIksyxMB6+irudPm0fGo65eXMXIEajKACedniYsiEyP1JdjZKgpQg8j
         L11g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fvmVAYeUdSrn9HdmiZpJD5pxR8Gg76A8Jpt7CDjD65g=;
        fh=2MaUgQrUvsxv5ed8abqzeoY9mhKzBPbjjz5tFkifi3I=;
        b=fAFsSZDkpYGtspbqO7PbvwYzfJUqnZDefER02ZZ8I3JM22Vaw2h+F0JYzYs0RuKkK0
         woH68xsH3EcG3yCJyNFjSpIgwJmvk2XsK5a8YABQvRM8QIRsnuzgYKpU7lZx0CXS+m7A
         amvUiytLyyLwlg41xlj76iHa/MLbr9e8MQEJjv7OMeKxgXL+B81bTQF/tgtieERqvcPe
         XUbNhSeRzn/W/nUe5P/J/viloPl2eI7QttETA9Qw59uaVezLiEtYeg7y7TouIzUffoD0
         9qcd2PlKc7k5dBxFZ9P2VADY2SPMj1Ics2CuKP+kg7M+oG8XkfHae7z57KyJnhmosCgd
         vDyA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776279273; x=1776884073; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fvmVAYeUdSrn9HdmiZpJD5pxR8Gg76A8Jpt7CDjD65g=;
        b=SD8OUCsOwqUsd3difI29vueXy+QseiEqjCAcf938hSdL6BkWxfg2yEXyZxix0F5fgF
         fO1mYg24Qt3DHIwSs/KR89SKBqHbYRhEB78ESHVOt5pbpZLcOHK58nuZyPXmeEaEuz4a
         7GU1ryEy2DnhfWIMzeLYyG/287l91eBYkMoGTqHbedLy+Wgehf9WNTCVLN8/jwqCyEzH
         X/Puni5PFbIkRusx+i3NLWpTg2dD34noi4P4wwilO/EdvslNfdo4cNRCa5IWG3DcvPxh
         nrzuCWjdNKrb1Dni2Xo04UfMsKvF/QqlePYSkBs8akxuo/KWts84UHzai4KDr8VR3BJF
         TXfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776279273; x=1776884073;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fvmVAYeUdSrn9HdmiZpJD5pxR8Gg76A8Jpt7CDjD65g=;
        b=ZgJ5XmE5dzgQ0XNgLU7oW7NE+iSYXjUwVaQ+EyXKBdoFoUfoiWPxCLGFp1MZQ3EEDK
         TgRMetU/E1K/OrEe7TyDhk5lZnsc1YXg2Zgkob2I2aFdu4vbQOjnan/fhFYtto6bOHpB
         NGh/zZtKsmbRNjQq6iaGgjbGuWLEBJuiTIXaiM6vVxKZeoHxP7SAg6gzCZRS2OKoy6v2
         wvUHU4M4xL8zEaswOBJTpKYk/H0Pkl55DFg4LZ3/54lw0wwhzrzS47qKpIKpve5NbY/A
         W9sylMau5C4VpGhPL7B4G1VNVO3E6HtuabTNTqO6R5icllEwG5LQH0kJRPeYp/d0m4wD
         W4DQ==
X-Forwarded-Encrypted: i=1; AFNElJ8kyGK1hcZ9HG8FSzBH57M/y9zq1UAugjpAJhZTrYEmLXuFJ5EWMK6W7QU42in6QL7TqGNDAemx@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4+5KnAksuAMzZQewZkMhb/UqtbHoJD3PfKChbtgl7sE24QfNb
	sKvgCslf8i6NdbL09WX3wHi4E6bHUd05w7aD24qLQJar074tOHJh5+KhtAmUP6rkIouptWdS1QT
	M0TTtqt3+g8yrRIWbEqKHNYKAsr+btbBtmCijSgGs
X-Gm-Gg: AeBDieuisa3kyeKVknJaDdl4+6yOFuZf3gAUg/GgsDXPBFpSsIqrS+AvwMMhurHLbvw
	43Q+R4HGKU34PGPKFjgjdbaBSwxt6EyejsTsbPy23WP8ZCnH3SxwY/2EGd9houFCIzOq1XbcFiL
	FtuMYWw9Ew0Lpxg+ranOOFyOiYNW9/N/PWWe61cD/EwCosqN/hzbAX5MRRSPbaKer/4Ok7tc8at
	mkxAbzpivSSiDiUObq5qbykKLQTnSkcx7dKqDgM3kTTs5WixePsYG81ggM8T2m4SDwCqKksClnf
	k35tLW4sP8BPWRx95WUT+IlK5Awi2VuA1U/BrEFyYSljMLmzSdtgVXsIGw==
X-Received: by 2002:a05:622a:a9c6:20b0:509:21ff:cd49 with SMTP id
 d75a77b69052e-50e254bc6e6mr2041191cf.4.1776279272758; Wed, 15 Apr 2026
 11:54:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260415173735.24437-1-tony.luck@intel.com> <CACw3F522f6p-x6MEU8t7CEoU1P=PtU8dKy7opKjH8sOecdF1kg@mail.gmail.com>
 <SJ1PR11MB6083BF86FFA17D90FBF86686FC222@SJ1PR11MB6083.namprd11.prod.outlook.com>
In-Reply-To: <SJ1PR11MB6083BF86FFA17D90FBF86686FC222@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Wed, 15 Apr 2026 11:54:18 -0700
X-Gm-Features: AQROBzCLembwy546Y5LhQ65sboCQA_VYbP6s9bHTxyGDzsDQtWuY3ifv6HzqkA8
Message-ID: <CACw3F51QuexjytfyCFZe6uRaWqMKbQwrG9qFCvArf--xEr-9jQ@mail.gmail.com>
Subject: Re: [PATCH v2] ACPI: APEI: EINJ: Fix EINJv2 memory injection
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, "Li, Herman" <herman.li@intel.com>, 
	Zaid Alali <zaidal@os.amperecomputing.com>, 
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Wed, Apr 15, 2026 at 11:15=E2=80=AFAM Luck, Tony <tony.luck@intel.com> w=
rote:
>
> > > +static bool is_memory_injection(u32 type, u64 param2)
> > > +{
> > > +       if (is_v2)
> > > +               return type & BIT(1);
> >
> > Hi Tony, just a nit: for readability would it better to introduce a
> > macro for BIT(1)? like ACPI65_EINJV2_ERROR_TYPE_MEMORY
>
> I thought about that. The old (v1?) EINJ type bits are in <acpi/actbl1.h>
>
> So "the right thing"(TM) might be to add some V2 defines there:
>
> #define ACPI_EINJV2_PROCESSOR   BIT(0)
> #define ACPI_EINJV2_MEMORY              BIT(1)
> #define ACPI_EINJV2_PCIX                        BIT(2)

Looks good to me. Let's see what Rafael thinks about adding them.

>
> Rafael: Do you want that? I can start the process in the ACPICA tree if y=
ou do.
>
> -Tony
