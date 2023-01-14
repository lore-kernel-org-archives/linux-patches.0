Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C357C
	for <patches@lists.linux.dev>; Sat, 14 Jan 2023 08:08:36 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id 20so12289984pfu.13
        for <patches@lists.linux.dev>; Sat, 14 Jan 2023 00:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lZpVju+c3esZJi64lpN19QBiN5Ioh9BTNl6Imk6TaQ8=;
        b=YDkbWirrjszTbCxF/w/+kgQBI26iQK/PpN2Pj1Xd/qpJUr7uC2C4Umt1nkDmVNgYL5
         +9EUfTmXyOCKO0w5Vcz+epHNUSG0dYzldYoPrNt3zofsDpl8OqfyLXstSE83vcrQrp/R
         fcm99IgQuqOctaqqAvPUkEpTaPp5ihSVcF/ltgxGCuOLMAeOpc9JFZP7zTl3f/iDX3ok
         EEdVj7+U+7o3c1Q/R59Vmm8ZK2QLM0qTgw68UfqgcYzLsF/pUDLgnctlcFqNdgVAXeih
         B5+mRish2KwjD7u7UO7r3lOyM9OmYRPjZefar17SYM27x2c0wZSnkvLu9kM7i5fUKwvs
         lRDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lZpVju+c3esZJi64lpN19QBiN5Ioh9BTNl6Imk6TaQ8=;
        b=TIhYfbtWsnOvuT5b3GUHOGx61h8+pcPPaX+aDqHHCTCswSrm9gOKWrimek/LYgzdO9
         jzEykXzWY+kcQHpF/v6K3AeZPvO+YnWfTShyNB+KaKIqyyLIVZ4WH/+5ZECXj3Mp35t1
         tFyVQBgFSwLw9C3G/SqnZ6wZayWyOzN/8fYcn94uS7AxKgCJbo6JMEhhqqwkWLDjsk67
         /H1J1h7e9Y3t77Psd8/MXmtH8qojMWztRzEmDgmfmwm997+/NTIeAXAYF4ILRTnZoObA
         AGCQ/UP6wEZjWxasJhCP5x/kag63VwDrhdx60LlP3HU0bOxuwndIc0Kje3DUqAnTIsBh
         ec2Q==
X-Gm-Message-State: AFqh2krVKqx2yjVH3Fm1ekVRMdAREu6psqW0FZQSSYKS+ma9Zve9cFkX
	tVPv3SIAWiUBUGp6DdNX/FszLEkofD8Je8ioVSw=
X-Google-Smtp-Source: AMrXdXsQsL3B/zYKPN9dUrbznfzAi6Xw7QwAsjh0FukLj4SuwnfW4cuGgva6gqrtIhvo+T9gnxMqe+jDFz37FYZX5gc=
X-Received: by 2002:a63:ee0f:0:b0:4a5:c88:55c2 with SMTP id
 e15-20020a63ee0f000000b004a50c8855c2mr2584926pgi.530.1673683715615; Sat, 14
 Jan 2023 00:08:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230113173345.9692-1-vbabka@suse.cz> <3e419e8e-cdd7-eaf5-0572-ae5c44d7b68e@suse.cz>
In-Reply-To: <3e419e8e-cdd7-eaf5-0572-ae5c44d7b68e@suse.cz>
From: Pedro Falcato <pedro.falcato@gmail.com>
Date: Sat, 14 Jan 2023 08:08:24 +0000
Message-ID: <CAKbZUD2SDT8afg9k2jOhXCU8W64j__1DGTcXNxbzS-=j+-4HPg@mail.gmail.com>
Subject: Re: [PATCH for 6.1 regression] Revert "mm/compaction: fix set skip in fast_find_migrateblock"
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, regressions@leemhuis.info, 
	Jiri Slaby <jirislaby@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Mel Gorman <mgorman@techsingularity.net>, Michal Hocko <mhocko@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Chuyi Zhou <zhouchuyi@bytedance.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, Jan 14, 2023 at 6:51 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>
> On 1/13/23 18:33, Vlastimil Babka wrote:
> > This reverts commit 7efc3b7261030da79001c00d92bc3392fd6c664c.
> >
> > We have got openSUSE reports (Link 1) for 6.1 kernel with khugepaged
> > stalling CPU for long periods of time. Investigation of tracepoint data
> > shows that compaction is stuck in repeating fast_find_migrateblock()
> > based migrate page isolation, and then fails to migrate all isolated
> > pages. Commit 7efc3b726103 ("mm/compaction: fix set skip in
> > fast_find_migrateblock") was suspected as it was merged in 6.1 and in
> > theory can indeed remove a termination condition for
> > fast_find_migrateblock() under certain conditions, as it removes a place
> > that always marks a scanned pageblock from being re-scanned. There are
> > other such places, but those can be skipped under certain conditions,
> > which seems to match the tracepoint data.
> >
> > Testing of revert also appears to have resolved the issue, thus revert
> > the commit until a more robust solution for the original problem is
> > developed.
> >
> > It's also likely this will fix qemu stalls with 6.1 kernel reported in
> > Link 2, but that is not yet confirmed.
> >
> > Link: https://bugzilla.suse.com/show_bug.cgi?id=1206848
> > Link: https://lore.kernel.org/kvm/b8017e09-f336-3035-8344-c549086c2340@kernel.org/
> > Fixes: 7efc3b726103 ("mm/compaction: fix set skip in fast_find_migrateblock")
> > Cc: <stable@vger.kernel.org>
>
> Oops, forgot:
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>
> > ---
> >  mm/compaction.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/mm/compaction.c b/mm/compaction.c
> > index ca1603524bbe..8238e83385a7 100644
> > --- a/mm/compaction.c
> > +++ b/mm/compaction.c
> > @@ -1839,6 +1839,7 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
> >                                       pfn = cc->zone->zone_start_pfn;
> >                               cc->fast_search_fail = 0;
> >                               found_block = true;
> > +                             set_pageblock_skip(freepage);
> >                               break;
> >                       }
> >               }
>

Vlastimil,

Thank you so much for looking into this. I've been daily driving it
for the past half day and it seems to have fixed my QEMU issues.
Of course, I don't have exactly a test suite for this but I've tried
everything and I can't get any of the original problems to show up.

That being said,
Tested-by: Pedro Falcato <pedro.falcato@gmail.com>

I'll report back if QEMU freezes the system again.

-- 
Pedro
