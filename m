Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58A73216
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 21:40:23 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id f10so268062plr.6
        for <patches@lists.linux.dev>; Tue, 05 Apr 2022 14:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=/v6MKITyj/7SAzMcTXcAwa1zUE4C9+wVBGJFdG8EEDE=;
        b=dMZUydk4BKA2ZeYjg1PSrdz2fBoVyivYvhTiBoIV9Mr2TlcJDNYVyntFb40XA1gQYB
         eM+njiTLhPUe5RcXcs5RnVyiBlIFBeUe6tcbTu83MTGNM4XE375eEkP2Jvw8ohfpY3XM
         kvwgJxX1VtRaQsPeBaN1LozUCYLkXHpchiKzCw/sK1o9GdOvYl1s0hoC61wST+pSs6kn
         DtH1bIaqUuFEmKskIBaWDJOGR8tXtZfKAHe/N5YjK3NqzLbVCjfrxW6mOEAVjc9VuZYt
         WnHG0LZOTnGEDjMHEeK2zQ13LuYSsjHhUUUM30Jj4bqc3YJ7mhAQkGpW1q6F0hgYSCTd
         q9Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=/v6MKITyj/7SAzMcTXcAwa1zUE4C9+wVBGJFdG8EEDE=;
        b=l5OppoJfkBlY82lYW/G3aMmOfEj4vMPdDaEf/9gtzQ4iwHZ8l1gfiVgzI0luQFwvoX
         dlglsOfvLFAXdzS5w6n7+7H7TdTq8QT35UFXLgz9yLeUrr3kHcB6NkEhgHvee2Xuzz8T
         rNBTbBP/CbMQYxKniMBv+FOQ3JAg0cSautqLvbvsaBs2jFqFqcEfIlB8NM+9AMAKI/fS
         T7oDsNjm9u/6XlIeBi41bBT4Oooz+LThJ+eYdYTpONnN8Ezym7qtqiudeP4QQuk0abJ4
         hkhd8tXckmwzaTyJgcy8puMbHFD0/aZRL8mcnYoPAK50wA/gSDs2oBh1gLbbvSz+p4NB
         2o6Q==
X-Gm-Message-State: AOAM532xrD2M/sfAj0qaSDk+JDw0VyUrdQ1Bp7K1dfSQTR588NQ9gCky
	Jl7cv13s2Lr851cvO7q3odZUmg==
X-Google-Smtp-Source: ABdhPJxJC/R0lJ9hIIlMX047W4yaxdR92GjHCZrTF7CLNQHhTZByKUAE/BPyRg7wZqj8mUY+XULNIg==
X-Received: by 2002:a17:90b:3802:b0:1c6:905c:af2e with SMTP id mq2-20020a17090b380200b001c6905caf2emr6287692pjb.236.1649194822900;
        Tue, 05 Apr 2022 14:40:22 -0700 (PDT)
Received: from [2620:15c:29:204:be3e:5e1c:99cc:513f] ([2620:15c:29:204:be3e:5e1c:99cc:513f])
        by smtp.gmail.com with ESMTPSA id a9-20020aa78649000000b004fe3d6c1731sm3693466pfo.175.2022.04.05.14.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 14:40:22 -0700 (PDT)
Date: Tue, 5 Apr 2022 14:40:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Vlastimil Babka <vbabka@suse.cz>
cc: Christoph Lameter <cl@linux.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
    Pekka Enberg <penberg@kernel.org>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
    patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
    Oliver Glitta <glittao@gmail.com>, Marco Elver <elver@google.com>, 
    Mike Rapoport <rppt@linux.ibm.com>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, 
    Imran Khan <imran.f.khan@oracle.com>
Subject: Re: [PATCH v3 5/6] mm/slub: sort debugfs output by frequency of
 stack traces
In-Reply-To: <20220404164112.18372-6-vbabka@suse.cz>
Message-ID: <cb22b4b-4ec-90da-6820-f62e431791a@google.com>
References: <20220404164112.18372-1-vbabka@suse.cz> <20220404164112.18372-6-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 4 Apr 2022, Vlastimil Babka wrote:

> From: Oliver Glitta <glittao@gmail.com>
> 
> Sort the output of debugfs alloc_traces and free_traces by the frequency
> of allocation/freeing stack traces. Most frequently used stack traces
> will be printed first, e.g. for easier memory leak debugging.
> 
> Signed-off-by: Oliver Glitta <glittao@gmail.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-and-tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>
