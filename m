Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278E515CE
	for <patches@lists.linux.dev>; Fri, 28 Apr 2023 02:54:09 +0000 (UTC)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-94f3df30043so1515840766b.2
        for <patches@lists.linux.dev>; Thu, 27 Apr 2023 19:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1682650447; x=1685242447;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/9mxxPAl4POq2fq0d8t6aqpR8L52uoUsixYLH2L9aFc=;
        b=gVr7G68nDrSh0Mm8XFg00vgUBfCAEBsm+kBDZ6P2d/L3Go4V19Aec1suNiJ2VDMl4a
         NC//cawahRxIQyl707Nwom4+1A1RhV2GpO/XSsIxz5nFODPCXoF0mxYmWyNW/oJNrQUG
         lEX7cDfl2BDYrMP3hbQsVenPmN2vzJMOvESpw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682650447; x=1685242447;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/9mxxPAl4POq2fq0d8t6aqpR8L52uoUsixYLH2L9aFc=;
        b=R4QxebqHdworxOq4+w852AyDmAOTN+PJWgptxddCC2kZ5a4X/Az5sUScEF9U+udJaD
         SezzcEPhkgin1wjBMiFo4TAVa3ocXeLua3+BGFaoStY4tci+PjzYp9QmFVB2zI/fUteu
         Z49YklvK0Z14TcUMhYj/YGfEzX/iJVMfquc8QWc9utdemhn1jLU5VV8ktsoAPCp5fBUv
         r4Eetc3kK2IkeTLH3ROWwIW2lmfa4kXON1cZhygNt+9S2610btytWWLInFKoG92Z3PrB
         q9zRkPVVV2iTrSA3XNtGLuAF9nd35kZ0UkfxKspgsvcvnD/6HyMsgTLsPoZSIJ88tjI1
         NxZw==
X-Gm-Message-State: AC+VfDzU9/t3K48fGNQ2LjtpneX0Lntd6QBtVNAka/TR9HCJ2u+qD6oR
	HeFrDuFzcE9X+ucz1m4AsMcg/MY6zmwiSYI7Kjf7IQ==
X-Google-Smtp-Source: ACHHUZ7p1z68chzGWQZpy+S4oQgnW34ZMuZkMbFZujQX81arbkLWeBuhQXhiQp6du86QVy6+hssu6Q==
X-Received: by 2002:a17:907:961e:b0:95f:1359:84ae with SMTP id gb30-20020a170907961e00b0095f135984aemr4617047ejc.55.1682650447063;
        Thu, 27 Apr 2023 19:54:07 -0700 (PDT)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com. [209.85.208.52])
        by smtp.gmail.com with ESMTPSA id m5-20020a170906848500b0094ef96a6564sm10409128ejx.75.2023.04.27.19.54.05
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 19:54:05 -0700 (PDT)
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5055141a8fdso13503979a12.3
        for <patches@lists.linux.dev>; Thu, 27 Apr 2023 19:54:05 -0700 (PDT)
X-Received: by 2002:a17:906:da8d:b0:94e:4586:f135 with SMTP id
 xh13-20020a170906da8d00b0094e4586f135mr3520975ejb.6.1682650445056; Thu, 27
 Apr 2023 19:54:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230427140959.27655-1-vbabka@suse.cz> <2023042719-stratus-pavestone-505e@gregkh>
 <3cc6e10c-f054-a30a-bf87-966098ccb7bf@suse.cz> <CAHk-=wgdGzy6-3jzN6Kvtz1QxStTZBZPz1zy9i4gM9nbe5FGbA@mail.gmail.com>
In-Reply-To: <CAHk-=wgdGzy6-3jzN6Kvtz1QxStTZBZPz1zy9i4gM9nbe5FGbA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 27 Apr 2023 19:53:48 -0700
X-Gmail-Original-Message-ID: <CAHk-=whwoKFbrCGXW9uwX3SPOezLdOKstuLAju1KTi5Ryq+ZcQ@mail.gmail.com>
Message-ID: <CAHk-=whwoKFbrCGXW9uwX3SPOezLdOKstuLAju1KTi5Ryq+ZcQ@mail.gmail.com>
Subject: Re: [PATCH for v6.3 regression] mm/mremap: fix vm_pgoff in
 vma_merge() case 3
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, lstoakes@gmail.com, regressions@lists.linux.dev, 
	linux-mm@kvack.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Jiri Slaby <jirislaby@kernel.org>, Fabian Vogt <fvogt@suse.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Vlastimil,

On Thu, Apr 27, 2023 at 8:12=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Ack. It's in my tree as commit 7e7757876f25 right now (not pushed out
> yet, will do the usual build tests and look around for other things
> pending).

Gaah. I just merged Andrew's MM tree, and while it had a lot of small
conflicts (and the ext4 ones were annoying semantic ones), the only
one that was in *confusing* code was the one introduced by this
one-liner fix.

I'm pretty sure I did the right thing, particularly given your other
patch for the mm tree, but please humor me and take a look at it?

That 'vma_merge()' function is the function from hell.

I haven't pushed out yet because it's still going through my build
tests, but it should be out soon.

                       Linus
