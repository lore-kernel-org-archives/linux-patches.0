Received: from mail-pf1-f226.google.com (mail-pf1-f226.google.com [209.85.210.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF323502BF
	for <patches@lists.linux.dev>; Mon, 19 Jan 2026 09:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.226
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768815590; cv=pass; b=MpV+V5Exzm1KEun4nMwHgn9mWM/fQ8ssA8lsdwXGj1BSBStAOdQwnz2xbe0EgXkmsbyLmFbtduDOUP8Y6hblGDy+2eXLdTzst5Wj8MK6HXvcAuDTrGT3FUbdtIGDgCgWy5vLX3agD7NoyIZjyjOdy+YEr/DjHVmrwBLFZ9GzvHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768815590; c=relaxed/simple;
	bh=kHjv6sX7sc1e3kdfkfM2/rF/1iUamjVZhSe9iP0DTSQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L/iiGZMju3p4KpjSOzi3SCeoeKhzjm57aGzKekUZlCJ0PyQ6S3E4XUnfsMbwgkVEH60I9frtl7bDlSEmeNhImr4Oixdztr317s6/lD0EDdlB0ggf/Bu3UuU/bnOR276Fd7pQi22FVUEiBtwYZ/pnl/+PYd2oVbRXbnMABKny5Y8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=BjzhGwUA; arc=pass smtp.client-ip=209.85.210.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BjzhGwUA"
Received: by mail-pf1-f226.google.com with SMTP id d2e1a72fcca58-81f391aeedbso83061b3a.0
        for <patches@lists.linux.dev>; Mon, 19 Jan 2026 01:39:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768815588; x=1769420388;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OplOUm8AczbNqLb8yKyAxVJQ4H/L7Y72+n700Fo/wz4=;
        b=SPtA6yHzX1cLKlm7+2eOj++9ns3oeKL4+3HUCFGpBYX0Z4NF7lPednAptexvj+ViBY
         E43MaDiDjHPpLqfvjKT3wyF4ggcS3uYSqfaEZov9v2Yf1ueHqU6UtIT3p3p5n3drNS5K
         z3xh10e73HdOLSHtk1xLCycdrIjM9O1bF3T/wYZvphdjiVsx/UBt5k3nwu1MRPo41Bff
         1I0WB6WVgScdmglwZ/yAgv13U1BnkbI36mhI8ZF4iVXihoR7tn/YDudm/jT7jjN/NP0q
         0eiLwQO9tqar6qZUjD0RgGlNtcggHyT9Qu5s5SKGyKNu1Wzowm+U5HN8pPQAXp+gVo8H
         fSyQ==
X-Gm-Message-State: AOJu0YxZJZ4U/sG2VJ73eCJ1WyVXepOkTabHWEZ6HB8xP75q8wI63wrY
	A8j1jjFf+wcLSD0mgfOl4NtCc6Vg3qVR75T0UtMYA4uZpVvHBQETMPM8wZO6EWWl4y/tzmcKfUp
	eLWPiZQOTbV9ANZ96iCE3++xXk0EcwQvBDPaSz+AIt7+5ENbgNOdpqq9b9CKiUd/zD0PWq7jztx
	d5257Nc1hAlDygK4/tfVfvvbl30uhYoxdTLGPQ6NZAkkK2UZej1cAaSGpvR7L8gBvw15Lqo6Jq1
	vTauW9c6zN/tVnfBfGUcE768YnfQ7Cd
X-Gm-Gg: AY/fxX6h1eOBX6oJj7wXAX9uEyFyxg1qacPkKAXmLESdODnebJWKwpNxFWFuMHo7H/Y
	L1C7TSj+BNLgRxWgB6L8ZKje39MZbHF15xZoXAqK9uZ2raRN+zLjoLNOUhRLXoIrGGQxa1c1A5P
	BeFoVda0GWFGgpTq+JGQPolobEYtIWoYW3YP4GLSU/LNSEcHoff+qGwAMW7ShQWgKN8SNkPrjgE
	8Yk62MBG+FRBgtjGE2qV0qoyQ4IPHHHM3izcWsi8e6fwjvZZjzOV0hLg36EOqgTm3WJATiP9Hw7
	EirsOfzbHfLQ8gl0FMQdsJ8gMHfRVjKlxrPdcANNxAPGoTCfrpo4EXl8lGecKSC/wNp8qdi1zmu
	cVQeurDCc7efqPLBCCGxh4a1ci6IKP7ASL7zh3cVo0AfFQ3bYyXfyDTIT6zUiY16Mi77EQ+7JYu
	ATRTLrtCojUEIcxOrR8Of/1bC8zowAl/xLXIMogBhL7tMJ0mi9AsuSLM7bGEi1a38U
X-Received: by 2002:a05:6a00:391c:b0:81e:fd4c:fb39 with SMTP id d2e1a72fcca58-81fa0357db7mr6237843b3a.4.1768815587539;
        Mon, 19 Jan 2026 01:39:47 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-118.dlp.protect.broadcom.com. [144.49.247.118])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-81fa125d153sm1008675b3a.6.2026.01.19.01.39.47
        for <patches@lists.linux.dev>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Jan 2026 01:39:47 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-64b9289a120so336971a12.0
        for <patches@lists.linux.dev>; Mon, 19 Jan 2026 01:39:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768815585; cv=none;
        d=google.com; s=arc-20240605;
        b=JiY3zWqtv5akras+RixQvbR1eF4R+MvskaWNa/1AcMMJdMXf+t7ONbgi7UZ0QOMeEA
         tj+cfOuPsZuEhP7k76OJqrhsH7Fcrs5VWA5UmDMnQ52B4L7lxQERzT38qMTgh+ZHrP+W
         AHNub6ZmReHnM1rOukj190+SDC8gg4ZJYBx+bAChwXctSgJHgd8kTKtl1LQ7/Ka3844l
         8KRolrSpApMQVLOL3GmNgElkOUXqgPaQyg5VLL/g4YY1fcpFFU0EitgnViMtN7fi7dhz
         2ray7Pl8M9IOjf7IDD54QnlhsgYhXmfA2YN/edLhdjGprD2hJVsA0p4kJoYVaBxA6i9M
         U43g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=OplOUm8AczbNqLb8yKyAxVJQ4H/L7Y72+n700Fo/wz4=;
        fh=PSGbApbzy7AMvALkEyZwT1cyFJkiYkKZy9+3BCX92jk=;
        b=QOC8UMdGS4Pz8vkOSBk2QWFVWXbPdwyzUJYowtDLla3PUlBGXGy2XyFpqc9cVh5FVK
         8rbmxEniXjGr50HZCxkGGteEdLbUe7ixqSFsuLheadUcHwxMM/7jxjBobUZs7zzQ7ph5
         eQjqllER1I+DN0M3oCa/DulYCwAVbwUsXlVgoGwHYu+to//S3J3cOj730IFbR3eTHsze
         wIq3WjMxrM3QxJV0yOKx1nEJej/s34OREnbr1UAbyq4HABmrsVPRHwO17/7clvo0TaCc
         Az+HIEBYpZm3s6CVAkA8bXkus11AIOjJG4FXolp26/VMC3ogBey3wGV6oOR8X1HcIbnB
         ur4w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1768815585; x=1769420385; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OplOUm8AczbNqLb8yKyAxVJQ4H/L7Y72+n700Fo/wz4=;
        b=BjzhGwUAPlZybA1RD37saVZkX+6H5YSkDea4UOqN3Lla3XX1+B9c7oRyDZmgdtsAQf
         H0n7rhDnDWJpIMG7eEmhCzKRR3tDHkfhW85XCoIdWVXZMVRE59RbteEhMLUpuahcmU0I
         RfJjL0FqsfQCQsCiwIg7PqybuQoINGCnbbqmU=
X-Received: by 2002:a05:6402:2342:b0:64b:a1e6:8013 with SMTP id 4fb4d7f45d1cf-65452ad28edmr4466293a12.6.1768815585199;
        Mon, 19 Jan 2026 01:39:45 -0800 (PST)
X-Received: by 2002:a05:6402:2342:b0:64b:a1e6:8013 with SMTP id
 4fb4d7f45d1cf-65452ad28edmr4466286a12.6.1768815584678; Mon, 19 Jan 2026
 01:39:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260115164230.864985076@linuxfoundation.org> <20260115164246.242565555@linuxfoundation.org>
 <4ca8d0770343eae44e19854cf197c76017a7c1ad.camel@decadent.org.uk> <CAM8uoQ-F++6iScZBzntmF=KhHRK3=rQvc-oug3KAXPddJPqR-Q@mail.gmail.com>
In-Reply-To: <CAM8uoQ-F++6iScZBzntmF=KhHRK3=rQvc-oug3KAXPddJPqR-Q@mail.gmail.com>
From: Keerthana Kalyanasundaram <keerthana.kalyanasundaram@broadcom.com>
Date: Mon, 19 Jan 2026 15:09:32 +0530
X-Gm-Features: AZwV_QjKNqOInOKN050mzCHEoShb74nhxG56a1Rae_6DRaW3SD4fASVDyy68IXo
Message-ID: <CAM8uoQ_7HD0AtJLqXsRvO=F2knq=BtrdTM2Fv0Dd4h-4oYebNw@mail.gmail.com>
Subject: Re: [PATCH 5.10 423/451] tls: Use __sk_dst_get() and dst_dev_rcu() in get_netdev_for_sock().
To: Greg KH <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@google.com>, 
	Eric Dumazet <edumazet@google.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>, 
	Ben Hutchings <ben@decadent.org.uk>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000a7c8fa0648ba78fc"

--000000000000a7c8fa0648ba78fc
Content-Type: multipart/alternative; boundary="0000000000009981320648ba7881"

--0000000000009981320648ba7881
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg,

I have backported the two additional patches required for the 5.10.y tree
and submitted a v2 series. You can find the updated patches here:
https://lore.kernel.org/stable/20260119092602.1414468-1-keerthana.kalyanasu=
ndaram@broadcom.com/T/#t


Could you please consume these in the next version, or alternatively, add
the two missed patches (commit IDs 5b998545 and 719a402cf) to the current
queue?

- Keerthana K


On Mon, Jan 19, 2026 at 10:31=E2=80=AFAM Keerthana Kalyanasundaram <
keerthana.kalyanasundaram@broadcom.com> wrote:

>
> On Mon, Jan 19, 2026 at 5:03=E2=80=AFAM Ben Hutchings <ben@decadent.org.u=
k> wrote:
>
>> On Thu, 2026-01-15 at 17:50 +0100, Greg Kroah-Hartman wrote:
>> > 5.10-stable review patch.  If anyone has any objections, please let me
>> know.
>> >
>> > ------------------
>> >
>> > From: Kuniyuki Iwashima <kuniyu@google.com>
>> >
>> > [ Upstream commit c65f27b9c3be2269918e1cbad6d8884741f835c5 ]
>> >
>> > get_netdev_for_sock() is called during setsockopt(),
>> > so not under RCU.
>> >
>> > Using sk_dst_get(sk)->dev could trigger UAF.
>> >
>> > Let's use __sk_dst_get() and dst_dev_rcu().
>> >
>> > Note that the only ->ndo_sk_get_lower_dev() user is
>> > bond_sk_get_lower_dev(), which uses RCU.
>> [...]
>>
>> So should 5.10 also have a backport of commit 007feb87fb15
>> ("net/bonding: Implement ndo_sk_get_lower_dev")?  Or is the use of
>> netdev_sk_get_lowest_dev() here not actually that important?
>>
>> It seems kind of wrong to add the netdev operation and a caller for it,
>> but no implementation.
>>
>>
> Hi Ben,
> Thank you for catching this issue.
> I agree that we should also add commit 007feb87fb15 ("net/bonding:
> Implement ndo_sk_get_lower_dev") to the 5.10.y tree to ensure the
> implementation is complete. I will send an updated patch soon.
> - Keerthana
>
> Ben.
>>
>>
>> --
>> Ben Hutchings
>> Power corrupts.  Absolute power is kind of neat. - John Lehman
>>
>

--0000000000009981320648ba7881
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div style=3D"font-family:verdana,sans-se=
rif"><span class=3D"gmail_default" style=3D"font-family:verdana,sans-serif"=
></span>H<span class=3D"gmail_default" style=3D"font-family:verdana,sans-se=
rif">i</span> Greg,</div><div style=3D"font-family:verdana,sans-serif"><br>=
</div><div style=3D"font-family:verdana,sans-serif">I have backported the t=
wo additional patches required for the 5.10.y tree and submitted a v2 serie=
s. You can find the updated patches here: <a href=3D"https://lore.kernel.or=
g/stable/20260119092602.1414468-1-keerthana.kalyanasundaram@broadcom.com/T/=
#t">https://lore.kernel.org/stable/20260119092602.1414468-1-keerthana.kalya=
nasundaram@broadcom.com/T/#t</a>=C2=A0</div><div style=3D"font-family:verda=
na,sans-serif"><br></div><div style=3D"font-family:verdana,sans-serif">Coul=
d you please consume these in the next version, or alternatively, add the t=
wo missed patches (commit IDs 5b998545 and 719a402cf) to the current queue?=
</div><div style=3D"font-family:verdana,sans-serif"><br></div><div style=3D=
"font-family:verdana,sans-serif"><span class=3D"gmail_default" style=3D"fon=
t-family:verdana,sans-serif">-=C2=A0</span>Keerthana K</div><div><div dir=
=3D"ltr" class=3D"gmail_signature"><div dir=3D"ltr"><div><br></div></div></=
div></div></div><br><div class=3D"gmail_quote gmail_quote_container"><div d=
ir=3D"ltr" class=3D"gmail_attr">On Mon, Jan 19, 2026 at 10:31=E2=80=AFAM Ke=
erthana Kalyanasundaram &lt;<a href=3D"mailto:keerthana.kalyanasundaram@bro=
adcom.com">keerthana.kalyanasundaram@broadcom.com</a>&gt; wrote:<br></div><=
blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-l=
eft:1px solid rgb(204,204,204);padding-left:1ex"><div dir=3D"ltr"><div dir=
=3D"ltr"><div><br></div></div><div class=3D"gmail_quote"><div dir=3D"ltr" c=
lass=3D"gmail_attr">On Mon, Jan 19, 2026 at 5:03=E2=80=AFAM Ben Hutchings &=
lt;<a href=3D"mailto:ben@decadent.org.uk" target=3D"_blank">ben@decadent.or=
g.uk</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1=
ex">On Thu, 2026-01-15 at 17:50 +0100, Greg Kroah-Hartman wrote:<br>
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
</blockquote></div></div>

--0000000000009981320648ba7881--

--000000000000a7c8fa0648ba78fc
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
i36nH2SuVm4wDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIMLT/s58vi8s1mW8MjFI
5ppBoXpKFK0mGXgvZ2lGkhI6MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTI2MDExOTA5Mzk0NVowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0G
CSqGSIb3DQEBAQUABIIBAKWeP/1ooTXKgfulMmU9CCRTlw2mdOik7yndMM5Wb3yitvanxdSRQ8se
qwUpCSqQr5bd8TSaHxQdJYr/SFsbL3/MIUHL3HGqAMm5yyqgY+81KG6OqAY/OPS3eesGsMqgQyvK
5ofNNSy44ueFdUz06tToq2KJaWELsnSGF0AujWSdrD29NPk6QvAhlGVlBx8DbJx9muS3yVJIo7SZ
/SfvR+UMhceGlsGkrYzTg8noMAMGCoCqShVEa1P/oFZ8ns4S3Uv5IN8NsqxXAEOpMr3xJTjPDxJm
bPDTwYbVfEmSDwPJObMhdMjczjLgQguv5+MGV3vv1ePElhA930kqdS99RDk=
--000000000000a7c8fa0648ba78fc--
