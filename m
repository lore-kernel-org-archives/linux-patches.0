Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AAB61170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:14:08 +0000 (UTC)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-99c93638322so964178866b.1
        for <patches@lists.linux.dev>; Mon, 11 Sep 2023 07:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent.com; s=google; t=1694441647; x=1695046447; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NtfPL2emZ+ThTIXQ737wda+eYe7YeOc3mG8avwXPF00=;
        b=d44/udH3tlPnBWLbz9ktclZcyF9ALuYcaTiSsvIp8p1mPtI1wd3N45LuVbp4HjJ0/0
         B+jM/Y43YnI96B2s/Q1m+mERIVYrtCpFvFeKOvhJpqTm4kwutDEVKYHfYk1UdyNSp0FM
         ruweIbgxQYMfjmbUFMpMzGCfjLtxnPftCzNj1g6aOeOTNz4I+Ab1eCotn9ttTGHRFGiB
         Ox2Hjx+n9psUdbm5tvf3B6I8oO8NAT75ScKK5nGWlwoUeUKODB0C9T91KgYvvNBZhRbP
         50S+5DdmQwNGtXpzimnlWrnEsw1P0nuoFwgraL+u92lBIgTuIEru0ePo5yVdkTlP3AGP
         zO8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694441647; x=1695046447;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NtfPL2emZ+ThTIXQ737wda+eYe7YeOc3mG8avwXPF00=;
        b=gflvPijp4dYEO5l4RBla9MmNXm7ZOqaRym38+8MHr/GfM1mZB9jKWAl6Se5eVkyxHf
         LUZSE4oPLAdP6szqYVN0puVGJgrrns1Aoppk0PZwSLhmOmLygRdO67dnE/hHhbyJQRLZ
         s0xEeUZJFwWnQc04OFFmZmGPj8vIZ9ZRU2uCosWDGeqZhteo36AkzLWYRYpCkAX9KH4D
         E+sornuszeK9Vsl6lR9mtnXt/NsnEO4WgPWth/Ts1oJ/jcK14AJDHpsstxqcbFqsoXua
         Ur+A9V+pPKOckBFjx5amjRv1r3cg1YFJtUIygnXsLyE3U8SIRog6Dt6Ac3glcEWw9tp/
         6mRA==
X-Gm-Message-State: AOJu0Yxa25lcH3gnWdri7UQdUAgnvx6S2WQTmzTz7otfKBWXn4abHE3b
	+Ga0SJ4isTYbicUKEAJyLCUt8j3J/MiTP+krzvc6Ig==
X-Google-Smtp-Source: AGHT+IE05e6MiDP//Kv1NcMJh6gG19EBAAYmMoj9z4lXWNtchtfjTgjw1+YWgi0eny9agYeRN38esqdVXPtIT8/btx0=
X-Received: by 2002:a17:907:9724:b0:9a5:962c:cb6c with SMTP id
 jg36-20020a170907972400b009a5962ccb6cmr18545113ejc.31.1694441646773; Mon, 11
 Sep 2023 07:14:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230911134650.921299741@linuxfoundation.org> <20230911134653.617660874@linuxfoundation.org>
In-Reply-To: <20230911134653.617660874@linuxfoundation.org>
From: Lorenz Bauer <lorenz.bauer@isovalent.com>
Date: Mon, 11 Sep 2023 15:13:56 +0100
Message-ID: <CAN+4W8jR5vXtgzanqDc2UHYZRC-m87cMFwCAztArENtgqfA9Rw@mail.gmail.com>
Subject: Re: [PATCH 6.5 090/739] net: export inet_lookup_reuseport and inet6_lookup_reuseport
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, Lorenz Bauer <lmb@isovalent.com>, 
	Martin KaFai Lau <martin.lau@kernel.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg,

I sent the below email to Sasha and stable@ this morning, but I forgot
to CC you and can't find a copy of it on lore. So here goes a copy:

On Mon, Sep 11, 2023 at 2:55=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.5-stable review patch.  If anyone has any objections, please let me kno=
w.

This commit is part of the following series
https://lore.kernel.org/all/20230720-so-reuseport-v6-0-7021b683cdae@isovale=
nt.com/
As far as I can tell this was pulled in due to the Fixes tag on patch
7. I think that tag was misguided, in that the original code
explicitly rejected SO_REUSEPORT sockets so there isn't a bug to fix
here. The SO_REUSEPORT code is quite fiddly, so I'm uneasy about
backporting the change. Could you drop patches 3-8 from 5.15, 6.1, 6.4
and 6.5 please? Patch 1-2 are good to backport.

This also means that "net: remove duplicate INDIRECT_CALLABLE_DECLARE
of udp[6]_ehashfn" is not required anymore.

Sorry for the mess,
Lorenz
