Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD22168
	for <patches@lists.linux.dev>; Tue, 14 Dec 2021 14:59:46 +0000 (UTC)
Received: by mail-qv1-f47.google.com with SMTP id m17so17437475qvx.8
        for <patches@lists.linux.dev>; Tue, 14 Dec 2021 06:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=you/HNG4TZF+v+WKwgjsAzsKRqVZeoHuBuYViT+/dLo=;
        b=1OmgDUPhOzz+xnmwqNkqxJLq32MqX28qZAHkeLUP5xIh/Iy40cV2PfECn/O4+zQqK8
         L0qIocd2YtB9TO5dd3b7R0t2ilUv5ERIJoKTqY1I2ZMoy4Shb8KIJv4Y53/eVlgzDqIS
         HQFLbAACVrAt0/FgmQWg3/v0jOKeqFI5HVd8wigbcsnsUUSYWm3QZOKVfFzvRxfT1j0A
         ls03VmuNE9BGkx60wWvK83782eJVTUwnGpIf3rcXQfa/0iYBHm/euRy6L7UUuN8XWX6M
         qC9iS7ZMX6THwB3oTqlFwd3+AgW1p8fj4nEOTGIHNAQylIkKNhveyp05dU6F7Tw3EBSC
         tudQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=you/HNG4TZF+v+WKwgjsAzsKRqVZeoHuBuYViT+/dLo=;
        b=wKLrUY2wgXpK2SzxPPNPYgg47mA6t4+FLe+CzJAScADNbYuyb2Eh79c50UUSbhguNu
         bUdzfoyUHSE8YYMOg7OMHQ87Sca1Wd+xXrp9a1jAD8qKsSyVjSQmSnnLysCY71JLvLFx
         PVrNPDgOn3uwbs0rxtcy8eZjhil20Fqf/w4z0a61jTpkUvV9ciXOKYsmT5wgWnlpqW99
         OXpclAEa9DkNhI0/DHba0ZflRVOTtnl9bu20qznnuA7+bvaUb8V4Lv8O2hCNUDr46Qps
         dXZlnaXHHkhXbjGI2wT4M478W84GzoiBTGIIiYKha5QdK6DTgVs1H+GLdts1oTI4qU8E
         ZURw==
X-Gm-Message-State: AOAM530Qfbu2qp8MgwuPj0Z3xFK2eKOLW/UvECRWe1ctLxIxnU6wdEl0
	+IROvU0mOVwgGk87VAKm0ha5Kw==
X-Google-Smtp-Source: ABdhPJxKprLbaF45m4aFZBCu8TcN47p88Sv27sxNXUwq/W62Jrj+gAb3bfdkghHDiwPsPeORB/7bTw==
X-Received: by 2002:ad4:50c7:: with SMTP id e7mr5847985qvq.53.1639493985145;
        Tue, 14 Dec 2021 06:59:45 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:e1e4])
        by smtp.gmail.com with ESMTPSA id ay36sm49065qkb.60.2021.12.14.06.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 06:59:44 -0800 (PST)
Date: Tue, 14 Dec 2021 15:59:42 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 28/33] bootmem: Use page->index instead of
 page->freelist
Message-ID: <YbixXjYCrYMwa13Y@cmpxchg.org>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-29-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201181510.18784-29-vbabka@suse.cz>

On Wed, Dec 01, 2021 at 07:15:05PM +0100, Vlastimil Babka wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> page->freelist is for the use of slab.  Using page->index is the same
> set of bits as page->freelist, and by using an integer instead of a
> pointer, we can avoid casts.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: <x86@kernel.org>
> Cc: "H. Peter Anvin" <hpa@zytor.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
