Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA29417C9
	for <patches@lists.linux.dev>; Fri, 26 May 2023 01:40:33 +0000 (UTC)
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2af1822b710so2056561fa.1
        for <patches@lists.linux.dev>; Thu, 25 May 2023 18:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685065231; x=1687657231;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mm58cdLmSJ5zDiAtA58RWN5FnFQJSGcvSIirliOWuIM=;
        b=hM86DWSSrWcI/RPc3GLJogtgReoZ8OSKtimvjFZX6uP/eQHyPF3IZSAsICSYIhRTWD
         qdTZl7Xqgffk+q70bYMwZR57LTQZkmuUCZye4RbORzO9Qn2Qqb4nUkmybl3drVTiLZ08
         zkMJdVIAC7jtYv2RvdaBnVv8BpqNV8EgYkFqk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685065231; x=1687657231;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mm58cdLmSJ5zDiAtA58RWN5FnFQJSGcvSIirliOWuIM=;
        b=J1x3yaoIFDdJKNbAebbAJTTTdHLICfiW5ZMd0AMrelNEDbucjNbBeAYRfSn6s6jwtr
         PqBCOcEwgamH3zHjmvVCaapjNEIyxBApLzjoJxiCHovPL2z069j6b1vWD5KzenwVkr4M
         cq54avjsj8mDDnzZyeFM+SLh7mh9THTxP/G1Up6HUSITg+GQxdYRZUQnh58ZPf/B6hcd
         PYJNKn9i66ktiBMbms43AT5/wR6oecc/nDv07EW2L448o6j0tBjZAkCvFz/TCn1E+HyG
         GCsKOfzS3sH7PWhnbq27y1VC/gXUNCn1iyVgFZ6UhoEAyXttdVOcMyjRIJVzs9FBY34a
         zI7A==
X-Gm-Message-State: AC+VfDwn/7IljNPKo8Blj/xkzd4XmP4tqshYJc+XpWIypimihTld+R4J
	0Rs0Ti9ANmphq1DB/3LHkPX3rVKj3Il0442Qhd5l+VCX
X-Google-Smtp-Source: ACHHUZ4w06Zi0hHeNmJ9ll5lMc6NFztjFzCVB4ET+KMAb1QTPnun3YH7Pws3/yHZreErW2W02ZJ+Hw==
X-Received: by 2002:a2e:888d:0:b0:2ac:78b0:8aef with SMTP id k13-20020a2e888d000000b002ac78b08aefmr116191lji.16.1685065231368;
        Thu, 25 May 2023 18:40:31 -0700 (PDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id w2-20020a2e3002000000b002ad96ba3760sm467546ljw.48.2023.05.25.18.40.30
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 May 2023 18:40:31 -0700 (PDT)
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2af30a12e84so2131141fa.0
        for <patches@lists.linux.dev>; Thu, 25 May 2023 18:40:30 -0700 (PDT)
X-Received: by 2002:a17:907:31c3:b0:96f:912d:7922 with SMTP id
 xf3-20020a17090731c300b0096f912d7922mr478321ejb.53.1685065209995; Thu, 25 May
 2023 18:40:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230524213620.3509138-1-mcgrof@kernel.org> <20230524213620.3509138-3-mcgrof@kernel.org>
 <8fc5b26b-d2f6-0c8f-34a1-af085dbef155@suse.com> <CAHk-=wiPjcPL_50WRWOi-Fmi9TYO6yp_oj63a_N84FzG-rxGKQ@mail.gmail.com>
 <6gwjomw6sxxmlglxfoilelswv4hgygqelomevb4k4wrlrk3gtm@wrakbmwztgeu>
 <CAHk-=whu8Wh4JP1hrc80ZvGgVW4GV6hw1vwzSiwOo9-1=Y1dWw@mail.gmail.com> <ZG/a+nrt4/AAUi5z@bombadil.infradead.org>
In-Reply-To: <ZG/a+nrt4/AAUi5z@bombadil.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 May 2023 18:39:52 -0700
X-Gmail-Original-Message-ID: <CAHk-=whiXzqprmQNRui3LbKQwvM8fg4nyAzWcU5qZs+kxBVzrA@mail.gmail.com>
Message-ID: <CAHk-=whiXzqprmQNRui3LbKQwvM8fg4nyAzWcU5qZs+kxBVzrA@mail.gmail.com>
Subject: Re: [PATCH 2/2] module: add support to avoid duplicates early on load
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>, Petr Pavlu <petr.pavlu@suse.com>, 
	gregkh@linuxfoundation.org, rafael@kernel.org, song@kernel.org, 
	lucas.de.marchi@gmail.com, christophe.leroy@csgroup.eu, peterz@infradead.org, 
	rppt@kernel.org, dave@stgolabs.net, willy@infradead.org, vbabka@suse.cz, 
	mhocko@suse.com, dave.hansen@linux.intel.com, colin.i.king@gmail.com, 
	jim.cromie@gmail.com, catalin.marinas@arm.com, jbaron@akamai.com, 
	rick.p.edgecombe@intel.com, yujie.liu@intel.com, david@redhat.com, 
	tglx@linutronix.de, hch@lst.de, patches@lists.linux.dev, 
	linux-modules@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pmladek@suse.com, prarit@redhat.com, 
	lennart@poettering.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 25, 2023 at 3:02=E2=80=AFPM Luis Chamberlain <mcgrof@kernel.org=
> wrote:
>
> So yeah definitely a pretty good improvement. Sometimes the system boots
> without any duplicates at all, for some reason Vs the previous attempt.
>
> Tested-by: Luis Chamberlain <mcgrof@kernel.org>

Ok, I decided to just move it from my experimental tree to my main tree.

I think I used about three times the time and effort (and lines of
text) on writing the commit message compared to what I did on the
patch itself.

I tried to lay out the background and the implications of the change -
it may be pretty darn simple, but it does have some subtle issues.

Anyway: I've committed it to my tree. This is not necessarily the best
time to do that, but let's get this behind us, and in particular,
let's get it out and into wider testing asap.

If it causes any problems what-so-ever, I'll just revert it very
aggressively (unless the problem is trivially and obviously fixable).
It is, after all, not a fix for a _kernel_ bug per se, and whil eI
think the patch is very benign, it does change user-visible behavior.
Very intentionally so, but still..

                         Linus
