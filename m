Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EA13EEAC6;
	Wed, 20 May 2026 17:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296924; cv=none; b=rcFLofntyctofTZ3yhaspG4tQsQcvZwUf9vrihNR2Jjw5N+ibTeRpJrkaHXuBEp07yCJfbjRk36v2dIxWB9Lh+dnBumzJ0Ewe0KheFdx5kyr1fds//7CvAY80POuV0L02oxcWTopzZeTR13TiV5JatG7dA+YMB8m29W0j96miDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296924; c=relaxed/simple;
	bh=nwOAuvb9zdiYLA1YDYM2y4sndnfc6us2hnD3d795oSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PNLZbBvGleoOYE10bgziCHdrC6Znq2ZH63SRQeiD3TAhaHwG1ph9iLVq0tzi0hhdquCua1E0ETRO/Ig0cgQ+9Ebfaqj11zQzWj+PIThZ4yily48nqQ0egcUDTiDMCxrY4WVWWAdVpKr6uBLE5v8EyCSJ5iFCOXIJRMPhTFtfzXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xi7x7vKx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xi7x7vKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145321F00893;
	Wed, 20 May 2026 17:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779296922;
	bh=w9HP9QD1bStPE0a/AIdK4vgeSA4PyhKoCISFxCkq/EA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Xi7x7vKx6d/U9gU4hRoHNvQNx2to1raVwGm6/dLWTfJ8aK3INMxwBu1qHHfqbn/Ag
	 ZCljK3d9wEbBsKWV5leqAnNjvnmbcGQ4GVWM7PbNp8Bnv+UZUPVlF5+hrB636jFLe2
	 AN5EkFP/wk/p/ky7uWkCa6FvAI4FraKwCg9dBE5uNRrC6gSVMj4VhjRsQEbBEJ45Zl
	 jNS0K1uRVQUrOxH4AcAFejNkEOIagO7mqolBtVk2hrQggyqp1dMVvSxhg/iZp9zLtB
	 rapjGhoZrL5rXx1+f84eV5/ubQkCo4FErTbXCA+I+lbmjvBx2cbzihUDy2Yx++jk9l
	 9U2FPK2iiOprg==
Date: Thu, 21 May 2026 01:08:36 +0800
From: Gao Xiang <xiang@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 7.0 0013/1146] erofs: verify metadata accesses for
 file-backed mounts
Message-ID: <ag3qlMOcTYM2FBUQ@debian>
References: <20260520162148.390695140@linuxfoundation.org>
 <20260520162148.691068692@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260520162148.691068692@linuxfoundation.org>

Hi Greg,

On Wed, May 20, 2026 at 06:04:23PM +0200, Greg Kroah-Hartman wrote:
> 7.0-stable review patch.  If anyone has any objections, please let me know.
> 

As I said in
https://lore.kernel.org/r/75e6d1c8-e989-4eb7-aca3-37a40318e888@linux.alibaba.com

and
https://lore.kernel.org/r/5a4afec4-fe39-419e-8b2b-4e9901eb93be@linux.alibaba.com


Please help dropping this patch from auto-backporting flow
since this fix commit needs another fix, but Christoph
doesn't like that fix so it never gets upstream:

https://lore.kernel.org/all/agF0wJSFRAEcRP8M@infradead.org/T/#u

Since it impacts Android use cases (SELinux), I will
backport this manually later, and for now not backporting
this won't impact any.

Thanks,
Gao Xiang

> ------------------
> 
> From: Gao Xiang <hsiangkao@linux.alibaba.com>
> 
> [ Upstream commit 307210c262a29f41d7177851295ea1703bd04175 ]
> 
> For file-backed mounts, metadata is fetched via the page cache of
> backing inodes to avoid double caching and redundant copy ops out
> of RO uptodate folios, which is used by Android APEXes, ComposeFS,
> containerd.  However, rw_verify_area() was missing prior to
> metadata accesses.
> 
> Similar to vfs_iocb_iter_read(), fix this by:
>  - Enabling fanotify pre-content hooks on metadata accesses;
>  - security_file_permission() for security modules.
> 
> Verified that fanotify pre-content hooks now works correctly.
> 
> Fixes: fb176750266a ("erofs: add file-backed mount support")
> Acked-by: Amir Goldstein <amir73il@gmail.com>
> Reviewed-by: Chunhai Guo <guochunhai@vivo.com>
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/erofs/data.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/fs/erofs/data.c b/fs/erofs/data.c
> index f79ee80627d95..132a27deb2f3b 100644
> --- a/fs/erofs/data.c
> +++ b/fs/erofs/data.c
> @@ -30,6 +30,20 @@ void *erofs_bread(struct erofs_buf *buf, erofs_off_t offset, bool need_kmap)
>  {
>  	pgoff_t index = (buf->off + offset) >> PAGE_SHIFT;
>  	struct folio *folio = NULL;
> +	loff_t fpos;
> +	int err;
> +
> +	/*
> +	 * Metadata access for file-backed mounts reuses page cache of backing
> +	 * fs inodes (only folio data will be needed) to prevent double caching.
> +	 * However, the data access range must be verified here in advance.
> +	 */
> +	if (buf->file) {
> +		fpos = index << PAGE_SHIFT;
> +		err = rw_verify_area(READ, buf->file, &fpos, PAGE_SIZE);
> +		if (err < 0)
> +			return ERR_PTR(err);
> +	}
>  
>  	if (buf->page) {
>  		folio = page_folio(buf->page);
> -- 
> 2.53.0
> 
> 
> 
