Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C3D2CA1
	for <patches@lists.linux.dev>; Sat,  8 Jan 2022 06:21:46 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id c14-20020a17090a674e00b001b31e16749cso13016412pjm.4
        for <patches@lists.linux.dev>; Fri, 07 Jan 2022 22:21:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nKc3rHw8bLwTpQvgM5tlXB3o1woijjKVi3JGNy/T3oI=;
        b=cnQgiY2duio95ZANcJ59sGBdyTbzR2ePP/TEDa3Zk6tlbaHGGl5n+TmNviPBnL6U5g
         /4Zu2d/WScAOJPSSB5kHGkH1kBESJxagJa7QQuxf7RWP6IfjScchzEY+XXM3ntEvMUa4
         9ovF+c+Bqgun4tTet9pLYiBqou6XYOX7kZij5dxAvf05IRVgYX0nCp2UMMk41Gmf9U37
         5BWeeOnaIDdql04Kg8qv3La1gDozmkURxc1iTKLFZNf2L5LTOcnBt1LEzammYEBxxR7/
         UPavqLQZ4d2aaijYLUkhq1VDKvsNGFPX8gJL5F/bZYje+XqDzb0ahA7h1R1MdVHMd2Mh
         Plmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nKc3rHw8bLwTpQvgM5tlXB3o1woijjKVi3JGNy/T3oI=;
        b=CouVTp5taFg3M+808w9Mn/vp12vh6MNr9AozDVwJUkJMf5Pj2qD8Etr0QlYwMKkye1
         B7euaGf1sbsFKsq3gpuLayW0HFByj+SaGdcJBRO1fP2SzXig75KXD9UD2wUEVlCROeQk
         bhNAxqs6BMK1kGQA5RN4k0yibu9iRgFW5SVoLdyvRI30gTebbUtPXU08e+ljBx8+LB8V
         qhJ4efRWxT2aaX77Q06ligfGVVP1rjrrBmrm6M+xdd3CTjBK0dB1ICsxX7WRvHcFPc0L
         A6WsC6AAiV8ckhHxItHNkkXYxaXX+aYHkXoRIXzvC9KNnY1mEE5FF1yfOYq34ILKI5w7
         0o5Q==
X-Gm-Message-State: AOAM533NnulsV5nrvbrJaq6PLmQcXJUkzaYcfLyLTgEfL1l9llEIxwzg
	8FWUitUMQBNDYGBtn1w79DE=
X-Google-Smtp-Source: ABdhPJz0kNd0pZAXiXuhcKhdFtZaMW8SNnMibCudhHmWDslnoTVHw1hZrQDx8flSDYl5v1p8gY/pAg==
X-Received: by 2002:a17:90a:4a11:: with SMTP id e17mr14926219pjh.237.1641622906308;
        Fri, 07 Jan 2022 22:21:46 -0800 (PST)
Received: from ip-172-31-30-232.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id c11sm806347pfv.85.2022.01.07.22.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 22:21:46 -0800 (PST)
Date: Sat, 8 Jan 2022 06:21:41 +0000
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH v4 07/32] mm: Convert __ksize() to struct slab
Message-ID: <Ydktdfqxtm1k2wNc@ip-172-31-30-232.ap-northeast-1.compute.internal>
References: <20220104001046.12263-1-vbabka@suse.cz>
 <20220104001046.12263-8-vbabka@suse.cz>
 <YdbxuCMUz9l1TW8e@ip-172-31-30-232.ap-northeast-1.compute.internal>
 <48ab4217-a0c4-19ba-2335-1154086a562d@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48ab4217-a0c4-19ba-2335-1154086a562d@suse.cz>

On Thu, Jan 06, 2022 at 06:26:06PM +0100, Vlastimil Babka wrote:
> On 1/6/22 14:42, Hyeonggon Yoo wrote:
> > On Tue, Jan 04, 2022 at 01:10:21AM +0100, Vlastimil Babka wrote:
> > 
> > This patch Looks good.
> > Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> 
> Thanks!
> 

:>

> > BTW, I see no reason to implement SLAB version of __ksize separately.
> > And there are no modules that use __ksize. EXPORT_SYMBOL is unnecessary.
> 
> OK, I'll look at a cleanup later. Or you can try?

I want to try it.

> 
> > BTW, Until when can I review your patches? until next week before starting
> > window?
> 
> I will send it tomorrow already, so records of any further review will be
> archived in the mailing list only, but not git. Thanks again!
>

Got it.
Thanks!

> > Thanks!
> > 
> >> -- 
> >> 2.34.1
> >> 
> 
