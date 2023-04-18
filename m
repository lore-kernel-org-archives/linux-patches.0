Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27703A20
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 04:31:32 +0000 (UTC)
Received: by mail-yb1-f169.google.com with SMTP id n193so5590492ybf.12
        for <patches@lists.linux.dev>; Mon, 17 Apr 2023 21:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681792291; x=1684384291;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8t7utIVn1NZcTfXhQfNQOixZnM/sHw7ItMZQq+M8aPc=;
        b=Cz9/Rr66vJy1JpuaPb/lZt+BqnIAULlsh/bMEJz7lecp7j2/VqIYFP9lYDAXo/GSOe
         jXegQSsMedSgQT77EeJ2KmfvMzZN6Ljv1+TN3WRsPIfy+i2b79tjjoDydxB2muV0m95F
         TkPvSFKMkzafvTvvY78d+3eTyLdggNl0pJ/8IVftS/PK5rnOzysZHuDvNz2HHgSEmlTM
         IFQJtX1mLDjgI+uRRoYmhs70M5a/m3OoBKLn7JyDtPchNoL/b66Hu6xw8kf3RtaIiqXk
         vwbDlDQqWGfOs1MddFqSn7e1o1bZyRAEkBxq9S98SAthePpj17XI8RVCikHwVaPs+HYc
         nxOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681792291; x=1684384291;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8t7utIVn1NZcTfXhQfNQOixZnM/sHw7ItMZQq+M8aPc=;
        b=SYMgcmYBa8UPrRSfnPIiDhptLFaXuwQXI8sMXZGvLwk7GT9+V4+N6IqCrjuNKmAvK7
         q0LeiEko72EjC4UR2U7sWOvWvDBR3VdlgvBz1W2yi/IjvJCQIUqz0WmfF3ej8yh9p1aV
         JRLKzgxlGqZfpvYnEefK13qbgDI8gdNz46ax1bRb0fjZ+DdXmM9fMgYl8n1jwY/UlUK6
         q7h5faOW5aL83T6GP1i37N0ESYn4QlrpcNfcTcIZbJ4K8s+5XuX1JNelI5hPDrZixOPo
         mW/ksNpaflItnuk2orVsAcdn2JrMrKqp6vwml/PR0Mf+cvG10U2LK7O2pss2TI9QIpNq
         7cfQ==
X-Gm-Message-State: AAQBX9eilN74lgGAJNCzGlyuhH0C1PNmK25PrDq7Kmj5T2IAuu+/jg4/
	9Nz4rtzxQYe3Y6ryrTrX0sBfRQ==
X-Google-Smtp-Source: AKy350bkagPcqZa3+5HDiDrj30dc80d8tI3FGCtUz+bHwJx733EmHG6BEvt4HtTfYB6l5+wXa/Zlqg==
X-Received: by 2002:a25:e706:0:b0:b8f:44bc:c4f9 with SMTP id e6-20020a25e706000000b00b8f44bcc4f9mr15495368ybh.32.1681792290910;
        Mon, 17 Apr 2023 21:31:30 -0700 (PDT)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 185-20020a2506c2000000b00b8f2d726471sm3464611ybg.3.2023.04.17.21.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 21:31:30 -0700 (PDT)
Date: Mon, 17 Apr 2023 21:31:20 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.attlocal.net
To: Luis Chamberlain <mcgrof@kernel.org>
cc: hughd@google.com, akpm@linux-foundation.org, willy@infradead.org, 
    brauner@kernel.org, linux-mm@kvack.org, p.raghav@samsung.com, 
    da.gomez@samsung.com, a.manzanares@samsung.com, dave@stgolabs.net, 
    yosryahmed@google.com, keescook@chromium.org, patches@lists.linux.dev, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] tmpfs: add the option to disable swap
In-Reply-To: <20230309230545.2930737-1-mcgrof@kernel.org>
Message-ID: <3382819f-4a4-8622-5642-78c03ecfb878@google.com>
References: <20230309230545.2930737-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Thu, 9 Mar 2023, Luis Chamberlain wrote:

> I'm doing this work as part of future experimentation with tmpfs and the
> page cache, but given a common complaint found about tmpfs is the
> innability to work without the page cache I figured this might be useful
> to others. It turns out it is -- at least Christian Brauner indicates
> systemd uses ramfs for a few use-cases because they don't want to use
> swap and so having this option would let them move over to using tmpfs
> for those small use cases, see systemd-creds(1).

Thanks for your thorough work on tmpfs "noswap": seems well-received
by quite a few others, that's good.

I've just a few comments on later patches (I don't understand why you
went into those little rearrangements at the start of shmem_writepage(),
but they seem harmless so I don't object), but wanted to ask here:

You say "a common complaint about tmpfs is the inability to work without
the page cache".  Ehh?  I don't understand that at all, and have never
heard such a complaint.  It doesn't affect the series itself (oh, Andrew
has copied that text into the first patch), but please illuminate!

Thanks,
Hugh
