Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CD07C
	for <patches@lists.linux.dev>; Thu, 26 May 2022 10:50:20 +0000 (UTC)
Received: by mail-io1-f49.google.com with SMTP id d198so1136150iof.12
        for <patches@lists.linux.dev>; Thu, 26 May 2022 03:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TC+g0nLAl/Vtki0o8V8TPa4Q9UDxrM3TqOj5/L4+ixM=;
        b=YFtSfT1JENMX6vzmwrx9GUbDu6/VrDr0IVJXPX2gPnW/hjKdIBiu33pEJOVxzUsw3Q
         x8OLELh31z75OJ0Gr5ZVVXHB2/2YyzR17mKXIj2WitC/FOmbvyhKCbcsAnDL871UhB90
         1c9fp2OQkf/e129KebQgybN3Uf+sWJu2myQSYcc+LGU45Sy4xQH5ntgeP3HOB+7lyVkZ
         w08YnDMYmP4ap7DT4XwMf5rlSSlldPalKvbouARLM3j7BClrRqllsKQ+d07rEwMZsAHW
         EQhnlZso+cIP/G8XyqToiCG3T0cYvIJEJXvlE/PWFHx9/+kCow1npxzOtkSXD89wQtbg
         a+kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TC+g0nLAl/Vtki0o8V8TPa4Q9UDxrM3TqOj5/L4+ixM=;
        b=SjE0hjjWBcOLKasuklo5sqdWZzmSW51Mic1+k6bJTgXrrY2jAgXYqniV21p/s5BGEv
         BsxFEGRpiY1e8TCxiSihSz+3tYntSkkxp7xpV/v45I55spFWJD/E8fIACXqDSoPHhiYu
         jcVSmbre1E6uFiHou8pNmccOCNvUJ1+Lo8doaaU8RvRjRZYW/H61RyVVM8F56yjXRwRb
         6gRPijRAX64sHWKwDdsNkTjNfKyZU7MXzzGc4PGZt+qr/pse6hXPbihQrQgHzkTkDzD0
         bGEH5AXIVC5fql6HM1hFLa8t/BU9Hj/Mx0ig9RsPwt7kDataC3v7oYvtQs72fazGg/CT
         7p9A==
X-Gm-Message-State: AOAM53253JMH2MbpGDrykIGHM1FeAuQ1mWLFEwh/1DdTC66q3VJ35U15
	pcKkoOkYk4NtI8OZbnFjRJY=
X-Google-Smtp-Source: ABdhPJwUpV2a90iS2PiXgiTesfBKCL+xwb8RUX/N5sKCYXvl4cOcQJr9lDj9vqIttu3IQmrFrI3nxQ==
X-Received: by 2002:a05:6638:1c13:b0:32e:c1d:a790 with SMTP id ca19-20020a0566381c1300b0032e0c1da790mr18978604jab.43.1653562219209;
        Thu, 26 May 2022 03:50:19 -0700 (PDT)
Received: from n2.us-central1-a.c.spheric-algebra-350919.internal (151.16.70.34.bc.googleusercontent.com. [34.70.16.151])
        by smtp.gmail.com with ESMTPSA id m1-20020a923f01000000b002d11397f4f9sm409593ila.74.2022.05.26.03.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 03:50:18 -0700 (PDT)
Date: Thu, 26 May 2022 10:50:17 +0000
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Alexander Potapenko <glider@google.com>
Subject: Re: [GIT PULL] slab for 5.19
Message-ID: <Yo9baUjgXqM63vSS@n2.us-central1-a.c.spheric-algebra-350919.internal>
References: <8062f61e-5a4d-00a5-be1a-7921d3277e9d@suse.cz>
 <CAHk-=wiztQWhEw4tLiH3t5gw=gKB7XtoTXC=S2bhxBxoxOVZLw@mail.gmail.com>
 <6cdbe746-2c6f-f698-11d4-9f86d2c4e5cc@suse.cz>
 <CAHk-=wjC5nS+fnf6EzRD9yQRJApAhxx7gRB87ZV+pAWo9oVrTg@mail.gmail.com>
 <af059855-959f-95b8-afc4-fad97e52cb46@suse.cz>
 <CAHk-=wjDNR5MxVXk17FjXJApUY5e7GWZGUe7t4e98RJALooXDA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjDNR5MxVXk17FjXJApUY5e7GWZGUe7t4e98RJALooXDA@mail.gmail.com>

On Wed, May 25, 2022 at 04:07:24PM -0700, Linus Torvalds wrote:
> On Wed, May 25, 2022 at 3:01 PM Vlastimil Babka <vbabka@suse.cz> wrote:
> >
> > Yes, running rcutorture will trigger that stackdepot allocation, but as
> > that's in RCU debugging part of config, I considered it in the same
> > category as enabling slub debugging.
> 
> Yeah, I don't think rcutorture is a problem per se, it was more an
> example of a random interaction that doesn't actually seem to make
> much sense.

Creating cache with SLAB_STORE_USER is (currently) done in rcutorture.
SLAB_STORE_USER means "we're going to track every user of this slab
cache" so IMO it should not be done if not debugging.

Otherwise stackdepot will be used only when user passes slub_debug
boot parameter. 

> As far as I can tell, there is nothing in rcutorture that actually
> wants that stack trace, and it seems to be doing just a test of the
> object dumping working.

dumping an arbitrary object may call kmem_dump_obj(), which will dump
slab objects and thus printing where it was allocated.

> 
> So it was more the oddity and randomness of it that made me go
> "Whaah?" There might be others hiding elsewhere, that rcutorture use
> just  happened to use the flag explicitly.
> 
>              Linus

AFAIK only 1) creating cache with SLAB_STORE_USER or 2) passing
slub_debug make kernel allocate hash table for stackdepot.

This do not look that odd too me.

But I agree not asking size of hash table to user and by 1) using
rhashtables or 2) deciding size of hash table at runtime would be
better :)
