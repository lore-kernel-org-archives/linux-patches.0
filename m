Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B7E3216
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 21:40:09 +0000 (UTC)
Received: by mail-pg1-f169.google.com with SMTP id r66so519570pgr.3
        for <patches@lists.linux.dev>; Tue, 05 Apr 2022 14:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=0JTmX/lC0hG9yq+jd3ONDrgjwpA6pJb9bWxC7NEbBEw=;
        b=WJEsMa2YFI+12uk4elHbe+wsu8NzrGPbtKk/cMhmPnEIxBfwWCE5xYcFcCp3XDF5iP
         CN0mXiNKtbHN9tg+e23UzyOXo6b2QeWp6Ipx81aUbVYBwWd4kCVr07/ZSDSGjuRUJJ8a
         kFAUQXmhTozJihzSfUVy8kpGM7tjoXuET30ufEoo64WSNW3XTRcj2y8tZVGeI9/beoy/
         zh7gATThbEx6K53xd68hBPQFFEVXbhToF8BWa1jzSOhogTHJgynuUr82tFkfN0Dw6SN2
         BNjtlX687++xrsB0EOFJdorTkm+VU9hKyp1c07hex6mxFw8d1ZtO5nbMumLeC1GrO7dn
         Lp0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=0JTmX/lC0hG9yq+jd3ONDrgjwpA6pJb9bWxC7NEbBEw=;
        b=qXttPxloJg884lk7WdnYOTzwGnc9HWHvWMH7kz3FtiBy854TIvNURjbn5rXQe/JQbA
         5mEDhbJK/eGPGrHT5TG/2lNJ8UShW/uTwES/4x6YxAJ8fjGzxakCmjApogV3XI9bPmYW
         Rwd0FQ4wAI5U9CEcDmeLVxTAn0AinQ8UDUwq73o1GT4NN9vexLHSGJ0tjWS+UPfOMlOd
         I/Ztn9Gq25GbILkUzeUV4KMnfWvwD3rBZdp6eNuHrizS96iu6Yd68cB9CdFx6iFjKKib
         2vAjFsMgBihwtrk7BN4nHC8IeB/lMWx75yj8YfMeGuXXzTA6e69d/MsjQN9m5GktsCpc
         5xOg==
X-Gm-Message-State: AOAM532TsQl26p3gikMBauMiA1CiOKKyPKGEXnfgBn2S3WRJGue0wj1X
	kwR0fKEU7BuFpro9zeNP/eZgqg==
X-Google-Smtp-Source: ABdhPJy5Pc2RZGWeq2zUSGslDcJEcOIWw3o6pAwyA9f0e/LD+reoFIt9Mx5IXFPevLffUC7Afoj2ZA==
X-Received: by 2002:a63:af10:0:b0:398:91:657 with SMTP id w16-20020a63af10000000b0039800910657mr4452112pge.413.1649194808849;
        Tue, 05 Apr 2022 14:40:08 -0700 (PDT)
Received: from [2620:15c:29:204:be3e:5e1c:99cc:513f] ([2620:15c:29:204:be3e:5e1c:99cc:513f])
        by smtp.gmail.com with ESMTPSA id c4-20020a17090a4d0400b001ca5cf3271csm3538893pjg.14.2022.04.05.14.40.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 14:40:08 -0700 (PDT)
Date: Tue, 5 Apr 2022 14:40:07 -0700 (PDT)
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
Subject: Re: [PATCH v3 2/6] mm/slub: move struct track init out of
 set_track()
In-Reply-To: <20220404164112.18372-3-vbabka@suse.cz>
Message-ID: <18ede94f-818a-d4f2-14e7-d73fdcd78eb5@google.com>
References: <20220404164112.18372-1-vbabka@suse.cz> <20220404164112.18372-3-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 4 Apr 2022, Vlastimil Babka wrote:

> set_track() either zeroes out the struct track or fills it, depending on
> the addr parameter. This is unnecessary as there's only one place that
> calls it for the initialization - init_tracking(). We can simply do the
> zeroing there, with a single memset() that covers both TRACK_ALLOC and
> TRACK_FREE as they are adjacent.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-and-tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>
