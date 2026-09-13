Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5C43624BC
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 15:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.227.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789312215; cv=pass; b=DLaN7U+ccQCXS0jPh87gw3KtrgCk7eB73FBAhvqFjgVpfvR69ite3rm4wIlpjCbSJdQuS4CSjqtZbN4ltIskS5B4GOr6xd31OAm5PmmLj8tuBMuUJ6RjZOBcCxyCZOHDeGLdNp8UfjiVUFYRB/PyzYD/2b+umFV81hPYjypsU9k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789312215; c=relaxed/simple;
	bh=Kbb/7E30ax39ZQEaiWexhkP/BDx0t8X14fDULjB1uBo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lHt+k61hzQmQPQBkOjy08C4TnUdWDGw5mQas1AZSM0a3/hyIjXsgb9f6NlfniQQ4+hxTk7lVaOyrYWm6eGX95MS7WQNd4zmjQJigr0D0WAfnVNDsoWf2Joigbi86JXtv+BiMhBaENFxy7nS1qEWz9MyU+/9jvV0x+RPhGAjOaCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HzvrG8kp; arc=pass smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HzvrG8kp"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-39666e7c9efso260449a91.3
        for <patches@lists.linux.dev>; Sun, 13 Sep 2026 08:10:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789312211; cv=none;
        d=google.com; s=arc-20260327;
        b=kTe1GPZLBDbg/vA1OmfGzIiqYUnb/rqFqlF5We1jt5xk1b02PaJmXYGRPXQOlDLv2C
         ES/7LllgQj1z0R/Jg83SqdE0OAUgluRtI10UWCACnxmbdXG3eZnzZ7k/XtkuI4LP7k52
         YkmqmioqcfdAuCliptX/gN7qgvgvuGnlltV9SlfvDR0TvP/r4axvwd2FV3fW6wQItlId
         cz8IDz9nnsr5n6ecWXIXCybPG1ssdo7c2lEHUM9NE5UMbhfB34SYS7sUqbp8HThxkn2U
         EUyTiFybcJDfCvCHzpBRJ4vjkoKlOGJLe2kU3J/kglRw02P91ocqHgWXrNWAUExXyQS4
         DWaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0CgHJ2BPkLttawZZGtVilE3FDoUcF7iE9BEhPTntfQc=;
        fh=lUBjqQy6vAgW8R+btCCMxnkTYIsMHRCG9P/xdByEIPs=;
        b=Lak9kFrSDaPyOiaNJ+SKeKsMhcvYqyteDD/Vn1HMLZjGt4GQv7Z9lmHvbihMNlVqPo
         F9fiKqa6Z9IACfacQyyEg/AulJP5gTpmfHPjMR9MnBQF4Fl0MT8wUgPhTTOPhQkuhSti
         1OreENrLw0H/YUIYqsc6RAGDQCnkk+LFVLf1wJh8rCVbnjgQg716wSmydjzXIhyZ25iJ
         nX00BaqqGR5O74qu2lZz088aMFFC+QvH/HTecl1Rn2OKBgjGY+7LCI15WNiXTXcsUEu1
         TPWiM+8rhtom3mqdk7p0IdSu35ugXzA1OGhR4uVf+BAzQLWxen5aOSjvvYUS0vInGqju
         VHyw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789312211; x=1789917011; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0CgHJ2BPkLttawZZGtVilE3FDoUcF7iE9BEhPTntfQc=;
        b=HzvrG8kpv7VppTWj2PNKQnWRoeOJaAby1QynEH6IV5xdr8e9YZJwXvAcjpY2vFs3+p
         OZf1Ln7TCqZWhcN3EdzJHcDrVOwMAfkLytRrp1Y2xyfBBzL50XFAu3T8aE5d2Kvw//lX
         oTXkn8OFzzf2EQoN4SulMbQFOlCFfON84kYfYdSiAJTW/oEkc1xjLmGdLxPC/nPQDFeI
         T38q0Kf+ud7khAfpmP94dh8ha3Ir/H320IQXhP3IfnUsFFo2WN6Mq2m1KQPnL9cok3JX
         2VB0f9Pq2pHCRGWX2prO6OzV1UGkkIpLKCc3SmliIspuRV32+/YHpp7EocrRWRqGNKf6
         z0Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789312211; x=1789917011;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0CgHJ2BPkLttawZZGtVilE3FDoUcF7iE9BEhPTntfQc=;
        b=MYvGOyji4v/OkQrQ5W80yavpp0iBIJ+DfEkDGiN7Ef2mMwuDk8nHqpqOYlKaIxxw0G
         ugifqLsFQl/N6KH2Ihwd7u9k/fmKA7r5bS4gDj1Th521h56nmPzE2kepP1mtznijsxFr
         SxzoIesQlH+lfDuJjrwktPDx+SP6BxQbAUx/77N0kzUISDKvF5woEsn5P3YlqPGDOhY1
         Og6lzewvkY26yZTIk6DbgbnDSdyr5nGrK8ogtKIbBcnhItur+0KRGZfQrKYVOclF3Nj1
         WLbGqf68QAqw9/4jxV4j0kmPiHwiOBMtqTDmuVfByi7c9KPITmkwzp3Zd0Z70Ul1XhNU
         8Jdw==
X-Forwarded-Encrypted: i=1; AKwUvBwU98iwfZ7ITRASjfhY/18siPParHvowg4KANSxBUiMQCOnFAq94dKbBGyoRVznvuPt79M3Lv7N@lists.linux.dev
X-Gm-Message-State: AFuF++mZz45eWwX3AuFKDq0nJc7wPYPG8KJoJ9uDxyPegcMaIad0ajvG
	ULf64ZD/KvGLvq65ryFHW1AKw84ljgJjaW2/rqpZpgurbXNo2hs19nfOanoTKRiD42v9mOA3oeI
	p2qtpCRM3Ck9VtnzHPLvy8ePS91Q0AD0=
X-Gm-Gg: AYBFou0xj+CfClInsQ3TJIieDNmLGRRRcSDdsu9BjN7J/xqYxopZNLDsNpRL+V7eVmD
	6DFOA9l7feLITd8Qo5hnP3s5lZFqPiOfSaRGoEokcHMO4dfvQ+FobGKjEDdnaKDa9yaUMX1SakL
	TEkp1KomidqAAeJuaV23XbdC6jAxW1dfU+nRRnt9egt17Uie3LGm9Fb/WQK3uIxKRzfgkoS8MYB
	u36qRgheBBiiWC9Gs7MgxJCLQIdSZ3wLjxtuJAswsJp2pITRIsMlYnFq1Jlj1DUuphb/g2pR9IC
	LsLJVH7ACIbyIIC1Iiq7hTRNjuKkcXXIBGfSBdTixMEkkOqWM/Z4LHE6GgrWtyALALzbHi6keyA
	64Smg+6XHn5DNr4RpWRLKZcnWmS9M+xHY4hecIQ9VU+2rWNRirJEUJkZz6w7HSFLYz/K9qwzDFZ
	S/jti+a1XPjLhUGvM6kNnN9npOaJdcVruaDlDryi6qp5TczFHci/U=
X-Received: by 2002:a17:90b:3d92:b0:398:bac0:238e with SMTP id
 98e67ed59e1d1-39d9c3bc1demr16298781a91.6.1789312211153; Sun, 13 Sep 2026
 08:10:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260912065526.833703348@linuxfoundation.org> <20260912065542.937384676@linuxfoundation.org>
In-Reply-To: <20260912065542.937384676@linuxfoundation.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 13 Sep 2026 17:09:58 +0200
X-Gm-Features: AcwNN1VstPN0DZ_vucv4j1EBW6eU3LbZ-rliJHRbeKxVGTZhoyRntdTd7caee2k
Message-ID: <CANiq72mEfbYd=Xz+f2MXku3RHt_oH7KJBi0iSHCOD47oPDo9=w@mail.gmail.com>
Subject: Re: [PATCH 5.15 702/935] scripts/tags.sh: Prevent binary files
 appearing in cscope.files
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Sergei Litvin <litvindev@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Nicolas Schier <n.schier@fritz.com>, Nicolas Schier <nsc@kernel.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 12, 2026 at 9:00=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 5.15-stable review patch.  If anyone has any objections, please let me kn=
ow.
>
> ------------------
>
> From: Sergei Litvin <litvindev@gmail.com>
>
> [ Upstream commit a9b93c34625a27bed5dc0f80ee2a359ceb955172 ]
>
> When executing the command `make COMPILED_SOURCE=3D1 cscope`, the resulti=
ng
> `cscope.files` file contains filenames with the extensions *.rlib, *.rmet=
a,
> and *.so.
>
> To fix this, modify the regular expression in the `all_compiled_sources()=
`
> function so that only files with the extensions *.h, *.c, *.S, and *.rs a=
re
> accepted.
>
> The issue has been introduced by commit 4f491bb6ea2a ("scripts/tags.sh:
> collect compiled source precisely") which implemented the parsing of
> compiled sources from *.cmd files instead of using the "find" command.
>
> Fixes: 4f491bb6ea2a ("scripts/tags.sh: collect compiled source precisely"=
)
> Signed-off-by: Sergei Litvin <litvindev@gmail.com>
> Acked-by: Miguel Ojeda <ojeda@kernel.org>
> Tested-by: Nicolas Schier <n.schier@fritz.com>
> Reviewed-by: Nicolas Schier <n.schier@fritz.com>
> Link: https://patch.msgid.link/20260714083331.69482-1-litvindev@gmail.com
> [nsc: cleaned-up commit message line breaks and removed cc trailers]
> Signed-off-by: Nicolas Schier <nsc@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

(Same comment as for 5.10.y) Before 6.1 there was no Rust, so in
principle this may not be needed (at least for the `*.rlib`, `*.rmeta`
and the Rust `*.so`s from proc macros), but it shouldn't hurt.

Cheers,
Miguel
