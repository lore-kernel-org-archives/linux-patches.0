Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041EF1FBF6A
	for <patches@lists.linux.dev>; Wed,  6 Nov 2024 12:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897719; cv=none; b=aGxVWxstQPLLZ7jYvYbonFK2OFoewqVFYExWugSh12+ce/HxEkC88p7+j+V8vh/Tg1bmuKTbTfwHKNrUcuWDj5yTPgViOqfwFK/bPGrJsGCIqmEZBTmgfW5xMebA4DOJEa7e08eeXy5SV0kaXPyyPEtEHMvGr9ZnceEMsRKtdPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897719; c=relaxed/simple;
	bh=jPS72vFYByANsMtQSh1fpS6SGvlLlwpt9xCT2EBhmRo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lnVRqzOkR+1yQ3WBZEKjG74Nnk4TYPDCnY/Il1f5UW15fmO7ysHZABJz8evZ6y62wLzYZcphi1UjpH4ATQKiGi48PGHSUssxapReZWme6EZqI8Ssee3DkOsclkjjBGXnvXDtgojncfHZ/nh2OkrPqXrFaudJAxpokJEmD0Fd/eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e291f1d659aso5956805276.3
        for <patches@lists.linux.dev>; Wed, 06 Nov 2024 04:55:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730897716; x=1731502516;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R+1YO9BxHmGu247QfteLcFUKWAlVNvpvoScbnZ5mn3g=;
        b=pJixM/WcFfeLGNYy9OJUho9ULqDIT6fTiRiOC+hjT5mgMboK1F8FqeYOKkrxrWriNT
         vv700B7idnGKgg7vO01cjV72IrwHBb9g7SHlz/9pLubMkINVb2e+VdBQAPkjmM+xeBSU
         he//CPSnbt39qCW5f8B0jNb5auVak19MlauB+ksCFEl13r4TZqlxI4haQaJaBmYkodyE
         tLgwhNQL4F+v3O6qOmuHDTea3VbyxqPCYZF0YayiqtUer/kqnARv4Q/07XFhMGibXxHi
         svw1JIoPgH9Hri1H7Q4C/+VQdRRn/kK6FbznMN5D2Bo2rK1DibPynHwOCeq5rJbi82hb
         j7QQ==
X-Forwarded-Encrypted: i=1; AJvYcCWiZJFzCZtmJqtAZt2t4dDVcD3otN4l7MFqrAADce4R26PB/Kbr3HnppGRfOJik7uJpuk/un/Z/@lists.linux.dev
X-Gm-Message-State: AOJu0YzENYVMfXeCpKOdJruIl7QUSALf+mvtv9QDopyt6U912n1SDBAe
	hv7e1yvi9P4ifiwhjcVVRotom3iWEEyVIioueZEgHcfZNC4I967QEWybi/cw
X-Google-Smtp-Source: AGHT+IF7B7PmLHqvuisTsAYIPTw8Tf5Ovwrmxcu04gMhxfTPpYRWph94njhqbXrzYak9BU8MKWODcg==
X-Received: by 2002:a05:690c:3709:b0:6de:2ae:811f with SMTP id 00721157ae682-6ea64bf4929mr207847367b3.35.1730897716389;
        Wed, 06 Nov 2024 04:55:16 -0800 (PST)
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com. [209.85.128.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6ea96406d3fsm13846417b3.66.2024.11.06.04.55.15
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2024 04:55:15 -0800 (PST)
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-6e2e41bd08bso70100857b3.2
        for <patches@lists.linux.dev>; Wed, 06 Nov 2024 04:55:15 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXvx0Ytm+oMzs3cJa+hm84EUb3qB8VZ4KYryX9TYfPq0IHwgYfd4uKpK+P+nqv96P2DH3tn3ov3@lists.linux.dev
X-Received: by 2002:a0d:e903:0:b0:6ea:6871:f6a8 with SMTP id
 00721157ae682-6ea6871f6f0mr118100397b3.36.1730897715363; Wed, 06 Nov 2024
 04:55:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241106120320.865793091@linuxfoundation.org> <20241106120328.478044780@linuxfoundation.org>
In-Reply-To: <20241106120328.478044780@linuxfoundation.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 6 Nov 2024 13:55:03 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWoAOzMtFWEukAfAOz-eGub2=7P0hyH2PkZKN6Pkv4LWQ@mail.gmail.com>
Message-ID: <CAMuHMdWoAOzMtFWEukAfAOz-eGub2=7P0hyH2PkZKN6Pkv4LWQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 312/350] dt-bindings: power: Add r8a774b1 SYSC power
 domain definitions
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Biju Das <biju.das@bp.renesas.com>, Geert Uytterhoeven <geert+renesas@glider.be>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Wed, Nov 6, 2024 at 1:22=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> 4.19-stable review patch.  If anyone has any objections, please let me kn=
ow.
>
> ------------------
>
> From: Biju Das <biju.das@bp.renesas.com>
>
> [ Upstream commit be67c41781cb4c06a4acb0b92db0cbb728e955e2 ]
>
> This patch adds power domain indices for the RZ/G2N (a.k.a r8a774b1)
> SoC.

Why is this being backported?
It is (only a small subset of) new hardware support.

> Signed-off-by: Biju Das <biju.das@bp.renesas.com>
> Link: https://lore.kernel.org/r/1567666326-27373-1-git-send-email-biju.da=
s@bp.renesas.com
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Stable-dep-of: 8a7d12d674ac ("net: usb: usbnet: fix name regression")

This is completely unrelated?

> Signed-off-by: Sasha Levin <sashal@kernel.org>

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
