Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C5F14263
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 19:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6699EC433C8
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 19:59:16 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VeBfh1Cx"
Resent-From: Ard Biesheuvel <ardb@kernel.org>
Resent-Date: Mon, 26 Jun 2023 21:59:13 +0200
Resent-Message-ID: <ZJnuEchJqssj7acC@gambale.home>
Resent-To: patches@lists.linux.dev
Received: by 2002:a05:6504:1595:b0:22f:342c:2b60 with SMTP id b21csp3844240ltq;
        Tue, 20 Jun 2023 13:16:35 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ49KovnIEjPgB7zJYJppc8SXcDMcqD3gv3M7UutjcmJ2fFxYdRlbUJ7n+WEQA5CuPceWR6+
X-Received: by 2002:a05:6870:b302:b0:19f:6fae:d5fc with SMTP id a2-20020a056870b30200b0019f6faed5fcmr6244744oao.33.1687292195598;
        Tue, 20 Jun 2023 13:16:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1687292195; cv=none;
        d=google.com; s=arc-20160816;
        b=JfBWEeoje1foa7PaBrxSzN404/bs6n+1iSxZij6Otb4d7rqGN+jhq9S8SX4kNffluG
         mrVhR3sFAhU/5DpfjmHITW3JQSHlJwRdR00olSwmAvrncNKEg7z69yyk3Y8VC4DSPW+T
         ChjHb5GnGUoekNdeA2fkKhGOQK98vRcvR3tJVdDCSvjVQlGDTCxsdY+IEILDP4Px266L
         LSA0wZdE3e1plUupOh7/uJg/mEPtJ2SVe7sdoXcH6asegXmYIqnt0p10CU4Cb+uxdNOW
         EPaXyUGH9EyMn6RvQRz+XnFMHFSL2EOU7iw6tPmluHTnqFK4nODluhKjqmT6PjUd/rFf
         o8xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:dmarc-filter:delivered-to;
        bh=/2n3a/QTfuxN4q84p6LfMlJX/psSWKoqLylI3pVIDYM=;
        b=Ey/pZVsRsdWuYM364GhfrceABxwtxCCPLA7oyClf70E6H9sN9ACdGhV2+m4Vafc3qv
         FIawJ9z/yYELScKR7sYvFUDI532j1Uae3U4lH8+h2I7acwtXZMgM4n42ezheUriLLjPi
         E5kD/5dd4a836om3sjqH/n9IOzD5c9RElcEq2lHPLbYqvA0qPqa+Q7ArCT3ickVY63VF
         guvYp3c9FetJo9NyfDkf+2OKV98DI01v1Q3SrS6WSOiubCDsYRdIUREvfQX/YQnghq5x
         DTcoJsXDqjpqz3tXBfpFbxG07kIU2N3hNa0X8P/FOQl4e06HjzGgu+AoQtbWWPqk3hUt
         zwaQ==
ARC-Authentication-Results: i=1; mx.google.com;
       dkim=pass header.i=@gmail.com header.s=20221208 header.b=VeBfh1Cx;
       spf=pass (google.com: domain of srs0=iuss=ci=gmail.com=rminnich@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom="SRS0=iuSs=CI=gmail.com=rminnich@kernel.org";
       dmarc=pass (p=NONE sp=QUARANTINE dis=NONE) header.from=gmail.com
Received: from dfw.source.kernel.org (dfw.source.kernel.org. [139.178.84.217])
        by mx.google.com with ESMTPS id z17-20020a056871039100b0019f99f5f6b6si1157423oaf.244.2023.06.20.13.16.35
        for <workofard@gmail.com>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 13:16:35 -0700 (PDT)
Received-SPF: pass (google.com: domain of srs0=iuss=ci=gmail.com=rminnich@kernel.org designates 139.178.84.217 as permitted sender) client-ip=139.178.84.217;
Authentication-Results: mx.google.com;
       dkim=pass header.i=@gmail.com header.s=20221208 header.b=VeBfh1Cx;
       spf=pass (google.com: domain of srs0=iuss=ci=gmail.com=rminnich@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom="SRS0=iuSs=CI=gmail.com=rminnich@kernel.org";
       dmarc=pass (p=NONE sp=QUARANTINE dis=NONE) header.from=gmail.com
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 3CD01611C5
	for <workofard@gmail.com>; Tue, 20 Jun 2023 20:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id B5F48C433CC; Tue, 20 Jun 2023 20:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65FDFC433C8;
	Tue, 20 Jun 2023 20:16:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 65FDFC433C8
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-6300f6ab032so31404026d6.2;
        Tue, 20 Jun 2023 13:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687292192; x=1689884192;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/2n3a/QTfuxN4q84p6LfMlJX/psSWKoqLylI3pVIDYM=;
        b=VeBfh1CxJxCqGBXzWFz3HfrSAFKNlkf9myUCj/Gn9mGjQqp2IO0WElvqCbQ9TIK8ga
         mg7VC3cQtcTh+9MvuxAJHJfjmgPapwrZM7m0XSCs+N4yliDlk0s6qND9DROcAjfw3jzH
         bxI9XjuK5i7nGE0lIKR/LlTQqsIUI/2M4fAJN1WkP2rK30WAEn41lPg1PfnQA1QzY1l1
         Uya3ldPzR4WNZXDF+LgmAu0bbJCRpMs0fpUFSKN3y/oQKWehOyVnV2Xm5DMhq1Mfro3A
         Ilv1INEN1wH59yv1jzX0w18aVS7Mw67zeHy/2En7SkDCjrhIvJfPaBg5+qHQzWnp8JdE
         8f+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687292192; x=1689884192;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/2n3a/QTfuxN4q84p6LfMlJX/psSWKoqLylI3pVIDYM=;
        b=GldS/18QPLxntzayKc9nvNNruV2KFlGf7y1C3qnhSOO7WeLtbnkIlCf36KTk03p3Sc
         T4Ruy+FFPqUk/7QV1wDW6oUZi2VxQ+BR3TKwgrQz497b3h2fe18K4gEHs3lItriADO/X
         utALJihzrcLwXQQu47axTm91z6XXNzteR+xMXXQV61IQoiEG6V0k/OLAFMPY9dU2zqL2
         FyRs1BPEIWV0H0ILWbNDiyv9zqgUmawNr1fU2qpEwVysdVqgT8F1Jr4e8u/9RjkwOQ9F
         cJ13qsMsAuI0OoG0id8NEizzLJcMww5GxxcWWPpvXas2svXYUH5WawtgPuAH94/Tux3b
         IXdg==
X-Gm-Message-State: AC+VfDzZSWwcwQyJhEVNhUGe5NIe+MgA8DyAgAPXUecyj9YWsJsHvQ8G
	CSv/ZChtpnnq0sOHYjXFfGMqFskAJSoiw2h/J1ePo/8o10S4xg==
X-Received: by 2002:a05:6214:2426:b0:61f:ace6:e94e with SMTP id
 gy6-20020a056214242600b0061face6e94emr17350922qvb.0.1687292192084; Tue, 20
 Jun 2023 13:16:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230426034001.16-1-cuiyunhui@bytedance.com> <CAMj1kXEKh9O-ndk3QFibJMYfMbG7vm-cLN2vVQM5eDsYK84NzQ@mail.gmail.com>
 <CAEEQ3wkJB5CKm33mHXUOPX5makYOHF8By6FYGnNzRkM-Mo72OQ@mail.gmail.com>
 <ZEj33QLZqEeL+/y4@FVFF77S0Q05N> <CAEEQ3wmDBJkfOeKCQfcnuE+1=1K0D2pzu+Sn+zPEWk+RHs0NFQ@mail.gmail.com>
 <CAP6exY+ydbzh1EkWTFejzwaW+PA-ySVO2Qj+CVJ1XbSMce2S9Q@mail.gmail.com>
In-Reply-To: <CAP6exY+ydbzh1EkWTFejzwaW+PA-ySVO2Qj+CVJ1XbSMce2S9Q@mail.gmail.com>
From: ron minnich <rminnich@gmail.com>
Date: Tue, 20 Jun 2023 13:16:20 -0700
Message-ID: <CAP6exY+tqAU0j1TVEMTzTb18M6_mPH5bWWiAS=94gyDGTY3hyQ@mail.gmail.com>
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

I am wondering if we can focus on risc-v here, and not drag in ARM, b/c the
ARM ACPI+UEFI ship has sailed. I had that discussion in 2013 ;-) and it's
clear we don't want to redo it.

In general, in my world, because of the many problems that come with UEFI
(security, code quality, performance), we'd like to avoid requiring a
dependency on UEFI just to get ACPI on RISC-V. It also seems, from other
discussions I'm having, that there is some belief that ACPI will be wanted
on RISC-V. It would be nice to separate those pieces on RISC-V;
certainly they were separate for a very long time in the x86 world (we had
ACPI+SMM on coreboot laptops without UEFI for example).

Is there some feeling here that it would be ok to restrict this discussion
to risc-v, and not bring in ARM considerations.  WDYT?

On Wed, Apr 26, 2023 at 9:04=E2=80=AFPM ron minnich <rminnich@gmail.com> wr=
ote:

> The device tree is self describing data. Adding new information is easy.
> If you add new information to a node, and older software does not know
> about it, it is no big deal.
>
> So I can't agree with this comment: "We'd have to create entirely new way=
s
> to pass that information, which is not
> very desirable."
>
> The whole point of the dt is that you can always add new ways to pass
> information, by design.
>
> Adding memory attributes would be quite easy.
>
> On Wed, Apr 26, 2023 at 8:38=E2=80=AFPM =E8=BF=90=E8=BE=89=E5=B4=94 <cuiy=
unhui@bytedance.com> wrote:
>
>> Hi Mark,
>>
>> On Wed, Apr 26, 2023 at 6:07=E2=80=AFPM Mark Rutland <mark.rutland@arm.c=
om>
>> wrote:
>> >
>> > Ard's point is that the device tree doesn't have all the same
>> information (e.g.
>> > nothing in DT describes the memory type attributes), and so this isn't
>> > sufficient.
>>
>> The device tree only needs to complete the parse of the memory type
>> attributes,
>> it should not be very complicated.
>>
>> >
>> > We'd have to create entirely new ways to pass that information, which
>> is not
>> > very desirable.
>> >
>>
>> >
>> > Can you extend coreboot to provide EFI services, or to chain-load an E=
FI
>> > payload?
>>
>> Currently, coreboot does not support UEFI, and it may not support it
>> in the future.
>> Hi rminnich, what do you think?
>>
>> Thanks,
>> Yunhui
>>
>

