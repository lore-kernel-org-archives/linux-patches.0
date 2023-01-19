Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685CEA93E
	for <patches@lists.linux.dev>; Thu, 19 Jan 2023 17:40:15 +0000 (UTC)
Received: by mail-vs1-f54.google.com with SMTP id l125so2972598vsc.2
        for <patches@lists.linux.dev>; Thu, 19 Jan 2023 09:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eeuukOKJ+v76G3XCHdrhKdumLe6It98OJosMQGHmHAc=;
        b=m/n40kEfZwk8dFbLpzgM8gTe/WEbqcbdhx2sLztNe+FhgPHjjI0z1GrSB/dmXN/XPM
         PHMiQUlh5UdnTclg2Uvy8O7JoFeHGV+X8F4lwuPyhn4S3Cq5r2I2qd3pZY2i7TTYz/n/
         9W38zVj2nnN42iZPYZk7qhmkdDyc+y0gxQ/yjRYnXSSCdTtprietNZv7Gch8aUrrMhjI
         /5MjxalWePc4rqWjdt4YJE++srheFg1VPdOHGl5fHevz/CpU0Eb5BGxEwp38xFJouCig
         niVdnELDk9MsNVEowg2GXNHfhIunHEscXb1NHROx3Pfp/lJ3OjQE5AbUpp5SW5cIysfW
         hk4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eeuukOKJ+v76G3XCHdrhKdumLe6It98OJosMQGHmHAc=;
        b=LNYTEgHPnUT8+dGJ89pldAuP/OEmqgB3mt0aDbp+mGeNt5w3oYDJWZUrYEtseW21sK
         HDs0W0daUIkbvGmoEw0zfyVut2Ub7qIDmG1amL3iE3OLFAnfKs5RFKOJQ3q4aiuOro59
         PKsATQ3f24IZdoHj5feSZDDshE4P6S/1jZvRdKvOOHZX5CD13agd8Y2DmrB1goKWGm+L
         JTs2GJ189LgUgX5BuNmI7e/jXZirR+t11a3zBosecz+BKVfkSYWXWbXhDUouzhey7Tci
         IVH2X441GSuvTeG5uTCKRvKP3lctvXzYRoAF18UkfS6K7Lz1jzzGBZ4cTd7RSMvi1NhX
         Uv3w==
X-Gm-Message-State: AFqh2koYnA2Q4LKG6XEDYubfoOmwYpG1PHtlnFPQzE0CoEKaTlpWBMMS
	vmnq/Jlyh8bJzM4mrdJA7g8=
X-Google-Smtp-Source: AMrXdXuKdthUK6SO5H32TpWAuohGOwM82yIcJB8OVzuFtOHBiR57KXMUy/sVvLPOOT6ltqJXlN7VHw==
X-Received: by 2002:a05:6102:2744:b0:3d0:d7cf:18ca with SMTP id p4-20020a056102274400b003d0d7cf18camr7530299vsu.27.1674150014247;
        Thu, 19 Jan 2023 09:40:14 -0800 (PST)
Received: from debian-BULLSEYE-live-builder-AMD64 (h64-35-202-119.cntcnh.broadband.dynamic.tds.net. [64.35.202.119])
        by smtp.gmail.com with ESMTPSA id f8-20020a05620a408800b0070543181468sm24876277qko.57.2023.01.19.09.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 09:40:13 -0800 (PST)
Date: Thu, 19 Jan 2023 12:40:11 -0500
From: Eric Whitney <enwlinux@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Eric Whitney <enwlinux@gmail.com>, Theodore Tso <tytso@mit.edu>,
	stable@kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 499/521] ext4: fix delayed allocation bug in
 ext4_clu_mapped for bigalloc + inline
Message-ID: <Y8mAe1SlcLD5fykg@debian-BULLSEYE-live-builder-AMD64>
References: <20230116154847.246743274@linuxfoundation.org>
 <20230116154909.507815847@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116154909.507815847@linuxfoundation.org>

Hi:

I recommend not backporting this patch or the other three patches apparently
intended to support it to 4.19 stable.  All these patches are related to
ext4's bigalloc feature, which was experimental as of 4.19 (expressly noted by
contemporary versions of e2fsprogs) and also suffered from a number of bugs.
A significant number of additional patches that were applied to 5.X kernels
over time would have to be backported to 4.19 for the patch below to function
correctly. It's really not worth doing that given bigalloc's experimental
status as of 4.19 and the very rare combination of the bigalloc and inline
features.

Thanks,
Eric


* Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> From: Eric Whitney <enwlinux@gmail.com>
> 
> [ Upstream commit 131294c35ed6f777bd4e79d42af13b5c41bf2775 ]
> 
> When converting files with inline data to extents, delayed allocations
> made on a file system created with both the bigalloc and inline options
> can result in invalid extent status cache content, incorrect reserved
> cluster counts, kernel memory leaks, and potential kernel panics.
> 
> With bigalloc, the code that determines whether a block must be
> delayed allocated searches the extent tree to see if that block maps
> to a previously allocated cluster.  If not, the block is delayed
> allocated, and otherwise, it isn't.  However, if the inline option is
> also used, and if the file containing the block is marked as able to
> store data inline, there isn't a valid extent tree associated with
> the file.  The current code in ext4_clu_mapped() calls
> ext4_find_extent() to search the non-existent tree for a previously
> allocated cluster anyway, which typically finds nothing, as desired.
> However, a side effect of the search can be to cache invalid content
> from the non-existent tree (garbage) in the extent status tree,
> including bogus entries in the pending reservation tree.
> 
> To fix this, avoid searching the extent tree when allocating blocks
> for bigalloc + inline files that are being converted from inline to
> extent mapped.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> Link: https://lore.kernel.org/r/20221117152207.2424-1-enwlinux@gmail.com
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@kernel.org
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/ext4/extents.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 0bb772cd7f88..1ad4c8eb82c1 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -5984,6 +5984,14 @@ int ext4_clu_mapped(struct inode *inode, ext4_lblk_t lclu)
>  	struct ext4_extent *extent;
>  	ext4_lblk_t first_lblk, first_lclu, last_lclu;
>  
> +	/*
> +	 * if data can be stored inline, the logical cluster isn't
> +	 * mapped - no physical clusters have been allocated, and the
> +	 * file has no extents
> +	 */
> +	if (ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
> +		return 0;
> +
>  	/* search for the extent closest to the first block in the cluster */
>  	path = ext4_find_extent(inode, EXT4_C2B(sbi, lclu), NULL, 0);
>  	if (IS_ERR(path)) {
> -- 
> 2.35.1
> 
> 
> 
