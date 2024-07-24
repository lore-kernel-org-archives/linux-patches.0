Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F50487B0
	for <patches@lists.linux.dev>; Wed, 24 Jul 2024 06:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721803961; cv=none; b=PUeXK908mTqAZbOnKqm0YoKy2d6ecI/y9MT28YQU7FTT21IWHbe9NnnH4NpE1cyiwsfQtZ0NeJ+2U8uPZCvVVZlQEyoEwtjqzG5eetfP5rruIwWuOspFJHxnOHzwu7ujmfk1YuVFk1CyBLebDXztNXAQvyR05WZGCWhmV26RzV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721803961; c=relaxed/simple;
	bh=Bfx5l7uwGafxxKFg8g544NeKdX/OJ82VNbHROmOPw5M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FA580erEKOmyxnu+6i+U8sLWxuo8AkJZ692rPhfh33kJ1VaVxDe4lZFn5oXHq46lfh4N4lgbbkVnvZua/vjEGpldtvQf8RclwEK6xZzVj0ye89oePhBkitCkrA0Fg1HwC3qdZX6FXsHqLodhf91ThtxA+6qLseltusHC6FYrLGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GuxnWaSH; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GuxnWaSH"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-79f19f19059so367044685a.0
        for <patches@lists.linux.dev>; Tue, 23 Jul 2024 23:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721803959; x=1722408759; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bfx5l7uwGafxxKFg8g544NeKdX/OJ82VNbHROmOPw5M=;
        b=GuxnWaSHRZoN2I2UA/GIUrWsuMobkyzG0pJCrRmQRJ1bytbVxRGJMxM8qjmDzIEFgZ
         gLzfB029yUq9DCJkFrINcoqen4cx0ZvXd4pxpz3icACayDH7J+bEkqvlmnkpVkXypSyW
         uu3kW4E86XmOIM0YVZc01qR8MF7ybyR8K0QK7KUaZMx9GTpT7DnRmDGS3QLYBwdTvN8l
         EJyM8E+UisxKld9sknCDy26ZhyD/wSLBatT2wk0O4ychf2uOpKZ5EHYkstoWc5FnB7mz
         MiqTvR6AiVHjDalYjQzt8GF5BefcKoRiWbsNHQpqZJCs6heGO7bi28yT64q2miPqhHv4
         fDUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721803959; x=1722408759;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bfx5l7uwGafxxKFg8g544NeKdX/OJ82VNbHROmOPw5M=;
        b=dJgbZBNEJu+x/uKNlPTjOlQWCvn7chk6wgfKkPLVskXUysWUktDShPCkkB+OVfWbas
         IQz/OIDM4IfuW0uIzcSejq9GpASLhUQS3bWXyVUUxfCNZjstp18312oy6L0p01jfmsFk
         JJF/PHzyZPKp0Dv8adGDLYYUBsjvuUav7csZUcl2A76S6Jb+WW05hTZg8+FX3ZWDH6K9
         6DUZ34HdMRcktvFv3YGDGw01LMO3Edb0VF3oCBD1npozWDNk93BPk1DJmygAheq4dp/F
         1+lvW7mdX5z6l65qJwOVCdLouykwleMo74lFgQ3zk9Stv8MeDQLS4eDAEAUQjRAxaH5e
         MmHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJ+IFmM94axsZnaXZdcXI0FK/aII/QrrmKd12PfbAkQJs70l+n4h2z6uNGvpLa8QHbNpCTfsSJN0JxIrVLAI7g33VNo5qEfg==
X-Gm-Message-State: AOJu0Yw9AoTumOzo7dsAM51Z9AhhS02ezv6SnKWpu8T2Y4rEECdnl6zu
	a5ok4aztcWJWROG9/XLRkkJ53Q40cjvLiyGd3HPNMVIGcYq2ctPSqtBVHpIiGU/PPPRPzKTuqIB
	SO77l/DHs4dTc9QIey1RdKoxZ7Ds=
X-Google-Smtp-Source: AGHT+IFfEqKfp851TI5GZPpKydt1I9aSw9uQDJMX+tizWj/bXIso7OPQLfv/VqnOOQ/0D4vxzeFCclLX2uexl3AmuU4=
X-Received: by 2002:a05:620a:400a:b0:79f:b34:9edc with SMTP id
 af79cd13be357-7a1cbd35be0mr139400485a.66.1721803958898; Tue, 23 Jul 2024
 23:52:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240618123422.213844892@linuxfoundation.org> <1721718387-9038-1-git-send-email-ajay.kaher@broadcom.com>
 <CAOQ4uxgz4Gq2Yg4upLWrOf15FaDuAPppRVsLbYvMxrLbpHJE1g@mail.gmail.com> <1C4B79C7-D88F-4664-AA99-4C9A39A32934@oracle.com>
In-Reply-To: <1C4B79C7-D88F-4664-AA99-4C9A39A32934@oracle.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 24 Jul 2024 09:52:27 +0300
Message-ID: <CAOQ4uxiWttnpLBbFzVjQLKbeubbwWG35pn3Ve_majuV9a0mPJQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 387/770] fanotify: Allow users to request
 FAN_FS_ERROR events
To: Chuck Lever III <chuck.lever@oracle.com>
Cc: Ajay Kaher <ajay.kaher@broadcom.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "jack@suse.cz" <jack@suse.cz>, 
	"krisman@collabora.com" <krisman@collabora.com>, "patches@lists.linux.dev" <patches@lists.linux.dev>, 
	"sashal@kernel.org" <sashal@kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, 
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, 
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "tytso@mit.edu" <tytso@mit.edu>, 
	"alexey.makhalov@broadcom.com" <alexey.makhalov@broadcom.com>, 
	"vasavi.sirnapalli@broadcom.com" <vasavi.sirnapalli@broadcom.com>, 
	"florian.fainelli@broadcom.com" <florian.fainelli@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 23, 2024 at 4:48=E2=80=AFPM Chuck Lever III <chuck.lever@oracle=
.com> wrote:
>
>
>
> > On Jul 23, 2024, at 5:20=E2=80=AFAM, Amir Goldstein <amir73il@gmail.com=
> wrote:
> >
> > On Tue, Jul 23, 2024 at 10:06=E2=80=AFAM Ajay Kaher <ajay.kaher@broadco=
m.com> wrote:
> >>
> >>> [ Upstream commit 9709bd548f11a092d124698118013f66e1740f9b ]
> >>>
> >>> Wire up the FAN_FS_ERROR event in the fanotify_mark syscall, allowing
> >>> user space to request the monitoring of FAN_FS_ERROR events.
> >>>
> >>> These events are limited to filesystem marks, so check it is the
> >>> case in the syscall handler.
> >>
> >> Greg,
> >>
> >> Without 9709bd548f11 in v5.10.y skips LTP fanotify22 test case, as:
> >> fanotify22.c:312: TCONF: FAN_FS_ERROR not supported in kernel
> >>
> >> With 9709bd548f11 in v5.10.220, LTP fanotify22 is failing because of
> >> timeout as no notification. To fix need to merge following two upstrea=
m
> >> commit to v5.10:
> >>
> >> 124e7c61deb27d758df5ec0521c36cf08d417f7a:
> >> 0001-ext4_fix_error_code_saved_on_super_block_during_file_system.patch
> >> https://lore.kernel.org/stable/1721717240-8786-1-git-send-email-ajay.k=
aher@broadcom.com/T/#mf76930487697d8c1383ed5d21678fe504e8e2305
> >>
> >> 9a089b21f79b47eed240d4da7ea0d049de7c9b4d:
> >> 0001-ext4_Send_notifications_on_error.patch
> >> Link: https://lore.kernel.org/stable/1721717240-8786-1-git-send-email-=
ajay.kaher@broadcom.com/T/#md1be98e0ecafe4f92d7b61c048e15bcf286cbd53
> >>
> >> -Ajay
> >
> > I agree that this is the best approach, because the test has no other
> > way to test
> > if ext4 specifically supports FAN_FS_ERROR.
> >
> > Chuck,
> >
> > I wonder how those patches end up in 5.15.y but not in 5.10.y?
>
> The process was by hand. I tried to copy the same
> commit ID set from 5.15 to 5.10, but some patches
> did not apply to 5.10, or may have been omitted
> unintentionally.
>
>
> > Also, since you backported *most* of this series:
> > https://lore.kernel.org/all/20211025192746.66445-1-krisman@collabora.co=
m/
> >
> > I think it would be wise to also backport the sample code and documenta=
tion
> > patches to 5.15.y and 5.10.y.
> >
> > 9abeae5d4458 docs: Fix formatting of literal sections in fanotify docs
> > 8fc70b3a142f samples: Make fs-monitor depend on libc and headers
> > c0baf9ac0b05 docs: Document the FAN_FS_ERROR event
> > 5451093081db samples: Add fs error monitoring example.
> >
> > Gabriel, if 9abeae5d4458 has a Fixes: tag it may have been auto seleced
> > for 5.15.y after c0baf9ac0b05 was picked up...
>
> Or this... I might not have backported those at all
> to 5.15, and they got pulled in by another process.
>
> In any event, do you want me to backport these to
> 5.10, or would you like to do it yourself?
>

Please backport the docs and sample patches above to 5.15 and 5.10
for completion of the backport.

I do not expect you should have any major conflicts with these standalone
document and sample code.

Thanks,
Amir.
