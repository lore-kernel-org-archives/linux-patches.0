Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6735329CA
	for <patches@lists.linux.dev>; Tue, 14 Dec 2021 14:26:32 +0000 (UTC)
Received: by mail-qt1-f172.google.com with SMTP id f20so18491833qtb.4
        for <patches@lists.linux.dev>; Tue, 14 Dec 2021 06:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hrqTsoDQNaD2K2Bh/utTizhae+yJlkti3/D4g1FZzqY=;
        b=Jt4YLpsOdB5yCX4hCAZA8wLCVnqmhO899If7RoYBFheUp8AEusrZea1wNkM+E+9kfp
         Jhvh0/r1pXSrpSdEl3PDCBZRPWZ5RQgh32t0N1oS84oQ0hRkUv3d80tZZknniPP1dpoQ
         CdTI5XfkeABOuZZ4lsj1QqUaR2kCebm2XBaDEEhr0r+R8vWOT+0FTxJApncRXR7RoVR2
         PKshxYQDQntDgSwxYcWIT5R5SB90iaLLu8M5z5+pP6SHLp736Puk0zdCJUcQpSAVFrcg
         RE6FnOmGpIUXqIygdAuWSS8Np51Ews4b1jzL5rQ0jbH8D/GDRwzRxxi+WF+msirjBWgZ
         m1cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hrqTsoDQNaD2K2Bh/utTizhae+yJlkti3/D4g1FZzqY=;
        b=MfL7uBIpB0zkCixnKo/KkU3eQOnUSn4/TdW9WlJ9kxOxK2joWPAflBs3ecRNunicjS
         gRup+UdMHP+vytUcTpAYB+X4RGU1TezTevajHs+bufJdVTUHpdt4cNsh6RxplufEyim3
         YhdJqZTO6lChDq680ZJtsw0gsNUqWzvDptVgJPjnoaR5w4FbI+hLil0QdHdZPW+u8K12
         SOU8SeSbUF7kdBv4VfFtU+PFTYGD8cU7xPL8n5ss7Xk/BR6Y+i6Vgwb4XcX6ALMTM6lk
         VGEGmJ+TJaakN4Fz84ktHbrQ0wZgyEc9VOwpCMO6hmidklDzG+tETUDTNaAwqeHXelRM
         5TXA==
X-Gm-Message-State: AOAM533a6I4/5F7y4S/4dsqvHu/UMpzCtd6gkZ/zMPTFpTZ49o2bftkM
	kYUJ+mQqBmg9v5kpfEgiLObW1A==
X-Google-Smtp-Source: ABdhPJx428C3tvrXzmA2H9a3hJOmYNe7QvZENIS0sSYZoUDpK6fbyBwgoUpvA/fzeon0cqF2cKMTvg==
X-Received: by 2002:a05:622a:1a14:: with SMTP id f20mr6225961qtb.294.1639491991546;
        Tue, 14 Dec 2021 06:26:31 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:e1e4])
        by smtp.gmail.com with ESMTPSA id m20sm26569qtx.39.2021.12.14.06.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 06:26:31 -0800 (PST)
Date: Tue, 14 Dec 2021 15:26:28 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev
Subject: Re: [PATCH v2 06/33] mm: Convert virt_to_cache() to use struct slab
Message-ID: <YbiplPvdc90kjnaX@cmpxchg.org>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-7-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201181510.18784-7-vbabka@suse.cz>

On Wed, Dec 01, 2021 at 07:14:43PM +0100, Vlastimil Babka wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> This function is entirely self-contained, so can be converted from
> page to slab.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
