Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222B03216
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 21:40:27 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id z16so690357pfh.3
        for <patches@lists.linux.dev>; Tue, 05 Apr 2022 14:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=+VkEMKPsUn5codAwC2objI7iKq9LeQy/6DGModLXRws=;
        b=a8L5o5P9uTOesLLONs4iibuBLPNtqXkJvnT5lW7YCQHxQj+KHSe3RjpJncrX2lwxya
         m0fpQalAUhuzaUI4Tcwrw1xxjobzM5WSzUovJuKD63HaCOAusMNombgK9/8bW0kMD9RA
         uXW3PuCngloNczariQrjxBBTI4pEg/lF5UhdpHu4gZf2rRUUsPk5RzgzY2vdluwR9223
         pvjyjRYpy+K2FvL0jB38jXUwaPr6w56Vx3V/I/KUvL1Eg21tAnG7cNwW8ZB8IVEFLgFp
         9d8bP7jb0a04ePZkHF8/bcPfS16jTZpInlewoW8Mby/pG/YZ/tNxtGBvPi8vwpW/VET7
         WQng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=+VkEMKPsUn5codAwC2objI7iKq9LeQy/6DGModLXRws=;
        b=O0fsQXcPx7QzsBknsdMgJ9OqphP7P3J50STmVyWZbw31PB7xBxX7hlMA54SPIaphl4
         S6NRX3GrI3/L+bIV45dfkLJ+dMpoLlK0+66Zol/sEItAr6joG/xdX5J1LNqa3XANqU6q
         eCVMvRGxz6e9GyD97ivBVPHIW733A+dV1xkijrZMBgjbgYr5OFYnYQmMMhC/ZuAT5Xx9
         l+lbfasWDBdx3jjOIv2ySygiBgLyHPNwxo37JvBxpSfHwneDHR4Jtzp3AofSLn/Je1Fs
         zb9e8Q6GiymJLXQkMFIK6DOCxFWQJRy8Wt+zs6X7IdabxymwhNoZJvCnbu9htgAOeBPh
         aF4A==
X-Gm-Message-State: AOAM531m1KBkgyDRr8eAag+lhPFbKEhf7POEBTxKzESm85Yl9wBuY30/
	GW1GJN6AjYraXWS7NWcjmGjobg==
X-Google-Smtp-Source: ABdhPJzohfbOUrOhh/eLDwWhPKl7DNSBnOmqX6sET9SS3mk7vVXphuAZWMw56KG1ZqqSbTanxtD0Bg==
X-Received: by 2002:a05:6a00:1341:b0:4fa:a3af:6ba3 with SMTP id k1-20020a056a00134100b004faa3af6ba3mr5505300pfu.51.1649194826458;
        Tue, 05 Apr 2022 14:40:26 -0700 (PDT)
Received: from [2620:15c:29:204:be3e:5e1c:99cc:513f] ([2620:15c:29:204:be3e:5e1c:99cc:513f])
        by smtp.gmail.com with ESMTPSA id o30-20020a63921e000000b00398e665e830sm13002381pgd.48.2022.04.05.14.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 14:40:26 -0700 (PDT)
Date: Tue, 5 Apr 2022 14:40:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Vlastimil Babka <vbabka@suse.cz>
cc: Christoph Lameter <cl@linux.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
    Pekka Enberg <penberg@kernel.org>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
    patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
    Oliver Glitta <glittao@gmail.com>, Marco Elver <elver@google.com>, 
    Mike Rapoport <rppt@linux.ibm.com>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, 
    Imran Khan <imran.f.khan@oracle.com>, Jonathan Corbet <corbet@lwn.net>, 
    Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 6/6] slab, documentation: add description of debugfs
 files for SLUB caches
In-Reply-To: <20220404164112.18372-7-vbabka@suse.cz>
Message-ID: <fcf0fbc-b464-cab-e8d7-ae1322b2ffb3@google.com>
References: <20220404164112.18372-1-vbabka@suse.cz> <20220404164112.18372-7-vbabka@suse.cz>
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
> Add description of debugfs files alloc_traces and free_traces
> to SLUB cache documentation.
> 
> [ vbabka@suse.cz: some rewording ]
> 
> Signed-off-by: Oliver Glitta <glittao@gmail.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: linux-doc@vger.kernel.org
> Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> Acked-by: Mike Rapoport <rppt@linux.ibm.com>

Acked-by: David Rientjes <rientjes@google.com>
