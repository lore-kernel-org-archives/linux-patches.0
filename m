Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0861821CED
	for <patches@lists.linux.dev>; Wed, 10 May 2023 23:09:55 +0000 (UTC)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-965e4be7541so1269000766b.1
        for <patches@lists.linux.dev>; Wed, 10 May 2023 16:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1683760194; x=1686352194;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jqoKxzx8nbzMGeKcw393T5tuP9l9MYfmO2sKW8WQB+Q=;
        b=ANW3gXPTsMJujOwxNhJ2I1zuSGraG9s1eUHJz3V5xLx6it/JmxcxrXRHSnNDWfaYrC
         djPbZQ+T8xqfoi6mX2CsLZfps6PcrUpxt47BLLFV/39yAILF2gOLskuhBq2QyTEgG8sU
         8cTihGAGBH0yLD+YuwdK6NQooC3MEPlunun6c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683760194; x=1686352194;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jqoKxzx8nbzMGeKcw393T5tuP9l9MYfmO2sKW8WQB+Q=;
        b=AEMn9zOUDmAUMzHXU4iCnjQLTqQjO581TxPxdshlm+4FDjr1XK6F9Jx7njhDbg1l0P
         Ue0PwM83wJd69rMCoppyx5DUHjI0cNt1EiE7VG7V3fRxjFjyXeYzEId0WJtQiRn5iEJk
         RDCUomm8GSEcUUaBOuq5kIn9iel9UBlm5FMrsW/Ln3qOCIp7ogGAqXpK0NTNDuvFD2cc
         iL+0HgN5I7r0wGK/dPo0eGp1KR20gUmPI9DgTDPk7gO6k8b6QYaFbJstSRRTGT8ysnGC
         ZGCVzgHRzmwQ3j0v49rjQyQfa0Vrqt/rwUAAXYFPODOYAQUUlYI68+2N2xVTFMOXTGu7
         XKZg==
X-Gm-Message-State: AC+VfDxe2HCyp0c6w/KtjF0e1EOObZWsr62DZhfksag05Xdgib4CeeZ/
	WA8cH4IP8d+JDna+IK4rOb3NwCM+iBN9tGL/GSdkTQ==
X-Google-Smtp-Source: ACHHUZ4Asvx4oFVhys2zvfUTEo0mnac5psxR7HKRy7kd+mr3jexRRxknE/tf6jQFsfGWf/UtUF3SRg==
X-Received: by 2002:a17:906:4fd6:b0:94e:56c4:59f2 with SMTP id i22-20020a1709064fd600b0094e56c459f2mr16839121ejw.26.1683760193878;
        Wed, 10 May 2023 16:09:53 -0700 (PDT)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id l17-20020a170907915100b0095004c87676sm3198104ejs.199.2023.05.10.16.09.53
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 May 2023 16:09:53 -0700 (PDT)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-966287b0f72so984499966b.0
        for <patches@lists.linux.dev>; Wed, 10 May 2023 16:09:53 -0700 (PDT)
X-Received: by 2002:a17:907:6e10:b0:968:1e8:a754 with SMTP id
 sd16-20020a1709076e1000b0096801e8a754mr10370572ejc.72.1683760192951; Wed, 10
 May 2023 16:09:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230509030611.521807993@linuxfoundation.org> <863a112f-f4a4-d580-9687-f6214d555939@linaro.org>
 <2023051035-monitor-sandy-2a5b@gregkh> <CAEUSe79AViqsHimbYbFjkKAxcvROGhFKA2yKVuC3aP1Gm=jc1w@mail.gmail.com>
 <CAEUSe7_ZBW_hPUZYeKkZ6zuckeqYb+O46GdgGx0wE6T0=c5wZg@mail.gmail.com>
 <4d3c5462-1788-426a-a44a-e839b1c4970d@roeck-us.net> <2023051154-activator-aside-bc8e@gregkh>
In-Reply-To: <2023051154-activator-aside-bc8e@gregkh>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 10 May 2023 18:09:35 -0500
X-Gmail-Original-Message-ID: <CAHk-=wh2nmNs98AUpv6+BZ3x_bNh6ps+nuufQO2Sn6LdXCbC9A@mail.gmail.com>
Message-ID: <CAHk-=wh2nmNs98AUpv6+BZ3x_bNh6ps+nuufQO2Sn6LdXCbC9A@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/370] 5.15.111-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>, =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>, 
	stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, 
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de, laoar.shao@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 10, 2023 at 5:58=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> Thanks!  Turns out someone put the wrong "Fixes:" tag in that commit
> which is why I missed it.

Hmm. Presumably the real commit ceeadb83aea2 at some point got
rebased, and had had that other mentioned SHA1 before that.

It might be a good idea in general - not just for stable - if we had
some automation that said "this refers to a commit ID that doesn't
exist".

Of course, sometimes those commits might exist elsewhere (ie the
stable tree obviously refers to upstream commits that are *not*
directly reachable from the commit that refers to it, and thus relies
on another tree not rebasing itself).

But on the whole, I would expect that the normal situation, outside of
that "upstream commit" issue in the stable tree, is that you only
refer to commits that are actually reachable from the referrer commit.

Or do people refer to other branches' (or even other projects') commit IDs?

It might be interesting to have some automation, particularly if it
then might highlight the situation where the same one-line description
does exist under a different commit name...

                Linus
