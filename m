Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD256FC6
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 20:10:07 +0000 (UTC)
Received: by mail-wr1-f51.google.com with SMTP id q16so18399022wrw.2
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 13:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678911006;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PjNFc/1sMZOGefBpFSEuqAcOT+g79OJ+uWo9eDYsxwg=;
        b=U04MlTlTCuZLzLmil7UNgqN++w9Yx1ypk+Hb8RZxgFRrUTMtmferA0mFwHFc0Yddib
         Sey4M7QJ8/nbJPj3Fsdhlu7LNKNXazlc7KLQPNzwQo/dHoLJK++E4FdKCW25yQcT7wL0
         9MRdYCAG5gENid8qwX9yh3XW9JgcSnGD8+7uW3h1Lq5Wc5NSeIO0mCnDAFeeFfcZmhUv
         XvAxGtXWZ6neYXJdh9/8irHIVE4FeVkGFANuLYPAZxnX6Lr4zS79YDNDKZOxnMdHaNKs
         TL1o2i7jIV7BLCWmRzEshailuKHjII/KnRDx/ZDJ4XZDS0P/Zu8HM3C6fZTn7ibwiuGm
         l1hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678911006;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PjNFc/1sMZOGefBpFSEuqAcOT+g79OJ+uWo9eDYsxwg=;
        b=LSoXmXMhKBEPXsgsx3fZFAMPunNaJwgz3qrnkp+For+mX+PY01uKXmdfg1UnmcjzEQ
         gVSdfucZRGSkAnZm4t5AscgsiLAvTPzxvbxIGgDvZ13eY9mLdU0M+ZmHdkVomjTod0Rv
         pbS0gzQcSCOvV7vvwYP2DY3lWM16M48Est/vHX/wnEeC6OPha4IQyUg+UmuRkm2K73v3
         jWFAXRP1xqxfSNzyIrSco8sa9jQ91JB7h7mAg+wpu7mkJx4MRtHizrFiqygE23SwnPlE
         pd/T0irHzLpwoum/2NKN5xF5/t06Ylqcxkr4TP7y16NZAH4WKK+4Ega/+rEFqxZGk6Ff
         dANA==
X-Gm-Message-State: AO0yUKUmw4mPCDCTgthD/EBnfJEOAl3bAbstIV3anSAUDYhoD497ivtj
	C/ZW1H43nKLgjk9Y26cz9es=
X-Google-Smtp-Source: AK7set/iDb0oAA8W1jHGhwWNaz0h3L+QskK8ZyvbCMZTalMSsRvQCWrk0wnuSpsMMK+XXUx+r1vbUw==
X-Received: by 2002:a5d:4577:0:b0:2ce:a7da:ed5b with SMTP id a23-20020a5d4577000000b002cea7daed5bmr2852784wrc.47.1678911006119;
        Wed, 15 Mar 2023 13:10:06 -0700 (PDT)
Received: from localhost (host86-146-209-214.range86-146.btcentralplus.com. [86.146.209.214])
        by smtp.gmail.com with ESMTPSA id o3-20020a056000010300b002ceac2ccc4asm5567757wrx.23.2023.03.15.13.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 13:10:05 -0700 (PDT)
Date: Wed, 15 Mar 2023 20:10:04 +0000
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	maple-tree@lists.infradead.org
Subject: Re: [PATCH 05/10] mm/mmap/vma_merge: initialize mid and next in
 natural order
Message-ID: <b2675efc-e019-43f6-b322-c0217fef5ed6@lucifer.local>
References: <20230309111258.24079-1-vbabka@suse.cz>
 <20230309111258.24079-6-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309111258.24079-6-vbabka@suse.cz>

On Thu, Mar 09, 2023 at 12:12:53PM +0100, Vlastimil Babka wrote:
> It is more intuitive to go from prev to mid and then next. No functional
> change.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/mmap.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 420d6847c94c..be60b344e4b1 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -912,10 +912,11 @@ struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
>  	if (vm_flags & VM_SPECIAL)
>  		return NULL;
>
> -	next = find_vma(mm, prev ? prev->vm_end : 0);
> -	mid = next;
> -	if (next && next->vm_end == end)		/* cases 6, 7, 8 */
> -		next = find_vma(mm, next->vm_end);
> +	mid = find_vma(mm, prev ? prev->vm_end : 0);
> +	if (mid && mid->vm_end == end)			/* cases 6, 7, 8 */
> +		next = find_vma(mm, mid->vm_end);
> +	else
> +		next = mid;

It feels like the original implementation may have been backwards like this just
to avoid this else branch. Which is silly.

>
>  	/* verify some invariant that must be enforced by the caller */
>  	VM_WARN_ON(prev && addr <= prev->vm_start);
> --
> 2.39.2
>

Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
