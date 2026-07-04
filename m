Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86338347FFE
	for <patches@lists.linux.dev>; Sat,  4 Jul 2026 11:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783164967; cv=pass; b=Cdv0f39o1tW6PYDN6P+DTpsWtF7nDXxWwqA6DMyc7VN9jj76ZP5++0P+LtIruakW2c178U49dv4Q+ozDTfkoASrt1WEB0X9yQ60LVhRaUw+I7kE2uEcJwvqhKGi4OvVU37rudefU+mzDHqLiTT1Kfx3zyW1zLpYXzOct553YVis=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783164967; c=relaxed/simple;
	bh=rY591y6LN3cQ4h4L2/+rf8c/HRQBY1pWbtbQ++fadR8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E+6aZKUg1XYhgEjfurCTIhWSp36algGf8lGFDb7j+M/JiZ3O5bYnDcVNomCvGGwy4CEsIQ39GQ+3mqhOrEdqYaLbVuAgBd5ODEO69BLX7Ar5eSfid+vbbFvbV02m93RQsRW8P6drSu46pthen+ydypV4OVoChCKaN3lIg/7URH4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZeZH2LKI; arc=pass smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZeZH2LKI"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2caed617615so8921795ad.3
        for <patches@lists.linux.dev>; Sat, 04 Jul 2026 04:36:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783164966; cv=none;
        d=google.com; s=arc-20260327;
        b=SLD2aKL2+Xq2GT1tNIMB89HHus8F0eJgezTLw2tff5lLBJKVtltB+vNTysqL9TrJLs
         2E2CrolCKSecrVqxCY9984orCsoq1jOJYCpZw2Ex4Ymz3jdcLmUvkZ5Qr3zrTYFUKAPB
         1GS9e3W8CORJqIqCZJCZ0rBp4vMF1CDRNV+qeTMh/cg4jq2FNX2xD4j/pBs08RsomLZ+
         zqvkz7grLDJSE49C8K7nqlpaMs5A0/YwJ/AUgSIzhRya91yHzf2nC55fCoMRbKd8Orue
         H+YtUXwZHb7ScYeXUVwst/yiPGvtRUNBCl1CCwaBoCO5dXrNPL8D0uf931aRFOIcshPV
         WFAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MoO9TmSNA1KXO5Z6hnx0FT1akZ4fwPRdrddAT7qIL+w=;
        fh=HkdJ9quJdfdm6mBawK6GJ4yyCDKby8jNswuI1TOsMfg=;
        b=cuI8ds1bfw7gbEfhp8NlfCoAdroUQ6wuXy7qzx+2h+Jp49IOanqyyE5vw2rKep2lHC
         X5pNJQBMOF1Pv2tgChJXjl8+ArMlzvcsCqTdG6+3hyNq67zgVNn/yLY/hghGOjb/J4Mv
         vKCnYtKAw/nYLzvWl28kiUVE/p+OthchZXnnafL74Y676asmhuV0r7guEKsCB+LFvEOc
         qs5TlK2VIa+JG+vClfCZ2V6jfODtt+YTvaJ9NkOm6b7r/CGp8uISKHv2i5YGgjq+MwxU
         OyKQk0wPuPWrioL6Xkf6+uVJPOKwSgZZGVwfeGEEtVg9qdlO9jO2uIqkH8+iXt7+uBOr
         P+GA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783164966; x=1783769766; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MoO9TmSNA1KXO5Z6hnx0FT1akZ4fwPRdrddAT7qIL+w=;
        b=ZeZH2LKIAm2a9+n2aXHSH817AeURUh672xmzrtiQXiw5r1Nx9Kj6p6L7Dph/iWsXdP
         EIcuefhbtQjACys9FVIDJBBFtxLCFxffXLhAlY1yXM2zTsR+eDUNVJuRcnuftJij7iok
         dY4ABGXLHebGCYQhpiW6ltZVwGC+vRzcQBQZhuR/8y5RNgo2EooCq+3XH8j75kuvIlUP
         VkZtWCL1+aIwF3SsTZaqqbnkfgrAVO6eyl1s/P9xAtpqRlNfj7Elwl0ApELauIOMBene
         kz3vLsGTlBPH5pYqcz8AX0njDgmFlFFIVIF6X4lo2WnaMaDw7558P6zrq2QsL30GnmLs
         J1Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783164966; x=1783769766;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MoO9TmSNA1KXO5Z6hnx0FT1akZ4fwPRdrddAT7qIL+w=;
        b=SOcBBf7UZ+HYiGIefcG7K5PdoOTB0d68y4nIX1vOMnmIwxb9oUT6SyxgINghUuu0Ip
         vlpyFQlCtJlLojl7mYZdxw7Jw0fa63SFN/s2okqMJwivkNBgo1zuCV0Iojltko0wRqCw
         P5LjEiKQCdnCDT+LY7NDewKv2TaH6kPlcm4Mh4HynNbedYWMo2A27vp2VHKSSdDniJhP
         C7d4vhhZ2hsYrg6B52mwG9qF0fFvAsdHGkzu8W1N3dMsN+gftTFWSYbVhjo2v+LflO9S
         F6TJcETKpgZUeUxFe+vbBfKocwaTJcvD9hJsVBaTZEXVJTPZv6XqknKsW1UDx8L2QT77
         q91g==
X-Forwarded-Encrypted: i=1; AHgh+RpSZuH021ck9+IWmcgKSt/WP8J8n0OOmlLlDYx4Q/7a8PPZOcz6mR1RbgaOOU8L0VIPH+Zj+6Il@lists.linux.dev
X-Gm-Message-State: AOJu0Yxoogmc0H5sDPKeSfZuGzcgbcr0gY0OmMqW1+q2eBGMkI49PqPO
	JROMqkWsxGxAyk86Tu2xcLC2bGY+7AN7QPzDCmOD4RVSPnJNYJL7Hq72M8284W8Snx2sR4Yi/pU
	BfDNQ7eR6b3l1Ke7cmJ2QSJkZqz/TwwU=
X-Gm-Gg: AfdE7ckTuKXmFGIX4pmRiF8RxuEcW1eALGSupqZBFWxJMS0NaqoezGqkVZfgVxQeCXF
	OcoEvnWlSdlUdygSlnB+0T5TTv8GAvLzclEPoBwM3fIlRlXxBolkXBd1fz5NrlwGy9MZ59AlaDy
	3wLN/f9r5c1UZcVZQYKepGSs1Xq/V1fkTC9FGsHftj0e+hRutaU8YC7zY0KQqRW+KC/z4cVtdyE
	C2lFVYQFscYrFGGqfddLB0tWh/giz+Mewaoek0qIcgAM5j0sX2tVEQVZv5H1h6eddpACXPTfg==
X-Received: by 2002:a17:90b:4d88:b0:37f:d9dc:557 with SMTP id
 98e67ed59e1d1-3829d70cc3bmr2960626a91.16.1783164965524; Sat, 04 Jul 2026
 04:36:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260528194646.819809818@linuxfoundation.org> <20260528194657.359703301@linuxfoundation.org>
 <CAFQ-Uc-wu8fbTDXhtyODCz36_1DBue5ay7V2LpzjrUgHs+0WvQ@mail.gmail.com>
 <2026062933-storeroom-amusement-0b66@gregkh> <CAFQ-Uc9p7PhXp-FC4N3iYAtyeKgN6z4A_+L8YwKDAkXxZAvksg@mail.gmail.com>
 <2026070446-blank-duckbill-13ec@gregkh> <CAFQ-Uc8AAEGw90BPximQm3cLzB+KiH_PXr-UZEPK9nvueMGtSg@mail.gmail.com>
 <2026070406-squander-geography-213a@gregkh> <CAFQ-Uc8CDnGUH3xhjaVBd+Dr=+b7Lfu1SUrGGh2gQ17WW+gqxQ@mail.gmail.com>
 <2026070421-overflow-voyage-73b8@gregkh>
In-Reply-To: <2026070421-overflow-voyage-73b8@gregkh>
From: maher azz <maherazz04@gmail.com>
Date: Sat, 4 Jul 2026 12:35:53 +0100
X-Gm-Features: AVVi8CecrYlLo7QVlDLZCm7Fw8LHog-pVbamjikeEXELRSjLIlFzv8YtHUdmvRM
Message-ID: <CAFQ-Uc9zmukVV3GcpneMJ5hrK4mB17FBSPyBh1_yjff5JC-r1g@mail.gmail.com>
Subject: Re: [PATCH 7.0 345/461] vsock/virtio: fix zerocopy completion for
 multi-skb sends
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Arseniy Krasnov <avkrasnov@salutedevices.com>, Jakub Kicinski <kuba@kernel.org>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I=E2=80=99m using gmail directly. I=E2=80=99m requesting a CVE to refer to =
it directly
as i'm going to disclose the poc on my accounts so people know about
it and patch

On Sat, Jul 4, 2026 at 12:26=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Sat, Jul 04, 2026 at 12:20:27PM +0100, maher azz wrote:
> > I sent it like half an hour ago the same way I'm sending you this
> > email, I sent it in plain text mode with the subject "CVE request for
> > a patched Linux kernel LPE vulnerability.",I really don't know what is
> > the issue..
>
> Please look in your email server logs for what is going wrong, as I
> don't see it here at all.
>
> > Anyway, can you please take a look, since a CVE should've been issued
> > a long time ago, Ubuntu 24.04 latest kernel with latest patch is still
> > vulnerable and many morea
>
> That's up to that vendor, not us, to fix it there.  Why not talk to
> them and what does a CVE have to do with that?
>
> thanks,
>
> greg k-h
