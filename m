Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0316F747A
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 22:20:49 +0000 (UTC)
Received: by mail-wm1-f47.google.com with SMTP id j19-20020a05600c191300b003eb3e1eb0caso1973111wmq.1
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 15:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678918848;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Uy2xay+QSUr4LgGqR0bhvHEFtaFjUeaP9/Kp4kYC9Bo=;
        b=VK2E0LRRwXPvr2BrU58q54QsjK/IXgxcnzSYcW3VRPEBLaf54GioNZ05oSTd/ucR2t
         rQhg7TEAd4eFqrVoliQ2odDOKXJi1lBxfmMMwvPtX1ozJ9ia28d0RIO2piNfpssTm6wi
         6sUn4xQ3vqT4WXgqDY/eeT4HvB1UYtDs+k1Y4N53aF58yks2SeZxQnykVS91L3W0zdXS
         S1e/rt4z4fTHdgS3UPw8wFKgcdGGITR33ubTe/OGm87rcfUk+RAhJRTQU6Qds6yHc+RT
         9NknRhvy2ou9cEh8IkYTNmtVqrtaEsgIvbBoTexX/Q5jhSsuRmvE1tpRndSC5HLo/4cz
         wbkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678918848;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uy2xay+QSUr4LgGqR0bhvHEFtaFjUeaP9/Kp4kYC9Bo=;
        b=pNrpt0MTF/oGPgiRnVG08s7OgAWlYJqm+utLknGasUV/T+ZamiDjUK6l3a97g0zlq3
         0IqnQagxdZcSF8ADC1Y6urCsy4fXWiMQh+FXnazaRDqzXEeHSVswj/MSdixPGeTuhS/Z
         8m0s22nhnqREnuRP+V4FknYMcw5gTcz6H5bPdnGwQyeMasXK3K0H7gEVR0SKN0epvp2T
         rbX38byCsWRyDxKsx99rT3LTsfippZNpxhL+twYVZ+HZ4TslDGl+/TYzHADXZQMebfdZ
         1HvQDKti4HFf10l0q0Wq75uqG+kpigovQGSZ3LyvobZhpXxw6xJZWKjuEDXwYQ4/qd7s
         R7hA==
X-Gm-Message-State: AO0yUKWzKZbR/Ktij41sMru/HxmD2ViqnexPmLbJV8/Q34nDAQLrGATx
	z5VEKko4/Fgl4JB+EQbfbQJXCuVdRto=
X-Google-Smtp-Source: AK7set+NT9e2NIMUlIy8tS9ZTx0pBweJ9iVltZKFNL5/Duj3rL8QABA5ZO6mvjxWUXtFQ/KfR9truw==
X-Received: by 2002:a05:600c:354f:b0:3eb:395b:19dc with SMTP id i15-20020a05600c354f00b003eb395b19dcmr19390422wmq.9.1678918848183;
        Wed, 15 Mar 2023 15:20:48 -0700 (PDT)
Received: from localhost (host86-146-209-214.range86-146.btcentralplus.com. [86.146.209.214])
        by smtp.gmail.com with ESMTPSA id t8-20020a1c7708000000b003ed2276cd0dsm3057428wmi.38.2023.03.15.15.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 15:20:47 -0700 (PDT)
Date: Wed, 15 Mar 2023 22:20:46 +0000
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	maple-tree@lists.infradead.org
Subject: Re: [PATCH 10/10] mm/mremap: simplify vma expansion again
Message-ID: <7a9ca4a6-9713-4e31-9c0f-11ec31817c7a@lucifer.local>
References: <20230309111258.24079-1-vbabka@suse.cz>
 <20230309111258.24079-11-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309111258.24079-11-vbabka@suse.cz>

On Thu, Mar 09, 2023 at 12:12:58PM +0100, Vlastimil Babka wrote:
> This effectively reverts d014cd7c1c35 ("mm, mremap: fix mremap()
> expanding for vma's with vm_ops->close()"). After the recent changes,
> vma_merge() is able to handle the expansion properly even when the vma
> being expanded has a vm_ops->close operation, so we don't need to
> special case it anymore.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/mremap.c | 20 ++++----------------
>  1 file changed, 4 insertions(+), 16 deletions(-)
>
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 411a85682b58..65f5b545601e 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -1040,23 +1040,11 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
>  			 * vma (expand operation itself) and possibly also with
>  			 * the next vma if it becomes adjacent to the expanded
>  			 * vma and  otherwise compatible.
> -			 *
> -			 * However, vma_merge() can currently fail due to
> -			 * is_mergeable_vma() check for vm_ops->close (see the
> -			 * comment there). Yet this should not prevent vma
> -			 * expanding, so perform a simple expand for such vma.
> -			 * Ideally the check for close op should be only done
> -			 * when a vma would be actually removed due to a merge.
>  			 */
> -			if (!vma->vm_ops || !vma->vm_ops->close) {
> -				vma = vma_merge(&vmi, mm, vma, extension_start,
> -					extension_end, vma->vm_flags, vma->anon_vma,
> -					vma->vm_file, extension_pgoff, vma_policy(vma),
> -					vma->vm_userfaultfd_ctx, anon_vma_name(vma));
> -			} else if (vma_expand(&vmi, vma, vma->vm_start,
> -					addr + new_len, vma->vm_pgoff, NULL)) {
> -				vma = NULL;
> -			}
> +			vma = vma_merge(&vmi, mm, vma, extension_start,
> +				extension_end, vma->vm_flags, vma->anon_vma,
> +				vma->vm_file, extension_pgoff, vma_policy(vma),
> +				vma->vm_userfaultfd_ctx, anon_vma_name(vma));
>  			if (!vma) {
>  				vm_unacct_memory(pages);
>  				ret = -ENOMEM;
> --
> 2.39.2
>

Good to eliminate this edge case! Do we have a self-test for this case to assert
that the issue is fixed by this? I guess a little tricky due to the need for the
the owning VMA to have ->close() specified.

In any case, the changes you have made in the previous patch should ensure the
edge case is no longer required, hence:-

Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
