Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221D9199FA4
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 08:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730968689; cv=none; b=cW/NDNum3cSEh0ptsj5Ut0FdRxndFbwQDk8/kr2SuIUVGajvQZU8Ure9VA7CKMQev+UZpfquE9BfUV8jKgxkoToe5y4ymyIglj5IiVqd46ZAFB0yJ3rwuVGePhPdpzod6p4Kpu3btoupbgNgva2NBBkxABogNXiAymwopCf8LD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730968689; c=relaxed/simple;
	bh=5K9RBw/syKo/ToA0mTS9h7O9ZvRiBwpEZbv4gIcFtbU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QOg44e7qw7gTaFn0Dm2r9Imgq0wJ9AcOO+/TYhzeY6JyFH74q4Igjs+iL5tiE1EE+OOLJgmYfik9bjBLoK8wn1DuePTXlkn19J9O1YWuzqb7Sbu6NAPZQHQ6e8hQaF3BU1ZW5MCHFeTbWwnLexn1gIqts0mJTUtlJYYuAvlvphE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e290d5f83bcso710703276.0
        for <patches@lists.linux.dev>; Thu, 07 Nov 2024 00:38:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730968686; x=1731573486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5qIkpxX8mie6S98MLU//bN6Dn5DgRJ3nz9AaO+MRWEA=;
        b=r9mXfnOzwQLflpRObg+MsMc7MzyGjmGVX/B8N6I0H1uoObvYbA5FlgV0KJtprvPogI
         lRJqeS7S9enRw3MbIO2f52tk9u+7bUb7Z+UITOQo1jLUOlahk2HZo3hKOzvWaVKnhYB/
         I5dV604/YzEv8cTePySCpICjvRsYpKTTc4jLuw9/akjfuq+iN6HZFx/JZFGgZJCQz82t
         /oz9SAMpse2iaswMNqAzP1usX6SR69vj9s6u2HbKGOt7jPU8YUbfr/6JATID3wFGaIxV
         5575jXcfTJINs3wtrhCtlSfJ3Oo57vbQaFza7xEUAsijTa2PWQLPU5rGmEzoicqCt2Sa
         JF3A==
X-Forwarded-Encrypted: i=1; AJvYcCUiuQqdpbWeng5XuP8/5Dtz9A9m5aDzxb6A/9ATbHMFKiChg6IoFD+U7VMvRs3vwsTGuGfJG3L+@lists.linux.dev
X-Gm-Message-State: AOJu0YwfYzzoE13eNvwS6upww32JLs79Ka+NRoVRqUNA8kRkR0yXrFYy
	xJBadtBZN4rlSfpZJQWR1pawoWUGpyFB7QmdGo6gILow+TIw0yxWN0Hs7b+b
X-Google-Smtp-Source: AGHT+IFfnUCYek1gN13+BJU/cIdh7jR+mV7FX16roo4iPNdmsB1IHKATLjvQF4IL4854IuTMrEVdiw==
X-Received: by 2002:a05:690c:380a:b0:6e2:ac0a:8926 with SMTP id 00721157ae682-6ea64aa6f72mr250706967b3.9.1730968685638;
        Thu, 07 Nov 2024 00:38:05 -0800 (PST)
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com. [209.85.128.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6eace8d5483sm2004627b3.2.2024.11.07.00.38.03
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2024 00:38:03 -0800 (PST)
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-6e3cdbc25a0so7355787b3.2
        for <patches@lists.linux.dev>; Thu, 07 Nov 2024 00:38:03 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXY35ZEoFtF/W6MTng3rYuGa4CQHcvFVdJjLHuI7mRRJ7DPvlYQGHpdNfe3siMnXMhet0EVJnV8@lists.linux.dev
X-Received: by 2002:a05:690c:6f8e:b0:685:3ca1:b9d8 with SMTP id
 00721157ae682-6ea64bdd307mr238656597b3.30.1730968683252; Thu, 07 Nov 2024
 00:38:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241107063342.964868073@linuxfoundation.org>
In-Reply-To: <20241107063342.964868073@linuxfoundation.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 7 Nov 2024 09:37:51 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUi=gLLJp2zLgq4bQ-PMXdB1hOZus-5zRSKYS-71cQJsA@mail.gmail.com>
Message-ID: <CAMuHMdUi=gLLJp2zLgq4bQ-PMXdB1hOZus-5zRSKYS-71cQJsA@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/349] 4.19.323-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Thu, Nov 7, 2024 at 7:47=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 4.19.323 release.
> There are 349 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 09 Nov 2024 06:33:12 +0000.
> Anything received after that time might be too late.

> Biju Das <biju.das@bp.renesas.com>
>     dt-bindings: power: Add r8a774b1 SYSC power domain definitions

Same question as yesterday: why is this being backported (to multiple
stable trees)? It is (only a small subset of) new hardware support.

> Stable-dep-of: 8a7d12d674ac ("net: usb: usbnet: fix name regression")

This is completely unrelated?

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
