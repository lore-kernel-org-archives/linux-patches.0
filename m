Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430EB6946
	for <patches@lists.linux.dev>; Tue, 22 Feb 2022 23:38:27 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id y11so13637672pfa.6
        for <patches@lists.linux.dev>; Tue, 22 Feb 2022 15:38:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=z14gdztNmeBCFYN6Nsa2blKh3AYnO4tYG9TJ7do4igA=;
        b=P8gl+rGgObz5JsQXub2YaOttUkPyGb7i1SkmFpqxkIGdUAU4YRxZiisW87LG9VpuCb
         4xpTct734i09Qzvlpxm2rsqYyXUeerHt09s8oTueO0vyy7cZq824/v8CE3tLThpYelvl
         eGhZ7/kKZNE2OzXT2ZnCyxKGFSGiR2+9TGAg+1jte1PnDWyifvCjffRrTEx8WPNVXUQh
         Ss0lTlHq8dKJpg115nPsBQWM6W9sHaYtYCXG5ghn91RI8pHSvR7KpVfQavU1lD7gLMkR
         fHgjaNKyXXnLzLV5azir/FN8AoEUAlUNfS4x+XnLacwJ6pNtrFt334tlZsU2uR+7Lfv4
         pT4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=z14gdztNmeBCFYN6Nsa2blKh3AYnO4tYG9TJ7do4igA=;
        b=PqB62tiUp+u98Ak6QCcpCtLpMEJO5yofvaQkPTDdduZ6LlxaBX5KgQtiQyDdgjWaBA
         YSU6ZL0wzHD3hTt4FdbX7x3awIl318uTpvrnCvhRB6yPJreCStukfZaxZmAQOOzyiYpQ
         wIKZX6nFYYoeRkML2ifXZbW4rc57mSCqPDxRV2K5mJRsc/+8GNsBWiCXWSlr/6pISE1M
         Yo6NHFjU67S2n9Y7ubVLdlLxw3UKvCAjZoEavuc3Fn7DG/2IcFZdc/fPqpHLwXL1m0zb
         fEcjUZjD81TOxw0nMg4cfWMthAYS4toDlJUneE+cwzug//l1x1lKmmuFUbCC8K9JamiW
         LE6A==
X-Gm-Message-State: AOAM530NZgJgiyhkh8RLGkWlsQfqCKTXiK36l/SAwqtthN9f+0pxebn4
	4qHCwJy0LyrVKxrQvEAhdz+T4g==
X-Google-Smtp-Source: ABdhPJxooYUF3cMjgU9bh8ub5zJAQM7l/5INUFoLGNz1daFOw83ZQTajR0NlWO7J06goIxmoJ8O6Qg==
X-Received: by 2002:a05:6a00:984:b0:4e1:5e1b:1e9b with SMTP id u4-20020a056a00098400b004e15e1b1e9bmr26851040pfg.71.1645573106467;
        Tue, 22 Feb 2022 15:38:26 -0800 (PST)
Received: from [2620:15c:29:204:6b0f:423a:fd82:4e05] ([2620:15c:29:204:6b0f:423a:fd82:4e05])
        by smtp.gmail.com with ESMTPSA id c9sm19098644pfv.70.2022.02.22.15.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 15:38:26 -0800 (PST)
Date: Tue, 22 Feb 2022 15:38:25 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
cc: Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>, 
    Pekka Enberg <penberg@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
    Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] MAINTAINERS, SLAB: Add Roman as reviewer, git tree
In-Reply-To: <YhU7T//RK6E+1Nig@carbon.DHCP.thefacebook.com>
Message-ID: <2c52e740-8373-4234-aeef-928abb41f521@google.com>
References: <20220222103104.13241-1-vbabka@suse.cz> <YhU7T//RK6E+1Nig@carbon.DHCP.thefacebook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 22 Feb 2022, Roman Gushchin wrote:

> On Tue, Feb 22, 2022 at 11:31:04AM +0100, Vlastimil Babka wrote:
> > The slab code has an overlap with kmem accounting, where Roman has done
> > a lot of work recently and it would be useful to make sure he's CC'd on
> > patches that potentially affect it. Thus add him as a reviewer for the
> > SLAB subsystem.
> > 
> > Also while at it, add the link to slab git tree.
> > 
> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> 
> Sorry, used the old e-mail. Here is the correct one:
> 
> Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
> 

Acked-by: David Rientjes <rientjes@google.com>
