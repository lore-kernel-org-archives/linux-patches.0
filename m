Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD62DDC5
	for <patches@lists.linux.dev>; Sat,  4 Jul 2026 10:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783161706; cv=pass; b=I4n51JwPIwAf5NoO9R5fToo44+wnyJIoxL0K3JOUtEt/XXM+9DuCO8gYNF3GfksFuA9Utm9cyCjmXeM2DENp0ei7j55WXyz6FRnI9ufHtfiF0rBQldsqcG2rlA0WN1u93BKWZnJOt0j67s8iJrokDm52fioXdr/TYfB/zev2PW4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783161706; c=relaxed/simple;
	bh=mWZz5Mptz0/RiSUfawe8LlR+jG6GWkw52ioPqYH466E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hNBvb0KTucdcbOzwHzR7cufMgFMcVL7kKyw6osaSaBzlQpjppuuM8U8fonNdrlt8DOQgCiu8JcGja6w18PqNalN5gAb+90oUtLOfZaUuA0OHsXGgQMRiv9wuY2lOJ3FdDStr+1sAkFie4ikfDgVU1zTv/rLed4ZrdW09xZPqV5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AXmJIten; arc=pass smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AXmJIten"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2caced6038eso14201665ad.0
        for <patches@lists.linux.dev>; Sat, 04 Jul 2026 03:41:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783161705; cv=none;
        d=google.com; s=arc-20260327;
        b=BWMvVYvaXLGE2a1yZT5KnHSgiAksSBdI3sLsSaR6UblgncSI4jww3ygd/WD8lyo46Z
         dTv1E+5k2dRqjP2bUgH9e3DGIstKQnYB9uPK2K9s9+MW4o0oDarlgHQacZOHsfp9yr/k
         J29OAP2FUYI/1XWge9Lf7IQg3Ayz3hhj8l8TjSMrHxw8WVBCNwvnIbjOxXPt9HO/E91D
         WQH/fAS9xO0fQaOUCQccHNPpWh6u4wAjuE8dfAQoAI7ra1tEOANDql6F2Qu6laP409MH
         ECL3uT7nNQA3EG0vPulQSj8mLUmdh7bfjyCo/sSp5WisuLRPXH5RQ3wGTPHJ1LdI8cxJ
         g/6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=831x1yZW+gScBu3FM5axlqX9hokdcT1dSf0nVkZowQQ=;
        fh=mfsXybzoz63PpE0U9z29nVLTI4jWTNspJwVUPE6hoZE=;
        b=dkcIoH8Io65hVXhjOfk5EitfoJJBEClrDsBDN/SlqMw81P2Y/sy0nxwBWzPjLcPG5F
         YcCvYDkALa8852szYNRxX70JjmoQgb90pBhj4NtDc5UaOxl88MB08u1fCeXkAG8M8m0k
         U+tWpWU9PPry17YlQn8KRgbxAKMCK15keT85pQRML4eff1J7wX5VEP4nVq3oYWzCr/yJ
         mWjLp2sJJx75tdGVyPa/MUvNu6osukooYxyvD25v3wDqGFLDOkNGcEp3qfKXSUV9Jgtt
         rdr3wqIzNzp6fK9jBY42JZVjjm2C0EPq0Es+aKibfKWBJCbOvV+BakhKVkUL2NsiIw9R
         WLXA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783161705; x=1783766505; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=831x1yZW+gScBu3FM5axlqX9hokdcT1dSf0nVkZowQQ=;
        b=AXmJItendJTtlmF6rTY0uPaKnH8Io9rc3uF1CRs+7hzvqBqPGPB+MlGxsRqKd/HTuo
         M7APVHid2eIGk+iuiR444iMwy0AJzGaSkJN4spWmZhmo++Ba4hATxqjsHYL9pRWaTZ93
         TDqrbfwlQQOMZskYnipxahYOCr+hzkwSQ9oiaGpRiEhj65s9nS2Bn3dZNZkoqEbDL3D7
         Z5FcJCIrRgrmnZEw0QSPa26lXPGkC1cjpWdd5PiNpiF08qfMzTHp6VmVv1b5cQ6W6f6Q
         AgQWXio9TmDcmADVBha3NZwWvRauXk/jacuu28dEY2uwlM/G/Y4mR4wOKtXu4dTA4ox7
         b9ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783161705; x=1783766505;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=831x1yZW+gScBu3FM5axlqX9hokdcT1dSf0nVkZowQQ=;
        b=N/l+bB8YniQcnKnmaiQAbJ71xn0qBCjn0Ph2AyoMowK8qgkNCSSbCp5hkq0QE7Kp0w
         0A973zHRimxLBgg7B5oqv/mV0FE2ne+dP9y4bKYGhPZ60JRYzJAQKMjXTulzNqwVzHTc
         uHkitGbhlnE89N/tohcwBKxHihbdsvg8ILSQNXwaCQj9TW1XiX0tDsbXl9NhXstGDto+
         iAHvvDR3VHr9S5Wejwfpw4346t9D6oZ+yK2Drw+rDcs6SuHIJjKfpqoN5mGU1W2ohztQ
         vkQVEjFoqHzQxCTVs+D+yT+3DTO0vXSZGqaMhMtIJkP9YDrrjM+o6Q95Sh3D6vMQfryv
         EiTA==
X-Forwarded-Encrypted: i=1; AHgh+Rr7i/Dm47dFbfBqTVTcPZmtFrwJJeNSp8KHsRL0Lmf/b/hgWTARakRl2qu7FWnQKuJED/gx7lVk@lists.linux.dev
X-Gm-Message-State: AOJu0Yxnluyh3kBfhKCUxaSxcmN6CscdGQ3APpXw5G1naOH3OgiYQUau
	mW1NmRjxQ9DLrngCOMgA4A7RVY38sbQW+CCMSZE+HSXxlNAjoZ5ZVqEi2eNMZKzjYW5jIG7BFZP
	EePueTohc7p4IP8NgT13nAg1elD6YoT0=
X-Gm-Gg: AfdE7cnFI3fYjof+pG8KOlCkYwbexqolDX63H2LheoUP6MWVKyL2ojL3C04b8pvVhIg
	peUDKYQCuwPXHeb+bI3StjGs6uCymRkRdg5gfxkrp/yupRwY+ZqfXHyW0E6vE1GkOMVTcEIehz9
	sma+bczNjeb6yxSvC5zFc4zGNI4KbavCV4SokjTF5EJc7aZ/3dFVYY2BjgjbI+BFnMzSGXTAkrN
	g0cPWdtGYA53RoXpvlQz93XkuHenRl9XNSitH1jbprHu6dJVBwCWx/YORmXutk93L2rTXHYXMrN
	ZZNy1ykJ
X-Received: by 2002:a17:903:3bcb:b0:2c0:fa52:1c47 with SMTP id
 d9443c01a7336-2cacb1975e0mr80557835ad.25.1783161704798; Sat, 04 Jul 2026
 03:41:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260528194646.819809818@linuxfoundation.org> <20260528194657.359703301@linuxfoundation.org>
 <CAFQ-Uc-wu8fbTDXhtyODCz36_1DBue5ay7V2LpzjrUgHs+0WvQ@mail.gmail.com>
 <2026062933-storeroom-amusement-0b66@gregkh> <CAFQ-Uc9p7PhXp-FC4N3iYAtyeKgN6z4A_+L8YwKDAkXxZAvksg@mail.gmail.com>
 <2026070446-blank-duckbill-13ec@gregkh>
In-Reply-To: <2026070446-blank-duckbill-13ec@gregkh>
From: maher azz <maherazz04@gmail.com>
Date: Sat, 4 Jul 2026 11:41:33 +0100
X-Gm-Features: AVVi8Cdp9nRRwcPFcpQTYVWqiWwmJdHjPoagAQpqxojtvTXgdnc0MFFxq5KXc8g
Message-ID: <CAFQ-Uc8AAEGw90BPximQm3cLzB+KiH_PXr-UZEPK9nvueMGtSg@mail.gmail.com>
Subject: Re: [PATCH 7.0 345/461] vsock/virtio: fix zerocopy completion for
 multi-skb sends
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Arseniy Krasnov <avkrasnov@salutedevices.com>, Jakub Kicinski <kuba@kernel.org>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Yes, I=E2=80=99m sure I sent an e-mail one week ago to cve@kernel.org, and =
I
just re-sent now just in case you didn=E2=80=99t get it.

Thank you,
Maher

On Sat, Jul 4, 2026 at 8:16=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Sat, Jul 04, 2026 at 03:12:12AM +0100, maher azz wrote:
> > Hello,
> >
> > Thank you Greg, I already sent an email requesting a CVE for this
> > specific LPE vulnerability one week ago.
>
> And where was that sent?  I see no such email from you sent to the
> kernel CVE team, are you sure it went through properly?
>
> thanks,
>
> greg k-h
