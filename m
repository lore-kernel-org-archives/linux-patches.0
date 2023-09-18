Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7411108
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 01:51:27 +0000 (UTC)
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-403012f27e3so45581405e9.3
        for <patches@lists.linux.dev>; Sun, 17 Sep 2023 18:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695001886; x=1695606686; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mdhYeWFUupd8CumwOXd56eCg8LNwmhFEfrbDHqjtz+U=;
        b=HCpvWeaHl3M8UqG/xIi7ewaUrQVH8RRvE3Fcsx81rEnKFg3LcG1k5x398K5hYKHh66
         L6mhN3cyomkz2RHuuENSmbvshwlD9kXXc/jgz7z4MqZtAGxhXplx4Ou5HtZhuYldaROE
         5AKPGAhjYW30kprLdw6H/KNqYplQ66n64cqKCgUMhxGijnE6YOV6ljwTp+RtjTUVIBVa
         Cjt3NULyQpL4v4pw9h3pfQ0xGvGreDyS106/sVrXyzHY5//nKSE1bm0l4rXZMc+iKlGj
         CYKbDXRpk9joK+NIzUIGQ3mnNTDF21t3hu68PrZCmL8QxF2wyuShY2cIRHDdOkradmIL
         k22Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695001886; x=1695606686;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mdhYeWFUupd8CumwOXd56eCg8LNwmhFEfrbDHqjtz+U=;
        b=IJ7gbZYuEXedUEFEMdsWM5M8iEOqnh2pUlk+x6avf0r1C9ozL05iv6cakn+o5/lMu5
         zJV2d3FFNWSEbixiVrdPM7093KaARHlNqkHOURMixbv/4HxadzQREF+r1tPH1q/wKVjG
         YR4ANpGnS30B5O74H3LWm9PrjR5Egh7tYxoLlN33qqsLHLNTJRLlwExsYp/rRiO8mkyw
         UCmypTd+LeQkeXJmG2EQ6Oth7EJkRg7+kJO96hY2yzKQHnzUcVjuEvhD9sCM57A6w2+V
         0qURuEf4XaYkMEjwI93KjLxgoYMigMVkOiZ2zqkb70sZ73SE4Qs0SYK4kwgCtkcdJifY
         F4lg==
X-Gm-Message-State: AOJu0YxA8heBmgv/VNZySnrm624HsZIsIE2TXZkGnUQ6kOsORb2WW8VP
	7McxhQferNLNmuURiIfXsmMTWWSV+9MgBZFnF8I=
X-Google-Smtp-Source: AGHT+IFsN4CSXAya55dgE/LFOVwBdT2N/njIrBCW1aKeXbivsdFRaHER1bQCTOosW08QEABG5AAoe7g6AVganKqPiuo=
X-Received: by 2002:adf:ef8a:0:b0:317:5f13:5c2f with SMTP id
 d10-20020adfef8a000000b003175f135c2fmr8236049wro.0.1695001885774; Sun, 17 Sep
 2023 18:51:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230917191101.035638219@linuxfoundation.org> <20230917191109.075455780@linuxfoundation.org>
 <276965bc5bb339bc02bbd653072ceb50a7103400.camel@gmail.com>
In-Reply-To: <276965bc5bb339bc02bbd653072ceb50a7103400.camel@gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Sun, 17 Sep 2023 18:51:14 -0700
Message-ID: <CAADnVQ+OwQzzGC7tP_qbLYi=k6T4dPKrod57iXt2-_JFCdqF4g@mail.gmail.com>
Subject: Re: [PATCH 5.10 294/406] bpf: Fix issue in verifying allow_ptr_leaks
To: Eduard Zingerman <eddyz87@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable <stable@vger.kernel.org>, 
	patches@lists.linux.dev, Yonghong Song <yonghong.song@linux.dev>, 
	Yafang Shao <laoar.shao@gmail.com>, Alexei Starovoitov <ast@kernel.org>, gerhorst@amazon.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 17, 2023 at 1:21=E2=80=AFPM Eduard Zingerman <eddyz87@gmail.com=
> wrote:
>
> On Sun, 2023-09-17 at 21:12 +0200, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me =
know.
>
> I believe Luis Gerhorst posted an objection to this patch for 6.1 in [1],
> for reasons described in [2]. The objection is relevant for 5.10 as well
> (does not depend on kernel version, actually).

Yes. Let's delay the backport of this patch until that thread is resolved.

> [1] https://lore.kernel.org/all/2023091653-peso-sprint-889d@gregkh/
> [2] https://lore.kernel.org/bpf/20230913122827.91591-1-gerhorst@amazon.de=
/
