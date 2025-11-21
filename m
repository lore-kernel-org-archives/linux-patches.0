Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09C234C981
	for <patches@lists.linux.dev>; Fri, 21 Nov 2025 14:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763735451; cv=none; b=eDlcLeQmAxagUth1aAddjyTmAJqyaWCi+B3ZVW2cZp4a2AGjl2VACy8VG+SGK27KqGoVFTTMEOHVMW642h41v3nvXsDyMUWI6jFgk/4W8Flfsg+mIx7cXmQDgwR43Wgs4FFgvqMA2qPzwoR7deuqBCZ/86w2zsIvQLwrnzbNU9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763735451; c=relaxed/simple;
	bh=Xq2Ox6E1sy4bDR3CmET/gt5D1v7ZyzHhtYje5ulpILo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RpPuRdD4uXf/GjDw8lkEWqy9k9kNPx7VL3qpf3xL6yBYEoY223qd3YuMKkdfsjjVoYCSjC/P39CEiv3R4CePOorsy9R5B5u/rT8AOwsudLXI7qdy7i4LnTTb68RwPQWhe+mQamL7fw0ecYYE+Wc142wlFvbr4QrsjxDlTr/9A+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=b0lfmm0i; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="b0lfmm0i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1763735434; x=1764340234; i=rwarsow@gmx.de;
	bh=FbS1KZ1l6NNw+ZGBt4EnqtAMt1Fx4itvke8+5O+avpA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=b0lfmm0iyW8pwTaPjTwjWnZrXripsjQ0OpyeBskTlynuM1MDeoLdsIWSjkRqWjJi
	 FciTJvt6TMiqg/NbcMdCKchLlA+o+gIQ2vKdn0u6b03zwAT6fnbOF6ztZkINchUJq
	 BMpiU+4H0/DboKGdrimbhE8Sr2lG3s1xtyrNGIDv6UZR7Khn0bYXogVavo1MZY/b3
	 jxBCME7xH8N43vlNziRsuMlWojh9BMioA2DpXEVpyKqKYwNc2TLuptRca2Q/KULMb
	 wdkVw+Iz7fYvI4l+UHwIGn8hB1EjXjQYljauOTV8eUkIPXbdgVs2vBu9W1M10Njo+
	 CiAmtIxKnRz6UZRZGA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.33.160]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mof9P-1vtoqR0YHJ-00ls1b; Fri, 21
 Nov 2025 15:30:34 +0100
Message-ID: <c982e824-3924-4fc0-aea8-9f940bb5f5b9@gmx.de>
Date: Fri, 21 Nov 2025 15:30:32 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/247] 6.17.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251121130154.587656062@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:23l3lJbUoMiLWvPxwEikIfmc4tTFBzi8d3R/b6h4CCZ0ahqwtAu
 pZxmloK0629K6yGLOjd751wH7YxGonaXR/bFq2oGlrChNkHikb4/5p8BKt2+PCGv62ZoxCr
 QktLWGoohfzi3PamFCgMEGVJnrPo93CYkET8PJ99ghdn9+0EDJtw9uk1s37aHkTJSwXUXPN
 gLKiEtFTC7Vw7GvDMO5SQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:wvx/c6+rtMU=;2aKXeCy2HihCORujGbSuBW8GGDW
 xb4MuRDbaTlu/QEWtsbOvwxzSwx9sv5O5ZjM8hnHusCjzzWp5ElV5y3L4i73og276LJrdRo7/
 2rM/78kC7oUdMObS2uiXsYaCwRGTzYDA1/pOjJ3GaF1WVUkrj55FEBpNLymuAumIpZFyXbNuV
 ET6CjSPZhkiv//x5tHjxFgojyfOmrFcOAj35gqKu6qM2pyZOwjW6WnnD+ZDfvYEscREcyb1Jh
 0KbIUdHctTGx5UhhcGjLsz0pEj4HQTWdauk/xYc1Nl4FtVI4qYKK6iTMrrrqC2wcaiHkUuOnD
 9/4eSwlcSBoRbFXK/oSK3g89EcIYdYZj9cPo5RuS8mKm0ql9kVqleXbq2K5d/6lvahbTCproz
 61OAUAKVEEEDmbBUelMh/pAS7xaRKvxYdCBb7AS+nnN5eFu/loommURfNG/mAL9H1DqAXon1f
 oYU2Tg5R+sG7bDbZihpPkeUUq0WiXgQbUNHnzdpupP2tF8rAsIV59Q0XYegNfBAypjZv1sQDo
 4UfP7J+e9Ul5GCdBBkKBzVrfgYPMRmsbV/xQNpiZtz0v1qy7rdgsCryC/LSz3bcCA4ue+FZwC
 8FC63rqQ02uiQ3cCSNLqIOmV7EhGbg5seLb2mO/XF2KqtQ/M8YojX94kThzsJe+pBJxKgjeJA
 DCOBDGcpM2FuBS3xOwK9esi/ktNBuU1JtuPxpJb4WAUSRTiUQZLlMhSNOWHlQ89qvpz88ZBfh
 gMYN/CCRbSxOVU0GqsldulgwrGwhCucHqRaQs+P3zMYPLuMUCog/flE5d0lOli4SL9iYlSM4n
 0nu1f3jGBN27T0DtXDytCvThaxPfznQgvIGxPaTlxJTEmdEOogYLk42fmcUEP0X5Jy5aNHrlF
 D4W46y8M+ksoC796I30WHDS5cu4fNnRmu5c+Q7WtvtUGEUtads4vHaeXUAMqWIyi0nIfzBFPB
 i+iJMBlqt7soaGs3CLA+1BbWgQnRwMino/xxnol5mmlqpk82SsZ+MPhGSJHrrneVaB2ar7Plr
 0RDLHdeWUeY90MBfzDa2XPFgPYHzG/Uekj+MBdzk+GR9L/DHl0sQH2E5dRurlEzooDcRvmc3p
 VCL/QBf7KZUSeVn7s8SnqWQekEvqjr9gZ7ryNsZM0eBKZ+PbmqYPny71MfMs8fMpiKn/Ib1q0
 kCBY+gSH/2nVY+oJBE8k7i1MxTn23A7KTCf8SWy7p92nX9KBvVTwNVL2WvT+o/+NElwcO4h7y
 ckLoWSizXkCXfsYVFKQPZNmsWzMY38C0LGAxjxAQ7f9kR88Q2yjAqOjVtOjdcDJ98fpFCFDJq
 aVB7miwFA/+Y91vYPbbeShXqkBfEZxdO6ihbXkoD/dvqlZ1jrv7YyPYTuseZBLOY0Tnm6hRPB
 0zos/8uXEZ2FHMyoyN9XvyoB+61bYO8g7M7KqkO62V3sjbfqSt6r98z5eGA6QcszGBxnLPOKS
 GLJevOTHOYlU6DCow5erb/7F89pmCAZUEgUiJR1e1Iv7Gd9LHxY5AOccaMUomwTScCZn2C3GC
 7ZqDk4EiB7cQUjw7WDyGpBVHDIUom6HcjyqGRMVm7755qj+XtW8UEncJjWuOVwBgqelSn6wSk
 camHj/zmjO0i006riYm3B0zollX3+xsZFNXSRpj0CzWZfGy7YhWIJlgdSJfi5emv58RmnAFZ/
 D6zq8ywNkOVvsiCJBozyf61Vtixrwcj61CGUXD8hTkpovVZtRe9aXZ5qWeNyqLRwJbyZwVp9f
 DYK4jOuUKUfGx634X40YS5oqKURCJ4+vfWiaOaEOy5aR/+IcFq4SqDuGJaZJnSd9gv5A2Xq+W
 5e20Hmvq2BYbsuSxwewZZiKgZE1oH5cN3HLpVIyOFN+JWZeBpkezTiCfh7u04D1C//NrIjWEb
 kkVptlSlsxGtD2XZCqZSf2W05TTKTgSUsKdThWWJFntZBGGdg7WtdZ88B/Zgm9JdM6k5e+lXM
 7en9f+GP3O/ecDLO7Io8pXmQTWuePbMM76pkUBDHFf3EyzDi8TF2qOdTcnKAma/HxIEdkfycz
 FXDoPWDsfrKdVeo2LAoIV2L6LuDqTc9rsSolzVXRGrC4xC09DKsR5n3DNbuNUA3praHIl5okr
 ZQux/nHNykJo+Gr5SPuXP8fDCG1XkT0h3uAuWiik+W5bsAGG2FThkLXzGngxCD9auSvGXYcd2
 2gB3Gszkxaqok1XVuiPVtA6Kx0yjVAuRo8aT2fkMoDwZBOsHMBYNLp/3EnsR4SMYKXWDtHHAl
 CnsuVqtcL52nducEvexgzJ1VUm+Mnh2pYyh7tEGYAV8k2p++hJea3s/ShxY2v17l4jTxUE4sV
 IomFStfX5m0ZA9uTAhfCkrj0TMKYIDdAuCCc2XZ2+ANSL9rDuLID1MYxVfGlnRGmw/IcGl82C
 VxrC6cI2vDHDcMNSMVouMkbb6Mv0nrvMcJk9SYvnQ/G4difwccBnNZE8VELy8pnJr4tH/JOhC
 Nd1Tcoz7CJG2KmCVMOZ1U65BmKyaMKzoqWjvO2ia+L3ZLwEUrmFBQFvxgmeq8Biipt81uVZwd
 x51LNl5xN7tcrbJmzUO6zFV7OpaaF8TwRcUzaiI1AbAzwwUSJrTHsVxhtRFNcSphOByjY7K6W
 B5/7vkGTaCeoBf+D+02XjPfbjNEI9hey9/dIrcAcG1kQqgO+lSk0DHuGBrFn79v7mls0RkBnL
 eitlK3rMDPVzhkr+LQ9VRQYwp8+dsNiwEtHpDcp7D3GoObkBv3HczQn7TOsrRUNhfmI7h5eYG
 pbzPLnySx978h4Ryzvad1yaZx/vMNFODQPMMqQ5cP7Ik9valbZ5Urp9pgNYhALk5iJUphSfSk
 uqm99chy4pLMRdA0CA7drzWxAdGHjnIxb3AyjTkfKwhfWSiGQ2mQAFO6U8ROSbWXwlfQKLF6l
 2Veai1Ivg6q+0UC1Q9Fkk6c4heg9rmte5DC8HlP458rwe7kntVQD7X7MWOvKHS2GJ133ApNoC
 wl95uGOExUyApR8qjDn09xZ/yLeErmarqs05qYrOnZQJkRlCaGuJrDlLUyLg3kgtcrNn9hU1u
 rRutxyaBWwBK3QSDmE6pkD4YYU64LwWVJG0sdSEOC4uImAdx1KiJJyuHGMuFsYAo0tCGHZfug
 ke6T+MkTeyM1LXBc2xhLWwLGfP8XORV5D/5IBrPULUJFVrcZN1EGgVQ6DQX9V5JOssVGdjAU/
 lgtSNJTI9CvvntFGgXfuTLgmBAyqlztcHbWNjjdQoapY6rKjosaz42iIDvRb835aMSzg1WuZq
 DYkv4uGLxOzC1FSnElDmJ/40tSlZeudhH/389FM+ZJB9qM2LQIZJArGYrI8hXxUiJ3KoQtegp
 kH/8VtA+j9wfCYYD0YMVdTJN7woXKmSk0q5jF743hHsuMtM97NxDWXRh3GjsgZIlhJfEKPFDg
 cqYcKzV8nI7JKruVS1daxnfbqIdx5Si3Raz6WtW82qrkpm8qTRSnHKJO6SBopGssLAi/wNOHw
 U8dizd12YYIFHu4DKMmanTB6nbCzN/WdV7qJZnZxNDphI9XeE8IpbnPeZmwElqEnVSWaOh7Ro
 fGnnRSGE4WTbks37zt868YDrq5RSQVTcl7X+3ZVg1nKezLVt8MLJ7YhuG+BzPQUc8/i1MjkvZ
 vY4rHgpWF+U7il8qyI2/mopxo9hn2Z2lbfh950ZtBncxhxOLmaP1DXJ8NUQvOFgO7s9gesK4D
 lSxuwqwpWOfEZKQB1CL9xzi+lYT6d0eoSkNue7DyjxunAGeXwpAWEB+E9GWD392zECG8+ig4e
 2NIY/WHWobMOaiSSCCUdih6KvBD3pggQ6QkHw7SriNXbAL80xY30EqwLeC/tBqIM272wOm7Nx
 9Xebjx8T/7fo+HbaQLvNV727nP+LYWULkslRYoyEmd8jI8zPOR3qLv2TSDKLh44Mq2IGpt1L0
 tHvq2mEz/mHWI7LM0TV9e99hKBykdgsNBHay9OST2gPzk+t1Qf3Y4c2Vp42tVCotS+H+HTdVq
 tskno3AcP5+zfDUieWpi2Ko++vroN2ETpWZ1o2esyaDAAip5LV9iuKs2KLqRwiWzo/75XTTJC
 wmbcb8gN5LFxEyoof20eEPICL1B2wXuRJtW/TTZjHPYFHAPVhqJlIDYXhFkxtO+pZCHw6dXk6
 6A+vd5wvafpWTeJrq2n6r0osu+A7H8WXswsqs2nkoIh3jhS+u6vXmN9TCDqwqEE12pViBy5z/
 vCdIwb83IOPrsOhK+4KQiY+B9Vo5JgEz39eebdVqHcOEVKSrQ8EQxlDhuPA+tKn5oKrHZaOJU
 q2qg/mxDnujqbV3bYQnb7gPlt+t6SvzqAQ7Wda28tHzyM/qIjEXqlm9kgC5+aGTYecoPprpgz
 t2Te2AKTx7I+DkCQifn/ITfmIVow6MiZoK8Pp64Jp3gqZ+rrj5MqXHI/ETZLIkHBiXF1xsNz1
 lUa5VGnpYSwx7++hU5U5Eqes230zolyZQbfRxfEXALN38hSZBCDEWc33r58QbYdhRRV4kIS25
 Dm4x0g+hs2f4nrYe4Z6jJK1BxCddMihgBa1ubaArSh+YcY3Jb0Dmib8l9F60Q8313kLBCaN7L
 VUjYsrcTxlXNVM2oCa0ZiaUBh8PBazi3NSlODMKLFWnGNGgitH6W/4xFhwLZdyfaXdB1BpAGO
 rJ43N+BYx/uGKjM3HJJ8vmfwyF4f65kUMzUFNBWT5YHYs8W9Km7jzWWTgIc451ihu4XIIPncA
 KT1F8ekQ8CK5zLvJVo7RoucmEm3CVQX08FpnhJexBhVZ4WgF5P59ClyvwkV/I2pWr7kxrzBMy
 XMe3ygUKPud0PzDIeciG1OvxxQu+aWCN5Zuuqc2TQ5YJl6hZpwzVn8YdhknWUiDinHucJQee9
 UCATtcj5YxkNJuUuSkmNphRW4PRKilIIHUkDrzPkVw75iaOogF+CyLP1wDHWHgaf53ZfsGTII
 xDvi51TFY0kpM4wLgEpSM2lzL7FZxDGTkdktMaU1BnOeVtA+tFHD1FAEq+Si8hX23a5q2Me4e
 gEal9yYq6SuMb5vcRtqxVY8MkafvTw+fIo9X2L62iHIaj/7E/XPk1x37rVvPd5NJYyFHXo41K
 M5+Wfw7ALIZ2odBfwJirbqr5oQaXbUSlGxQ+H1AJHxa4hSTLTbv6Jjm8mRAiyNHmCvrnw==

Hi

with CONFIG_KEXEC_HANDOVER=3Dn

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)


but with CONFIG_KEXEC_HANDOVER=3Dy
the compiler runs in an error:

...
                 from kernel/kexec_handover.c:12:
kernel/kexec_handover.c: In function =E2=80=98kho_preserve_phys=E2=80=99:
kernel/kexec_handover.c:732:41: error: =E2=80=98nr_pages=E2=80=99 undeclar=
ed (first use=20
in this function); did you mean =E2=80=98dir_pages=E2=80=99?
   732 |                                         nr_pages << PAGE_SHIFT)))=
 {
       |                                         ^~~~~~~~
./include/asm-generic/bug.h:123:32: note: in definition of macro =E2=80=98=
WARN_ON=E2=80=99
   123 |         int __ret_warn_on =3D !!(condition);=20
         \
       |                                ^~~~~~~~~
kernel/kexec_handover.c:732:41: note: each undeclared identifier is=20
reported only once for each function it appears in
   732 |                                         nr_pages << PAGE_SHIFT)))=
 {
       |                                         ^~~~~~~~
./include/asm-generic/bug.h:123:32: note: in definition of macro =E2=80=98=
WARN_ON=E2=80=99
   123 |         int __ret_warn_on =3D !!(condition);=20
         \
       |                                ^~~~~~~~~
make[3]: *** [scripts/Makefile.build:287: kernel/kexec_handover.o] Error 1

...
=3D=3D=3D

I guess one of the four kho:* patches contains the bug

anyway

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

