Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F6628F9
	for <patches@lists.linux.dev>; Mon, 30 May 2022 11:14:47 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id d129so9866707pgc.9
        for <patches@lists.linux.dev>; Mon, 30 May 2022 04:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HJSdgcuK4aBK7WvVZ3jjMmg2JsOtEFs5Q/G06ql/0YM=;
        b=KjSi+vqRex30uFWXic9sXcJStCRuKOrDdpmV8fPRTD1QuEPKBrBfWD1Y9cXiJmpMXR
         a8AXnEreUuie6RZoAqqUpzn6KchVxyQG/DmvLY+G1oCCC8ZScJ5YQ97Ymgeym/upa5dP
         tiUMQJYUeSr+hKMdYFtHeYSU7lX4B9LLlhdFd+M0Ate49CryU84da6+6SVKTqHRJ1whj
         uYCuQTiPy9uztRTlUBPm5q/yR5qhKRUvGwG0KA4EOe5Na4of/ilhUNuE7wpiNHiOim/V
         lwDRABFc/uoPRTSxdixI3pIJoZ+z5ZqtgF11/PxBGeneyDBnbqwpmBiCLHr/OT0B4zhq
         LJpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HJSdgcuK4aBK7WvVZ3jjMmg2JsOtEFs5Q/G06ql/0YM=;
        b=J4vae4bWGnxDFxhZpf7xTYH3CJwoIbloRiw+8MCKxhA1V2g2ERdtMnPO1ku2hL5z8L
         qERIQMVoczs1MbKDoXvHB+movC2tooqzLAVw8pFvxbD27TOHdfigLC/vLtTGdfgIHOmh
         V3heR5FP/feLvoPPupVvgDNGdMwLl8Fc+LcCRPn/ZpGwM/xpE4d8EV8wUjdYMd7PTOZM
         E8rtEhR942lwMxagWEZ3E5J4yeP+ficaq+G6eNHzJ4nijKuoQ9T5EiZEkLBfHh+EgHLs
         wniNbsO9IZV7JMLVCF0iDPcPgI8wujc+rf6O4F03BbFmGlCH/5XbA+M1QNWDNrsYp+5t
         xhLw==
X-Gm-Message-State: AOAM533EhmxTnLHiF+I9PTA1ja5KhVw12TklYF4Jhs80PtsE/eaIn1UL
	pv4MrN9Gv6KZxW2smlcM2WfWLFZmD5NHzXvC+geveF1t4ys=
X-Google-Smtp-Source: ABdhPJzg7n+/guo7/sglTcTdVapzEO+2nA+dclteRDSAxvXl5LtF2FTYOGTxdKxoif5Tfq6h27oIEmLideo2F/qekmc=
X-Received: by 2002:a65:6a50:0:b0:3f6:4566:581d with SMTP id
 o16-20020a656a50000000b003f64566581dmr46245743pgu.122.1653909286904; Mon, 30
 May 2022 04:14:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220527211708.839033-1-matenajakub@gmail.com>
 <20220527211708.839033-3-matenajakub@gmail.com> <20220529164718.ed1eac7d614804c825fae9fd@linux-foundation.org>
In-Reply-To: <20220529164718.ed1eac7d614804c825fae9fd@linux-foundation.org>
From: =?UTF-8?Q?Jakub_Mat=C4=9Bna?= <matenajakub@gmail.com>
Date: Mon, 30 May 2022 13:15:03 +0200
Message-ID: <CABsDyaK87nC_bJ1OAc9LOsL53M7qrfkkoO-QzSwGhtt=Np0p2w@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] [PATCH 2/2] mm: add merging after mremap resize
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Vlastimil Babka <vbabka@suse.cz>, mhocko@kernel.org, mgorman@techsingularity.net, 
	willy@infradead.org, Liam Howlett <liam.howlett@oracle.com>, 
	Hugh Dickins <hughd@google.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, riel@surriel.com, 
	rostedt@goodmis.org, peterz@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 30, 2022 at 1:47 AM Andrew Morton <akpm@linux-foundation.org> w=
rote:
>
> On Fri, 27 May 2022 23:17:08 +0200 Jakub Mat=C4=9Bna <matenajakub@gmail.c=
om> wrote:
>
> > When mremap call results in expansion, it might be possible to merge th=
e
> > VMA with the next VMA which might become adjacent. This patch adds
> > vma_merge call after the expansion is done to try and merge.
>
> Thanks.
>
> Would it make sense to add a test case for this in (I assume)
> tools/testing/selftests/vm/mremap_test.c?  Maybe parse /proc/self/maps
> and check that the merging occurred as expected?
>

It shouldn't be a problem and it makes sense. I will do it.

Jakub Mat=C4=9Bna
