Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8019014263
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 20:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3C1C433C0
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 20:02:01 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=permerror (0-bit key) header.d=gmail.com header.i=@gmail.com header.b="PZ37KPsD"
Resent-From: Ard Biesheuvel <ardb@kernel.org>
Resent-Date: Mon, 26 Jun 2023 22:01:58 +0200
Resent-Message-ID: <ZJnuti3o+EWdHZyf@gambale.home>
Resent-To: patches@lists.linux.dev
Received: by 2002:ab3:5d14:0:b0:22b:28fe:6113 with SMTP id j20csp171670ltc;
        Wed, 26 Apr 2023 21:05:10 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5lAU44bAR1mM/V58eOgiObvh7MrltnOhld7g2sib+BmOoCBrknqRxtl601TtwkY2GDrOTS
X-Received: by 2002:a05:6870:3a32:b0:17a:ccda:5c04 with SMTP id du50-20020a0568703a3200b0017accda5c04mr231347oab.14.1682568310284;
        Wed, 26 Apr 2023 21:05:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1682568310; cv=none;
        d=google.com; s=arc-20160816;
        b=z7SVIahTznY51BhTqk0Fa2rUIlu6l2KRfo+X6VwPLgsHUpkbK2tYD3xBdwIRZzI7bZ
         RI8FYJ6Kggde4omjayVW686rEn2WV7OA8TrmxYU+GRJ5c+j9wyX4Fiw8llQTxUAil3jx
         CtyqZoex7JGRhBt7sZtna34RzeZa/cYUTDRZrtXLcIB1YdN6bveqkCnjU6N86xyJay70
         Wwoy1E3pwr3CfTmQFkCILBoFsvn3WMesIRq2Hv6vcjFjaOj7e7ejYXuCP40ScOl5x0AB
         wiGYuTFuvxKKSTXVBzNp0Ep4V9SX4+sqWg3deb9V2B7pGCsztwWt1fZLUMBuCp3Bh4hd
         4DoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:dmarc-filter:delivered-to;
        bh=xFRFBtsjnNHabTVryZj98hadxLzsvBz2RVdC5gAyhq0=;
        b=LUN/ii41DSnTppHBXum3egegEyjx1rBlEWHhLDJGrnqcISY0RtkkrjyMs9U6+dNec/
         LjGHMDNVPWKDEeSk0aCN462jn+PZ1ZldGjZ4Pl4TPcnZ9BYo3pP4SMe97idH+JQlG7Lc
         yDN/Ylicbat9tKZZ9XJFd8L3LxfOrhoRhWWX9Hl/VIIGabq3eOfY/1QsY02hUxS/rKJ0
         B4kSxyoq5tJQiRpVVPi22cUql0LOhotQzP7/8ObzMRfroSIyx6J/gvLjKZOW/fDV7pNT
         XUfDZSE+c+es8kM1TG/IMY8BANvi1dHVl9JJTVAgLBSS2kqaLtC4Ev7BZVRw6A6gZyYX
         CmZQ==
ARC-Authentication-Results: i=1; mx.google.com;
       dkim=pass header.i=@gmail.com header.s=20221208 header.b=PZ37KPsD;
       spf=pass (google.com: domain of srs0=8ge6=as=gmail.com=rminnich@kernel.org designates 2604:1380:4641:c500::1 as permitted sender) smtp.mailfrom="SRS0=8GE6=AS=gmail.com=rminnich@kernel.org";
       dmarc=pass (p=NONE sp=QUARANTINE dis=NONE) header.from=gmail.com
Received: from dfw.source.kernel.org (dfw.source.kernel.org. [2604:1380:4641:c500::1])
        by mx.google.com with ESMTPS id i28-20020a9d611c000000b006a12ffd44aasi17887863otj.40.2023.04.26.21.05.10
        for <workofard@gmail.com>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Apr 2023 21:05:10 -0700 (PDT)
Received-SPF: pass (google.com: domain of srs0=8ge6=as=gmail.com=rminnich@kernel.org designates 2604:1380:4641:c500::1 as permitted sender) client-ip=2604:1380:4641:c500::1;
Authentication-Results: mx.google.com;
       dkim=pass header.i=@gmail.com header.s=20221208 header.b=PZ37KPsD;
       spf=pass (google.com: domain of srs0=8ge6=as=gmail.com=rminnich@kernel.org designates 2604:1380:4641:c500::1 as permitted sender) smtp.mailfrom="SRS0=8GE6=AS=gmail.com=rminnich@kernel.org";
       dmarc=pass (p=NONE sp=QUARANTINE dis=NONE) header.from=gmail.com
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id F3CE463A06
	for <workofard@gmail.com>; Thu, 27 Apr 2023 04:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 7E283C433A0; Thu, 27 Apr 2023 04:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5CC6DC433EF;
	Thu, 27 Apr 2023 04:05:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 5CC6DC433EF
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-5ef6e0f9d5aso78159436d6.0;
        Wed, 26 Apr 2023 21:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682568307; x=1685160307;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xFRFBtsjnNHabTVryZj98hadxLzsvBz2RVdC5gAyhq0=;
        b=PZ37KPsDgvYk5WhKQGFTA+y0ZOa4cm60Ow+VHybjjOlSM689gT5LCD3YSJOdvJpnAG
         5vRSylllh3A8kkme0CwI4dctKEnNbKBn4NuU23xSWDlwy5DdUj6XKq537EGcGRLJwtrH
         JufduAJpeH4bm2kLKGj+dKOOpiMGHS9ncz5Apozbh3tU1h0eI0kitNVF11t3sbAGiIEy
         j3AhJHfvEL5QmoDgGqftO7+ORU8ZHi4R5OvhfbB/KnU4YhTZb4Lo8nlf3hc2H0ZdbhEV
         f8sY1H02eJ3b0UxwmHPHleaKkaf+JCrGf3LbdtBfyQZMfnRHI3MT21WXE+waIJlvDhxs
         H92w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682568307; x=1685160307;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xFRFBtsjnNHabTVryZj98hadxLzsvBz2RVdC5gAyhq0=;
        b=APn47hgU12x6CLZqy7X7VB69A2F6WZIShtVHj3ogKLiduioSu6C9Dg4FSLADv4TTq9
         ScqIUyu2Xh5PHzLkn2uBBNDp0VV3BwxOlxQYtb1l5UmH+ll6L55/NQvYjPU/DSO9jHtB
         4vNSM+TfTnp+qwnaVo/U2dYr3Pfu3vM+rR/Ya0qLXYXxv3GSZyiC2UvzDvr4hP5Xa5YB
         PgZkGuWTEzjhA6dioGgvOJmMtlFRx7sBRTDyPQlVTSpkLV7PjFgNYjULuEVraisUBke8
         pSGhNX6xG9Krdm+wDPPEYCkUoladLcpp2Y7agQi4DNSOg/NXJFUJajiHT4kR6OOyS16R
         KLow==
X-Gm-Message-State: AAQBX9fq2FdT373LPDxfOgK4JJKx/ZUhoKs9ydJEsLwAz2qDKvDmTY2x
	dfqq9RZVlFJoFm4wFBD13FmtGLgWwEk1hd3zuXs=
X-Received: by 2002:a05:6214:5185:b0:5d9:a36d:3ed2 with SMTP id
 kl5-20020a056214518500b005d9a36d3ed2mr36818133qvb.45.1682568307301; Wed, 26
 Apr 2023 21:05:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230426034001.16-1-cuiyunhui@bytedance.com> <CAMj1kXEKh9O-ndk3QFibJMYfMbG7vm-cLN2vVQM5eDsYK84NzQ@mail.gmail.com>
 <CAEEQ3wkJB5CKm33mHXUOPX5makYOHF8By6FYGnNzRkM-Mo72OQ@mail.gmail.com>
 <ZEj33QLZqEeL+/y4@FVFF77S0Q05N> <CAEEQ3wmDBJkfOeKCQfcnuE+1=1K0D2pzu+Sn+zPEWk+RHs0NFQ@mail.gmail.com>
In-Reply-To: <CAEEQ3wmDBJkfOeKCQfcnuE+1=1K0D2pzu+Sn+zPEWk+RHs0NFQ@mail.gmail.com>
From: ron minnich <rminnich@gmail.com>
Date: Wed, 26 Apr 2023 21:04:56 -0700
Message-ID: <CAP6exY+ydbzh1EkWTFejzwaW+PA-ySVO2Qj+CVJ1XbSMce2S9Q@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] firmware: added a firmware information
 passing method FFI
To: =?UTF-8?B?6L+Q6L6J5bSU?= <cuiyunhui@bytedance.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, rafael@kernel.org, lenb@kernel.org, 
	jdelvare@suse.com, yc.hung@mediatek.com, 
	angelogioacchino.delregno@collabora.com, allen-kh.cheng@mediatek.com, 
	pierre-louis.bossart@linux.intel.com, tinghan.shen@mediatek.com, 
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The device tree is self describing data. Adding new information is easy. If
you add new information to a node, and older software does not know about
it, it is no big deal.

So I can't agree with this comment: "We'd have to create entirely new ways
to pass that information, which is not
very desirable."

The whole point of the dt is that you can always add new ways to pass
information, by design.

Adding memory attributes would be quite easy.

On Wed, Apr 26, 2023 at 8:38=E2=80=AFPM =E8=BF=90=E8=BE=89=E5=B4=94 <cuiyun=
hui@bytedance.com> wrote:

> Hi Mark,
>
> On Wed, Apr 26, 2023 at 6:07=E2=80=AFPM Mark Rutland <mark.rutland@arm.co=
m> wrote:
> >
> > Ard's point is that the device tree doesn't have all the same
> information (e.g.
> > nothing in DT describes the memory type attributes), and so this isn't
> > sufficient.
>
> The device tree only needs to complete the parse of the memory type
> attributes,
> it should not be very complicated.
>
> >
> > We'd have to create entirely new ways to pass that information, which i=
s
> not
> > very desirable.
> >
>
> >
> > Can you extend coreboot to provide EFI services, or to chain-load an EF=
I
> > payload?
>
> Currently, coreboot does not support UEFI, and it may not support it
> in the future.
> Hi rminnich, what do you think?
>
> Thanks,
> Yunhui
>
