Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8757A
	for <patches@lists.linux.dev>; Wed, 23 Mar 2022 02:08:29 +0000 (UTC)
Received: by mail-lf1-f42.google.com with SMTP id w27so395464lfa.5
        for <patches@lists.linux.dev>; Tue, 22 Mar 2022 19:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J8R5fIKIW6T8IIqFMnxqRAyAbWLACxuZ0qCUQR/pgGY=;
        b=Eq6BQka4f8LYxS/Tno67bSzUoi2mPqlP+glM7TxOjfAPhoCdKuboSnQmWForCK/G5Q
         uvSWbW9LGbfwRAbIk2bphRZ9Qq8tpiA45DZWZTzPG6mPJUagHr2/7r5uPM6LolhND+kx
         ws/mB3u/w9v98tgrtujz3csM3dx0hX8Bmi0fQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J8R5fIKIW6T8IIqFMnxqRAyAbWLACxuZ0qCUQR/pgGY=;
        b=uL9gAxve1PIWBlS7rJo9HZqaHNAdwB5COKQflvvq6AMJYrzNLFRDhHY+o7tzHvnbnC
         XVLArcgVMIOt30oLRlw9hNYBKVNETaySkhAm4ogRazDPUgqVgFb0MQ/waYlVaq1E7t9i
         j/0UL8qraqlDohn+qxI0Z+tbBBFWyGf3WWsxIrTo4ivJtST3y/1uuEHaljKhRbRoT0kA
         qaoXOZUoX1DzWN5DVSeSHfGtD7qwRFRm75y0xmAMOXqu9Q8z8mQJjSmmyQ3wv3wt5W4x
         3/OpiwsadVVvc78whxyusJ+eQjSIdjb4JkXYYZXKfdYOi8LgUbVDHVOaupjQcGS7USlD
         Bsxw==
X-Gm-Message-State: AOAM531yMcBpXU6VW1jfPLfbCxrBkHTea6RNa4tGwBFyuiM0qoAZTGD6
	df0rJTABYlYpVDq+hNZFnTnqnZzqxTgJoPpDBdE=
X-Google-Smtp-Source: ABdhPJzy8UGA9JIXl0D5GmoIU4F0BKs17sqYrlERS5w/Kan8kE4M7wVlevj+v3M+yZPSkdJIFs586A==
X-Received: by 2002:ac2:5085:0:b0:448:33ff:5b94 with SMTP id f5-20020ac25085000000b0044833ff5b94mr20253727lfm.564.1648001307567;
        Tue, 22 Mar 2022 19:08:27 -0700 (PDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id c3-20020a056512104300b0044a3582c9ecsm614966lfb.219.2022.03.22.19.08.24
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 19:08:25 -0700 (PDT)
Received: by mail-lj1-f181.google.com with SMTP id q14so48964ljc.12
        for <patches@lists.linux.dev>; Tue, 22 Mar 2022 19:08:24 -0700 (PDT)
X-Received: by 2002:a2e:9794:0:b0:249:8488:7dbd with SMTP id
 y20-20020a2e9794000000b0024984887dbdmr9591965lji.176.1648001304369; Tue, 22
 Mar 2022 19:08:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
 <20220322214648.AB7A1C340EC@smtp.kernel.org> <Yjpo2jnp5pkJr+XI@google.com>
In-Reply-To: <Yjpo2jnp5pkJr+XI@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 22 Mar 2022 19:08:08 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiLMM1QJfmosoY3+Ah79_Oga8=EzUZnR8AoTRBUZGSfoA@mail.gmail.com>
Message-ID: <CAHk-=wiLMM1QJfmosoY3+Ah79_Oga8=EzUZnR8AoTRBUZGSfoA@mail.gmail.com>
Subject: Re: [patch 163/227] mm: madvise: skip unmapped vma holes passed to process_madvise
To: Minchan Kim <minchan@kernel.org>, Charan Teja Kalla <quic_charante@quicinc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, stable <stable@vger.kernel.org>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, David Rientjes <rientjes@google.com>, 
	Nadav Amit <nadav.amit@gmail.com>, Michal Hocko <mhocko@suse.com>, patches@lists.linux.dev, 
	Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Mar 22, 2022 at 5:25 PM Minchan Kim <minchan@kernel.org> wrote:
>
> I thought it was still under discussion and Charan will post next
> version along with previous patch
> "mm: madvise: return correct bytes advised with process_madvise"
>
> https://lore.kernel.org/linux-mm/7207b2f5-6b3e-aea4-aa1b-9c6d849abe34@quicinc.com/

Hmm. It's merged now, as commit 08095d6310a7.

So any fixes please do it on top of that existing state ;(

            Linus
