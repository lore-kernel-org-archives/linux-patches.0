Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA74033F2
	for <patches@lists.linux.dev>; Sun,  4 Jun 2023 14:26:25 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-653fcd58880so874368b3a.0
        for <patches@lists.linux.dev>; Sun, 04 Jun 2023 07:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1685888785; x=1688480785;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HA5YrIYH9MawD+4VRjcWbjHM//DpBE3FGKspT1TvJ+c=;
        b=CcQtwON+W3n7y7rA9m3IbuMZf1gq/6rWVzSIyiMZaJ9Vp4L7cwZl7Eptdo7f5/JYrH
         VY96BmCnZdcD+JuKrA0Kjp42bz0LLhrV3VQlkDWcACaWtSQ2lb+QUxFB38AQn87H3lTj
         U+n4Q9vvxFpFS30gxqxlMKuZ5R50iQVSLSHXU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685888785; x=1688480785;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HA5YrIYH9MawD+4VRjcWbjHM//DpBE3FGKspT1TvJ+c=;
        b=NGaR1jjJnSiWP6Q52XBfcxPfJELV6YNxK79PLve1jyTcK2b0hkDS7fwh/N6aLXtWri
         xa8GlfbN2m1zxhCLegZ2ZiqZYFFhqASBaRQUFXDb42GwIHPjTkt+alOMT2hTPaYP5cHd
         Wir/N5jvCDoLgTyZyFZfdzmn2kt3G8edSxwFqUbG8SeqDRr0F13wAfrPfkowR37xFTce
         IqCgEp8H2TFubEHhhT2v/LYcNNcVZNj81n3DpMRRX/l7GdPLy/Vsh6A+BjqUn1GHCzGz
         Q5YIAJaVpTiyZ6C2uQvzfRVNUm0JHgVE+lLKjNnpyB3G+MO7xoCf995oF+A3M3n0AdE7
         1jfw==
X-Gm-Message-State: AC+VfDxpoMdLAy5h64Yt/AIpvbkvor0CjPf7KGc3swP8z53j250/G+90
	MVacmSYzyiqx+/2tCmH1V3WFfQ==
X-Google-Smtp-Source: ACHHUZ5L7kPdWHNyYrkbAXFw/Ud0NVHz/4s8+yRhJJX2mlG+9wCBm0pRDUZD3gxZ8iMp5wqgAPDJQQ==
X-Received: by 2002:a05:6a20:158b:b0:10c:4c76:e909 with SMTP id h11-20020a056a20158b00b0010c4c76e909mr1573877pzj.8.1685888784842;
        Sun, 04 Jun 2023 07:26:24 -0700 (PDT)
Received: from 80e1dc6c40da ([122.199.31.3])
        by smtp.gmail.com with ESMTPSA id h6-20020a62b406000000b00637b0c719c5sm3657475pfn.201.2023.06.04.07.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 07:26:23 -0700 (PDT)
Date: Sun, 4 Jun 2023 14:26:12 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johan Hovold <johan@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Petr Pavlu <petr.pavlu@suse.com>, gregkh@linuxfoundation.org,
	rafael@kernel.org, song@kernel.org, lucas.de.marchi@gmail.com,
	christophe.leroy@csgroup.eu, peterz@infradead.org, rppt@kernel.org,
	dave@stgolabs.net, willy@infradead.org, vbabka@suse.cz,
	mhocko@suse.com, dave.hansen@linux.intel.com,
	colin.i.king@gmail.com, jim.cromie@gmail.com,
	catalin.marinas@arm.com, jbaron@akamai.com,
	rick.p.edgecombe@intel.com, yujie.liu@intel.com, david@redhat.com,
	tglx@linutronix.de, hch@lst.de, patches@lists.linux.dev,
	linux-modules@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pmladek@suse.com, prarit@redhat.com,
	lennart@poettering.net, imre.deak@intel.com
Subject: Re: [PATCH 2/2] module: add support to avoid duplicates early on load
Message-ID: <ZHyfBLbZCE4cUMdV@80e1dc6c40da>
References: <CAHk-=wiPjcPL_50WRWOi-Fmi9TYO6yp_oj63a_N84FzG-rxGKQ@mail.gmail.com>
 <6gwjomw6sxxmlglxfoilelswv4hgygqelomevb4k4wrlrk3gtm@wrakbmwztgeu>
 <CAHk-=whu8Wh4JP1hrc80ZvGgVW4GV6hw1vwzSiwOo9-1=Y1dWw@mail.gmail.com>
 <ZG/a+nrt4/AAUi5z@bombadil.infradead.org>
 <CAHk-=whiXzqprmQNRui3LbKQwvM8fg4nyAzWcU5qZs+kxBVzrA@mail.gmail.com>
 <ZHRpH-JXAxA6DnzR@hovoldconsulting.com>
 <CAHk-=wh6sXSO63kka+EWEqq0tGwtOnXYFWMXPQ6T_wZa+Np3MQ@mail.gmail.com>
 <ZHSeOUpKtyc8VKx5@hovoldconsulting.com>
 <ZHTCK2_1pF61yWIr@hovoldconsulting.com>
 <CAHk-=wg7ihygotpO9x5a6QJO5oAom9o91==L_Kx-gUHvRYuXiQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wg7ihygotpO9x5a6QJO5oAom9o91==L_Kx-gUHvRYuXiQ@mail.gmail.com>

On Mon, May 29, 2023 at 09:55:15PM -0400, Linus Torvalds wrote:
> On Mon, May 29, 2023 at 11:18 AM Johan Hovold <johan@kernel.org> wrote:
> >
> > I took a closer look at some of the modules that failed to load and
> > noticed a pattern in that they have dependencies that are needed by more
> > than one device.
> 
> Ok, this is a "maybe something like this" RFC series of two patches -
> one trivial one to re-organize things a bit so that we can then do the
> real one which uses a filter based on the inode pointer to return an
> "idempotent return value" for module loads that share the same inode.
> 
> It's entirely untested, and since I'm on the road I'm going to not
> really be able to test it. It compiles for me, and the code looks
> fairly straightforward, but it's probably buggy.

The updated patches fix the issue experienced with 6.4-rc4 where the Intel
NUC12 booted fine, but on media playback resulted in the video stuttering,
then freezing - and that audio was not coming though.

# diff modules-rc4 modules-rc4-patched
< snd_hda_codec_hdmi     77824  0
< snd_hda_codec_realtek   159744  0
---
> snd_hda_codec_hdmi     77824  1
> snd_hda_codec_realtek   159744  1

 Revert "module: error out early on concurrent load of the same module file"
 module: split up 'finit_module()' into init_module_from_file() helper
 modules: catch concurrent module loads, take two
 Johan's fix:
  -static struct spinlock idem_lock;
  +static DEFINE_SPINLOCK(idem_lock);

Tested-by: Rudi Heitbaum <rudi@heitbaum..com>
