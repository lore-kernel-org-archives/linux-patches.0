Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979A429AC
	for <patches@lists.linux.dev>; Wed, 25 May 2022 23:07:44 +0000 (UTC)
Received: by mail-ed1-f54.google.com with SMTP id er5so28772701edb.12
        for <patches@lists.linux.dev>; Wed, 25 May 2022 16:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rhZHhPtlN8R7i0B/YpUEdtpRE1Mi/VoabZq2hM6NjXc=;
        b=bVsV616n58twV6qsTo0cPivFx66Vcij9oJRcp2WH1X5FqI/MZDHKuyhjdX5C6ec689
         sjIkBbCkPRBJfJcC29/ryFx96LBch0w/XUKGov4IHTlIVeMLQ8TjfzfI5fWoJ3pg6Y9S
         5u4MuYVRSOFInddt6Aqu6XCXrnqbOEbHeuiNM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rhZHhPtlN8R7i0B/YpUEdtpRE1Mi/VoabZq2hM6NjXc=;
        b=2wO5J8xIw3G4E7hijxoVQ2ArrnhkXWW0Ae0zyBKQUDNBkxFgFi9Fq2hDfrkhwKwpgI
         SwXEth/OeOp5LFHQ8+fPwSc2QCTMzMA94vNMGfANnsB3y9Xdry1pnx64bnEyXndyYBbT
         1SaKXtLspfh0wivGYZAOSKMfZfTtRAsD+Dx8KNnpVp+Zx5ALe/yZUg+cURlV1ZPNUpB7
         xmfrZYws/xT7ZNCRRbFjp+t1Ikgn45vdpd63YgbvzEH/sfbQ6EZ+vxtYrdvYkqYJMxqB
         1PBKxAyX+nKvOM1ncr/6N4wBgpS3UjsLnB1uEbn4BrjCcrbYjNJ6ZhUJJ0Evq2nvrb9c
         IWJw==
X-Gm-Message-State: AOAM531Ml6WVRXQWIoqx90V8nsuqlayYG9QTtcplo12JrTCNjvftC125
	NpUSHe3kBlcK4DUk9AZrg5vNObjzAs9+nbtDCzg=
X-Google-Smtp-Source: ABdhPJzF81MjXyXKD6r/+EX5yamG/4EaxSnWTYqstHdVuhX5ZLqIsyAKJgz45SGmhJOBVA5Jr+y7tg==
X-Received: by 2002:a05:6402:a42:b0:42b:c5e9:1495 with SMTP id bt2-20020a0564020a4200b0042bc5e91495mr6660310edb.323.1653520062183;
        Wed, 25 May 2022 16:07:42 -0700 (PDT)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com. [209.85.221.47])
        by smtp.gmail.com with ESMTPSA id j21-20020a170906105500b006f3ef214dbesm8411181ejj.36.2022.05.25.16.07.41
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 16:07:41 -0700 (PDT)
Received: by mail-wr1-f47.google.com with SMTP id k30so53720wrd.5
        for <patches@lists.linux.dev>; Wed, 25 May 2022 16:07:41 -0700 (PDT)
X-Received: by 2002:a5d:59ac:0:b0:20e:6fd6:88c1 with SMTP id
 p12-20020a5d59ac000000b0020e6fd688c1mr26524571wrr.442.1653520060789; Wed, 25
 May 2022 16:07:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <8062f61e-5a4d-00a5-be1a-7921d3277e9d@suse.cz> <CAHk-=wiztQWhEw4tLiH3t5gw=gKB7XtoTXC=S2bhxBxoxOVZLw@mail.gmail.com>
 <6cdbe746-2c6f-f698-11d4-9f86d2c4e5cc@suse.cz> <CAHk-=wjC5nS+fnf6EzRD9yQRJApAhxx7gRB87ZV+pAWo9oVrTg@mail.gmail.com>
 <af059855-959f-95b8-afc4-fad97e52cb46@suse.cz>
In-Reply-To: <af059855-959f-95b8-afc4-fad97e52cb46@suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 25 May 2022 16:07:24 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjDNR5MxVXk17FjXJApUY5e7GWZGUe7t4e98RJALooXDA@mail.gmail.com>
Message-ID: <CAHk-=wjDNR5MxVXk17FjXJApUY5e7GWZGUe7t4e98RJALooXDA@mail.gmail.com>
Subject: Re: [GIT PULL] slab for 5.19
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, May 25, 2022 at 3:01 PM Vlastimil Babka <vbabka@suse.cz> wrote:
>
> Yes, running rcutorture will trigger that stackdepot allocation, but as
> that's in RCU debugging part of config, I considered it in the same
> category as enabling slub debugging.

Yeah, I don't think rcutorture is a problem per se, it was more an
example of a random interaction that doesn't actually seem to make
much sense.

As far as I can tell, there is nothing in rcutorture that actually
wants that stack trace, and it seems to be doing just a test of the
object dumping working.

So it was more the oddity and randomness of it that made me go
"Whaah?" There might be others hiding elsewhere, that rcutorture use
just  happened to use the flag explicitly.

             Linus
