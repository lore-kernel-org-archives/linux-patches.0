Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00635168
	for <patches@lists.linux.dev>; Tue, 14 Dec 2021 15:06:16 +0000 (UTC)
Received: by mail-qv1-f43.google.com with SMTP id bu11so17525054qvb.0
        for <patches@lists.linux.dev>; Tue, 14 Dec 2021 07:06:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Kz/DHX7Of8rElxQ1e6eUGt9O4KC2BtAuJkqWaa57eKA=;
        b=EVnShM0i24uwHctR1PaRdrtF8PKBgKgd8yQbbObpRE3WWI9PKFTXauOX9a6WU/2CJB
         PRwdDOsqUa1BXrNV+9h6bR/6jsf/Qd2oAa8C0yldpr5XxlZ4P6Map9rqMkqxdbRDMA8V
         yymD1DbZbpbKir9xf85rI4J4v1vOnzKXYpv5NSXCw878OAjRHEcK2Uhadw9VvnJrtcIm
         FJDAJeBIbqoLzUabwf3KH5pJt83PcOln3YQ6n50ebsPf/Orf46T/igZycfq7kFRrTP1/
         cZIAls2SW3WrkeG1RoJy+5dONJx7Ovn0pOTCUVisGiytxdVBNhFQpo0zLRau4Peeu031
         7FUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Kz/DHX7Of8rElxQ1e6eUGt9O4KC2BtAuJkqWaa57eKA=;
        b=xdPm/ZfJCBJdeMa1qVxaB/vxgbL/V85kFQy76BO2LfB69GSxCdb9H7kLtjeoNyasjQ
         3wqxnFDNjKHeApr9E3hjd+QWMSXHFwGT2HW/jOopx8LJjFg2/0Mv3U44Jfn9YT7h2f1C
         5si0T4L+zLu9jpiWRD1wGy8KL4yDIBwcTEU1bCp5la/waFAUgONO81vmM0mGtWfY+uws
         FIm6+9aDu5CVkCakXLeno94w77ZcXmRCxe/qgm2prIfzuM/KheJvgfGZpVAuFWVej3lG
         7hqcattQlM4eDgYKn48DTWllsj80Iiw48fLxonNgijYDlKR67qcEwn2PFOCjdHeGfy1o
         8vWw==
X-Gm-Message-State: AOAM530CdiyLr9FLTlvZbRfXKpD6TkHqPPPR1i+Em55osAAPgnU9RzUA
	lNyydQnW9X0pdHzL68MDwka7sQ==
X-Google-Smtp-Source: ABdhPJzIBlmf843oCOgmlyV4C3v3WehqZDmTvinJYVE9r7J+/PcU94NJpprQSj9YB6Nl52eh4GbD8g==
X-Received: by 2002:a05:6214:27c6:: with SMTP id ge6mr5948769qvb.103.1639494375768;
        Tue, 14 Dec 2021 07:06:15 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:e1e4])
        by smtp.gmail.com with ESMTPSA id d11sm110468qtj.4.2021.12.14.07.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 07:06:15 -0800 (PST)
Date: Tue, 14 Dec 2021 16:06:13 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev
Subject: Re: [PATCH v2 32/33] mm/slub: Simplify struct slab slabs field
 definition
Message-ID: <Ybiy5REGRPxgznX4@cmpxchg.org>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-33-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201181510.18784-33-vbabka@suse.cz>

On Wed, Dec 01, 2021 at 07:15:09PM +0100, Vlastimil Babka wrote:
> Before commit b47291ef02b0 ("mm, slub: change percpu partial accounting from
> objects to pages") we had to fit two integer fields into a native word size, so
> we used short int on 32-bit and int on 64-bit via #ifdef. After that commit
> there is only one integer field, so we can simply define it as int everywhere.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
