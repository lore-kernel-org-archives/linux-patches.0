Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77DEBA32
	for <patches@lists.linux.dev>; Wed, 28 Jun 2023 20:14:45 +0000 (UTC)
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2b6adef5c22so3390701fa.3
        for <patches@lists.linux.dev>; Wed, 28 Jun 2023 13:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1687983283; x=1690575283;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hbAy1A4hg8jKYhqwi5Dl7jA23U6AKUJrNF/g/KP9ftA=;
        b=I02KJdX/sqhNyIJ9w/Im9qxreHXACL5Q3p8oMMBMhPbJYat2hODczOrYJBLITwUV7Z
         tkU+2UKvQByIaHnGGyUAz5PP7HUouULlAM5Qwcvq9PiSnNgpoYzR4FRxOlbfvqmwpGPl
         9ENhgRgP8kACdyEBeo22TQKvyElQ5UZCb03AQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687983283; x=1690575283;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hbAy1A4hg8jKYhqwi5Dl7jA23U6AKUJrNF/g/KP9ftA=;
        b=jpufFi5DMmls+Cs87RQhg9C2p9G88KOFIgXcRT1ERSkfrfHINvwd3pbdrCAK4QFWxB
         onVewtJjN1KujlH0zyKbRk18y+9C2UrhWQzqFkBD8Ffj2W62sIXyouoJuXUVs4zi+g1P
         4F6xFeHP91JfC963uTQoA2cK5FyJMaqxu1kOJg7hJaEpvUmINpFs7OKF1yQcWvsezGhm
         8pzbGO2vDq5UZbaozK9ZCQAdMzhcTZPQ4Ke9qo8wJ/kvW/isVkTj4b7pBCfJPMA5p/uu
         nWIJiwtTw3Og/gaDm2ijf36vI2U77RnsQTNILxVLFMPI61IesiCN61+UItIyID8xVAvu
         oqMQ==
X-Gm-Message-State: AC+VfDw95XsLschCBLOTqr5NY1DiTwppwKpDcDu4xgl3zFR9f82pEm/S
	bhYzxpdlLkX5hx+9jOkCr2vcJctF7DOBPY36GX2gMbNw
X-Google-Smtp-Source: ACHHUZ7ETjuSwvh5vliVwWe755d/KmND/8iegKa9l7COLDQWfV+8+3RYtUpmH1ZFEr6gH7CQVPMUbQ==
X-Received: by 2002:a2e:6a07:0:b0:2b5:7fba:18ac with SMTP id f7-20020a2e6a07000000b002b57fba18acmr19880169ljc.48.1687983283647;
        Wed, 28 Jun 2023 13:14:43 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id i5-20020a2e8085000000b002b6a3b573d8sm1459994ljg.61.2023.06.28.13.14.42
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jun 2023 13:14:42 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-4f8775126d3so69903e87.1
        for <patches@lists.linux.dev>; Wed, 28 Jun 2023 13:14:42 -0700 (PDT)
X-Received: by 2002:aa7:de11:0:b0:51b:ea1d:bc31 with SMTP id
 h17-20020aa7de11000000b0051bea1dbc31mr12411899edv.26.1687983261040; Wed, 28
 Jun 2023 13:14:21 -0700 (PDT)
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
 <ZJyBhv6yrAfYvMh5@bombadil.infradead.org>
In-Reply-To: <ZJyBhv6yrAfYvMh5@bombadil.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Jun 2023 13:14:04 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiSRTEOgiDA5qUTPGcw=Fbk9Ou2i97kfSBcj3pey3X=fQ@mail.gmail.com>
Message-ID: <CAHk-=wiSRTEOgiDA5qUTPGcw=Fbk9Ou2i97kfSBcj3pey3X=fQ@mail.gmail.com>
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

On Wed, 28 Jun 2023 at 11:52, Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> Linus, were you thinking of including these patches in for v6.5-rc1?

Heh, I don't even have them in my tree any more, I was assuming that
if they were good they'd be sent back to me...

I guess I can go fish them out from my old emails, but I actually was
expecting to just get them from you.

I do actually maintain my own branches for *some* things, and merge
them myself, but they tend to be for areas that I feel I'm
co-maintaining (ie notably vfs and mm that I still feel I'm involved
in).

In other areas, I may send out patches, but I don't feel like I'm a
maintainer, so I then think that "the real maintainer can decide if
these patches are good or not".

And I would very much hope that people don't take said patches _just_
because they come from me. They should be judged on their own merits,
and then occasionally people can mutter "Christ, what drugs is Linus
on _today_?" and just throw my patches in the garbage.

             Linus
