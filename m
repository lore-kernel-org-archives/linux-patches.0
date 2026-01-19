Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03091CAA6C
	for <patches@lists.linux.dev>; Mon, 19 Jan 2026 05:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.226
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768798891; cv=pass; b=Sl/i4uksJIXSL8GH0OG25rNRB/MGh5cnNsyG0VonYwuhpKZX1IFcv1yrqYgrE5HCX8CbRj3x135wVZbJMOMLyEEXL7aRUARRft798dcpQJO/m+cR1ezTj3RCWBBWkwi88lXGhbgr/evWqnDkwdqlKYUbP4VJu4003GDzZb47TJM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768798891; c=relaxed/simple;
	bh=TZNNhqKNqBYDbfZl4+nRs4X3rsiXhOhwLeux9A0MzNY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L1hb1PL2+dLHhaU15LR+m/SLxQn5560+2WmS7WUvFbVrFY2/u0Tvk+YgTdc3VUpkabdxC20ZjsxCXs6gzJ6FCtzUrLXvU5Iu2ItyhXh1b+rHucRx6z/LyR9wsCZptBMPMuHA7rOW3XwuccIoG5c/27edqgWctHFBt9xS9vtLARI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=g8BCgqaZ; arc=pass smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="g8BCgqaZ"
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-29f2d829667so10022115ad.0
        for <patches@lists.linux.dev>; Sun, 18 Jan 2026 21:01:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768798889; x=1769403689;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+KZ74f/sqoiGU5ok8nbRbU/Gngw20nEvTkzOJvQQC/g=;
        b=IF+v9vxgRst5JIf8g3jTDi9C2GamZzC9eZGUB5nVtvr3ytjdr8HEU9QLMwjmI3CRbG
         h/+J/wlq08HEG7AWJOQlN2XXAzwR1tEHav93unMBrdBtoZfcmEq8KhlHnrWazO0KwA0R
         /Ig0QhmQvSBDtAxaLB+iIGv34YpPxe7y8N2r+YTZ2e+Gqsdp2LFlFDZqyI2HBGZa1+eR
         AVyL+WcCScGVRtiByrh2D26R131GD/sJSHF+pdtmBnyDvEY0jPXZIAtbYwqsVkQl0FRP
         okat4C52O1vYf32xPGRqlM+/E+hRXr3dKvlLAxz/Zi+QeE5Ve2PMkFoKew3cFpTGPODC
         RcCA==
X-Gm-Message-State: AOJu0Yzfjvh+O1LUZUtEIzZWlAxfJcxYleezedA2+Vj6lTAlXE+gLCBC
	tOIXQJFwtwLoFCfWkYt6fs7r6vSzgsR2MX8k27wxeJKhrbomC+rf+OHk+tc5pMDsJHdjYo+yS8+
	8jvZ/W+ud4u1HA+pKh0YP42Ehp9BqwGf5rsEmeICO1SAMxTT4h4cogxfZntHRdCodPjknuu3LTW
	9iJh9ZFs0teqqBbg7LLUUNs7EzsMk4lcyWV2D0v4dsV0+WRxq/zxs9xhjyyK90finpWrb3vNgAG
	0N6+k13zynfSsI8SJbSjt/W3Ins+A==
X-Gm-Gg: AZuq6aLziAoRRWGIpHSXGYQcwVhXfvmiX39VTiFU2EQ+TROvwJkWm6YMK5IoW74d9KZ
	H4Ui5/wjfgfpX468uvGx9IW0JBNh7dEXfv2i7561s3p2yN3Vo+HSUAx/g4ZvGNAyXayT1L+lluZ
	2PJlWxEgmkeLw5R6TbQF6hVqU2qLiMiDHLTuY/vWoHJCSM8SZlBQ4n2l2f/BqR9vBwu4lNVSkFc
	6L8SbtUXk3eNofeqWhE2qEnWIECHWAk1Bh7AWVL6C48Sc4MZriYFS1khsoFbYQAuNHN2YIqFF/8
	oNwATnFkghwaWh8hYQxFrxiA8ZY0pgDBIyVHPqg8Bvlizql3/TGajPBzC6Ee3Fl6x4U+95NIo7e
	e+whYLTQRINGfzsnPl/2oqywWwi/iGM/M+eSPIkfE53Ib1pEhfRaAY3F1fHIvjnU9RjU3gyOdU2
	V4d22oiKsBEw3IGymPEfIWz/yocGuRXnk3X9meVAiY/aQOcNeQ9x6v/JR+WcE=
X-Received: by 2002:a17:903:32ca:b0:2a0:990e:effd with SMTP id d9443c01a7336-2a7175c65bbmr74124715ad.7.1768798888681;
        Sun, 18 Jan 2026 21:01:28 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-2.dlp.protect.broadcom.com. [144.49.247.2])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2a71939c0aesm13809965ad.53.2026.01.18.21.01.28
        for <patches@lists.linux.dev>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Jan 2026 21:01:28 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-64b8f91e4ecso261603a12.2
        for <patches@lists.linux.dev>; Sun, 18 Jan 2026 21:01:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768798886; cv=none;
        d=google.com; s=arc-20240605;
        b=LDvjkHthHBMkyoJfd/UfNznvrWcps6ECpROMBZREYUIlrw3aoYKxouR5brNXpMLgOy
         UymRQIhMpbJEYsKScHskPJucoQtVGNbd06x1ayBKEh1rXH5QoTNPkwFmNYweRSS7Mwtg
         VyPXEnScBAYhfeeFglvt26thH8fifICLPgBkm3QRshYkKHPP8yetaYl195vU1xEIyU9Z
         B6XezE4jPMkKEdZKYIVNArKn3++mtrMeoCt8rmVK4i94nKQzMbKp6JwaYVqnjW4OH1TM
         IplmM7BMLNMxeqN6AwOgWsw0hKpafYFn4w4pRo/25E6Tc2KCVIMBzJWmMh+raoHlfzuJ
         0wvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+KZ74f/sqoiGU5ok8nbRbU/Gngw20nEvTkzOJvQQC/g=;
        fh=DuQHeVnKYiMAk4SuKiHlR8/FlskJWKc5a3I0TJdq8Ow=;
        b=U/JAd8cUciluSioxpF2nT0s+STZDtg9awPlWQOqQcyUMCOaDLoXW4QfO+Q4+Xt6Jla
         TndRUY7mK+AltCmomL12OOrcz2oIO6m+gTSPojg5Ii8nDCAIYPA+nA3kHcIxxR2n2kzt
         n0z953TrSZnrHxASKzYxT8U6lz/vQgZ3bUzyu4tas7ThvABpTvmKOn4VAa7dARKO9SHk
         aydAAyK1MCbhF4KrwMC0sQJO224+eUPILW/88QADH7g0PrlO7oXwwFfE/UVxSXZl4avL
         SLtB+cm/b2Zh5mtIS57tjDG8yoTPiVDj5YdzZsg6gODASdRmkoZxEndWlqbXMDcr/oSu
         ZYQg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1768798886; x=1769403686; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+KZ74f/sqoiGU5ok8nbRbU/Gngw20nEvTkzOJvQQC/g=;
        b=g8BCgqaZaL3HIo3rAi901U27HCFk687zLLpth2HBNpnGgL+Jcd2H6kYsv4+vXCqP83
         McmRlVTd8sScXutdYC7XUrP16DjsM/xF8z9ciTPgyD2PS76Axn+NqtNFF79dSUcgk+EV
         tLB7qE1NGfq49KMliBZwa1xMTa0YMFc0ESg/M=
X-Received: by 2002:a05:6402:518e:b0:649:9aff:9f42 with SMTP id 4fb4d7f45d1cf-654517f1219mr4344233a12.0.1768798886572;
        Sun, 18 Jan 2026 21:01:26 -0800 (PST)
X-Received: by 2002:a05:6402:518e:b0:649:9aff:9f42 with SMTP id
 4fb4d7f45d1cf-654517f1219mr4344221a12.0.1768798886158; Sun, 18 Jan 2026
 21:01:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260115164230.864985076@linuxfoundation.org> <20260115164246.242565555@linuxfoundation.org>
 <4ca8d0770343eae44e19854cf197c76017a7c1ad.camel@decadent.org.uk>
In-Reply-To: <4ca8d0770343eae44e19854cf197c76017a7c1ad.camel@decadent.org.uk>
From: Keerthana Kalyanasundaram <keerthana.kalyanasundaram@broadcom.com>
Date: Mon, 19 Jan 2026 10:31:13 +0530
X-Gm-Features: AZwV_QiApkccmQyjOoV_3uoxeF5xaTy1NNkIlgGxsoFZVM8_b-lHMLc52omJ_ds
Message-ID: <CAM8uoQ-F++6iScZBzntmF=KhHRK3=rQvc-oug3KAXPddJPqR-Q@mail.gmail.com>
Subject: Re: [PATCH 5.10 423/451] tls: Use __sk_dst_get() and dst_dev_rcu() in get_netdev_for_sock().
To: Ben Hutchings <ben@decadent.org.uk>
Cc: patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@google.com>, 
	Eric Dumazet <edumazet@google.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable <stable@vger.kernel.org>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000054e5f70648b69518"

--00000000000054e5f70648b69518
Content-Type: multipart/alternative; boundary="0000000000004a51940648b69503"

--0000000000004a51940648b69503
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 19, 2026 at 5:03=E2=80=AFAM Ben Hutchings <ben@decadent.org.uk>=
 wrote:

> On Thu, 2026-01-15 at 17:50 +0100, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me
> know.
> >
> > ------------------
> >
> > From: Kuniyuki Iwashima <kuniyu@google.com>
> >
> > [ Upstream commit c65f27b9c3be2269918e1cbad6d8884741f835c5 ]
> >
> > get_netdev_for_sock() is called during setsockopt(),
> > so not under RCU.
> >
> > Using sk_dst_get(sk)->dev could trigger UAF.
> >
> > Let's use __sk_dst_get() and dst_dev_rcu().
> >
> > Note that the only ->ndo_sk_get_lower_dev() user is
> > bond_sk_get_lower_dev(), which uses RCU.
> [...]
>
> So should 5.10 also have a backport of commit 007feb87fb15
> ("net/bonding: Implement ndo_sk_get_lower_dev")?  Or is the use of
> netdev_sk_get_lowest_dev() here not actually that important?
>
> It seems kind of wrong to add the netdev operation and a caller for it,
> but no implementation.
>
>
Hi Ben,
Thank you for catching this issue.
I agree that we should also add commit 007feb87fb15 ("net/bonding:
Implement ndo_sk_get_lower_dev") to the 5.10.y tree to ensure the
implementation is complete. I will send an updated patch soon.
- Keerthana

Ben.
>
>
> --
> Ben Hutchings
> Power corrupts.  Absolute power is kind of neat. - John Lehman
>

--0000000000004a51940648b69503
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div><br></div></div><div class=3D"gmail_=
quote gmail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Mon, =
Jan 19, 2026 at 5:03=E2=80=AFAM Ben Hutchings &lt;<a href=3D"mailto:ben@dec=
adent.org.uk">ben@decadent.org.uk</a>&gt; wrote:<br></div><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rg=
b(204,204,204);padding-left:1ex">On Thu, 2026-01-15 at 17:50 +0100, Greg Kr=
oah-Hartman wrote:<br>
&gt; 5.10-stable review patch.=C2=A0 If anyone has any objections, please l=
et me know.<br>
&gt; <br>
&gt; ------------------<br>
&gt; <br>
&gt; From: Kuniyuki Iwashima &lt;<a href=3D"mailto:kuniyu@google.com" targe=
t=3D"_blank">kuniyu@google.com</a>&gt;<br>
&gt; <br>
&gt; [ Upstream commit c65f27b9c3be2269918e1cbad6d8884741f835c5 ]<br>
&gt; <br>
&gt; get_netdev_for_sock() is called during setsockopt(),<br>
&gt; so not under RCU.<br>
&gt; <br>
&gt; Using sk_dst_get(sk)-&gt;dev could trigger UAF.<br>
&gt; <br>
&gt; Let&#39;s use __sk_dst_get() and dst_dev_rcu().<br>
&gt; <br>
&gt; Note that the only -&gt;ndo_sk_get_lower_dev() user is<br>
&gt; bond_sk_get_lower_dev(), which uses RCU.<br>
[...]<br>
<br>
So should 5.10 also have a backport of commit 007feb87fb15<br>
(&quot;net/bonding: Implement ndo_sk_get_lower_dev&quot;)?=C2=A0 Or is the =
use of<br>
netdev_sk_get_lowest_dev() here not actually that important?<br>
<br>
It seems kind of wrong to add the netdev operation and a caller for it,<br>
but no implementation.<br>
<br></blockquote><div><span class=3D"gmail_default" style=3D"font-family:ve=
rdana,sans-serif"><br></span></div><div><span class=3D"gmail_default" style=
=3D"font-family:verdana,sans-serif">Hi Ben,</span></div><div style=3D"color=
:rgb(31,31,31);font-family:Roboto,Helvetica,Arial,sans-serif;font-size:14px=
;letter-spacing:0.2px">Thank you for catching this issue.</div><div style=
=3D"color:rgb(31,31,31);font-family:Roboto,Helvetica,Arial,sans-serif;font-=
size:14px;letter-spacing:0.2px"><span style=3D"letter-spacing:0.2px">I agre=
e that we should also add commit 007feb87fb15 (&quot;net/bonding: Implement=
 ndo_sk_get_lower_dev&quot;) to the 5.10.y tree to ensure the implementatio=
n is complete.</span><span style=3D"font-family:Arial,Helvetica,sans-serif;=
font-size:small;letter-spacing:normal;color:rgb(34,34,34)">=C2=A0<span clas=
s=3D"gmail_default" style=3D"font-family:verdana,sans-serif">I will send an=
 updated patch soon.</span></span></div><div style=3D"color:rgb(31,31,31);f=
ont-family:Roboto,Helvetica,Arial,sans-serif;font-size:14px;letter-spacing:=
0.2px"><span style=3D"font-family:Arial,Helvetica,sans-serif;font-size:smal=
l;letter-spacing:normal;color:rgb(34,34,34)">-<span class=3D"gmail_default"=
 style=3D"font-family:verdana,sans-serif"> Keerthana</span></span></div><di=
v style=3D"color:rgb(31,31,31);font-family:Roboto,Helvetica,Arial,sans-seri=
f;font-size:14px;letter-spacing:0.2px"><span style=3D"font-family:Arial,Hel=
vetica,sans-serif;font-size:small;letter-spacing:normal;color:rgb(34,34,34)=
"><span class=3D"gmail_default" style=3D"font-family:verdana,sans-serif"><b=
r></span></span></div><blockquote class=3D"gmail_quote" style=3D"margin:0px=
 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
Ben.<br>
<br>
<br>
-- <br>
Ben Hutchings<br>
Power corrupts.=C2=A0 Absolute power is kind of neat. - John Lehman<br>
</blockquote></div></div>

--0000000000004a51940648b69503--

--00000000000054e5f70648b69518
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
tJVewHuOmXgWQxNWV7Oiszu1d9xAcqyj65s1PrEIIaHnxEM3eTK+teecLEy8QymZjjDTrCHg4x36
2AczdlQAIiq5TSAucGja5VP8g1zTnfL/RAxEZvLS471GABptArolXY2hMVHdVEYcTduZlu8aHARc
phXveOB5/l3bPqpMVf2aFalv4ab733Aw6cPuQkbtwpMFifp9Y3s/0HGBfADomK4OeDTDJfuvCp8g
a907E48SjOJBGkh6c6B3ace2XH+CyB7+WBsoK6hsrV5twAXSe7frgP4lN/4Cm2isQl3D7vXM3PBQ
ddI2aZzmewTfbgZptt4KCUhZh+t7FGB6ZKppQ++Rx0zsGN1s71MtjJnhXvJyPs9UyL1n7KQPTEX/
07kwIwdMjxC/hpbZmVq0mVccpMy7FYlTuiwFD+TEnhmxGDTVTJ267fcfrySVBHioA7vugeXaX3yL
SqGQdCWnsz5LyCxWvcfI7zjiXJLwefechLp0LWEBIH5+0fJPB1lfiy1DUutGDJTh9WZHeXfVVFsf
rSQ3y0VaTqBESMjYsJnFFYQJ9tZJScBluOYacW6gqPGC6EU+bNYC1wpngwVayaQQMIIGhTCCBG2g
AwIBAgIMD+aKIot+px9krlZuMA0GCSqGSIb3DQEBCwUAMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
ExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIEdDQyBSNiBTTUlNRSBDQSAy
MDIzMB4XDTI0MTEyODA2NDkyM1oXDTI2MTEyOTA2NDkyM1owgcMxCzAJBgNVBAYTAlVTMRMwEQYD
VQQIEwpDYWxpZm9ybmlhMREwDwYDVQQHEwhTYW4gSm9zZTEZMBcGA1UEYRMQTlRSVVMrREUtNjYx
MDExNzEWMBQGA1UEChMNQlJPQURDT00gSU5DLjEiMCAGA1UEAxMZS2VlcnRoYW5hIEthbHlhbmFz
dW5kYXJhbTE1MDMGCSqGSIb3DQEJARYma2VlcnRoYW5hLmthbHlhbmFzdW5kYXJhbUBicm9hZGNv
bS5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCzJUx8cxWWLKOtWyrWjmxtNemY
IAZzJtBCZUu44YcV0VWRTEyy7ETgVKv+gsS31DMOAW6riOQk4Kq1NwaqGpWcNeN4lDbjYNgdsVd+
o9k4EYujmMl0cgM7K7hzNddW+Ay96MU9XKfPz2sgaaEg+yf7Lc4qEJAHoeB0ZjdbljIIRWD7Y/NA
zvboOGCqVTtK/MDNUbO3DM22mnISOsFdyh2D45TWDZTwu4xaGvcSWxLWmvKT/F8eOAs9WQstDJfq
Tmu6blTu87+GvJDl7ve1uoTZ2v8iJJgVmw4FHt60UKs2YygdJ0VyVdlGaqP2t1tRmfUlu7CGVl1p
CsZtHLW+HDLdAgMBAAGjggHnMIIB4zAOBgNVHQ8BAf8EBAMCBaAwgZMGCCsGAQUFBwEBBIGGMIGD
MEYGCCsGAQUFBzAChjpodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc2djY3I2
c21pbWVjYTIwMjMuY3J0MDkGCCsGAQUFBzABhi1odHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9n
c2djY3I2c21pbWVjYTIwMjMwZQYDVR0gBF4wXDAJBgdngQwBBQMBMAsGCSsGAQQBoDIBKDBCBgor
BgEEAaAyCgMCMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9z
aXRvcnkvMAkGA1UdEwQCMAAwQQYDVR0fBDowODA2oDSgMoYwaHR0cDovL2NybC5nbG9iYWxzaWdu
LmNvbS9nc2djY3I2c21pbWVjYTIwMjMuY3JsMDEGA1UdEQQqMCiBJmtlZXJ0aGFuYS5rYWx5YW5h
c3VuZGFyYW1AYnJvYWRjb20uY29tMBMGA1UdJQQMMAoGCCsGAQUFBwMEMB8GA1UdIwQYMBaAFAAp
Np5ceroPry1QLdugI4UYsKCSMB0GA1UdDgQWBBQHh8+7satHOJPcYL7AeQdvH3LpMDANBgkqhkiG
9w0BAQsFAAOCAgEAYWBk58l2FyT07DXkrrA2hlcTBcEZihWQx8/9g29moMSrBsNjKgfWEAXXBONl
VItnKxTO0LLFBDk0aORtQ77l8a5shNEChWVYr6HaQ4+yEzwgzGmYro7sX9H0WNhPYqGxkaOhvirw
pVpXqJuPEzKRu/cGLsd/0yta4ifC8tbv2NS+/0xF92mVwwFk/drV6gzbXet3UR0Oc4E8X6cuqker
//F6sqQvY8JqD4mfN+FYlRsJMJbaotK+vEh80P3H+DiIl5yMKVsV+IDp7lNqqEr8vp6x1Sd5+kqm
iw/P5dRLJ1fqzim8rqtJ/7qy6A7f9XW26mrfXgopzpH+PpyOWTNn+1WHE3Qsf56FygZkoyRkyNeg
LDRtQlfPVV4VzF2T4Isd4+38Ec+rpHUjh92yzjrf7FL1NWhk9Q7IEFNhX6Ss1VY+qawoyAwq3PCX
N38TFnsqQc+ulwWwKrr/UAidp1h/nDizvfesRK5Iy/qJ+ey9WDm2cuRgn9EKPN4hqc1KVeLWhMS5
2Q76mvXu00vebvmkm8gEOUWX/f/7sJ9OiTxEUFA914opWhBW681OZe8N3qTdG0WpE+Dwuz0tXpzB
QjeGoKexgsMfSRTmaxQT/YnlZiJPM3qfsvSl3wUoJ+GrMGtrszD3Ehg1jbcHkUM/n2fmYA4m1ObI
fGQEpn8e5I0CKl4xggJXMIICUwIBATBiMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
aWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIEdDQyBSNiBTTUlNRSBDQSAyMDIzAgwP5ooi
i36nH2SuVm4wDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIGGRwwi6vX0SssTMKfig
pp9/IMf1H4d5Wp2MG01hOzzWMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTI2MDExOTA1MDEyNlowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0G
CSqGSIb3DQEBAQUABIIBACXsudB63qPNwvU6GZ/l9nhMDEkYfbP9AcHwhqNEL2wCdlrwt7HB7d2M
sOg3KelanINuq6et59SYCMA8jTcqet6YUatZiTXPDGDB6VVrM0aEiMmmJWxAXBDrKTFBqlIfgEzu
sjj7WYMi9R8R3iWtcVEC2NE32xDM73MHv6tbx6TY9wZx8NxX3sY5XGqeAyKe4nrVCB4d+6NcIDNo
k2lB1OA3oglNLMcZA1qmvba/AJadxpOWON7AUpEHJf7y89gpKJQI4XDGimtoZmiwdC+/8eNVb+3C
SU9y73WB+WPsVqK+QDvJS8zE3K0hduahmGdwHMgtVab+iq2Q3c1/uJ8ALRs=
--00000000000054e5f70648b69518--
