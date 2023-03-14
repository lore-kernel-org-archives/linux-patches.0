Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A4228EF
	for <patches@lists.linux.dev>; Tue, 14 Mar 2023 09:34:10 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id gp15-20020a17090adf0f00b0023d1bbd9f9eso4302419pjb.0
        for <patches@lists.linux.dev>; Tue, 14 Mar 2023 02:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678786450;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ysZcgPIZpy+HhVhzVSSUWzsAzGKPFN8FhmKQ7lvViXM=;
        b=fBK7Q7ynMAXgbK2sdnxHmrLOizlbck5xtQ5OIR4fjkahD8USoUHUK45d9H92Cp1Ddk
         zNR9LP+kUS/qLbV+9TgTcIW6Ohi1myNLcekkSVoYaGCsWlUC30z2wF6zvoQ4u6xBJk/u
         sREzqnwt0ALn06h4jy3zdFtb1nHQzn7yumamBoM+fmiqt2IF1nj92uM+JjWBuVaYbS54
         PkzMt0+4/ulBzkVSdMATyjrkVc+nrnyX5XPsRzv9oHOVMdRWLOJbH6LqfEjLh3xXYiaX
         a3l7zQRXgh1Yegw2Z+RBXyWxblOGhbCfzqJyjCpY6VvFmV4/9p5MESY42xt6SzfIg2sO
         M21w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678786450;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ysZcgPIZpy+HhVhzVSSUWzsAzGKPFN8FhmKQ7lvViXM=;
        b=h9TKKopJAGTBWWqN9YNf8mL71rPENC9EwCB8qfIFC/MMdEeo4o0Rp5z/buyvcHo/dJ
         c7nuvbes4ramEedkDCEmGpOlBD17uUxzECRsQP+pp88h+ImF+thzzmie5YpNlb4BY9F9
         OhPwGhoS3VfCWX4NREt3uERu+QKeSJ8XCqvlLUN+ovqOhxJVCFhG+l8Dxww2tOlaTIKZ
         MSKCMpKJ93isP7uB1P1y01la0y2VrtggbZvnGSifCBn4+PIbmUug6VMX1EW3hed2GpGt
         JQwHZKoDD8IA4YlNhqNu8hJS/7sUjgHgiUBqajkZRnfZxON8ryb18kJAc8MbnZald/18
         A4zg==
X-Gm-Message-State: AO0yUKXNSJ1FDNzSkFl7kboL8beVqU5NGYUjcBDwI/Qe53AkfA7deXFX
	meFdDWnh/O5K2l1f6iFOYwI=
X-Google-Smtp-Source: AK7set+l1it0mNZFvuEDI3VT1K7wkdRl7g9zbpaOT2luN/TmcsFqz/Zv0OWl6OJWRd52+XBEAjiN+g==
X-Received: by 2002:a05:6a20:748b:b0:bf:65dd:94fd with SMTP id p11-20020a056a20748b00b000bf65dd94fdmr35793146pzd.59.1678786450235;
        Tue, 14 Mar 2023 02:34:10 -0700 (PDT)
Received: from localhost ([2400:8902::f03c:93ff:fe27:642a])
        by smtp.gmail.com with ESMTPSA id c4-20020aa781c4000000b006254377ce44sm1166268pfn.43.2023.03.14.02.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 02:34:09 -0700 (PDT)
Date: Tue, 14 Mar 2023 09:34:03 +0000
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 6/7] mm/slob: remove slob.c
Message-ID: <ZBA/iw9//3o62oRO@localhost>
References: <20230310103210.22372-1-vbabka@suse.cz>
 <20230310103210.22372-7-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310103210.22372-7-vbabka@suse.cz>

On Fri, Mar 10, 2023 at 11:32:08AM +0100, Vlastimil Babka wrote:
> Remove the SLOB implementation.
> 
> RIP SLOB allocator (2006 - 2023)
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Goodbye to SLOB.

Acked-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

> ---
>  mm/slob.c | 757 ------------------------------------------------------
>  1 file changed, 757 deletions(-)
>  delete mode 100644 mm/slob.c
> 
> diff --git a/mm/slob.c b/mm/slob.c
> deleted file mode 100644
> index fe567fcfa3a3..000000000000
> --- a/mm/slob.c
> +++ /dev/null
