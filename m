Received: from mail-qt1-f225.google.com (mail-qt1-f225.google.com [209.85.160.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155D32FF66A
	for <patches@lists.linux.dev>; Mon, 19 Jan 2026 11:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.225
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768820938; cv=pass; b=hh+ym3uHp56h4ImbtwNvjm8aw8XLDYupxqJrixJFQRUXA4X7JastuZ8Li/iVbF1alh6HyFj9XZ3dp0j0eziOycxgaMWk05GQTQmrzpIjviTvHH+sNKkfd1xyFYn/OlxSwnxXJKRI5uvUF2rJ7f9kbg6QZENDcXybW3naQOv7RII=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768820938; c=relaxed/simple;
	bh=QPaAipOa5Zt8QQExX1Quh94NAWxVdOTX17TgSHoNPjM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H0XFTkqFtrxPaWL+99Wb3X+HzBlCMS/kjCDndUw5KVVJMvKcCQ9nOYfHrPZr5TLXx/tYoSU1VKZ0tUxcxZYKmGPHrKSE6VTyRBb9FL5sBjErd2FrHMfHCr27iP1oKh4HzUzUVJocEiqBtFXFbHubx9VV0ozXLsuUz+4UWPXKQSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Sj98DtDt; arc=pass smtp.client-ip=209.85.160.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Sj98DtDt"
Received: by mail-qt1-f225.google.com with SMTP id d75a77b69052e-50146605f2cso8106831cf.3
        for <patches@lists.linux.dev>; Mon, 19 Jan 2026 03:08:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768820936; x=1769425736;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QPaAipOa5Zt8QQExX1Quh94NAWxVdOTX17TgSHoNPjM=;
        b=D3iWSdqRFn61Zw08K5huRn+rMGxcy4F1RQvn6NW8JA85a5BvGxIipiRBLuaG3MGM4i
         WL2F2dxTE9fpWeohBnebabZPHyoH9oNf6Wwx905HjfAgtW0ZrC8pYZVPRLOCMYDuw/Wd
         wz9h+HDtkGk3WxNd2srbZcYmtTqTgyq6JvciuWtVfy9lYJZYoXe4nsbdioR+fU6FNNhR
         SMm+yNdb3BamQ2Dya3vmD9qhTynNBiXT7v4TASNXZwhik8/iZ50TbhCbi0nZ/7A/6i4e
         +AVRBncCGNqqrnB3LmhoF55Cq6OWrRAQpovLbpZWtJI/PALem9zoE8LI/+TaK9DZILIL
         5b5Q==
X-Gm-Message-State: AOJu0Yy7cEeuEi5OMBnWLWXkFY1NN8heDhCkqiaMK7cMzRzLHX69MpiY
	5uZvimyUVcu7VyLbe+i71UsUSpCkq2wlVUBJewGNjQTuqMAAigU1Qz7IjZqRcVsNPmjiiUOAnar
	9YsmSp95bMW7bjHJLEO4c/MDNH/NW3HjN4+EoQ+sn+qw64qzWUVUbDkOvPSaMqLXSxCl4EvC0fM
	XL5FxHc/sHMw6zIJWhoI3RfNN0L28/vC/hkCs1NgQrQwwBn7MBoeeJX1e5o/sdw29hb7eBV+MME
	f4zu3RgVxdKD65a7gZOc3ReK+oCZCVN
X-Gm-Gg: AY/fxX6DbRZWclwmwY7FA4kqr2elfboEYv6YR0rQPfwSpuImjpMNmH2u0zv4cLahvr8
	KOlBDRSn08zPKodteAmsbekdd4vLEB+/VFhGEAmf0/Fu6vP7C19WPvB6xJIRl+B2JgH17iReKxD
	p/6WDoH7ajZHqMEkXyitC9Zp8GULVeJZjteqtB1EPz+Vzs4sBiZOBjkR3WYXjhfQjF1HyoHS0jX
	yTVMqWcD/DTbcf5AMpf/s6T+NMdm2WLGzPqR3pNXM9hVbkkUaoaXzf6dWbqReKQDmSVUsS86gUC
	qsGUWVmVbKy+y1zPM8NbV2ayaUUnUbAec3nlQDBVQ4mbIXIjXNabw79mzreVKsuugvWxrd3iyxR
	/44QuVZJS0Lv+C4R+kueA/Gp9H1aHUivtM6fZrgQ6kG9en6doCcyoXYxhoVbnx7EDF85r4UcqXJ
	19faVFKOg1r4FO+3SMSu45FoxX3Xdhkh1yn+yaVA4D/GK5zt61jxD/Z436VoPofAbI
X-Received: by 2002:ac8:7f56:0:b0:502:9b30:a33d with SMTP id d75a77b69052e-502a16b869emr119484921cf.11.1768820935566;
        Mon, 19 Jan 2026 03:08:55 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-118.dlp.protect.broadcom.com. [144.49.247.118])
        by smtp-relay.gmail.com with ESMTPS id d75a77b69052e-502a1f129f5sm8225371cf.9.2026.01.19.03.08.55
        for <patches@lists.linux.dev>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Jan 2026 03:08:55 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-64b9ccb80a4so367964a12.0
        for <patches@lists.linux.dev>; Mon, 19 Jan 2026 03:08:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768820934; cv=none;
        d=google.com; s=arc-20240605;
        b=bXgxBdDsEHw/TeeHqKdHdivyfdNIG/bKK++uA4ZCC9R6NQb3Nccm3yD2LMOYyHXGuC
         zRCZI+XvUNLTdCchf+/Yy7D4LmuKDPSxDZeaoM40gaX5uKQhNhPCwY9CWeWeYpKo419G
         PpFS5jmW8jLHxP437qqz+7YCcK5Io9SuZGoXEx0d1eFc9KzUw4IqP+L0uuILdN1CJA0F
         y4Pz4cQwMxzcQe3fh5vUcuHIKPnIYf8dUX7qSI/PlEGbMVZEgJq/cltIOd2r/vG3CJun
         1Wjv1mN1IBj14JH38eHvrDlAMib/CBMEG7fMaieQxQASiDLJu3FdghLrHzcDxpBWqNnh
         vcCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QPaAipOa5Zt8QQExX1Quh94NAWxVdOTX17TgSHoNPjM=;
        fh=PSGbApbzy7AMvALkEyZwT1cyFJkiYkKZy9+3BCX92jk=;
        b=XzSDEYqnV5rgl//n9XDGgpP1bCG7um8lANmMzgvJgABrzBU2gzTzzufxtnlUNfgCvC
         a33t6Wqu2R7LDbZ879mUmm4FckVVGNSP7C3WQl6YZHyuF8nqWNe/DNMe6tfMmxcOKPO0
         xCR+sS3K6+Ev5IaoWPUGkipOshVH4e+RoFrOd8zD8J9p+hn6MEgoLmXPJ8JSqXuJ+h+r
         5Mdj85g73CYgOYmxiSKtnVbgRHsgwJpQ3EaNFEYTcYQEEpYbVU6sA0SBkpe8ZMQiJtpg
         ny+MTNeDDAbnOBTgHTOouZOz2FDR26DvLWuA+dsnJ1oikCdMUu20LtpxeRSYtiCnpqjt
         Kv3g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1768820934; x=1769425734; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QPaAipOa5Zt8QQExX1Quh94NAWxVdOTX17TgSHoNPjM=;
        b=Sj98DtDtdDMMRCgRMWSAhwU/YFRJLyMc/fUL7aFVRrhcuZjs79pQqcGF1rhXcCPxv4
         DltNNtLhFs/S5FVX5J1GNuP1s71lV/XX6gWd/LfUjFRPejWObNhPpJnJX2Zl41M+Uk4+
         yc2qdWUM6o8eLFCuVrFe5N2dc2TC2H43J4w48=
X-Received: by 2002:a05:6402:3487:b0:64d:1bbf:9548 with SMTP id 4fb4d7f45d1cf-65452cd78f9mr4762040a12.6.1768820933924;
        Mon, 19 Jan 2026 03:08:53 -0800 (PST)
X-Received: by 2002:a05:6402:3487:b0:64d:1bbf:9548 with SMTP id
 4fb4d7f45d1cf-65452cd78f9mr4762017a12.6.1768820933433; Mon, 19 Jan 2026
 03:08:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260115164230.864985076@linuxfoundation.org> <20260115164246.242565555@linuxfoundation.org>
 <4ca8d0770343eae44e19854cf197c76017a7c1ad.camel@decadent.org.uk>
 <CAM8uoQ-F++6iScZBzntmF=KhHRK3=rQvc-oug3KAXPddJPqR-Q@mail.gmail.com>
 <CAM8uoQ_7HD0AtJLqXsRvO=F2knq=BtrdTM2Fv0Dd4h-4oYebNw@mail.gmail.com> <2026011944-wielder-ignition-dee8@gregkh>
In-Reply-To: <2026011944-wielder-ignition-dee8@gregkh>
From: Keerthana Kalyanasundaram <keerthana.kalyanasundaram@broadcom.com>
Date: Mon, 19 Jan 2026 16:38:41 +0530
X-Gm-Features: AZwV_Qg_OXVHwp91a5NRCTbyCx0gv0COFYIkUpPvLFHJiwcfd3eoFI8A0tqxL2o
Message-ID: <CAM8uoQ-NyJQatRYXty2XdiTjsuO6hRmEam_YaNrBbgEUuK6KQA@mail.gmail.com>
Subject: Re: [PATCH 5.10 423/451] tls: Use __sk_dst_get() and dst_dev_rcu() in get_netdev_for_sock().
To: Greg KH <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@google.com>, 
	Eric Dumazet <edumazet@google.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>, 
	Ben Hutchings <ben@decadent.org.uk>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000754f710648bbb7b2"

--000000000000754f710648bbb7b2
Content-Type: multipart/alternative; boundary="00000000000068bedf0648bbb72b"

--00000000000068bedf0648bbb72b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 19, 2026 at 3:36=E2=80=AFPM Greg KH <gregkh@linuxfoundation.org=
> wrote:

> On Mon, Jan 19, 2026 at 03:09:32PM +0530, Keerthana Kalyanasundaram wrote=
:
> > Hi Greg,
> >
> > I have backported the two additional patches required for the 5.10.y tr=
ee
> > and submitted a v2 series. You can find the updated patches here:
> >
> https://lore.kernel.org/stable/20260119092602.1414468-1-keerthana.kalyana=
sundaram@broadcom.com/T/#t
> >
> >
> > Could you please consume these in the next version, or alternatively, a=
dd
> > the two missed patches (commit IDs 5b998545 and 719a402cf) to the curre=
nt
> > queue?
>
> I've dropped them all from the 5.10.y tree now, and from the 5.15.y
> tree. Can you also resend that series?
>

Hi Greg,

The other two commits are already part of the stable 5.15.y tree, so
changes are only needed for the 5.10.y tree.

Please check my latest v2 patchset : (
https://lore.kernel.org/stable/20260119092602.1414468-1-keerthana.kalyanasu=
ndaram@broadcom.com/T/#t
)

Thanks,
Keerthana K

>
> thanks,
>
> greg k-h
>

--00000000000068bedf0648bbb72b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div><br clear=3D"all"></div><div><div di=
r=3D"ltr" class=3D"gmail_signature"><div dir=3D"ltr"><div><br></div></div><=
/div></div></div><div class=3D"gmail_quote gmail_quote_container"><div dir=
=3D"ltr" class=3D"gmail_attr">On Mon, Jan 19, 2026 at 3:36=E2=80=AFPM Greg =
KH &lt;<a href=3D"mailto:gregkh@linuxfoundation.org">gregkh@linuxfoundation=
.org</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1=
ex">On Mon, Jan 19, 2026 at 03:09:32PM +0530, Keerthana Kalyanasundaram wro=
te:<br>
&gt; Hi Greg,<br>
&gt; <br>
&gt; I have backported the two additional patches required for the 5.10.y t=
ree<br>
&gt; and submitted a v2 series. You can find the updated patches here:<br>
&gt; <a href=3D"https://lore.kernel.org/stable/20260119092602.1414468-1-kee=
rthana.kalyanasundaram@broadcom.com/T/#t" rel=3D"noreferrer" target=3D"_bla=
nk">https://lore.kernel.org/stable/20260119092602.1414468-1-keerthana.kalya=
nasundaram@broadcom.com/T/#t</a><br>
&gt; <br>
&gt; <br>
&gt; Could you please consume these in the next version, or alternatively, =
add<br>
&gt; the two missed patches (commit IDs 5b998545 and 719a402cf) to the curr=
ent<br>
&gt; queue?<br>
<br>
I&#39;ve dropped them all from the 5.10.y tree now, and from the 5.15.y<br>
tree. Can you also resend that series?<br></blockquote><div style=3D"font-f=
amily:verdana,sans-serif"><br></div><div style=3D"font-family:verdana,sans-=
serif">Hi Greg,</div><div style=3D"font-family:verdana,sans-serif"><br></di=
v><div style=3D"font-family:verdana,sans-serif">The other two commits are a=
lready part of the stable 5.15.y tree, so changes are only needed for the 5=
.10.y tree.</div><div style=3D"font-family:verdana,sans-serif"><br></div><d=
iv style=3D"font-family:verdana,sans-serif"><span class=3D"gmail_default"><=
/span>P<span class=3D"gmail_default">lease check my latest v2 patchset=C2=
=A0</span>: (<a href=3D"https://lore.kernel.org/stable/20260119092602.14144=
68-1-keerthana.kalyanasundaram@broadcom.com/T/#t">https://lore.kernel.org/s=
table/20260119092602.1414468-1-keerthana.kalyanasundaram@broadcom.com/T/#t<=
/a>)</div><div style=3D"font-family:verdana,sans-serif"><br></div><div styl=
e=3D"font-family:verdana,sans-serif">Thanks,</div><div><span style=3D"font-=
family:verdana,sans-serif">Keerthana K</span>=C2=A0</div><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rg=
b(204,204,204);padding-left:1ex">
<br>
thanks,<br>
<br>
greg k-h<br>
</blockquote></div></div>

--00000000000068bedf0648bbb72b--

--000000000000754f710648bbb7b2
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
i36nH2SuVm4wDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIPnYdv5C/1IrBW9wQiAC
sCLGU8GR8wEVcGG8RKS4E+ECMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTI2MDExOTExMDg1NFowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0G
CSqGSIb3DQEBAQUABIIBALApfGcA9xEv0g9BHb8KWahIeMs6j7OJKnpKX2cDsCsVE3NYhjQ3nsgg
jf7Wdx0m+XXSoAZuSbv7iZTMyQMgRasBMpvaaSeCk3MrFTbdkFIcOW2dNBMg09PpyA4fg5pRHOxk
HBAvNsGQ4RogmtWiH0LdqXk5EFIZ93lerO42cNMWpYBcQMhVQorFC1La59OErOFlaUQ4qRq81Fyw
Q2qMZuPc96mrG4PdfStQDLGXj+Vh82JoQCCeC5y1nfCsoEPOPRSuAdRUwAe+2y0nyFwtMeIC4IrI
XoVZj1PV2Mm+Jl+wd/fKH2g0eFK1gBQ6KOeP/7cYtSB44V8YLW1RDP5tweE=
--000000000000754f710648bbb7b2--
