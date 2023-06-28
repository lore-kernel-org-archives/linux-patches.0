Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6785F1119C
	for <patches@lists.linux.dev>; Wed, 28 Jun 2023 22:07:55 +0000 (UTC)
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2b69f71a7easo402601fa.1
        for <patches@lists.linux.dev>; Wed, 28 Jun 2023 15:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1687990073; x=1690582073;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LafiJyNgbZmNNbdJGp4ZrkLO2f20OEreitolc2Mh/lo=;
        b=OXj6n2h9HrVbQYMFoM14lfzi6flG9VwlaUQXgRLPZhhkGRfmuPQbZdGqyIVsRkEdGe
         XvMvvmQnlWDwAKgTDQM5nKyPnKovV84E4t2oTV8SvIcieWv3doOdU4nXnptspaaBJgfe
         TsTQbg8S2VG1mHl6kwuptuRSQ2SeoKi6yrVrc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687990073; x=1690582073;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LafiJyNgbZmNNbdJGp4ZrkLO2f20OEreitolc2Mh/lo=;
        b=lh429rN9S/PH1DXZohGouMX06pDzPBO/XQ3/eVsUpqQEdJNkMasJmlNB1eAnlJXPgY
         zAwpm14atw46+7PROqySyiIRANPLCfgfHNlLV0qDNOoaxB5dVoVB/7YU4aUat0Ul8oWD
         UT1buDWOGU+vyJKMMdFT0lIwjHF5jJ2stDnJM1JJMkx4pAIgyLCUp+5YHb+3TMtJ/Xcq
         vrDuJ/S3G6TOJh2FcEs6uRZXVNmYOs3VUmc/X2En7Auh/dqSrbBI3BmckMjkXbZnKJW0
         p9kCOOHE/UuQjKp7BOIlnUIO/KlCaI8m4FF62OWV3FGcVkyy+Mb6rYkpPYDtd7GnP7I2
         f0TQ==
X-Gm-Message-State: ABy/qLZDn3lNtekTv8Ay7mfu3W9FnxT1rE4m4MpbwA7OqzAZPEgJ0fMJ
	8Qmu5R85EkRhOh4Qo8yMlrXcJ+UQDnM3QjYwV4KZRbCF
X-Google-Smtp-Source: APBJJlEkCtnPNVsOOvz1RbUH9GYLXwrqWbARUGPDxaUAbGQcckNxIRuR1rWaQvA99OuMWdF/rHx4mQ==
X-Received: by 2002:a05:6512:6d2:b0:4fb:97e8:ed8c with SMTP id u18-20020a05651206d200b004fb97e8ed8cmr549544lff.4.1687990072990;
        Wed, 28 Jun 2023 15:07:52 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id p14-20020ac246ce000000b004eff1163c37sm1748995lfo.308.2023.06.28.15.07.51
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jun 2023 15:07:52 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2b6985de215so317511fa.2
        for <patches@lists.linux.dev>; Wed, 28 Jun 2023 15:07:51 -0700 (PDT)
X-Received: by 2002:aa7:c947:0:b0:51a:2c81:72ee with SMTP id
 h7-20020aa7c947000000b0051a2c8172eemr23606011edt.20.1687990050285; Wed, 28
 Jun 2023 15:07:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZHTCK2_1pF61yWIr@hovoldconsulting.com> <CAHk-=wg7ihygotpO9x5a6QJO5oAom9o91==L_Kx-gUHvRYuXiQ@mail.gmail.com>
 <ZHYitt7P7W+8ZlSB@bombadil.infradead.org> <499e30cc-d015-8353-1364-50d17da58f47@redhat.com>
 <ZHd8bLPY4OQCb/Z5@bombadil.infradead.org> <ba60bca6-b682-4c27-3c54-2512b6f16151@redhat.com>
 <ZHoTFDkPIgglW0sU@bombadil.infradead.org> <fa3f1a1f-edc6-f13b-cc84-f3264b03b0b1@redhat.com>
 <ZH38lpTHZ/RISC1v@bombadil.infradead.org> <ZH3/KVCHhX4D4yh9@bombadil.infradead.org>
 <ZJyBhv6yrAfYvMh5@bombadil.infradead.org> <CAHk-=wiSRTEOgiDA5qUTPGcw=Fbk9Ou2i97kfSBcj3pey3X=fQ@mail.gmail.com>
In-Reply-To: <CAHk-=wiSRTEOgiDA5qUTPGcw=Fbk9Ou2i97kfSBcj3pey3X=fQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Jun 2023 15:07:12 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgPz4Fj9M_h7sRSHAK9QeJiTFaYMWX3fDyZ-Bj41HftmA@mail.gmail.com>
Message-ID: <CAHk-=wgPz4Fj9M_h7sRSHAK9QeJiTFaYMWX3fDyZ-Bj41HftmA@mail.gmail.com>
Subject: Re: [PATCH 2/2] module: add support to avoid duplicates early on load
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: David Hildenbrand <david@redhat.com>, song@kernel.org, Johan Hovold <johan@kernel.org>, 
	Lucas De Marchi <lucas.demarchi@intel.com>, Petr Pavlu <petr.pavlu@suse.com>, 
	gregkh@linuxfoundation.org, rafael@kernel.org, lucas.de.marchi@gmail.com, 
	christophe.leroy@csgroup.eu, peterz@infradead.org, rppt@kernel.org, 
	dave@stgolabs.net, willy@infradead.org, vbabka@suse.cz, mhocko@suse.com, 
	dave.hansen@linux.intel.com, colin.i.king@gmail.com, jim.cromie@gmail.com, 
	catalin.marinas@arm.com, jbaron@akamai.com, rick.p.edgecombe@intel.com, 
	yujie.liu@intel.com, tglx@linutronix.de, hch@lst.de, patches@lists.linux.dev, 
	linux-modules@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pmladek@suse.com, prarit@redhat.com, 
	lennart@poettering.net
Content-Type: text/plain; charset="UTF-8"

On Wed, 28 Jun 2023 at 13:14, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> In other areas, I may send out patches, but I don't feel like I'm a
> maintainer, so I then think that "the real maintainer can decide if
> these patches are good or not".

Anyway, since I clearly didn't communicate clearly that I was throwing
the patch over to you, let me go and find it and just apply it myself.

           Linus
