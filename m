Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CF1C944
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 21:21:08 +0000 (UTC)
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-54f21cdfadbso424554977b3.7
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 14:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681852867; x=1684444867;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qWdLrM8P5tKlvuJeK/CWoUbY/57OR2hY93j5YcDXvNw=;
        b=rIRTptJwMR9RNS5QlyMl2+kc/TA94WPxxo3f17+iyobEdC0e4rGfCX48D58F9wRJ6F
         si1gyr55NBY4UOviXN1eiHhiQaxYaHuCE5ioCUOVyPjoa+XkSyUu9t8L8sKz7wWAYekm
         zUYRulerwJQcUyMI4D+11I2DEmWz4gCwDJOkEc7MKuDG+DfQ7y0+dsiRfgCNNXmsyJKN
         FfZEw0TtwsR66InOJ0KmbpMkRLVFOFAg4qhbyP4RBveRx3xAkk8RGmBURRUscz64s/1u
         B2dmhngysNOAXtqHSsnNtwNy33v9E1TaHdNjoCQdIFR/tZbAX3SUBDDThd7CqDADtK7e
         iavg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681852867; x=1684444867;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qWdLrM8P5tKlvuJeK/CWoUbY/57OR2hY93j5YcDXvNw=;
        b=Zcvso60bYG8DDJhpb+PxGW49hT4e7hc/wlAvM1VMjTZqARNvOzgbyljECkv9ThYl6h
         U8yEzblMOTLcJwBVcSHisOhxlfYPrdCAsxwWGsEkJgBtLNpq7FdoMsYQ/iQsHYMuqvV8
         K19n2umVx8vZhwUoXFUlKE648BQaldAuRYUU0M0mBfjy+F9cJCAdAvPSmGxTIkKgFNN6
         c0DlxkzJszj3U+89UZfSgGNGo4wS0P257FeTVQnLL4cA5i0SAIpQ1CXusqbbSyhIfg+1
         2xRcOdLpP1DlYHvy4ZfM/MlSi7mpgiZ74oTsjpFcyzJpukZkrd/aGOZds0vcsFXOCKm6
         7N8Q==
X-Gm-Message-State: AAQBX9eVnHZZn/yXofqqUdJBytIVruab4nuXctzqcnbz2kL7NvD0mb/i
	jQrzBxqeMNAUoMOG/JUn5Jl7IQ==
X-Google-Smtp-Source: AKy350aPT69etndT9Y5DXnIKWAPOkeuFizCReXExgc8GViiHUiiYdlDYCcOditcCtgaKdDHGXYA48Q==
X-Received: by 2002:a0d:d597:0:b0:54e:f0d1:e3e5 with SMTP id x145-20020a0dd597000000b0054ef0d1e3e5mr1346873ywd.24.1681852867289;
        Tue, 18 Apr 2023 14:21:07 -0700 (PDT)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id l15-20020a81700f000000b0054629ed8300sm4054543ywc.80.2023.04.18.14.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 14:21:06 -0700 (PDT)
Date: Tue, 18 Apr 2023 14:20:55 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.attlocal.net
To: Luis Chamberlain <mcgrof@kernel.org>
cc: Hugh Dickins <hughd@google.com>, akpm@linux-foundation.org, 
    willy@infradead.org, brauner@kernel.org, linux-mm@kvack.org, 
    p.raghav@samsung.com, da.gomez@samsung.com, a.manzanares@samsung.com, 
    dave@stgolabs.net, yosryahmed@google.com, keescook@chromium.org, 
    patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
    David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v2 4/6] shmem: skip page split if we're not reclaiming
In-Reply-To: <ZD8HdxbwhUUGvmNC@bombadil.infradead.org>
Message-ID: <8afe1f7f-31a2-4fc0-1fbd-f9ba8a116fe3@google.com>
References: <20230309230545.2930737-1-mcgrof@kernel.org> <20230309230545.2930737-5-mcgrof@kernel.org> <cfaac1a4-20c6-bdd6-ff68-981e9a8858e@google.com> <ZD8HdxbwhUUGvmNC@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 18 Apr 2023, Luis Chamberlain wrote:
> On Mon, Apr 17, 2023 at 09:41:41PM -0700, Hugh Dickins wrote:
> > On Thu, 9 Mar 2023, Luis Chamberlain wrote:
> > 
> > > +	if (WARN_ON_ONCE(info->flags & VM_LOCKED))
> > > +		goto redirty;
> > 
> > Well, okay, I don't mind that.  But shall we take bets on how soon syzbot
> > (hope it's not watching) will try flipping SHM_LOCK on while swapping out
> > pages from a SHM segment, and hit that warning?  Perhaps I'm wrong, but I
> > don't think any serialization prevents that.
> 
> I though that may be the case. Would such serialization be welcomed?

Absolutely not!  We don't insert slowdowns just to avoid warnings,
unless the warning is of something that really matters.  This one
does not matter, the situation is correctly handled, so the warning
would be better reverted.  Though I personally don't mind you leaving
it in until the first report of it arrives.

Hugh
