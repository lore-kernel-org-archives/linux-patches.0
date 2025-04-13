Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C13010E9
	for <patches@lists.linux.dev>; Sun, 13 Apr 2025 04:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744519533; cv=none; b=hiZV/GPVds38SwUU46IMSqihacClcr5XVzP3Kql1eXLXjHsi2bgOpcZHHNqH98Tahgn9rwQpUr77Jx+JJNpWaMOcKbEqTuS3CspwzrSgm8FmWZhjDEF48n+xXeI3dewrL7Y9bJnKh5PDlToqEBj/GTrk8anXSXz8nJts2o7WeJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744519533; c=relaxed/simple;
	bh=lw5JRYrm01bZN/WGAo/rBu1PEwwZZg9mW50bAbmZG80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GE24cx36mqwQVX937mqAVZF3OHYSONcPM4WuEnXBhgPxRb2Spt+gA2oq66l9P5fG7cPfRpi97XWuQ6xkIVJ+DfnkK9g3M9fQzMYwQ9GhIiVYMg+da4u39NNvNC0l4QEOmjpvy6eXII+21ynKsap4banSyBnOqyjxUBKX/dU2ghw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b=1lfbQ8ax; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b="1lfbQ8ax"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6f0ad744811so20055746d6.1
        for <patches@lists.linux.dev>; Sat, 12 Apr 2025 21:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1744519530; x=1745124330; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C8uy9RLe6EmydLFrJvcYXD6QVbwFOjWHkxU1MVvas60=;
        b=1lfbQ8ax+L2URk/TzM0NX1+M3dYZh489qeLcC0EHtzd9ApTNVAaL1bFfatJWqoOk2q
         67sHeaPWxCfPjLndLTnW9mwkj24ChSg2DX95eOgmF6BwMrr0Jn3jIU4SbzTLRofYyvFO
         VPs4FpMP6IzmGjhO3vPHdtV0+RYA03KVvnHLviuYXAD9OHHFNhRFVRouLW5ZSWASgIUY
         +8jpiYBI0755tgNhIjZ3hg2odD+hK0v5jp0tjhLvfRJmxO+YPkfxH+/MI9S401aQ4lip
         khMHhCIOeR+ZvKc9adXrf0bzipCfOj6wFi8Acpnnb8QhQMKLAiRbTJwSTOn80Ri8/YFx
         2H2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744519530; x=1745124330;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C8uy9RLe6EmydLFrJvcYXD6QVbwFOjWHkxU1MVvas60=;
        b=u4jEa/f+aJbiGpRSHxyfr7xc+Y/EkBrerqDqJhVqrq/sy6MJ58AhctEQuQV9fLE1+l
         Bzp2+zoz79sVWBAvsG5CDnPFq2SMp/Su2kJV9HANrRR+8ebLFBFpc0jlSZxy8tD/hL7Q
         kZCA341BBgcSnmqeATid8lgaACtgN4DjEBJ4ICMGPYeVF/6gbjpqMgJnPSAFTBDwc7Ls
         ISPZncp3frRB51UeSFwAcfK9JDPVl29VCjZ4edyuSvFP+PpKCMHMTM7goEQfdsT6fARn
         LAwFhIlTw7CIV33oZuX+FmD3ta8fSww3TXQ+XNwyJGjy8xJYFbbUSfxaNuhsoJqmS3XM
         8pRw==
X-Forwarded-Encrypted: i=1; AJvYcCWaQ7nlj2Gr4/VkLIYpz7qCueW7ASUDwHaGE0MK/7bPX+lJY1AoUDomDzi8kl5+9rtKci7yvoEO@lists.linux.dev
X-Gm-Message-State: AOJu0Ywq3X+288jdiDTzoMeV+ZphkEKjqSO9VXY+In+SFzGf63l82OyC
	D38jMalOCs6J6VhSOyfR5XXfujjuv/7odjVlyQ0NxyQ8J8B8pEPq9lxBgcN/gdc=
X-Gm-Gg: ASbGncvHsCq0NSxah5oGv3s0fJy7EPCmi/80GATsurdBSRgXuCzT9zmW1WzXh3FSn3U
	ND9Jk6w0HyAdVYFhJK85Uz7Sx0X0VGOe86Ca/JxHCtWnZOCJuorofFO/p1406wZ8H8EfRDVleGH
	DI9GEJCr5wmvY3nYckGKAk5q4fa398vmQG6c5pyb2UpD49ZIxF4X6Q+3Y3BNDoFZ2rB7fbebdc5
	bLRI5m89RtVJlg8ORDD0yNK+89AuxsmynQIl3vF3BZBuvKBgFEIPJ8m2tOncpEWOzQQH5uZSKiu
	ZPH++A0obuD5I3kv4xNFCpDcNr6IDgGpEbDmjdk=
X-Google-Smtp-Source: AGHT+IHkFwzdLW17zoH0eIq/02TMpxPx02NyI7kV8LC8mAi0cTvY6AEe68rUu7uwJoEMv6jrZvCPzw==
X-Received: by 2002:a05:6214:500d:b0:6e2:43d1:5fd0 with SMTP id 6a1803df08f44-6f23f11d25fmr122831646d6.31.1744519529530;
        Sat, 12 Apr 2025 21:45:29 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:365a:60ff:fe62:ff29])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-6f0de95fd3dsm60193846d6.14.2025.04.12.21.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Apr 2025 21:45:28 -0700 (PDT)
Date: Sun, 13 Apr 2025 00:45:27 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH 2/2] MAINTAINERS: add MM subsection for the page allocator
Message-ID: <20250413044527.GG366747@cmpxchg.org>
References: <20250410090021.72296-3-vbabka@suse.cz>
 <20250410090021.72296-4-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250410090021.72296-4-vbabka@suse.cz>

On Thu, Apr 10, 2025 at 11:00:23AM +0200, Vlastimil Babka wrote:
> Add a subsection for the page allocator, including compaction as it's
> crucial for high-order allocations and works together with the
> anti-fragmentation features. Add reviewers (including myself) who
> voluteered.
> 
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Brendan Jackman <jackmanb@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
