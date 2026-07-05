Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35D0433E7A
	for <patches@lists.linux.dev>; Sun,  5 Jul 2026 15:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783264760; cv=pass; b=Wu+7s/Rg7Vg45iNk4+zYxow+Dzw+i0APilNgEZMpc7lopsoX5q5NdiwhVenAqtn9/CkoFw3D2x9edgSKftBgTzCPfjfAagX86fzAA0NYDJcARjKF5VIT8Sopqr9QrlwUAUKHCstj3A2nkdBezlCnG4pdLobtC5l3Vv9uoLSqc/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783264760; c=relaxed/simple;
	bh=oP7nSsm92j9AKFJ5eaVUz/K2L8mjciRFihFP24h4pN0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lJqqUUiQOs0LO6bguvvOvnYo0oO55ob7ZL/KvidbbbeSVOSuR5R2Goj7DpkykHZTqSHJFtcmcgSzOkMN0kX7wxvXrn3rk0Nh1eFh82TfgXmzl2xZKSU/i+R9cJOBBnRD9CmlmItazFBkRx+u5C1wkt/SokGf70tUTyv6nQ3pWNk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gQfrf5Pg; arc=pass smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gQfrf5Pg"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cc73e322dbso7140625ad.1
        for <patches@lists.linux.dev>; Sun, 05 Jul 2026 08:19:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783264759; cv=none;
        d=google.com; s=arc-20260327;
        b=iFd7szuyadfFMgHGnR3X4EnrEXjIOvyAxEqMqzPy9seUp9eMKo42oJWFuS5Jt8cJWM
         WUr8BrYkPfXvarO+DYEap5DeMerThX5PVvh9WaPljfQYqAKce7VANXalN2mHD7ZtqFYg
         pwjft2clfA5GuDqIwt7ISyJsbNKTaMWeM803bvm4opOYDAGAtkkblE3R+rEBdI5QKGVI
         LKy3PDnlNZd8W7sgWtFmgAH5cmr5Ttr1kAmmQ0cx+gvlRwwzTejsbhZ8fBe6HAuD2vrQ
         YCmMj4CKsWo1/Ec7TbO0mHRV+zCD5bZaCMdU/4z9PqMuhkqBdBRkCVGgxIxGf53BjuVu
         IbOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oP7nSsm92j9AKFJ5eaVUz/K2L8mjciRFihFP24h4pN0=;
        fh=DfmxYTP+dWtmhr8aXBCfOOo55IfmM32jEYwUWDNCvso=;
        b=IvMUCE2SykNgQxBU2eLbeJxEiqnODkF/AGGabf+cYAgncy6SPhjZ/y8L7L0LEY/nQ/
         nl6aKLUzDs9QcYWjYVsL8XamCJgukfz/Y/Cv+axxxIEJyXEjbLxSJRZsFu+WeAMFliLq
         UvFF/kPdH//dezT4ffFQqFI+zN/eSjlsenwjOeAWgB57ZILJobF5206+1GcVrYcjIlm0
         lsHsiPt47DjgjdH5AWsgoZ/M2KTRAMwXvV/nD0458dlsKkvc2Wvv6mtq78r7BOcXbPn/
         iiDz96GgQNnlkLvMy8ResEmGp51eQJTufBAGKrp02+cpc0j4w27Es7C83JNNDh8G73NL
         5GZA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783264759; x=1783869559; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oP7nSsm92j9AKFJ5eaVUz/K2L8mjciRFihFP24h4pN0=;
        b=gQfrf5Pgxo4KrH2Y2uWc+9+zo6vXt1WoU9Cewkvow1kX9quJwXdvAryfrFebEbpBub
         IvODUMCkLw8hSucfAAYe5SV5m3TwTR04ioNg1/KUWA12BhSnxKye7oEyjPONvP9ad55d
         CrhFw0Ljyjad13atUMJNvWQfP7+0mFWpo1tBjvrtYnbkYpDSedGsIt7cvPBD/9hwh5S5
         pry58tia8hmbdB6PGwrnL8+mO5oJ+J70juCUWQfkBFPV40C9SNHNiHhSOOqIoAhoarL3
         TmVbsQCTuxN4Z5xe+4N4TrUN0Uh70XFvr/KQxQmE0xGgp/MKO7c12q6iVGOaOLvnQPDF
         qaPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783264759; x=1783869559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oP7nSsm92j9AKFJ5eaVUz/K2L8mjciRFihFP24h4pN0=;
        b=Zp4d6MgAa6K9aRIpP+57oW6d+dNbr82JS1N67r0KJl37JvUHOoKwmWiaOnsuwKklXJ
         VFwOg5Dw+DWcsP2qYcbGXI4xsyM2JHXvvB4upnWjHvu05/6xQnxlTMVOaRd19kAnAmaa
         tydY74rJzAG8Y2NRdF9peN1KdQV9VRUhvo18RSTV9l3AzAhdSS9vyr/ov0axJ7rqGTGt
         U4j8UwEBcreW4MdgLnfxnYccweq2IKQpmnY5pGOxic9q5UKnr/rC5Pdw+tJ5PMlpYzT7
         lyXJHc7J1RUZlrerKVSCNNc+VTfxo793w5XsMvgD0og/FW/G6Q75ENraROPUjeIwvtN3
         sbUA==
X-Forwarded-Encrypted: i=1; AHgh+RrEMdwkw3bd0tTnVEsGMZgbXI/yAgxtcRUMpv+dMopAxxMUxBVcJ1Qm5OQ2RCYWVxSiezfTg+Wd@lists.linux.dev
X-Gm-Message-State: AOJu0YyypT2+cSX2eMiePZejb3pxmplS6fjHFVDuRapZOT2Jie7MgPCV
	tQGvIIm1eCX4ZfrNNqErpVlBrHqhR2lIbFFhXfXr1/RrH3f1f3h3iCM93RmCG1MZki4V1l8av2J
	scuBMEqwQsp+n6L5mq/PY2E3CbsGfZLo=
X-Gm-Gg: AfdE7ckPIxIdPeoRbKTh2zL+gLYfk1CnMgqFF/i+96qC42kyZ5jI4D6Rk/fCR0Se9Bc
	nMMNkZ3+gJImGC0w/0q5vYCAyhQNMWvt82kpNooajbIjPnVqptTbbrfohO373YBD0NTGoInejVJ
	0K+XOhLzW00ibasVt1465htmDo+h8zQotSnCg/Fzod/OEZxMXW/0kzl39NUon1IcNTByL+va70l
	O6R4O8ujAbF8s7bT4nnLOFTDbYK8PmHygvaYkoTAQX9BJQNnPxoFqZPN5a5nU0Dd6Ylmiwa9aQ=
X-Received: by 2002:a17:902:ce10:b0:2cb:ea0b:9164 with SMTP id
 d9443c01a7336-2cbea0b92f3mr66876105ad.6.1783264758990; Sun, 05 Jul 2026
 08:19:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260528194657.359703301@linuxfoundation.org> <CAFQ-Uc-wu8fbTDXhtyODCz36_1DBue5ay7V2LpzjrUgHs+0WvQ@mail.gmail.com>
 <2026062933-storeroom-amusement-0b66@gregkh> <CAFQ-Uc9p7PhXp-FC4N3iYAtyeKgN6z4A_+L8YwKDAkXxZAvksg@mail.gmail.com>
 <2026070446-blank-duckbill-13ec@gregkh> <CAFQ-Uc8AAEGw90BPximQm3cLzB+KiH_PXr-UZEPK9nvueMGtSg@mail.gmail.com>
 <2026070406-squander-geography-213a@gregkh> <CAFQ-Uc8CDnGUH3xhjaVBd+Dr=+b7Lfu1SUrGGh2gQ17WW+gqxQ@mail.gmail.com>
 <2026070421-overflow-voyage-73b8@gregkh> <CAFQ-Uc9JvsHVCgj6ydVrg++hA4CCxw+FuQYfKzBC65HyuJNMoQ@mail.gmail.com>
 <2026070400-broadways-designer-ea0b@gregkh>
In-Reply-To: <2026070400-broadways-designer-ea0b@gregkh>
From: maher azz <maherazz04@gmail.com>
Date: Sun, 5 Jul 2026 16:19:07 +0100
X-Gm-Features: AVVi8Cflt3WU4EW9KvEe6pUrgWLhymOYj-fuuxb_awP3laKJg2ZT0yxF-A-6ylY
Message-ID: <CAFQ-Uc_+TQutABrGb5+JvrBLUyq30KcfLURQHoJdCw_Uu9-MPg@mail.gmail.com>
Subject: Re: [PATCH 7.0 345/461] vsock/virtio: fix zerocopy completion for
 multi-skb sends
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Arseniy Krasnov <avkrasnov@salutedevices.com>, Jakub Kicinski <kuba@kernel.org>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Yes i am sending to cve@kernel.org, i sent using another email just a
few seconds ago, please re-check?

On Sat, Jul 4, 2026 at 12:40=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Sat, Jul 04, 2026 at 12:34:20PM +0100, maher azz wrote:
> > I=E2=80=99m using gmail directly. I=E2=80=99m requesting a CVE to refer=
 to it directly as
> > im going to disclose the poc on my accounts so people know about it
> > and patch
>
> You keep sending html email :(
>
> And are you sure you are sending it to the correct email address?
